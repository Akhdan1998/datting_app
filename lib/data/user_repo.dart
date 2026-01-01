part of '../../pages.dart';

class UserRepo {
  UserRepo._();

  static final instance = UserRepo._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> ensureUserInitialized(DatingUser user) async {
    final uid = user.uid;

    final userRef = _db.collection('users').doc(uid);
    final publicRef = _db.collection('publicProfiles').doc(uid);

    final isNewUser = await _db.runTransaction<bool>((tx) async {
      final userSnap = await tx.get(userRef);
      final publicSnap = await tx.get(publicRef);

      final isNew = !userSnap.exists;

      // =========================
      // 1) PRIVATE USERS (/users)
      // =========================
      final userData = <String, dynamic>{
        'uid': uid,
        'email': user.email ?? '',
        'provider': user.provider ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
      };

      tx.set(userRef, userData, SetOptions(merge: true));

      // ===============================
      // 2) PUBLIC PROFILE (/publicProfiles)
      // (jangan kirim null)
      // ===============================
      final pubData = <String, dynamic>{
        'uid': uid,
        'isProfileComplete': user.isProfileComplete ?? false,
        'updatedAt': FieldValue.serverTimestamp(),
        if (!publicSnap.exists) 'createdAt': FieldValue.serverTimestamp(),

        // optional fields (hanya kalau ada nilainya)
        if ((user.name ?? '').trim().isNotEmpty) 'name': user.name!.trim(),
        if ((user.photoUrl ?? '').trim().isNotEmpty)
          'photoUrl': user.photoUrl!.trim(),
        if (user.age != null) 'age': user.age,
        if ((user.city ?? '').trim().isNotEmpty) 'city': user.city!.trim(),
      };

      tx.set(publicRef, pubData, SetOptions(merge: true));

      return isNew;
    });

    return isNewUser;
  }

  Stream<List<DatingUser>> streamDiscoverUsers({
    required String myUid,
    int limit = 50,
    bool onlyCompleted = true,
  }) {
    Query<Map<String, dynamic>> q = _db.collection('publicProfiles');

    if (onlyCompleted) {
      q = q.where('isProfileComplete', isEqualTo: true);
    }

    q = q.limit(limit);

    return q.snapshots().map((snap) {
      return snap.docs
          .where((d) => d.id != myUid)
          .map((d) => DatingUser.fromDoc(d))
          .toList();
    });
  }
}

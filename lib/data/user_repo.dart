part of '../../pages.dart';

class UserRepo {
  UserRepo._();

  static final instance = UserRepo._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const int kDailySuperLikeLimit = 3;
  Future<bool> ensureUserInitialized(DatingUser user) async {
    final uid = user.uid;

    final userRef = _db.collection('users').doc(uid);
    final publicRef = _db.collection('publicProfiles').doc(uid);

    final isNewUser = await _db.runTransaction<bool>((tx) async {
      final userSnap = await tx.get(userRef);
      final publicSnap = await tx.get(publicRef);

      final isNew = !userSnap.exists;

      final userData = <String, dynamic>{
        'uid': uid,
        'email': user.email ?? '',
        'provider': user.provider ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
      };

      tx.set(userRef, userData, SetOptions(merge: true));

      final pubData = <String, dynamic>{
        'uid': uid,
        'isProfileComplete': user.isProfileComplete ?? false,
        'updatedAt': FieldValue.serverTimestamp(),
        if (!publicSnap.exists) 'createdAt': FieldValue.serverTimestamp(),
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

  Future<List<DatingUser>> fetchDiscoverUsersPage({
    required DatingUser me,
    required Set<String> excludedUids,
    required int limit,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    Query<Map<String, dynamic>> query = _db
        .collection('publicProfiles')
        .where('isProfileComplete', isEqualTo: true)
        .where('gender', isEqualTo: me.showMe!.value)
        .orderBy('updatedAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final QuerySnapshot<Map<String, dynamic>> snap = await query.get();

    final users = snap.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
      return DatingUser.fromDoc(d);
    })
        .where((u) =>
    u.uid != me.uid &&
        !excludedUids.contains(u.uid) &&
        u.lat != null &&
        u.lng != null &&
        u.age != null)
        .toList();

    users.sort((a, b) {
      final sa = computeRecommendationScore(me: me, other: a);
      final sb = computeRecommendationScore(me: me, other: b);
      return sb.compareTo(sa);
    });

    return users;
  }

  Future<void> swipeNope({
    required String myUid,
    required String targetUid,
  }) async {
    await _db
        .collection('swipes')
        .doc(myUid)
        .collection('nope')
        .doc(targetUid)
        .set({
      'uid': targetUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> swipeLike({
    required String myUid,
    required String targetUid,
  }) async {
    await _db
        .collection('swipes')
        .doc(myUid)
        .collection('likes')
        .doc(targetUid)
        .set({
      'uid': targetUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> swipeSuperLikeWithLimit({
    required String myUid,
    required String targetUid,
  }) async {
    final ok = await tryConsumeSuperLike(myUid);
    if (!ok) return false;

    await _db
        .collection('swipes')
        .doc(myUid)
        .collection('superLikes')
        .doc(targetUid)
        .set({
      'uid': targetUid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  Future<void> checkAndCreateMatch({
    required String myUid,
    required String targetUid,
  }) async {
    final otherLike = await _db
        .collection('swipes')
        .doc(targetUid)
        .collection('likes')
        .doc(myUid)
        .get();

    if (!otherLike.exists) return;

    final matchId = myUid.compareTo(targetUid) < 0
        ? '${myUid}_$targetUid'
        : '${targetUid}_$myUid';

    await _db.collection('matches').doc(matchId).set({
      'users': [myUid, targetUid],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Set<String>> getExcludedUids(String myUid) async {
    final likes =
        await _db.collection('swipes').doc(myUid).collection('likes').get();

    final nope =
        await _db.collection('swipes').doc(myUid).collection('nope').get();

    return {
      ...likes.docs.map((e) => e.id),
      ...nope.docs.map((e) => e.id),
    };
  }

  Future<bool> tryConsumeSuperLike(String myUid) async {
    final ref = _db.collection('superLikeUsage').doc(myUid);
    final today = _todayKey();

    return _db.runTransaction<bool>((tx) async {
      final snap = await tx.get(ref);

      int count = 0;
      String date = today;

      if (snap.exists) {
        final data = snap.data()!;
        if (data['date'] == today) {
          count = (data['count'] ?? 0) as int;
        }
      }

      if (count >= kDailySuperLikeLimit) {
        return false;
      }

      tx.set(ref, {
        'count': count + 1,
        'date': today,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true; // ✅ boleh super like
    });
  }

  double computeRecommendationScore({
    required DatingUser me,
    required DatingUser other,
  }) {
    if (me.lat == null ||
        me.lng == null ||
        other.lat == null ||
        other.lng == null ||
        me.age == null ||
        other.age == null) {
      return 0.0;
    }

    final dist = distanceKm(
      lat1: me.lat!,
      lon1: me.lng!,
      lat2: other.lat!,
      lon2: other.lng!,
    );

    final distanceScore = (1 / (1 + dist / 10)).clamp(0.0, 1.0);

    final ageDiff = (me.age! - other.age!).abs();
    final ageScore = (1 / (1 + ageDiff / 3)).clamp(0.0, 1.0);

    final randomScore =
        (other.uid.hashCode % 100) / 500;

    return (0.6 * distanceScore) +
        (0.3 * ageScore) +
        (0.1 * randomScore);
  }

  Future<DatingUser?> getMyPublicProfile(String uid) async {
    final snap =
    await _db.collection('publicProfiles').doc(uid).get();
    if (!snap.exists) return null;
    return DatingUser.fromDoc(snap);
  }
}
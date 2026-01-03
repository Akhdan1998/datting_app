part of '../../pages.dart';

class MeController extends GetxController {
  static const _tag = 'MeController';

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // profile (publicProfiles)
  final uid = ''.obs;
  final name = 'Guest'.obs;
  final email = ''.obs;
  final photoUrl = ''.obs;

  final age = RxnInt();
  final city = ''.obs;
  final job = ''.obs;

  // verified (photo verification)
  final verified = false.obs;

  // completion
  final completion = 0.0.obs;

  // quick counts (users/{uid})
  final likesYou = 0.obs;
  final boosts = 0.obs;
  final superLikes = 0.obs;

  // toggles / privacy
  final showOnDiscovery = true.obs;
  final showDistance = true.obs;
  final showOnlineStatus = true.obs;
  final readReceipts = false.obs;

  // discovery values
  final distanceKm = 10.obs;
  final ageMin = 22.obs;
  final ageMax = 30.obs;
  final preference = 'Women'.obs;

  // notif settings (users)
  final notifMatches = true.obs;
  final notifChats = true.obs;
  final notifLikes = true.obs;

  // premium
  final isPro = false.obs;

  // ui
  final isLoading = true.obs;
  final isSaving = false.obs;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _publicSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSub;

  String get _uid => _auth.currentUser?.uid ?? '';

  DocumentReference<Map<String, dynamic>> get _publicRef =>
      _db.collection('publicProfiles').doc(_uid);

  DocumentReference<Map<String, dynamic>> get _userRef =>
      _db.collection('users').doc(_uid);

  @override
  void onInit() {
    super.onInit();
    _applyUser(_auth.currentUser);

    _authSub = _auth.authStateChanges().listen((u) async {
      AppLog.d(_tag, 'authStateChanges uid=${u?.uid}');
      _applyUser(u);
      await _bindDocs();
    });
  }

  void _applyUser(User? user) {
    if (user == null) {
      debugPrint('[MeController] auth null → cancelling listeners');

      _publicSub?.cancel();
      _userSub?.cancel();
      _publicSub = null;
      _userSub = null;

      uid.value = '';
      name.value = 'Guest';
      email.value = '';
      photoUrl.value = '';
      verified.value = false;
      isLoading.value = false;

      return;
    }

    uid.value = user.uid;
    email.value = user.email ?? '';
    name.value = user.displayName ?? 'User';
    photoUrl.value = user.photoURL ?? '';
  }

  Future<void> _bindDocs() async {
    final id = _uid;
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    await _publicSub?.cancel();
    await _userSub?.cancel();

    await _ensureDocs();

    _publicSub = _publicRef.snapshots().listen(
      (snap) {
        if (_uid.isEmpty) return;
        final data = snap.data();
        if (data == null) return;

        name.value = (data['name'] ?? name.value).toString();
        city.value = (data['city'] ?? city.value).toString();
        job.value = (data['job'] ?? job.value).toString();
        photoUrl.value = (data['photoUrl'] ?? photoUrl.value).toString();

        final a = data['age'];
        if (a is num) age.value = a.toInt();

        final sod = data['showOnDiscovery'];
        if (sod is bool) showOnDiscovery.value = sod;

        final pv = data['photoVerified'];
        if (pv is bool) verified.value = pv;

        final newCompletion = _computeCompletionFromPublic(data);

        if (completion.value != newCompletion) {
          completion.value = newCompletion;

          AppLog.d(
            _tag,
            'publicProfiles updated city=${city.value} completion=$newCompletion',
          );
        }
      },
      onError: (e, st) {
        if (e is FirebaseException && e.code == 'permission-denied') {
          debugPrint('[MeController] snapshot blocked (logged out)');
          return;
        }
        AppLog.e(_tag, e, st);
      },
    );

    _userSub = _userRef.snapshots().listen((snap) {
      final data = snap.data();
      if (data == null) return;

      final dist = data['distanceKm'];
      if (dist is num) distanceKm.value = dist.toInt();

      final mn = data['ageMin'];
      if (mn is num) ageMin.value = mn.toInt();

      final mx = data['ageMax'];
      if (mx is num) ageMax.value = mx.toInt();

      final pref = data['preference'];
      if (pref is String && pref.trim().isNotEmpty) preference.value = pref;

      final sd = data['showDistance'];
      if (sd is bool) showDistance.value = sd;

      final so = data['showOnlineStatus'];
      if (so is bool) showOnlineStatus.value = so;

      final rr = data['readReceipts'];
      if (rr is bool) readReceipts.value = rr;

      final ly = data['likesYou'];
      if (ly is num) likesYou.value = ly.toInt();

      final bs = data['boosts'];
      if (bs is num) boosts.value = bs.toInt();

      final sl = data['superLikes'];
      if (sl is num) superLikes.value = sl.toInt();

      final pro = data['isPro'];
      if (pro is bool) isPro.value = pro;

      final nm = data['notifMatches'];
      if (nm is bool) notifMatches.value = nm;

      final nc = data['notifChats'];
      if (nc is bool) notifChats.value = nc;

      final nl = data['notifLikes'];
      if (nl is bool) notifLikes.value = nl;

      AppLog.d(_tag,
          'users settings updated dist=${distanceKm.value} pref=${preference.value} pro=${isPro.value}');
    }, onError: (e, st) => AppLog.e(_tag, e, st));

    isLoading.value = false;
  }

  double _computeCompletionFromPublic(Map<String, dynamic> data) {
    int score = 0;
    if ((data['name'] ?? '').toString().trim().isNotEmpty) score++;
    if (data['age'] is num) score++;
    if ((data['city'] ?? '').toString().trim().isNotEmpty) score++;
    if ((data['photoUrl'] ?? '').toString().trim().isNotEmpty) score++;
    if ((data['bio'] ?? '').toString().trim().length >= 20) score++;
    final ints = data['interests'];
    if (ints is List && ints.isNotEmpty) score++;
    return (score / 6.0).clamp(0.0, 1.0);
  }

  Future<void> _ensureDocs() async {
    final id = _uid;
    if (id.isEmpty) return;

    await safeRun(_tag, () async {
      final uSnap = await _userRef.get();
      if (!uSnap.exists) {
        await _userRef.set({
          'uid': id,
          'distanceKm': 10,
          'ageMin': 22,
          'ageMax': 30,
          'preference': 'Women',
          'showDistance': true,
          'showOnlineStatus': true,
          'readReceipts': false,
          'likesYou': 0,
          'boosts': 0,
          'superLikes': 0,
          'isPro': false,
          'notifMatches': true,
          'notifChats': true,
          'notifLikes': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        AppLog.d(_tag, 'created users/$id');
      }

      final pSnap = await _publicRef.get();
      if (!pSnap.exists) {
        await _publicRef.set({
          'uid': id,
          'name': name.value,
          'age': age.value,
          'city': city.value,
          'job': job.value,
          'photoUrl': photoUrl.value,
          'showOnDiscovery': false,
          'photoVerified': false,
          'isProfileComplete': false,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        AppLog.d(_tag, 'created publicProfiles/$id');
      }
    }, userMessage: 'Gagal init profile/settings');
  }

  Future<void> _saveUser(Map<String, dynamic> data) async {
    if (_uid.isEmpty) return;
    if (isSaving.value) return;

    isSaving.value = true;
    await safeRun(_tag, () async {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _userRef.set(data, SetOptions(merge: true));
      AppLog.d(_tag, 'save users: $data');
    }, userMessage: 'Gagal menyimpan settings');
    isSaving.value = false;
  }

  Future<void> _savePublic(Map<String, dynamic> data) async {
    if (_uid.isEmpty) return;
    if (isSaving.value) return;

    isSaving.value = true;
    await safeRun(_tag, () async {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _publicRef.set(data, SetOptions(merge: true));
      AppLog.d(_tag, 'save public: $data');
    }, userMessage: 'Gagal menyimpan profil');
    isSaving.value = false;
  }

  // ================== NAV / ACTIONS ==================

  void openSettings() {
    AppLog.d(_tag, 'openSettings');
    Get.snackbar('Settings', 'Coming soon ✨');
  }

  Future<void> openEditProfile() async {
    if (Get.isRegistered<EditProfileController>()) {
      Get.delete<EditProfileController>(force: true);
    }

    final result = await Get.to<bool>(() => const EditProfile());

    if (result == true) {
      if (Get.isRegistered<DattingController>()) {
        final dating = Get.find<DattingController>();
        await dating.refreshAfterProfileUpdated();
      }
    }
  }

  void openPreviewProfile() {
    AppLog.d(_tag, 'openPreviewProfile');
    Get.snackbar('Preview', 'Coming soon');
  }

  // ================== DISCOVERY PICKERS ==================

  Future<void> openDistance() async {
    AppLog.d(_tag, 'openDistance');

    final res = await Sheets.sliderInt(
      title: 'Distance',
      subtitle: 'Maks jarak swipe kamu',
      value: distanceKm.value,
      min: 1,
      max: 200,
      unit: 'km',
      icon: Icons.radar_rounded,
      accentColor: electric,
    );

    if (res == null) return;
    distanceKm.value = res;
    await _saveUser({'distanceKm': res});
  }

  Future<void> openAgeRange() async {
    AppLog.d(_tag, 'openAgeRange');

    final res = await Sheets.rangeInt(
      title: 'Age range',
      min: 18,
      max: 60,
      start: ageMin.value,
      end: ageMax.value,
      icon: Icons.cake_rounded,
      accentColor: electric,
    );

    if (res == null || res.length != 2) return;

    ageMin.value = res[0];
    ageMax.value = res[1];
    await _saveUser({'ageMin': res[0], 'ageMax': res[1]});
  }

  // Future<void> openPreference() async {
  //   AppLog.d(_tag, 'openPreference');
  //
  //   final options = ['Women', 'Men', 'Everyone'];
  //   final res = await Sheets.pickOne(
  //     title: 'Show me',
  //     options: options,
  //     selected: preference.value,
  //     icon: Icons.favorite_rounded,
  //     accentColor: electric,
  //   );
  //
  //   if (res == null) return;
  //   preference.value = res;
  //   await _saveUser({'preference': res});
  // }

  // ================== TOGGLES (AUTO SAVE) ==================

  Future<void> setShowOnDiscovery(bool v) async {
    AppLog.d(_tag, 'setShowOnDiscovery=$v');
    showOnDiscovery.value = v;
    await _savePublic({'showOnDiscovery': v});
  }

  Future<void> setShowDistance(bool v) async {
    AppLog.d(_tag, 'setShowDistance=$v');
    showDistance.value = v;
    await _saveUser({'showDistance': v});
  }

  Future<void> setShowOnlineStatus(bool v) async {
    AppLog.d(_tag, 'setShowOnlineStatus=$v');
    showOnlineStatus.value = v;
    await _saveUser({'showOnlineStatus': v});
  }

  Future<void> setReadReceipts(bool v) async {
    AppLog.d(_tag, 'setReadReceipts=$v');
    if (!isPro.value) {
      Get.snackbar('Premium', 'Read receipts khusus PRO');
      return;
    }
    readReceipts.value = v;
    await _saveUser({'readReceipts': v});
  }

  // ================== PREMIUM / PAGES ==================

  void openFilters() {
    AppLog.d(_tag, 'openFilters');
    if (!isPro.value) {
      Get.snackbar('Premium', 'Advanced filters khusus PRO');
      return;
    }
    Get.snackbar('Advanced filters', 'Coming soon ✨');
  }

  Future<void> openVerification() async {
    AppLog.d(_tag, 'openVerification');
    if (verified.value) {
      Get.snackbar('Verified', 'Kamu sudah verified');
      return;
    }

    final ok = await SDialog.show(
      title: 'Photo verification',
      message: 'Simulasi verifikasi. Lanjutkan?',
      icon: Icons.person,
      // pillText: 'OUT',
      primaryText: 'Verify',
      secondaryText: 'Cancel',
      accentColor: electric,
    );

    if (ok != true) return;

    verified.value = true;
    await _savePublic({'photoVerified': true});
    await _saveUser({'photoVerified': true});
    Get.snackbar('Verified', 'Photo verification sukses');
  }

  void openBlockList() {
    AppLog.d(_tag, 'openBlockList');
    Get.to(() => const BlockedUsers());
  }

  void openNotifications() {
    AppLog.d(_tag, 'openNotifications');
    Get.to(() => const Notification());
  }

  void openSubscription() {
    AppLog.d(_tag, 'openSubscription');
    Get.to(() => const Subscription());
  }

  void openConnectedAccounts() {
    AppLog.d(_tag, 'openConnectedAccounts');
    Get.to(() => const ConnectedAccounts());
  }

  // ================== ACCOUNT ==================

  Future<void> logout() async {
    AppLog.d(_tag, 'logout');

    final confirm = await SDialog.show(
      title: 'Keluar account?',
      message: 'Anda yakin ingin keluar dari akun ini?',
      icon: Icons.logout_rounded,
      primaryText: 'Keluar',
      secondaryText: 'Cancel aja',
      accentColor: electric,
    );

    if (confirm != true) return;

    await safeRun(_tag, () async {
      await AuthService.instance.signOut();
      Get.delete<DattingController>(force: true);
      Get.delete<ChatListController>(force: true);
      Get.delete<MeController>(force: true);
      Get.offAll(() => const SignIn());
    }, userMessage: 'Logout gagal');
  }

  Future<void> deleteAccount() async {
    AppLog.d(_tag, 'deleteAccount');

    final confirm = await SDialog.show(
      title: 'Delete account?',
      message: 'This can’t be undone. Kamu beneran yakin?',
      icon: Icons.delete_forever_rounded,
      primaryText: 'Delete',
      secondaryText: 'Cancel aja',
      accentColor: electric,
    );

    if (confirm != true) return;

    await safeRun(_tag, () async {
      final id = _uid;
      if (id.isEmpty) throw Exception('No user logged in');

      await _db.collection('publicProfiles').doc(id).delete();
      await _db.collection('users').doc(id).delete();

      final user = _auth.currentUser;
      await user?.delete();

      Get.offAll(() => const SignIn());
      Get.snackbar('Deleted', 'Akun kamu sudah dihapus');
    }, userMessage: 'Delete gagal (mungkin butuh login ulang / re-auth)');
  }

  @override
  void onClose() {
    _authSub?.cancel();
    _publicSub?.cancel();
    _userSub?.cancel();
    super.onClose();
  }
}

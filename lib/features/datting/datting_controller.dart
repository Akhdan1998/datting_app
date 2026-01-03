part of '../../pages.dart';

class DattingController extends GetxController {
  final users = <DatingUser>[].obs;
  final isLoading = true.obs;
  final isFetchingMore = false.obs;
  final error = ''.obs;

  static const int _pageSize = 20;
  static const int _prefetchThreshold = 5;

  DatingUser? _me;
  Set<String> _excludedUids = {};
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _checkPrefetch() {
    if (users.length <= _prefetchThreshold) {
      _fetchNextPage();
    }
  }

  Future<void> refreshAfterProfileUpdated() async {
    isLoading.value = true;
    error.value = '';
    _hasMore = true;
    users.clear();

    await _init();
  }

  Future<void> _init() async {
    error.value = '';
    isLoading.value = true;

    try {
      final auth = AuthService.instance.currentUser;
      if (auth == null) {
        error.value = 'Not logged in';
        return;
      }

      _me = await UserRepo.instance.getMyPublicProfile(auth.uid);

      if (_me == null ||
          _me!.lat == null ||
          _me!.lng == null ||
          _me!.age == null ||
          _me!.gender == null) {
        error.value = 'Lengkapi profil & lokasi terlebih dahulu';
        return;
      }

      _excludedUids = await UserRepo.instance.getExcludedUids(auth.uid);
      debugPrint('[DatingController] me=$_me '
          'lat=${_me?.lat} lng=${_me?.lng} age=${_me?.age} gender=${_me?.gender}');
      await _fetchNextPage(reset: true);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchNextPage({bool reset = false}) async {
    if (isFetchingMore.value || !_hasMore) return;

    isFetchingMore.value = true;

    if (reset) {
      users.clear();
      _hasMore = true;
    }

    final snap = await FirebaseFirestore.instance
        .collection('publicProfiles')
        .where('isProfileComplete', isEqualTo: true)
        .where('gender', isEqualTo: _me!.showMe!.value)
        .orderBy('updatedAt', descending: true)
        .limit(_pageSize)
        .get();

    if (snap.docs.isEmpty) {
      _hasMore = false;
      isFetchingMore.value = false;
      return;
    }

    final page = snap.docs
        .map((d) => DatingUser.fromDoc(d))
        .where((u) => u.uid != _me!.uid && !_excludedUids.contains(u.uid))
        .toList();

    users.addAll(page);

    if (page.length < _pageSize) {
      _hasMore = false;
    }

    isFetchingMore.value = false;
  }

  void onSwipeLeft(DatingUser u) {
    final me = AuthService.instance.currentUser!;
    UserRepo.instance.swipeNope(myUid: me.uid, targetUid: u.uid);
    users.removeWhere((e) => e.uid == u.uid);
    _checkPrefetch();
  }

  void onSwipeRight(DatingUser u) async {
    final me = AuthService.instance.currentUser!;
    await UserRepo.instance.swipeLike(myUid: me.uid, targetUid: u.uid);
    await UserRepo.instance.checkAndCreateMatch(
      myUid: me.uid,
      targetUid: u.uid,
    );
    users.removeWhere((e) => e.uid == u.uid);
    _checkPrefetch();
  }

  void onSwipeUp(DatingUser u) async {
    final me = AuthService.instance.currentUser!;
    final ok = await UserRepo.instance.swipeSuperLikeWithLimit(
      myUid: me.uid,
      targetUid: u.uid,
    );
    if (!ok) {
      Get.snackbar('Limit Tercapai', 'Super Like hari ini sudah habis');
      return;
    }
    users.removeWhere((e) => e.uid == u.uid);
    _checkPrefetch();
  }
}

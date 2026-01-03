part of '../../pages.dart';

class SplashController extends GetxController {
  Timer? _timer;
  StreamSubscription<User?>? _sub;
  bool _navigated = false;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[SplashController] onInit');

    _sub = AuthService.instance.authStateChanges.listen((user) {
      if (user != null) {
        _fetchAndSaveLocation();
      }
      _maybeNavigate(user);
    });

    _timer = Timer(const Duration(seconds: 3), () {
      _maybeNavigate(AuthService.instance.currentUser);
    });
  }

  Future<void> _fetchAndSaveLocation() async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;

    try {
      final pos = await getCurrentLocation();
      if (pos == null) return;

      final ref = FirebaseFirestore.instance
          .collection('publicProfiles')
          .doc(user.uid);

      final snap = await ref.get();
      if (!snap.exists) {
        debugPrint('[SplashController] publicProfiles not exists, init first');

        await ref.set({
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      debugPrint('[GPS] lat=${pos.latitude}, lng=${pos.longitude}');

      await ref.set({
        'lat': pos.latitude,
        'lng': pos.longitude,
        'locationUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

    } on FirebaseException catch (e, st) {
      debugPrint('[SplashController] FIREBASE ERROR '
          'code=${e.code} message=${e.message}');
      debugPrint(st.toString());
    } catch (e, st) {
      debugPrint('[SplashController] UNKNOWN ERROR: $e');
      debugPrint(st.toString());
    }
  }

  void _maybeNavigate(User? user) {
    if (_navigated) return;
    _navigated = true;

    _timer?.cancel();
    _sub?.cancel();

    if (user != null) {
      Get.offAll(() => const Navigation());
    } else {
      Get.offAll(() => const SignIn());
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _sub?.cancel();
    super.onClose();
  }
}
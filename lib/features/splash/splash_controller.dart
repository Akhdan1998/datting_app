part of '../../pages.dart';

class SplashController extends GetxController {
  Timer? _timer;
  StreamSubscription<User?>? _sub;
  bool _navigated = false;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[SplashController] onInit');

    // Listen auth state. Kalau sudah ada user sebelum 3 detik, bisa langsung route.
    _sub = AuthService.instance.authStateChanges.listen((user) {
      debugPrint('[SplashController] authStateChanges: user=${user?.uid}');
      _maybeNavigate(user);
    });

    // Delay splash 3 detik (branding)
    _timer = Timer(const Duration(seconds: 3), () async {
      debugPrint('[SplashController] timer done, checking currentUser...');
      _maybeNavigate(AuthService.instance.currentUser);
    });
  }

  void _maybeNavigate(User? user) {
    if (_navigated) return;
    _navigated = true;

    // stop listener/timer biar gak double navigate
    _timer?.cancel();
    _sub?.cancel();

    if (user != null) {
      debugPrint('[SplashController] route -> Navigation (uid=${user.uid})');
      Get.offAll(() => const Navigation());
    } else {
      debugPrint('[SplashController] route -> SignIn');
      Get.offAll(() => const SignIn());
    }
  }

  @override
  void onClose() {
    debugPrint('[SplashController] onClose');
    _timer?.cancel();
    _sub?.cancel();
    super.onClose();
  }
}
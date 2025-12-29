part of '../../pages.dart';

class SignInController extends GetxController {
  final isLoadingGoogle = false.obs;
  final isLoadingApple = false.obs;

  Future<void> loginGoogle() async {
    if (isLoadingGoogle.value) return;
    isLoadingGoogle.value = true;

    try {
      final cred = await AuthService.instance.signInWithGoogle();
      debugPrint('[SignInController] loginGoogle ok uid=${cred.user?.uid}');
    } catch (e, st) {
      debugPrint('[SignInController] loginGoogle ERROR: $e\nST $st');
      Get.snackbar('Login failed', e.toString());
    } finally {
      isLoadingGoogle.value = false;
      debugPrint('[SignInController] loginGoogle end');
    }
  }

  Future<void> loginApple() async {
    if (isLoadingApple.value) return;
    isLoadingApple.value = true;

    try {
      final cred = await AuthService.instance.signInWithApple();
      debugPrint('[SignInController] loginApple ok uid=${cred.user?.uid}');
    } catch (e, st) {
      debugPrint('[SignInController] loginApple ERROR: $e');
      debugPrintStack(label: '[SignInController] loginApple ST', stackTrace: st);
      Get.snackbar('Login failed', e.toString());
    } finally {
      isLoadingApple.value = false;
      debugPrint('[SignInController] loginApple end');
    }
  }
}

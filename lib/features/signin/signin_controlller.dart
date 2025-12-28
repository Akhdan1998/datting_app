part of '../../pages.dart';

class SignInController extends GetxController {
  final isLoading = false.obs;

  Future<void> loginGoogle() async {
    if (isLoading.value) {
      debugPrint('[SignInController] loginGoogle ignored: already loading');
      return;
    }

    debugPrint('[SignInController] loginGoogle start');
    try {
      isLoading.value = true;

      final cred = await AuthService.instance.signInWithGoogle();

      debugPrint(
        '[SignInController] loginGoogle success: uid=${cred.user?.uid}, email=${cred.user?.email}',
      );

      Get.offAll(() => const Navigation());
    } catch (e, st) {
      debugPrint('[SignInController] loginGoogle ERROR: $e');
      debugPrint('[SignInController] loginGoogle STACKTRACE:\n$st');

      Get.snackbar('Login failed', e.toString());
    } finally {
      isLoading.value = false;
      debugPrint('[SignInController] loginGoogle end (loading=false)');
    }
  }

  Future<void> loginApple() async {
    if (isLoading.value) {
      debugPrint('[SignInController] loginApple ignored: already loading');
      return;
    }

    debugPrint('[SignInController] loginApple start');
    try {
      isLoading.value = true;

      final cred = await AuthService.instance.signInWithApple();

      debugPrint(
        '[SignInController] loginApple success: uid=${cred.user?.uid}, email=${cred.user?.email}',
      );

      Get.offAll(() => const Navigation());
    } catch (e, st) {
      debugPrint('[SignInController] loginApple ERROR: $e');
      debugPrint('[SignInController] loginApple STACKTRACE:\n$st');

      Get.snackbar('Login failed', e.toString());
    } finally {
      isLoading.value = false;
      debugPrint('[SignInController] loginApple end (loading=false)');
    }
  }
}
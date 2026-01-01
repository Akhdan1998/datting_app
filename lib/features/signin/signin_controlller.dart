part of '../../pages.dart';

class SignInController extends GetxController {
  final isLoadingGoogle = false.obs;
  final isLoadingApple = false.obs;

  Future<void> loginGoogle() async {
    if (isLoadingGoogle.value) return;
    isLoadingGoogle.value = true;

    try {
      final (cred, isNewUser) = await AuthService.instance.signInWithGoogle();
      debugPrint(
          '[SignInController] loginGoogle ok uid=${cred.user?.uid} isNew=$isNewUser');

      Get.offAll(() => const Navigation());

      if (isNewUser) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final nav = Get.find<NavigationController>();
          nav.goToMeTab();

          Future.delayed(const Duration(milliseconds: 150), () {
            Get.defaultDialog(
              title: 'Lengkapi Profil',
              middleText:
                  'Agar akunmu bisa tampil di menu Discover dan bisa mulai swipe, lengkapi profil dulu ya.',
              textConfirm: 'Lengkapi sekarang',
              textCancel: 'Nanti',
              barrierDismissible: false,
              onConfirm: () {
                Get.back();
                Get.to(() => const EditProfile());
              },
              onCancel: () => Get.back(),
            );
          });
        });
      }
    } catch (e, st) {
      debugPrint('[SignInController] loginGoogle ERROR: $e');
      debugPrintStack(
          label: '[SignInController] loginGoogle ST', stackTrace: st);
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

      Get.offAll(() => const Navigation());
    } catch (e, st) {
      debugPrint('[SignInController] loginApple ERROR: $e');
      debugPrintStack(
          label: '[SignInController] loginApple ST', stackTrace: st);
      Get.snackbar('Login failed', e.toString());
    } finally {
      isLoadingApple.value = false;
      debugPrint('[SignInController] loginApple end');
    }
  }
}

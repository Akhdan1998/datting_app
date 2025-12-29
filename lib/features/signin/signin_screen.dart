part of '../../pages.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    return Scaffold(
      backgroundColor: electric,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/logo_datting.png',
                color: lemonade,
                scale: 4.5,
              ),
              const SizedBox(height: 24),
              Text(
                'Real Ones Only',
                style: inconsolataStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: lemonade,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'No fake energy.\nJust genuine convos, effortless connections.',
                style: inconsolataStyle(
                  fontSize: 16,
                  color: lemonade.withOpacity(0.75),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              controller.isLoadingGoogle.value
                  ? CircularProgressIndicator(color: lemonade)
                  : BounceButton(
                      onTap: controller.isLoadingGoogle.value
                          ? () {}
                          : controller.loginGoogle,
                      color: lemonade,
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/google.png',
                            height: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Continue with Google',
                            style: inconsolataStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: electric,
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: Platform.isIOS ? 20 : 0),
              Platform.isIOS
                  ? controller.isLoadingApple.value
                      ? CircularProgressIndicator(color: lemonade)
                      : BounceButton(
                          onTap: controller.isLoadingApple.value
                              ? () {}
                              : controller.loginApple,
                          color: lemonade,
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/apple.png',
                                height: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continue with Apple',
                                style: inconsolataStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: electric),
                              ),
                            ],
                          ),
                        )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              Text(
                'By continuing, you agree to our Terms & Privacy Policy',
                style: inconsolataStyle(
                  fontSize: 12,
                  color: lemonade.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

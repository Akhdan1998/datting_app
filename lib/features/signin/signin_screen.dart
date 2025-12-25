part of '../../pages.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lemonade,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/images/logo_datting.png',
                color: electric,
                scale: 4.5,
              ),
              const SizedBox(height: 24),
              Text(
                'Real Ones Only',
                style: inconsolataStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: electric,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'No fake energy.\nJust genuine convos, effortless connections.',
                style: inconsolataStyle(
                  fontSize: 16,
                  color: pureBlack.withOpacity(0.75),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              BounceButton(
                onTap: () {
                  Get.to(Navigation());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      height: 22,
                    ),
                    const SizedBox(width: 12),
                    Text('Continue with Google',
                        style: inconsolataStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'By continuing, you agree to our Terms & Privacy Policy',
                style: inconsolataStyle(
                  fontSize: 12,
                  color: pureBlack.withOpacity(0.5),
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

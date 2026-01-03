part of '../../pages.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: electric,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo_datting.png',
              color: lemonade,
              scale: 5,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                'SABRUT APP',
                style: inconsolataStyle(
                  fontSize: 20,
                  color: lemonade,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
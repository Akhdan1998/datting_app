part of '../../pages.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: electric,
      body: Center(
        child: Text(
          'Me',
          style: inconsolataStyle(),
        ),
      ),
    );
  }
}

part of '../../pages.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: electric,
      body: Center(
        child: Text('Chat', style: inconsolataStyle(),),
      ),
    );
  }
}

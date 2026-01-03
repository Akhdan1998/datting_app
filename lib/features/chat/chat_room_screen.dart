part of '../../pages.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String otherUid;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.otherUid,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final ChatRoomController c;
  final text = TextEditingController();

  @override
  void initState() {
    super.initState();
    c = Get.put(ChatRoomController(widget.roomId), tag: widget.roomId);
  }

  @override
  void dispose() {
    Get.delete<ChatRoomController>(tag: widget.roomId);
    text.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final myUid = AuthService.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: electric,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.otherUid,
            style: inconsolataStyle(color: lemonade)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: c.messages.length,
                itemBuilder: (_, i) {
                  final m = c.messages[i];
                  final isMe = m.senderId == myUid;

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe
                            ? lemonade.withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        m.text,
                        style:
                        inconsolataStyle(color: lemonade),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: text,
                    style: inconsolataStyle(color: lemonade),
                    decoration: const InputDecoration(
                      hintText: 'Tulis pesan...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: lemonade),
                  onPressed: () {
                    final t = text.text;
                    text.clear();
                    c.send(t);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
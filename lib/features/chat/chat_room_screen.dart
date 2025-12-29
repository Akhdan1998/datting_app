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
  late final TextEditingController _text;
  late final ChatRoomController c;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController();

    // gunakan tag biar controller tidak bentrok antar room
    c = Get.put(ChatRoomController(widget.roomId), tag: widget.roomId);
  }

  @override
  void dispose() {
    _text.dispose();
    Get.delete<ChatRoomController>(tag: widget.roomId, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: electric,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.otherUid,
            style: inconsolataStyle(fontSize: 16, color: lemonade)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(color: lemonade));
              }
              if (c.error.value.isNotEmpty) {
                return Center(
                    child: Text(c.error.value,
                        style: inconsolataStyle(color: lemonade)));
              }

              final myUid = AuthService.instance.currentUser?.uid ?? '';
              final msgs = c.messages;

              return ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: msgs.length,
                itemBuilder: (_, i) {
                  final m = msgs[i];
                  final isMe = m.senderId == myUid;

                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: isMe
                            ? lemonade.withOpacity(0.2)
                            : Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: lemonade.withOpacity(0.15)),
                      ),
                      child: Text(m.text,
                          style:
                              inconsolataStyle(fontSize: 14, color: lemonade)),
                    ),
                  );
                },
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _text,
                      style: inconsolataStyle(fontSize: 14, color: lemonade),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: inconsolataStyle(
                            fontSize: 14, color: lemonade.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: lemonade.withOpacity(0.15)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: lemonade.withOpacity(0.15)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: lemonade),
                    onPressed: () async {
                      final t = _text.text;
                      _text.clear();
                      await c.send(t);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

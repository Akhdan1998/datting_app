part of '../../pages.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChatListController());

    return Scaffold(
      backgroundColor: electric,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Chat',
            style: inconsolataStyle(fontSize: 18, color: lemonade)),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: lemonade));
        }

        if (c.rooms.isEmpty) {
          return Center(
            child: Text('Belum ada chat',
                style: inconsolataStyle(color: lemonade)),
          );
        }

        final myUid = AuthService.instance.currentUser!.uid;

        return ListView.builder(
          itemCount: c.rooms.length,
          itemBuilder: (_, i) {
            final r = c.rooms[i];
            final otherUid =
            r.members.firstWhere((u) => u != myUid);

            return ListTile(
              title: Text(otherUid,
                  style: inconsolataStyle(color: lemonade)),
              subtitle: Text(
                r.lastMessage ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: inconsolataStyle(
                    fontSize: 12,
                    color: lemonade.withOpacity(0.7)),
              ),
              onTap: () async {
                final roomId =
                await ChatRepo.instance.ensureRoom(
                  myUid: myUid,
                  otherUid: otherUid,
                );

                Get.to(() => ChatRoomScreen(
                  roomId: roomId,
                  otherUid: otherUid,
                ));
              },
            );
          },
        );
      }),
    );
  }
}
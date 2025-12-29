part of '../../pages.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChatListController());

    return Scaffold(
      backgroundColor: electric,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Chat', style: inconsolataStyle(fontSize: 18, color: lemonade)),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: lemonade));
        }
        if (c.error.value.isNotEmpty) {
          return Center(
            child: Text(c.error.value, style: inconsolataStyle(color: lemonade)),
          );
        }
        if (c.rooms.isEmpty) {
          return Center(
            child: Text('Belum ada chat', style: inconsolataStyle(color: lemonade)),
          );
        }

        return ListView.separated(
          itemCount: c.rooms.length,
          separatorBuilder: (_, __) => Divider(color: lemonade.withOpacity(0.15)),
          itemBuilder: (_, i) {
            final room = c.rooms[i];
            return _RoomTile(room: room);
          },
        );
      }),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final ChatRoom room;
  const _RoomTile({required this.room});

  @override
  Widget build(BuildContext context) {
    final myUid = AuthService.instance.currentUser?.uid ?? '';
    final otherUid = room.members.firstWhere((u) => u != myUid, orElse: () => room.members.first);

    return ListTile(
      title: Text(
        otherUid, // nanti bisa ganti jadi nama user (ambil dari collection users/publicProfiles)
        style: inconsolataStyle(fontSize: 16, color: lemonade),
      ),
      subtitle: Text(
        room.lastMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: inconsolataStyle(fontSize: 12, color: lemonade.withOpacity(0.75)),
      ),
      onTap: () async {
        final me = AuthService.instance.currentUser;
        if (me == null) return;

        // pastikan room ada (kalau sudah ada, cuma return id yg sama)
        final roomId = await ChatRepo.instance.ensureRoom(myUid: me.uid, otherUid: otherUid);

        Get.to(() => ChatRoomScreen(
          roomId: roomId,
          otherUid: otherUid,
        ));
      },
    );
  }
}
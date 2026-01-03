part of '../../pages.dart';

class ChatRoomController extends GetxController {
  final String roomId;
  ChatRoomController(this.roomId);

  final messages = <ChatMessage>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();

    _sub = ChatRepo.instance
        .streamMessages(roomId, limit: 100)
        .listen((list) {
      messages.value = list;
      isLoading.value = false;
    }, onError: (e) {
      error.value = e.toString();
      isLoading.value = false;
    });
  }

  Future<void> send(String text) async {
    final me = AuthService.instance.currentUser;
    if (me == null) return;

    final t = text.trim();
    if (t.isEmpty) return;

    await ChatRepo.instance.sendMessage(
      roomId: roomId,
      senderId: me.uid,
      text: t,
    );
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
part of '../../pages.dart';

class ChatRoomController extends GetxController {
  final String roomId;

  ChatRoomController(this.roomId);

  final messages = <ChatMessage>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;

  StreamSubscription<List<ChatMessage>>? _sub;

  @override
  void onInit() {
    super.onInit();

    _sub = ChatRepo.instance.streamMessages(roomId, limit: 100).listen((list) {
      messages.value = list;
      isLoading.value = false;
      error.value = '';
    }, onError: (e, st) {
      debugPrint('[ChatRoomController] error: $e\n$st');
      error.value = e.toString();
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  Future<void> send(String text) async {
    final me = AuthService.instance.currentUser;
    if (me == null) throw Exception('Not logged in');

    final t = text.trim();
    if (t.isEmpty) return;

    await ChatRepo.instance.sendMessage(
      roomId: roomId,
      senderId: me.uid,
      text: t,
    );
  }
}

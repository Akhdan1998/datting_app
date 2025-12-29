part of '../../pages.dart';

class ChatListController extends GetxController {
  final rooms = <ChatRoom>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;

  StreamSubscription<List<ChatRoom>>? _sub;

  @override
  void onInit() {
    super.onInit();

    final me = AuthService.instance.currentUser;
    if (me == null) {
      error.value = 'Not logged in';
      isLoading.value = false;
      return;
    }

    _sub = ChatRepo.instance.streamMyRooms(me.uid).listen((list) {
      rooms.value = list;
      isLoading.value = false;
      error.value = '';
    }, onError: (e, st) {
      debugPrint('[ChatListController] error: $e\n$st');
      error.value = e.toString();
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
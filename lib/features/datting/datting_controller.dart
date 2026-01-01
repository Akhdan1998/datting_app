part of '../../pages.dart';

class DattingController extends GetxController {
  final users = <DatingUser>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;

  StreamSubscription<List<DatingUser>>? _sub;

  @override
  void onInit() {
    super.onInit();

    final me = AuthService.instance.currentUser;
    debugPrint('ME UID = ${me?.uid}');
    if (me == null) {
      error.value = 'Not logged in';
      isLoading.value = false;
      return;
    }

    _sub = UserRepo.instance.streamDiscoverUsers(myUid: me.uid).listen((list) {
      users.value = list;
      isLoading.value = false;
      error.value = '';
    }, onError: (e) {
      error.value = e.toString();
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void onSwipeLeft(DatingUser u) => debugPrint('NOPE: ${u.uid}');

  void onSwipeRight(DatingUser u) => debugPrint('LIKE: ${u.uid}');

  void onSwipeUp(DatingUser u) => debugPrint('SUPER: ${u.uid}');
}

part of '../../pages.dart';

// class ChatHomeController extends GetxController {
//   final items = <ChatHomeItem>[].obs;
//   final isLoading = true.obs;
//   final error = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // TODO: ganti dari Firestore rooms yang member-nya termasuk currentUser
//     // sementara contoh dummy:
//     final myUid = AuthService.instance.currentUser?.uid;
//     if (myUid == null) {
//       error.value = 'Not logged in';
//       isLoading.value = false;
//       return;
//     }
//
//     items.assignAll([
//       ChatHomeItem(roomId: 'room_1', otherUid: 'userA'),
//       ChatHomeItem(roomId: 'room_2', otherUid: 'userB'),
//     ]);
//     isLoading.value = false;
//   }
// }
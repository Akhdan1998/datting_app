part of '../../pages.dart';

// class ChatHome extends StatelessWidget {
//   const ChatHome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.put(ChatHomeController());
//
//     return Scaffold(
//       backgroundColor: electric,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text('Chat',
//             style: inconsolataStyle(fontSize: 18, color: lemonade)),
//       ),
//       body: Obx(() {
//         if (c.isLoading.value) {
//           return Center(child: CircularProgressIndicator(color: lemonade));
//         }
//         if (c.error.value.isNotEmpty) {
//           return Center(
//               child: Text(c.error.value,
//                   style: inconsolataStyle(color: lemonade)));
//         }
//         if (c.items.isEmpty) {
//           return Center(
//               child: Text('Belum ada chat',
//                   style: inconsolataStyle(color: lemonade)));
//         }
//
//         return ListView.separated(
//           padding: const EdgeInsets.all(12),
//           itemCount: c.items.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 10),
//           itemBuilder: (_, i) {
//             final it = c.items[i];
//             return BounceButton(
//               onTap: () {
//                 Get.to(() => ChatRoomScreen(
//                       roomId: it.roomId,
//                       otherUid: it.otherUid,
//                     ));
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.06),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: lemonade.withOpacity(0.12)),
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: lemonade.withOpacity(0.15),
//                       child: Icon(Icons.person,
//                           color: lemonade.withOpacity(0.9), size: 18),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         it.otherUid,
//                         style: inconsolataStyle(
//                             fontSize: 14,
//                             color: lemonade,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     Icon(Icons.chevron_right, color: lemonade.withOpacity(0.5)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
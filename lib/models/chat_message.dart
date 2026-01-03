part of '../../pages.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final Timestamp? createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    this.createdAt,
  });

  factory ChatMessage.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return ChatMessage(
      id: doc.id,
      senderId: d['senderId'],
      text: d['text'],
      createdAt: d['createdAt'],
    );
  }
}
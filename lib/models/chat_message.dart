part of '../../pages.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final Timestamp? createdAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'createdAt': FieldValue.serverTimestamp(),
  };

  factory ChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data() ?? {};
    return ChatMessage(
      id: doc.id,
      senderId: (m['senderId'] ?? '') as String,
      text: (m['text'] ?? '') as String,
      createdAt: m['createdAt'] as Timestamp?,
    );
  }
}
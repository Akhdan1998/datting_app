part of '../../pages.dart';

class ChatRoom {
  final String id;
  final List<String> members;
  final String? lastMessage;
  final String? lastSenderId;
  final Timestamp? lastAt;
  final Timestamp? createdAt;

  const ChatRoom({
    required this.id,
    required this.members,
    this.lastMessage,
    this.lastSenderId,
    this.lastAt,
    this.createdAt,
  });

  Map<String, dynamic> toMap({bool forCreate = false}) => {
    'members': members,
    'lastMessage': lastMessage,
    'lastSenderId': lastSenderId,
    'lastAt': lastAt ?? FieldValue.serverTimestamp(),
    if (forCreate) 'createdAt': FieldValue.serverTimestamp(),
  };

  factory ChatRoom.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data() ?? {};
    return ChatRoom(
      id: doc.id,
      members: List<String>.from((m['members'] ?? const []) as List),
      lastMessage: m['lastMessage'] as String?,
      lastSenderId: m['lastSenderId'] as String?,
      lastAt: m['lastAt'] as Timestamp?,
      createdAt: m['createdAt'] as Timestamp?,
    );
  }
}
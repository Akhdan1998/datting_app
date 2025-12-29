part of '../../pages.dart';

class ChatRepo {
  ChatRepo._();

  static final instance = ChatRepo._();

  final _db = FirebaseFirestore.instance;

  String buildRoomId(String a, String b) {
    final pair = [a, b]..sort();
    return '${pair[0]}_${pair[1]}';
  }

  DocumentReference<Map<String, dynamic>> roomRef(String roomId) =>
      _db.collection('rooms').doc(roomId);

  CollectionReference<Map<String, dynamic>> msgCol(String roomId) =>
      roomRef(roomId).collection('messages');

  Future<String> ensureRoom({
    required String myUid,
    required String otherUid,
  }) async {
    final roomId = buildRoomId(myUid, otherUid);
    final ref = roomRef(roomId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) {
        final room = ChatRoom(
          id: roomId,
          members: ([myUid, otherUid]..sort()),
        );
        tx.set(ref, room.toMap(forCreate: true));
      }
    });

    return roomId;
  }

  Stream<List<ChatRoom>> streamMyRooms(String myUid) {
    return _db
        .collection('rooms')
        .where('members', arrayContains: myUid)
        .orderBy('lastAt', descending: true)
        .snapshots()
        .map((q) => q.docs.map((d) => ChatRoom.fromDoc(d)).toList());
  }

  Stream<List<ChatMessage>> streamMessages(String roomId, {int limit = 50}) {
    return msgCol(roomId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((q) => q.docs.map((d) => ChatMessage.fromDoc(d)).toList());
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String text,
  }) async {
    final room = roomRef(roomId);
    final msgs = msgCol(roomId);
    final msgDoc = msgs.doc();

    await _db.runTransaction((tx) async {
      tx.set(msgDoc, {
        'senderId': senderId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.set(
          room,
          {
            'lastMessage': text,
            'lastSenderId': senderId,
            'lastAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true));
    });
  }
}

part of '../../pages.dart';

class ChatRepo {
  ChatRepo._();

  static final instance = ChatRepo._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    if (myUid == otherUid) {
      throw Exception('Cannot create room with yourself');
    }

    final roomId = buildRoomId(myUid, otherUid);
    final roomRef = this.roomRef(roomId);

    final matchId = buildRoomId(myUid, otherUid);
    final matchSnap = await _db.collection('matches').doc(matchId).get();

    if (!matchSnap.exists) {
      throw Exception('Chat not allowed before match');
    }

    await _db.runTransaction((tx) async {
      final snap = await tx.get(roomRef);

      if (!snap.exists) {
        tx.set(roomRef, {
          'members': [myUid, otherUid]..sort(),
          'createdAt': FieldValue.serverTimestamp(),
          'lastAt': FieldValue.serverTimestamp(),
        });
      } else {
        tx.update(roomRef, {
          'lastAt': FieldValue.serverTimestamp(),
        });
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

  Stream<List<ChatMessage>> streamMessages(
    String roomId, {
    int limit = 50,
  }) {
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
    final msgs = msgCol(roomId).doc();

    await _db.runTransaction((tx) async {
      tx.set(msgs, {
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
        SetOptions(merge: true),
      );
    });
  }
}

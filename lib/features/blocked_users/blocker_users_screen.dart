part of '../../pages.dart';

class BlockedUsers extends StatelessWidget {
  const BlockedUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('blocked')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Blocked users')),
      body: uid.isEmpty
          ? const Center(child: Text('Not logged in'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.snapshots(),
        builder: (c, snap) {
          if (snap.hasError) {
            debugPrint('[BlockedUsers] ERROR: ${snap.error}');
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No blocked users'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final blockedUid = (d.data()['uid'] ?? d.id).toString();
              return ListTile(
                title: Text(blockedUid),
                trailing: TextButton(
                  onPressed: () async {
                    try {
                      await d.reference.delete();
                      debugPrint('[BlockedUsers] Unblocked $blockedUid');
                      Get.snackbar('Unblocked', blockedUid);
                    } catch (e, st) {
                      debugPrint('[BlockedUsers] ERROR: $e\n$st');
                    }
                  },
                  child: const Text('Unblock'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
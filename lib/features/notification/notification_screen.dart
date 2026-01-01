part of '../../pages.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            children: [
              SwitchListTile(
                title: const Text('Matches'),
                value: c.notifMatches.value,
                onChanged: (v) async {
                  c.notifMatches.value = v;
                  await c._saveUser({'notifMatches': v});
                },
              ),
              SwitchListTile(
                title: const Text('Chats'),
                value: c.notifChats.value,
                onChanged: (v) async {
                  c.notifChats.value = v;
                  await c._saveUser({'notifChats': v});
                },
              ),
              SwitchListTile(
                title: const Text('Likes'),
                value: c.notifLikes.value,
                onChanged: (v) async {
                  c.notifLikes.value = v;
                  await c._saveUser({'notifLikes': v});
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

part of '../../pages.dart';

class ConnectedAccounts extends StatelessWidget {
  const ConnectedAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final providers = user?.providerData ?? const <UserInfo>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Connected accounts')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: providers.isEmpty
            ? const Text('No connected accounts')
            : Column(
                children: providers
                    .map((p) => ListTile(
                          title: Text(p.providerId),
                          subtitle: Text(p.email ?? ''),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}

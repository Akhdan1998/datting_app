part of '../../pages.dart';

class Subscription extends StatelessWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current plan: ${c.isPro.value ? "PRO" : "FREE"}'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  debugPrint('[Subscription] upgrade tapped');
                  Get.snackbar(
                      'Upgrade', 'Integrasi payment nanti (IAP/Stripe)');
                },
                child: const Text('Upgrade to PRO'),
              ),
            ],
          );
        }),
      ),
    );
  }
}

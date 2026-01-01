part of '../../pages.dart';

class Datting extends StatefulWidget {
  const Datting({super.key});

  @override
  State<Datting> createState() => _DattingState();
}

class _DattingState extends State<Datting> {
  late final DattingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<DattingController>()
        ? Get.find<DattingController>()
        : Get.put(DattingController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: electric,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Discover',
                  style: inconsolataStyle(fontSize: 20, color: lemonade)),
              const SizedBox(height: 15),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: lemonade),
                    );
                  }

                  debugPrint('ERROR NIH ${controller.error.value}');
                  if (controller.error.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.error.value,
                        textAlign: TextAlign.center,
                        style: inconsolataStyle(
                          fontSize: 14,
                          color: lemonade.withOpacity(0.85),
                        ),
                      ),
                    );
                  }

                  final data = controller.users;

                  if (data.isEmpty) {
                    return Center(
                      child: Text(
                        'No more profiles',
                        style: inconsolataStyle(
                          fontSize: 16,
                          color: lemonade.withOpacity(0.8),
                        ),
                      ),
                    );
                  }

                  return SwipeDeck<DatingUser>(
                    key: ValueKey(data.map((e) => e.uid).join('|')),
                    items: data,
                    visibleCount: 3,
                    onSwipeLeft: controller.onSwipeLeft,
                    onSwipeRight: controller.onSwipeRight,
                    onSwipeUp: controller.onSwipeUp,
                    cardBuilder: (context, user) => ProfileCard(user: user),
                  );
                }),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionCircle(
                    icon: Icons.close,
                    onTap: () => SwipeDeckController.of(context)?.swipeLeft(),
                  ),
                  ActionCircle(
                    icon: Icons.favorite,
                    onTap: () => SwipeDeckController.of(context)?.swipeRight(),
                  ),
                  ActionCircle(
                    icon: Icons.star,
                    onTap: () => SwipeDeckController.of(context)?.swipeUp(),
                  ),
                ],
              ),
              SizedBox(height: 6 + bottomInset),
            ],
          ),
        ),
      ),
    );
  }
}

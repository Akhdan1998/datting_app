part of '../../pages.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final controller = Get.put(NavigationController());

  static final List<Widget> _pages = [
    const Datting(),
    const ChatHome(),
    const Me(),
  ];

  static const List<_NavItem> _items = [
    _NavItem(label: 'Dating', iconPath: 'assets/icons/datting.png'),
    _NavItem(label: 'Chat', iconPath: 'assets/icons/chat.png'),
    _NavItem(label: 'Me', iconPath: 'assets/icons/profile.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: electric,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
          Obx(() {
            final activeIndex = controller.currentIndex.value;

            return Container(
              color: whiteSkin,
              padding: EdgeInsets.only(top: 10, bottom: bottomInset),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  return _BottomNavButton(
                    iconPath: item.iconPath,
                    label: item.label,
                    isActive: i == activeIndex,
                    onTap: () => controller.changeTab(i),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isActive ? lemonade : lemonade.withOpacity(0.55);

    return BounceButton(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 92,
        height: 92,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isActive ? lemonade.withOpacity(0.10) : transparentColor,
          border: Border.all(
            color: isActive
                ? lemonade.withOpacity(0.22)
                : lemonade.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: lemonade.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : const [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSlide(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              offset: isActive ? const Offset(0, -0.06) : Offset.zero,
              child: Image.asset(
                iconPath,
                width: 22,
                height: 22,
                color: fg,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: inconsolataStyle(
                fontSize: 13,
                color: fg,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

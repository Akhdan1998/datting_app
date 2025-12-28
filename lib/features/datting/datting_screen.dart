part of '../../pages.dart';

class Datting extends StatefulWidget {
  const Datting({super.key});

  @override
  State<Datting> createState() => _DattingState();
}

class _DattingState extends State<Datting> {
  late final DattingController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.put(DattingController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final data = _c.data;

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
                child: SwipeDeck<_DatingCardData>(
                  items: data,
                  visibleCount: 3,
                  onSwipeLeft: _c.onSwipeLeft,
                  onSwipeRight: _c.onSwipeRight,
                  onSwipeUp: _c.onSwipeUp,
                  cardBuilder: (context, item) => _ProfileCard(item: item),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionCircle(
                    icon: Icons.close,
                    onTap: () => SwipeDeckController.of(context)?.swipeLeft(),
                  ),
                  _ActionCircle(
                    icon: Icons.favorite,
                    onTap: () => SwipeDeckController.of(context)?.swipeRight(),
                  ),
                  _ActionCircle(
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

class _SwipeDeckScope extends InheritedWidget {
  final _SwipeDeckState state;

  const _SwipeDeckScope({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_SwipeDeckScope oldWidget) =>
      state != oldWidget.state;
}

class SwipeDeck<T> extends StatefulWidget {
  final List<T> items;
  final int visibleCount;
  final SwipeCardBuilder<T> cardBuilder;

  final ValueChanged<T>? onSwipeLeft;
  final ValueChanged<T>? onSwipeRight;
  final ValueChanged<T>? onSwipeUp;

  const SwipeDeck({
    super.key,
    required this.items,
    required this.cardBuilder,
    this.visibleCount = 3,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
  });

  @override
  State<SwipeDeck<T>> createState() => _SwipeDeckState<T>();
}

class _SwipeDeckState<T> extends State<SwipeDeck<T>>
    with TickerProviderStateMixin {
  int _topIndex = 0;

  late final AnimationController _anim;
  Animation<Offset>? _offsetAnim;

  Offset _drag = Offset.zero;

  static const double _throwThresholdX = 120;
  static const double _throwThresholdUp = 120;
  static const double _maxRotation = 0.18;

  @override
  void initState() {
    super.initState();
    SwipeDeckController._lastState = this;

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..addListener(() {
        if (_offsetAnim != null) {
          setState(() => _drag = _offsetAnim!.value);
        }
      });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  bool get _hasCards => _topIndex < widget.items.length;

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _drag += d.delta);
  }

  void _onPanEnd(DragEndDetails d) {
    final dx = _drag.dx;
    final dy = _drag.dy;

    if (dx.abs() > _throwThresholdX) {
      _dismiss(dx > 0 ? SwipeDirection.right : SwipeDirection.left);
      return;
    }

    if (-dy > _throwThresholdUp) {
      _dismiss(SwipeDirection.up);
      return;
    }

    _snapBack();
  }

  void _snapBack() {
    _offsetAnim = Tween<Offset>(begin: _drag, end: Offset.zero).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );
    _anim.forward(from: 0);
  }

  void _dismiss(SwipeDirection dir) {
    final size = MediaQuery.of(context).size;

    final end = switch (dir) {
      SwipeDirection.left => Offset(-size.width * 1.2, _drag.dy),
      SwipeDirection.right => Offset(size.width * 1.2, _drag.dy),
      SwipeDirection.up => Offset(_drag.dx, -size.height * 1.2),
    };

    _offsetAnim = Tween<Offset>(begin: _drag, end: end).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeIn),
    );

    _anim.forward(from: 0).whenComplete(() {
      if (!_hasCards) return;

      final item = widget.items[_topIndex];
      setState(() {
        _topIndex++;
        _drag = Offset.zero;
        _offsetAnim = null;
      });

      switch (dir) {
        case SwipeDirection.left:
          widget.onSwipeLeft?.call(item);
          break;
        case SwipeDirection.right:
          widget.onSwipeRight?.call(item);
          break;
        case SwipeDirection.up:
          widget.onSwipeUp?.call(item);
          break;
      }
    });
  }

  void _programmaticSwipe(SwipeDirection dir) {
    if (!_hasCards) return;

    _drag = dir == SwipeDirection.left
        ? const Offset(-20, 0)
        : dir == SwipeDirection.right
            ? const Offset(20, 0)
            : const Offset(0, -20);

    _dismiss(dir);
  }

  @override
  Widget build(BuildContext context) {
    return _SwipeDeckScope(
      state: this,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;

          if (!_hasCards) {
            return Center(
              child: Text(
                'No more profiles',
                style: inconsolataStyle(
                    fontSize: 16, color: lemonade.withOpacity(0.8)),
              ),
            );
          }

          final remaining = widget.items.length - _topIndex;
          final count =
              remaining < widget.visibleCount ? remaining : widget.visibleCount;

          return Stack(
            alignment: Alignment.center,
            children: List.generate(count, (i) {
              final index = _topIndex + (count - 1 - i);
              final item = widget.items[index];
              final isTop = index == _topIndex;

              final depth = (_topIndex + count - 1) - index;
              final scale = 1.0 - (0.04 * depth);
              final translateY = 10.0 * depth;

              if (!isTop) {
                return Transform.translate(
                  offset: Offset(0, translateY),
                  child: Transform.scale(
                    scale: scale,
                    child: SizedBox(
                        width: w,
                        height: h,
                        child: widget.cardBuilder(context, item)),
                  ),
                );
              }

              final rot = (_drag.dx / w).clamp(-1.0, 1.0) * _maxRotation;
              final likeOpacity = (_drag.dx / 140).clamp(0.0, 1.0);
              final nopeOpacity = (-_drag.dx / 140).clamp(0.0, 1.0);
              final superOpacity = (-_drag.dy / 140).clamp(0.0, 1.0);

              return GestureDetector(
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Transform.translate(
                  offset: _drag,
                  child: Transform.rotate(
                    angle: rot,
                    child: Stack(
                      children: [
                        SizedBox(
                            width: w,
                            height: h,
                            child: widget.cardBuilder(context, item)),
                        Positioned(
                          top: 18,
                          left: 18,
                          child: Opacity(
                            opacity: likeOpacity,
                            child: _Stamp(text: 'LIKE', borderColor: lemonade),
                          ),
                        ),
                        Positioned(
                          top: 18,
                          right: 18,
                          child: Opacity(
                            opacity: nopeOpacity,
                            child: _Stamp(
                                text: 'NOPE',
                                borderColor: lemonade.withOpacity(0.7)),
                          ),
                        ),
                        Positioned(
                          top: 64,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Opacity(
                              opacity: superOpacity,
                              child: _Stamp(
                                  text: 'SUPER',
                                  borderColor: lemonade.withOpacity(0.9)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  final String text;
  final Color borderColor;

  const _Stamp({required this.text, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 2),
        color: transparentColor,
      ),
      child: Text(
        text,
        style: inconsolataStyle(
          fontSize: 18,
          color: borderColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final _DatingCardData item;

  const _ProfileCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteBlue,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(item.image, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  transparentColor,
                  transparentColor,
                  electric.withOpacity(0.85),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.name}\n${item.age} Tahun',
                    style: inconsolataStyle(
                      fontSize: 22,
                      color: lemonade,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: lemonade.withOpacity(0.10),
          border: Border.all(color: lemonade.withOpacity(0.18)),
        ),
        child: Icon(icon, color: lemonade),
      ),
    );
  }
}

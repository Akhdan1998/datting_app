part of '../../../pages.dart';

class SwipeDeckScope extends InheritedWidget {
  final SwipeDeckState state;

  const SwipeDeckScope({super.key, required this.state, required super.child});

  @override
  bool updateShouldNotify(covariant SwipeDeckScope oldWidget) =>
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
  State<SwipeDeck<T>> createState() => SwipeDeckState<T>();
}

class SwipeDeckState<T> extends State<SwipeDeck<T>>
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
        if (!mounted) return;
        if (_offsetAnim != null) setState(() => _drag = _offsetAnim!.value);
      });
  }

  @override
  void didUpdateWidget(covariant SwipeDeck<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final len = widget.items.length;
    if (len == 0) {
      _anim.stop();
      _offsetAnim = null;
      _drag = Offset.zero;
      _topIndex = 0;
      return;
    }

    if (_topIndex >= len) {
      setState(() {
        _anim.stop();
        _offsetAnim = null;
        _drag = Offset.zero;
        _topIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    if (SwipeDeckController._lastState == this) {
      SwipeDeckController._lastState = null;
    }
    _anim.dispose();
    super.dispose();
  }

  bool get _hasCards => _topIndex < widget.items.length;

  void _onPanUpdate(DragUpdateDetails d) {
    if (_anim.isAnimating) return;
    setState(() => _drag += d.delta);
  }

  void _onPanEnd(DragEndDetails d) {
    if (_anim.isAnimating) return;

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
    if (!_hasCards) return;

    final T currentItem = widget.items[_topIndex];

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
      if (!mounted) return;

      setState(() {
        _topIndex = (_topIndex + 1).clamp(0, widget.items.length);
        _drag = Offset.zero;
        _offsetAnim = null;
      });

      switch (dir) {
        case SwipeDirection.left:
          widget.onSwipeLeft?.call(currentItem);
          break;
        case SwipeDirection.right:
          widget.onSwipeRight?.call(currentItem);
          break;
        case SwipeDirection.up:
          widget.onSwipeUp?.call(currentItem);
          break;
      }
    });
  }

  void programmaticSwipe(SwipeDirection dir) {
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
    return SwipeDeckScope(
      state: this,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;

          if (!_hasCards) return const SizedBox.shrink();

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
                      child: widget.cardBuilder(context, item),
                    ),
                  ),
                );
              }

              final rot = (_drag.dx / w).clamp(-1.0, 1.0) * _maxRotation;

              return GestureDetector(
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Transform.translate(
                  offset: _drag,
                  child: Transform.rotate(
                    angle: rot,
                    child: SizedBox(
                      width: w,
                      height: h,
                      child: widget.cardBuilder(context, item),
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

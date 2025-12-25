part of '../../pages.dart';

enum SwipeDirection { left, right, up }

typedef SwipeCardBuilder<T> = Widget Function(BuildContext context, T item);

class DattingController extends GetxController {
  final List<_DatingCardData> data = const [
    _DatingCardData(name: 'Caca', age: 23, image: 'assets/images/p1.jpg'),
    _DatingCardData(name: 'Naya', age: 25, image: 'assets/images/p2.jpg'),
    _DatingCardData(name: 'Jessi', age: 24, image: 'assets/images/p3.jpg'),
    _DatingCardData(name: 'Tara', age: 22, image: 'assets/images/p4.jpg'),
  ];

  int get cardCount => data.length;

  void onSwipeLeft(_DatingCardData item) {
    debugPrint('NOPE: ${item.name}');
    // TODO: simpan dislike
  }

  void onSwipeRight(_DatingCardData item) {
    debugPrint('LIKE: ${item.name}');
    // TODO: simpan like
  }

  void onSwipeUp(_DatingCardData item) {
    debugPrint('SUPER: ${item.name}');
    // TODO: super like
  }
}

class SwipeDeckController {
  final _SwipeDeckState? _state;

  SwipeDeckController._(this._state);

  static _SwipeDeckState? _lastState;

  static SwipeDeckController? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SwipeDeckScope>();
    final st = scope?.state ?? _lastState;
    if (st == null) return null;
    return SwipeDeckController._(st);
  }

  void swipeLeft() => _state?._programmaticSwipe(SwipeDirection.left);

  void swipeRight() => _state?._programmaticSwipe(SwipeDirection.right);

  void swipeUp() => _state?._programmaticSwipe(SwipeDirection.up);
}

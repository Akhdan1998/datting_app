part of '../../../pages.dart';

class SwipeDeckController {
  final SwipeDeckState? _state;

  SwipeDeckController._(this._state);

  static SwipeDeckState? _lastState;

  static SwipeDeckController? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SwipeDeckScope>();
    final st = scope?.state ?? _lastState;
    if (st == null) return null;
    return SwipeDeckController._(st);
  }

  void swipeLeft() => _state?.programmaticSwipe(SwipeDirection.left);

  void swipeRight() => _state?.programmaticSwipe(SwipeDirection.right);

  void swipeUp() => _state?.programmaticSwipe(SwipeDirection.up);
}

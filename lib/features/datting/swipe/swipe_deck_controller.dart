part of '../../../pages.dart';

class SwipeDeckController {
  final SwipeDeckState _state;

  SwipeDeckController._(this._state);

  static SwipeDeckController? of(BuildContext context) {
    final scope =
    context.dependOnInheritedWidgetOfExactType<SwipeDeckScope>();
    if (scope == null) return null;
    return SwipeDeckController._(scope.state);
  }

  void swipeLeft() => _state.programmaticSwipe(SwipeDirection.left);
  void swipeRight() => _state.programmaticSwipe(SwipeDirection.right);
  void swipeUp() => _state.programmaticSwipe(SwipeDirection.up);
}
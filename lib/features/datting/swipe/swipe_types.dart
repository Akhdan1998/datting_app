part of '../../../pages.dart';

enum SwipeDirection { left, right, up }

typedef SwipeCardBuilder<T> = Widget Function(BuildContext context, T item);
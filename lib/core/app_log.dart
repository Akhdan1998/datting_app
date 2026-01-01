part of '../../pages.dart';

class AppLog {
  static void d(String tag, String msg) => debugPrint('[$tag] $msg');

  static void e(String tag, Object e, [StackTrace? st]) {
    debugPrint('[$tag] ERROR: $e');
    if (st != null) debugPrint('[$tag] STACK:\n$st');
  }
}

Future<T?> safeRun<T>(
    String tag,
    Future<T> Function() task, {
      String? userMessage,
    }) async {
  try {
    return await task();
  } catch (e, st) {
    AppLog.e(tag, e, st);
    if (userMessage != null) Get.snackbar('Oops', userMessage);
    return null;
  }
}
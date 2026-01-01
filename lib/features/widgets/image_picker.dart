part of '../../pages.dart';

Future<String?> pickAndEncodePhotoBase64({
  required String uid,
  required int slot,
}) async {
  try {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (file == null) {
      debugPrint('[EditProfileController] pickImage cancelled');
      return null;
    }

    final ext = p.extension(file.path).toLowerCase();
    final format = (ext == '.png') ? CompressFormat.png : CompressFormat.jpeg;

    final Uint8List? compressed = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 50,
      minWidth: 720,
      minHeight: 720,
      format: format,
    );

    if (compressed == null || compressed.isEmpty) {
      debugPrint('[EditProfileController] compress failed: empty bytes');
      Get.snackbar('Upload failed', 'Gagal kompres foto.');
      return null;
    }

    debugPrint('[EditProfileController] photo bytes=${compressed.length}');

    final b64 = base64Encode(compressed);

    final mime = (format == CompressFormat.png) ? 'image/png' : 'image/jpeg';
    final dataUrl = 'data:$mime;base64,$b64';

    if (dataUrl.length > 800000) {
      debugPrint(
          '[EditProfileController] WARNING: base64 too large len=${dataUrl.length}');
      // Get.snackbar(
      //   'Foto terlalu besar',
      //   'Coba pilih foto lain atau turunin quality lagi.',
      // );
      return null;
    }

    debugPrint('[EditProfileController] base64 ok len=${dataUrl.length}');
    return dataUrl;
  } catch (e, st) {
    debugPrint('[EditProfileController] pick/encode error: $e');
    debugPrint('$st');
    Get.snackbar('Upload failed', 'Coba lagi ya. ($e)');
    return null;
  }
}

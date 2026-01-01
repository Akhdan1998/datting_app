part of '../../../pages.dart';

class PhotoGrid extends StatelessWidget {
  final RxList<String> photos;
  final Future<void> Function(int index) onAddOrEdit;
  final Future<void> Function(int index) onRemove;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.onAddOrEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = photos.toList();
      const totalSlots = 3;

      return Row(
        children: List.generate(totalSlots, (i) {
          final url = i < list.length ? list[i] : '';
          final bytes = url.isNotEmpty ? _bytesFromDataUrl(url) : null;
          return Expanded(
            child: GestureDetector(
              onTap: () async => await onAddOrEdit(i),
              onLongPress: url.isEmpty ? null : () async => await onRemove(i),
              child: Container(
                height: 120,
                margin: EdgeInsets.only(right: i == totalSlots - 1 ? 0 : 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: whiteBlue.withOpacity(0.06),
                  border: Border.all(color: lemonade.withOpacity(0.12)),
                  image: bytes != null
                      ? DecorationImage(
                          image: MemoryImage(bytes), fit: BoxFit.cover)
                      : (url.startsWith('http')
                          ? DecorationImage(
                              image: NetworkImage(url), fit: BoxFit.cover)
                          : null),
                ),
                child: url.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_rounded,
                                color: lemonade.withOpacity(0.75), size: 20),
                            const SizedBox(height: 6),
                            Text(
                              'Add',
                              style: inconsolataStyle(
                                fontSize: 12,
                                color: lemonade.withOpacity(0.70),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: electric.withOpacity(0.55),
                            border:
                                Border.all(color: lemonade.withOpacity(0.18)),
                          ),
                          child: Text(
                            'Hold to remove',
                            style: inconsolataStyle(
                              fontSize: 10,
                              color: lemonade.withOpacity(0.92),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          );
        }),
      );
    });
  }
}

Uint8List? _bytesFromDataUrl(String s) {
  try {
    final v = s.trim();
    if (v.isEmpty) return null;

    if (v.startsWith('http://') || v.startsWith('https://')) {
      return null;
    }

    final idx = v.indexOf('base64,');
    final b64 = (idx >= 0) ? v.substring(idx + 7) : v;

    return base64Decode(b64);
  } catch (e) {
    debugPrint('[PhotoGrid] base64 decode error: $e');
    debugPrint(s);
    return null;
  }
}

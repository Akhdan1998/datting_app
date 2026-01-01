part of '../../../pages.dart';

class ChipEditor extends StatelessWidget {
  final List<String> items;
  final List<String> suggestions;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const ChipEditor({
    super.key,
    required this.items,
    required this.suggestions,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: [
              ...items.map((e) => _ChipPill(
                text: e,
                onTap: () => onRemove(e),
                isRemove: true,
              )),
              _ChipPill(
                text: '+ Add',
                onTap: () {
                  final ctrl = TextEditingController();
                  Get.defaultDialog(
                    title: 'Add interest',
                    middleText: 'Tulis 1 interest',
                    content: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: ctrl,
                        decoration: InputDecoration(
                          hintText: 'ex: Coffee',
                          filled: true,
                          fillColor: whiteSkin,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    textConfirm: 'Add',
                    textCancel: 'Cancel',
                    onConfirm: () {
                      onAdd(ctrl.text);
                      Get.back();
                    },
                    onCancel: () => Get.back(),
                  );
                },
                isRemove: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text('Suggestions',
            style: inconsolataStyle(
              fontSize: 12,
              color: lemonade.withOpacity(0.65),
              fontWeight: FontWeight.w800,
            )),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: suggestions.map((s) {
              final selected = items.contains(s);
              return _ChipPill(
                text: s,
                onTap: () => selected ? onRemove(s) : onAdd(s),
                isRemove: selected,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ChipPill extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isRemove;

  const _ChipPill({
    required this.text,
    required this.onTap,
    required this.isRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isRemove
                ? lemonade.withOpacity(0.10)
                : whiteBlue.withOpacity(0.06),
            border: Border.all(
              color: isRemove
                  ? lemonade.withOpacity(0.25)
                  : lemonade.withOpacity(0.12),
            ),
          ),
          child: Text(
            text,
            style: inconsolataStyle(
              fontSize: 12,
              color: lemonade.withOpacity(0.86),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
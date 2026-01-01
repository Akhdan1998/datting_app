part of '../../../pages.dart';

class PromptBox extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final int maxLen;

  const PromptBox({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.maxLen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: whiteBlue.withOpacity(0.06),
        border: Border.all(color: lemonade.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: inconsolataStyle(
                fontSize: 12,
                color: lemonade.withOpacity(0.85),
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 2,
            maxLength: maxLen,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ).copyWith(hintText: hint),
            style: inconsolataStyle(
              fontSize: 13,
              color: lemonade.withOpacity(0.90),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

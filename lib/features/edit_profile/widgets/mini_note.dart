part of '../../../pages.dart';

class _MiniNote extends StatelessWidget {
  final String text;

  const _MiniNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: lemonade.withOpacity(0.08),
        border: Border.all(color: lemonade.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates_rounded,
              size: 18, color: lemonade.withOpacity(0.85)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: inconsolataStyle(
                fontSize: 12,
                color: lemonade.withOpacity(0.78),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

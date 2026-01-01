part of '../../../pages.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: whiteSkin,
        border: Border.all(color: lemonade.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: inconsolataStyle(
                fontSize: 14,
                color: lemonade.withOpacity(0.92),
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 4),
          Text(subtitle,
              style: inconsolataStyle(
                fontSize: 12,
                color: lemonade.withOpacity(0.62),
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
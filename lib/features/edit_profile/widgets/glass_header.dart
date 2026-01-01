part of '../../../pages.dart';

class GlassHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double completion;

  const GlassHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (completion * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: whiteSkin,
        border: Border.all(color: lemonade.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: lemonade.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: inconsolataStyle(
                fontSize: 18,
                color: lemonade.withOpacity(0.95),
                fontWeight: FontWeight.w900,
              )),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: inconsolataStyle(
              fontSize: 12,
              color: lemonade.withOpacity(0.68),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile completion',
                  style: inconsolataStyle(
                    fontSize: 12,
                    color: lemonade.withOpacity(0.65),
                    fontWeight: FontWeight.w700,
                  )),
              Text('$pct%',
                  style: inconsolataStyle(
                    fontSize: 12,
                    color: lemonade.withOpacity(0.90),
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: completion.clamp(0.0, 1.0),
              minHeight: 9,
              backgroundColor: whiteBlue.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                lemonade.withOpacity(0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
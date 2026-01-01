part of '../../../pages.dart';

class SliderRow extends StatelessWidget {
  final String title;
  final String valueText;
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderRow({
    super.key,
    required this.title,
    required this.valueText,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
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
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: inconsolataStyle(
                      fontSize: 12,
                      color: lemonade.withOpacity(0.80),
                      fontWeight: FontWeight.w900,
                    )),
              ),
              Text(valueText,
                  style: inconsolataStyle(
                    fontSize: 12,
                    color: lemonade.withOpacity(0.90),
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: lemonade.withOpacity(0.9),
            inactiveColor: lemonade.withOpacity(0.18),
          ),
        ],
      ),
    );
  }
}

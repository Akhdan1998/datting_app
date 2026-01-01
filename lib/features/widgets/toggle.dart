part of '../../pages.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: lemonade.withOpacity(0.95),
      inactiveThumbColor: lemonade.withOpacity(0.35),
      inactiveTrackColor: lemonade.withOpacity(0.12),
    );
  }
}
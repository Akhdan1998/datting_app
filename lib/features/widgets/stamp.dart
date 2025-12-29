part of '../../pages.dart';

class Stamp extends StatelessWidget {
  final String text;
  final Color borderColor;

  const Stamp({super.key, required this.text, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 2),
        color: Colors.transparent,
      ),
      child: Text(
        text,
        style: inconsolataStyle(
          fontSize: 18,
          color: borderColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
part of '../../pages.dart';

class ActionCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ActionCircle({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: lemonade.withOpacity(0.10),
          border: Border.all(color: lemonade.withOpacity(0.18)),
        ),
        child: Icon(icon, color: lemonade),
      ),
    );
  }
}
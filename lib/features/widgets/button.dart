part of '../../pages.dart';

class BounceButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const BounceButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 120),
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? electric,
        ),
        padding: padding,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
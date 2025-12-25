part of '../../pages.dart';

class BounceButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const BounceButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 120),
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: electric),
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
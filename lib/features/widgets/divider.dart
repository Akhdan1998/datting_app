part of '../../pages.dart';

Widget _buildDivider(BuildContext context,
    {Color? color, double? indent, double? endIndent}) {
  return Divider(
    height: 1,
    color: color ?? lemonade.withOpacity(0.2),
    indent: indent ?? 0.0,
    endIndent: endIndent ?? 0.0,
  );
}
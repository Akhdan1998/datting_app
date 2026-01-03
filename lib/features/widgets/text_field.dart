part of '../../pages.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;

  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final VoidCallback? onTap;

  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final double borderRadius;

  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocus,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    assert(controller == null || initialValue == null);

    final Color base = (borderColor ?? lemonade);
    final Color focusBase = (focusedBorderColor ?? borderColor ?? lemonade);

    final Color normal = base.withOpacity(0.12);
    final Color focused = focusBase.withOpacity(0.28);
    final Color disabled = base.withOpacity(0.08);
    final Color error = redBull.withOpacity(0.45);

    OutlineInputBorder b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: c),
        );

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      onChanged: onChanged,
      onTap: onTap,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: whiteBlue.withOpacity(0.06),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: b(normal),
        enabledBorder: b(normal),
        focusedBorder: b(focused),
        disabledBorder: b(disabled),
        errorBorder: b(error),
        focusedErrorBorder: b(error),
      ),
      style: inconsolataStyle(
        fontSize: 13,
        color: textColor ?? electric,
        fontWeight: FontWeight.w700,
      ),
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}

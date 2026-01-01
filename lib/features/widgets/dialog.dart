part of '../../pages.dart';

class SDialog {
  static Future<bool?> show({
    required String title,
    required String message,
    IconData icon = Icons.auto_awesome_rounded,
    String? pillText,
    String primaryText = 'Okay',
    String secondaryText = 'Cancel',
    bool showSecondary = true,
    bool barrierDismissible = true,
    Color? accentColor,
    VoidCallback? onPrimary,
  }) {
    final theme = Get.theme;
    final accent = accentColor ?? theme.colorScheme.primary;

    return Get.dialog<bool>(
      _ConfirmDialog(
        title: title,
        message: message,
        icon: icon,
        pillText: pillText,
        primaryText: primaryText,
        secondaryText: secondaryText,
        showSecondary: showSecondary,
        accent: accent,
        onPrimary: onPrimary,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}

class Sheets {
  static Future<String?> inputText({
    required String title,
    required String hint,
    String? initial,
    IconData icon = Icons.edit_rounded,
    String primaryText = 'Save',
    String secondaryText = 'Cancel',
    Color? accentColor,
    int maxLen = 40,
  }) async {
    final ctrl = TextEditingController(text: initial ?? '');
    final theme = Get.theme;
    final accent = accentColor ?? theme.colorScheme.primary;

    return Get.bottomSheet<String?>(
      SafeArea(
        top: false,
        child: _SheetShell(
          title: title,
          icon: icon,
          accent: accent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                maxLength: maxLen,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: hint,
                  counterText: '',
                  filled: true,
                  fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onSurface.withOpacity(0.10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onSurface.withOpacity(0.10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: accent.withOpacity(0.55)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GhostButton(
                      text: secondaryText,
                      onTap: () => Get.back(result: null),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      text: primaryText,
                      color: accent,
                      onTap: () => Get.back(result: ctrl.text.trim()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Future<String?> pickOne({
    required String title,
    required List<String> options,
    required String selected,
    IconData icon = Icons.tune_rounded,
    String? pillText,
    Color? accentColor,
  }) async {
    final theme = Get.theme;
    final accent = accentColor ?? theme.colorScheme.primary;

    return Get.bottomSheet<String?>(
      SafeArea(
        top: false,
        child: _SheetShell(
          title: title,
          icon: icon,
          accent: accent,
          pillText: pillText,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...options.map((o) {
                final active = o == selected;
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Get.back(result: o),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: active
                          ? accent.withOpacity(0.10)
                          : theme.colorScheme.onSurface.withOpacity(0.04),
                      border: Border.all(
                        color: active
                            ? accent.withOpacity(0.35)
                            : theme.colorScheme.onSurface.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            o,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Icon(
                          active
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: active
                              ? accent.withOpacity(0.95)
                              : theme.colorScheme.onSurface.withOpacity(0.35),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              GhostButton(
                text: 'Cancel aja',
                onTap: () => Get.back(result: null),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Future<List<int>?> rangeInt({
    required String title,
    required int min,
    required int max,
    required int start,
    required int end,
    String? pillText,
    IconData icon = Icons.cake_rounded,
    Color? accentColor,
  }) async {
    final theme = Get.theme;
    final accent = accentColor ?? theme.colorScheme.primary;

    int mn = start.clamp(min, max);
    int mx = end.clamp(min, max);

    return Get.bottomSheet<List<int>?>(
      SafeArea(
        top: false,
        child: StatefulBuilder(builder: (context, setState) {
          return _SheetShell(
            title: title,
            icon: icon,
            accent: accent,
            pillText: pillText,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$mn – $mx',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                RangeSlider(
                  values: RangeValues(mn.toDouble(), mx.toDouble()),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: (max - min),
                  onChanged: (v) => setState(() {
                    mn = v.start.round();
                    mx = v.end.round();
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GhostButton(
                        text: 'Cancel aja',
                        onTap: () => Get.back(result: null),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Save',
                        color: accent,
                        onTap: () => Get.back(result: [mn, mx]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
    );
  }

  static Future<int?> sliderInt({
    required String title,
    required String subtitle,
    required int value,
    required int min,
    required int max,
    required String unit,
    IconData icon = Icons.radar_rounded,
    Color? accentColor,
  }) async {
    final theme = Get.theme;
    final accent = accentColor ?? theme.colorScheme.primary;

    int v = value.clamp(min, max);

    return Get.bottomSheet<int?>(
      SafeArea(
        top: false,
        child: StatefulBuilder(builder: (context, setState) {
          return _SheetShell(
            title: title,
            icon: icon,
            accent: accent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.70),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$v $unit',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Slider(
                  value: v.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: (max - min),
                  onChanged: (nv) => setState(() => v = nv.round()),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GhostButton(
                        text: 'Cancel aja',
                        onTap: () => Get.back(result: null),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Save',
                        color: accent,
                        onTap: () => Get.back(result: v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? pillText;
  final String primaryText;
  final String secondaryText;
  final bool showSecondary;
  final Color accent;
  final VoidCallback? onPrimary;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
    required this.showSecondary,
    required this.accent,
    this.pillText,
    this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: accent.withOpacity(0.14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.22),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.14),
                  ),
                ),
              ),
              Positioned(
                bottom: -70,
                left: -70,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.08),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent.withOpacity(0.12),
                            border: Border.all(color: accent.withOpacity(0.18)),
                          ),
                          child: Icon(icon, color: accent, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  if (pillText != null &&
                                      pillText!.trim().isNotEmpty)
                                    Pill(text: pillText!, color: accent),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                message,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.35,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.78),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (showSecondary) ...[
                          Expanded(
                            child: GhostButton(
                              text: secondaryText,
                              onTap: () => Get.back(result: false),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: PrimaryButton(
                            text: primaryText,
                            color: accent,
                            onTap: () {
                              onPrimary?.call();
                              Get.back(result: true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetShell extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final String? pillText;
  final Widget child;

  const _SheetShell({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
    this.pillText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        border: Border.all(color: accent.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 26,
            offset: const Offset(0, -10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withOpacity(0.12),
                  border: Border.all(color: accent.withOpacity(0.18)),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (pillText != null && pillText!.trim().isNotEmpty)
                Pill(text: pillText!, color: accent),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color color;

  const Pill({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color.withOpacity(0.9),
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const GhostButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.10),
            ),
          ),
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface.withOpacity(0.78),
            ),
          ),
        ),
      ),
    );
  }
}

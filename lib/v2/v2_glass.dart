import 'dart:ui';

import 'package:flutter/material.dart';

class V2GlassTheme {
  const V2GlassTheme._();

  static ThemeData light({
    required Color seed,
    Color background = const Color(0xFFF7F8FB),
    Color ink = const Color(0xFF1B1C20),
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: const Color(0xFFFEFEFF),
    ).copyWith(onSurface: ink);
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: seed.withValues(alpha: .11),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white.withValues(alpha: .46),
        foregroundColor: ink,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: .48),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: ink.withValues(alpha: .08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: ink.withValues(alpha: .08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: seed.withValues(alpha: .72), width: 1.3),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink.withValues(alpha: .92),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
    );
  }

  static ThemeData dark({
    required Color seed,
    Color background = const Color(0xFF0E0F12),
    Color ink = const Color(0xFFF4F4F7),
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      surface: const Color(0xFF17181C),
    ).copyWith(onSurface: ink);
    final base = light(seed: seed, background: background, ink: ink);
    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
    );
  }
}

class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.blurSigma = 18,
    this.tint,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color? tint;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final highContrast = media?.highContrast ?? false;
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final baseTint = tint ?? (dark ? const Color(0xFF25262B) : Colors.white);
    final accentTint = Color.lerp(baseTint, theme.colorScheme.primary, dark ? .16 : .10)!;
    final topAlpha = highContrast ? (dark ? .96 : .98) : (dark ? .60 : .48);
    final middleAlpha = highContrast ? (dark ? .94 : .96) : (dark ? .50 : .36);
    final bottomAlpha = highContrast ? (dark ? .92 : .94) : (dark ? .42 : .28);
    final edge = dark
        ? Colors.white.withValues(alpha: highContrast ? .32 : .28)
        : Colors.white.withValues(alpha: highContrast ? .96 : .78);

    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: content,
        ),
      );
    }

    final body = Stack(
      fit: StackFit.passthrough,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, .48, 1],
              colors: [
                baseTint.withValues(alpha: topAlpha),
                accentTint.withValues(alpha: middleAlpha),
                baseTint.withValues(alpha: bottomAlpha),
              ],
            ),
            border: Border.all(color: edge, width: 1),
          ),
          child: content,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  stops: const [0, .24, .62],
                  colors: [
                    Colors.white.withValues(alpha: dark ? .16 : .36),
                    Colors.white.withValues(alpha: dark ? .05 : .11),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final clipped = ClipRRect(
      borderRadius: borderRadius,
      child: highContrast || blurSigma <= 0
          ? body
          : BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigma + 4,
                sigmaY: blurSigma + 4,
              ),
              child: body,
            ),
    );

    final glass = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? .28 : .13),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: dark ? .04 : .20),
            blurRadius: 10,
            spreadRadius: -5,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: clipped,
    );

    if (semanticLabel == null) return glass;
    return Semantics(label: semanticLabel, button: onTap != null, child: glass);
  }
}

class AppGlassNavItem {
  const AppGlassNavItem({required this.icon, required this.label, this.selectedIcon});
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
}

class AppGlassNavigationBar extends StatelessWidget {
  const AppGlassNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.items,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<AppGlassNavItem> items;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: AppGlassSurface(
        borderRadius: BorderRadius.circular(30),
        blurSigma: 20,
        padding: const EdgeInsets.all(6),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = index == selectedIndex;
            return Expanded(
              child: Semantics(
                selected: selected,
                button: true,
                label: item.label,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => onSelected(index),
                    child: AnimatedContainer(
                      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      constraints: const BoxConstraints(minHeight: 54),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected ? scheme.primary.withValues(alpha: .11) : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selected ? (item.selectedIcon ?? item.icon) : item.icon,
                            size: 22,
                            color: selected ? scheme.primary : scheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                              color: selected ? scheme.primary : scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AppGlassActionButton extends StatelessWidget {
  const AppGlassActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.semanticLabel,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppGlassSurface(
      onTap: onPressed,
      semanticLabel: semanticLabel ?? label,
      borderRadius: BorderRadius.circular(24),
      blurSigma: 18,
      padding: EdgeInsets.symmetric(horizontal: label == null ? 16 : 18, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 21, color: scheme.primary),
          if (label != null) ...[
            const SizedBox(width: 9),
            Text(label!, style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w800)),
          ],
        ],
      ),
    );
  }
}

class AppGlassSearchButton extends StatelessWidget {
  const AppGlassSearchButton({super.key, required this.hint, required this.onTap, this.trailing});
  final String hint;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppGlassSurface(
      onTap: onTap,
      semanticLabel: hint,
      borderRadius: BorderRadius.circular(22),
      blurSigma: 16,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: scheme.onSurface),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 10), trailing!],
        ],
      ),
    );
  }
}

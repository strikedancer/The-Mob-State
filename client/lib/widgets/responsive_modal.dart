import 'package:flutter/material.dart';

class ResponsiveModalLayout extends StatelessWidget {
  final Widget child;
  final bool embedded;
  final double phoneMaxWidth;
  final double tabletMaxWidth;
  final double desktopMaxWidth;
  final double minHeight;
  final Color backgroundColor;
  final Color? cardColor;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry borderRadius;
  final double elevation;

  const ResponsiveModalLayout({
    super.key,
    required this.child,
    this.embedded = false,
    this.phoneMaxWidth = 560,
    this.tabletMaxWidth = 720,
    this.desktopMaxWidth = 920,
    this.minHeight = 240,
    this.backgroundColor = Colors.black87,
    this.cardColor,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.elevation = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaSize = MediaQuery.of(context).size;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : mediaSize.width;
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : mediaSize.height;
        final compactWidth = availableWidth < 430;
        final compactHeight = availableHeight < 760;
        final tabletWidth = availableWidth >= 700;
        final desktopWidth = availableWidth >= 1100;
        final horizontalMargin = compactWidth
            ? 12.0
            : tabletWidth
                ? 24.0
                : 18.0;
        final verticalMargin = compactHeight ? 12.0 : 24.0;
        final maxCardWidth = desktopWidth
            ? desktopMaxWidth
            : tabletWidth
                ? tabletMaxWidth
                : phoneMaxWidth;
        final maxCardHeight =
            (availableHeight - (verticalMargin * 2)).clamp(minHeight, double.infinity);

        final card = Card(
          margin: margin ??
              EdgeInsets.symmetric(
                horizontal: horizontalMargin,
                vertical: verticalMargin,
              ),
          color: cardColor,
          surfaceTintColor: Colors.transparent,
          elevation: elevation,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxCardWidth,
              maxHeight: maxCardHeight,
            ),
            child: child,
          ),
        );

        if (embedded) {
          return Center(child: card);
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(child: Center(child: card)),
        );
      },
    );
  }
}

class ResponsiveDialogContent extends StatelessWidget {
  final Widget child;
  final double phoneMaxWidth;
  final double tabletMaxWidth;
  final double desktopMaxWidth;
  final double maxHeightFactor;

  const ResponsiveDialogContent({
    super.key,
    required this.child,
    this.phoneMaxWidth = 360,
    this.tabletMaxWidth = 520,
    this.desktopMaxWidth = 640,
    this.maxHeightFactor = 0.72,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaSize = MediaQuery.of(context).size;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : mediaSize.width;
        final tabletWidth = availableWidth >= 700;
        final desktopWidth = availableWidth >= 1100;
        final maxWidth = desktopWidth
            ? desktopMaxWidth
            : tabletWidth
                ? tabletMaxWidth
                : phoneMaxWidth;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: mediaSize.height * maxHeightFactor,
          ),
          child: SingleChildScrollView(child: child),
        );
      },
    );
  }
}
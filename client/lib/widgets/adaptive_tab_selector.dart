import 'package:flutter/material.dart';

/// Same breakpoint everywhere: below this width show a full-width [DropdownButton]
/// instead of a [TabBar] so every section title stays reachable on phones.
const double kAdaptiveTabNarrowBreakpoint = 720;

const double kAdaptiveTabBarHeight = 72;

/// Tab row for [Scaffold.appBar] [AppBar.bottom] **or** the top of a [Column] /
/// nested panel. Implements [PreferredSizeWidget] for the app bar; fixed height
/// [kAdaptiveTabBarHeight] in both layouts.
class AdaptiveTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.narrowBreakpoint = kAdaptiveTabNarrowBreakpoint,
    this.isScrollable = true,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.padding,
  });

  final TabController controller;
  final List<Widget> tabs;
  final double narrowBreakpoint;
  final bool isScrollable;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final EdgeInsetsGeometry? padding;

  @override
  Size get preferredSize => const Size.fromHeight(kAdaptiveTabBarHeight);

  static String labelForTab(
    Widget tabWidget,
    int index,
    int tabCount,
    BuildContext context,
  ) {
    if (tabWidget is Tab) {
      final t = tabWidget;
      if (t.text != null && t.text!.trim().isNotEmpty) return t.text!;
    }
    return MaterialLocalizations.of(context).tabLabel(
      tabIndex: index + 1,
      tabCount: tabCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < narrowBreakpoint;
    return SizedBox(
      height: kAdaptiveTabBarHeight,
      child: narrow ? _dropdownBar(context) : _tabBar(),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: controller,
      tabs: tabs,
      isScrollable: isScrollable,
      indicatorColor: indicatorColor,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      padding: padding,
    );
  }

  Widget _dropdownBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.surfaceContainerHighest.withValues(alpha: 0.92);

    return Material(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final n = tabs.length;
            if (n == 0) return const SizedBox.shrink();
            final idx = controller.index.clamp(0, n - 1);
            return DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: idx,
                icon: Icon(Icons.arrow_drop_down, color: scheme.onSurface),
                borderRadius: BorderRadius.circular(8),
                items: [
                  for (var i = 0; i < n; i++)
                    DropdownMenuItem<int>(
                      value: i,
                      child: _DropdownRow(
                        tab: tabs[i],
                        index: i,
                        tabCount: n,
                        tabContext: context,
                      ),
                    ),
                ],
                selectedItemBuilder: (ctx) {
                  return [
                    for (var i = 0; i < n; i++)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: _DropdownRow(
                          tab: tabs[i],
                          index: i,
                          tabCount: n,
                          tabContext: context,
                          dense: true,
                        ),
                      ),
                  ];
                },
                onChanged: (v) {
                  if (v == null || v == controller.index) return;
                  controller.animateTo(v);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.tab,
    required this.index,
    required this.tabCount,
    required this.tabContext,
    this.dense = false,
  });

  final Widget tab;
  final int index;
  final int tabCount;
  final BuildContext tabContext;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    if (tab is Tab) {
      final t = tab as Tab;
      final label = AdaptiveTabBar.labelForTab(tab, index, tabCount, tabContext);
      final icon = t.icon;
      final fontSize = dense ? 15.0 : 14.0;
      return Row(
        children: [
          if (icon != null) ...[
            SizedBox(
              width: dense ? 26 : 28,
              height: dense ? 26 : 28,
              child: Center(child: icon),
            ),
            SizedBox(width: dense ? 8 : 10),
          ],
          Expanded(
            child: Text(
              label,
              maxLines: dense ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(tabContext).textTheme.bodyLarge?.copyWith(
                    fontSize: fontSize,
                    fontWeight: dense ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ),
        ],
      );
    }
    return Text(
      AdaptiveTabBar.labelForTab(tab, index, tabCount, tabContext),
      overflow: TextOverflow.ellipsis,
    );
  }
}

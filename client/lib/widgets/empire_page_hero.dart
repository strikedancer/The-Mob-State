import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/web_asset_helper.dart';
import 'game_page_info.dart';

const Color kEmpireGold = Color(0xFFFFB347);
const Color kEmpireBgStart = Color(0xFF160707);
const Color kEmpireBgMid = Color(0xFF261010);
const Color kEmpireBgEnd = Color(0xFF100505);

/// Noir/gold photo header used on Empire hubs (Don/Drugs pattern).
class EmpirePageHero extends StatelessWidget {
  const EmpirePageHero({
    super.key,
    required this.title,
    required this.imageAsset,
    this.cacheBust,
    this.subtitle,
    this.topicId,
    this.onRefresh,
    this.refreshEnabled = true,
    this.chips = const [],
    this.fallbackIcon = Icons.apartment,
    this.infoTooltip,
  });

  final String title;
  final String? subtitle;
  final String imageAsset;
  final String? cacheBust;
  final String? topicId;
  final VoidCallback? onRefresh;
  final bool refreshEnabled;
  final List<Widget> chips;
  final IconData fallbackIcon;
  final String? infoTooltip;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final hasSub = subtitle != null && subtitle!.trim().isNotEmpty;
    final height = wide
        ? (hasSub ? 186.0 : 168.0)
        : (hasSub ? 166.0 : 148.0);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1A1A), Color(0xFF1B1212)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kEmpireGold.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            WebAssetHelper.image(
              imageAsset,
              fit: BoxFit.cover,
              cacheBust: cacheBust,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: Colors.black26,
                child: Icon(
                  fallbackIcon,
                  color: kEmpireGold.withValues(alpha: 0.55),
                  size: 36,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.black.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: kEmpireGold,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      if (topicId != null)
                        GamePageInfoButton(
                          topicId: topicId!,
                          tooltip: infoTooltip,
                        ),
                      if (onRefresh != null) ...[
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: refreshEnabled ? onRefresh : null,
                          color: kEmpireGold,
                          tooltip: AppLocalizations.of(context)?.retry,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ],
                  ),
                  if (hasSub) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                  if (chips.isNotEmpty) ...[
                    const Spacer(),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: chips,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmpireStatChip extends StatelessWidget {
  const EmpireStatChip({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kEmpireGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kEmpireGold),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  PinnedTabBarDelegate({
    required this.tabBar,
    this.background = kEmpireBgMid,
  });

  final TabBar tabBar;
  final Color background;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: background,
      elevation: overlapsContent ? 2 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant PinnedTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || background != oldDelegate.background;
  }
}

Widget empireHubPainted({required Widget child}) {
  return DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [kEmpireBgStart, kEmpireBgMid, kEmpireBgEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: child,
  );
}

TabBar empireGoldTabBar({
  required TabController controller,
  required List<Widget> tabs,
  ValueChanged<int>? onTap,
}) {
  return TabBar(
    controller: controller,
    isScrollable: true,
    labelColor: kEmpireGold,
    unselectedLabelColor: Colors.white70,
    indicatorColor: kEmpireGold,
    dividerColor: kEmpireGold.withValues(alpha: 0.22),
    onTap: onTap,
    tabs: tabs,
  );
}

/// Shared Empire-shell page: photo hero scrolls away; optional gold TabBar stays pinned.
class EmpireHubScaffold extends StatelessWidget {
  const EmpireHubScaffold({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.body,
    this.cacheBust,
    this.embedded = false,
    this.subtitle,
    this.topicId,
    this.onRefresh,
    this.refreshEnabled = true,
    this.chips = const [],
    this.fallbackIcon = Icons.apartment,
    this.tabBar,
    this.extraHeaderSlivers = const [],
    this.floatingActionButton,
  });

  final bool embedded;
  final String title;
  final String? subtitle;
  final String imageAsset;
  final String? cacheBust;
  final String? topicId;
  final VoidCallback? onRefresh;
  final bool refreshEnabled;
  final List<Widget> chips;
  final IconData fallbackIcon;
  final TabBar? tabBar;
  final List<Widget> extraHeaderSlivers;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final scroll = NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: EmpirePageHero(
              title: title,
              subtitle: subtitle,
              imageAsset: imageAsset,
              cacheBust: cacheBust,
              topicId: topicId,
              onRefresh: onRefresh,
              refreshEnabled: refreshEnabled,
              chips: chips,
              fallbackIcon: fallbackIcon,
            ),
          ),
        ),
        ...extraHeaderSlivers,
        if (tabBar != null)
          SliverPersistentHeader(
            pinned: true,
            delegate: PinnedTabBarDelegate(tabBar: tabBar!),
          ),
      ],
      body: body,
    );
    final painted = empireHubPainted(child: scroll);
    if (embedded) {
      if (floatingActionButton == null) return painted;
      return Stack(
        children: [
          Positioned.fill(child: painted),
          Positioned(
            right: 16,
            bottom: 16,
            child: floatingActionButton!,
          ),
        ],
      );
    }
    return Scaffold(
      backgroundColor: kEmpireBgEnd,
      appBar: AppBar(
        backgroundColor: kEmpireBgStart,
        foregroundColor: kEmpireGold,
        title: Text(title),
      ),
      floatingActionButton: floatingActionButton,
      body: painted,
    );
  }
}


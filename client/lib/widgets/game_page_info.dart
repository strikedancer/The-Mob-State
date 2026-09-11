import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/help_topic_localizations.dart';
import '../utils/web_asset_helper.dart';

const Color _pageInfoGold = Color(0xFFFFB347);
const Color _pageInfoPanelDark = Color(0xFF1B1212);
const Color _pageInfoPanelLight = Color(0xFF2A1A1A);

class GamePageInfoScope extends InheritedWidget {
  const GamePageInfoScope({
    super.key,
    required this.topicId,
    required super.child,
  });

  final String topicId;

  static String? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GamePageInfoScope>()
        ?.topicId;
  }

  @override
  bool updateShouldNotify(GamePageInfoScope oldWidget) =>
      topicId != oldWidget.topicId;
}

/// Gold circular `i`. Safe to place in a hero, AppBar, or [GamePageInfoHost] overlay.
class GamePageInfoButton extends StatelessWidget {
  const GamePageInfoButton({
    super.key,
    required this.topicId,
    this.tooltip,
  });

  final String topicId;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Tooltip(
      message: tooltip ?? l10n?.pageInfoTooltip ?? '',
      child: Material(
        color: Colors.black.withValues(alpha: 0.55),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => showGamePageInfoDialog(context, topicId),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _pageInfoGold.withValues(alpha: 0.8),
              ),
            ),
            child: const Icon(
              Icons.info_outline,
              color: _pageInfoGold,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps a player page with [GamePageInfoScope].
/// Set [showOverlay] only for standalone mobile routes that have no title-row `i`.
/// Nested hosts are no-ops, so dashboard + screen can both wrap safely.
class GamePageInfoHost extends StatelessWidget {
  const GamePageInfoHost({
    super.key,
    required this.topicId,
    required this.child,
    this.enabled = true,
    this.showOverlay = true,
  });

  final String topicId;
  final Widget child;
  final bool enabled;
  final bool showOverlay;

  @override
  Widget build(BuildContext context) {
    if (!enabled || topicId.isEmpty) return child;
    if (GamePageInfoScope.maybeOf(context) != null) return child;

    final scoped = GamePageInfoScope(topicId: topicId, child: child);
    if (!showOverlay) return scoped;

    return GamePageInfoScope(
      topicId: topicId,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 12, 0),
                child: GamePageInfoButton(topicId: topicId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GamePageInfoSection {
  const GamePageInfoSection({
    required this.title,
    required this.body,
    this.imageAsset,
    this.icon = Icons.menu_book,
  });

  final String title;
  final String body;
  final String? imageAsset;
  final IconData icon;
}

List<GamePageInfoSection> gamePageInfoSections(
  AppLocalizations l10n,
  String topicId,
) {
  switch (topicId) {
    case 'events':
      return [
        GamePageInfoSection(
          title: l10n.pageInfoOverview,
          body: l10n.gameScreenHeroSubtitle,
        ),
        ..._helpSections(l10n, 'vault'),
      ];
    case 'vehicle-heist':
      return [
        GamePageInfoSection(
          title: l10n.pageInfoOverview,
          body: l10n.vehicleHeistHeroSubtitle,
        ),
        ..._helpSections(l10n, 'garage'),
        ..._helpSections(l10n, 'motor'),
        ..._helpSections(l10n, 'marina'),
      ];
    case 'player-profile':
      return [
        GamePageInfoSection(
          title: l10n.profile,
          body: [
            l10n.profileEventChipsHint,
            l10n.profileAchievementsHint,
            l10n.profilePropertiesHint,
          ].join('\n'),
        ),
        ..._helpSections(l10n, 'settings'),
      ];
    default:
      return _helpSections(l10n, topicId);
  }
}

String gamePageInfoTitle(AppLocalizations l10n, String topicId) {
  switch (topicId) {
    case 'events':
      return l10n.gameScreenHeroTitle;
    case 'vehicle-heist':
      return l10n.vehicleHeistTitle;
    case 'player-profile':
      return l10n.profile;
    default:
      final title = l10n.helpTopicTitleStr(topicId);
      return title.isEmpty ? l10n.pageInfoTooltip : title;
  }
}

String? _bannerAssetFor(String topicId) {
  switch (topicId) {
    case 'crimes':
      return 'assets/images/cooldown_crimes.png';
    case 'jobs':
      return 'assets/images/cooldown_jobs.png';
    case 'travel':
    case 'aviation':
      return 'assets/images/cooldown_airfield.png';
    case 'school':
      return 'assets/images/cooldown_school.png';
    case 'prison':
      return 'assets/images/cooldown_jail.png';
    default:
      return null;
  }
}

List<GamePageInfoSection> _helpSections(
  AppLocalizations l10n,
  String topicId,
) {
  final summary = l10n.helpTopicSummaryStr(topicId);
  final how = l10n.helpTopicHowStr(topicId);
  final tips = l10n.helpTopicTipsStr(topicId);
  return [
    if (summary.isNotEmpty)
      GamePageInfoSection(title: l10n.pageInfoOverview, body: summary),
    if (how.isNotEmpty)
      GamePageInfoSection(title: l10n.pageInfoHow, body: how),
    if (tips.isNotEmpty)
      GamePageInfoSection(title: l10n.pageInfoTips, body: tips),
  ];
}

Future<void> showGamePageInfoDialog(
  BuildContext context,
  String topicId,
) async {
  final media = MediaQuery.of(context);
  final maxWidth = media.size.width >= 900
      ? 640.0
      : media.size.width >= 600
          ? 520.0
          : media.size.width - 24;
  final maxHeight = media.size.height * 0.82;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      final sections = gamePageInfoSections(l10n, topicId);
      final banner = _bannerAssetFor(topicId);
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: SafeArea(
          child: SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_pageInfoPanelLight, _pageInfoPanelDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _pageInfoGold.withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: _pageInfoPanelDark,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: _pageInfoGold),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                gamePageInfoTitle(l10n, topicId),
                                style: const TextStyle(
                                  color: _pageInfoGold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: l10n.close,
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              color: _pageInfoGold,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (banner != null) ...[
                                  _guideImage(banner, Icons.menu_book, 140),
                                  const SizedBox(height: 12),
                                ],
                                for (final section in sections)
                                  _guideSection(section),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: _pageInfoGold,
                              foregroundColor: const Color(0xFF1A0C0C),
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(),
                            child: Text(l10n.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _guideSection(GamePageInfoSection section) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: const TextStyle(
            color: _pageInfoGold,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (section.imageAsset != null) ...[
          const SizedBox(height: 8),
          _guideImage(section.imageAsset!, section.icon, 120),
        ],
        const SizedBox(height: 10),
        ..._spacedBody(section.body),
      ],
    ),
  );
}

List<Widget> _spacedBody(String body) {
  final lines = body
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  if (lines.isEmpty) return const [];
  if (lines.length == 1) {
    return [
      Text(
        lines.first,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.86),
          height: 1.45,
        ),
      ),
    ];
  }
  return [
    for (final line in lines)
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 7),
              child: Icon(Icons.circle, size: 7, color: _pageInfoGold),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                line,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.86),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

Widget _guideImage(String asset, IconData icon, double height) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: WebAssetHelper.image(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => ColoredBox(
          color: const Color(0xFF2A1A1A),
          child: Icon(icon, color: _pageInfoGold, size: 40),
        ),
      ),
    ),
  );
}

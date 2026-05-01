import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../data/help_content.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatefulWidget {
  final bool embedded;

  const HelpScreen({super.key, this.embedded = false});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedCategory;
  String? _selectedTopicId;

  String _helpLanguageCode(BuildContext context) =>
      Localizations.localeOf(context).languageCode;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HelpTopic> _filteredTopics(String lang) {
    final query = _query.trim().toLowerCase();
    return helpTopics.where((topic) {
      final categoryMatch =
          _selectedCategory == null ||
          topic.category(lang) == _selectedCategory;
      final queryMatch =
          query.isEmpty || topic.searchableText(lang).contains(query);
      return categoryMatch && queryMatch;
    }).toList();
  }

  List<String> _categories(String lang) {
    final categories =
        helpTopics.map((topic) => topic.category(lang)).toSet().toList()
          ..sort();
    return categories;
  }

  HelpTopic? _resolveSelectedTopic(List<HelpTopic> topics) {
    if (topics.isEmpty) {
      return null;
    }

    final match = _selectedTopicId == null
        ? null
        : topics.where((topic) => topic.id == _selectedTopicId).firstOrNull;

    return match ?? topics.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = _helpLanguageCode(context);
    final topics = _filteredTopics(lang);
    final selectedTopic = _resolveSelectedTopic(topics);

    if (selectedTopic != null && _selectedTopicId != selectedTopic.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedTopicId = selectedTopic.id);
        }
      });
    }

    Widget mainContent = ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(context, l10n),
              const SizedBox(height: 16),
              _buildSearchBar(context, l10n),
              const SizedBox(height: 12),
              _buildCategoryChips(l10n, lang),
              const SizedBox(height: 16),
              if (topics.isEmpty)
                _buildEmptyState(l10n)
              else ...[
                DropdownButtonFormField<String>(
                  value: selectedTopic?.id,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1F1F1F),
                  decoration: InputDecoration(
                    labelText: l10n.helpUiTopicLabel,
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: topics
                      .map(
                        (topic) => DropdownMenuItem<String>(
                          value: topic.id,
                          child: Text(topic.title(lang)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedTopicId = value);
                  },
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildCompactTopicDetail(
                      context,
                      l10n,
                      lang,
                      selectedTopic!,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          );

    final compactBody = widget.embedded
        ? mainContent
        : ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.invertedStylus,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.unknown,
              },
            ),
            child: mainContent,
          );

    if (widget.embedded) {
      return Padding(padding: const EdgeInsets.all(16), child: compactBody);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpAndGuide)),
      body: Padding(padding: const EdgeInsets.all(16), child: compactBody),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.18),
            Colors.red.withOpacity(0.10),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.menu_book, color: Colors.amber),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.helpUiManualTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations l10n) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: l10n.helpUiSearchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildCategoryChips(AppLocalizations l10n, String lang) {
    final categories = _categories(lang);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: Text(l10n.helpUiAllChip),
          selected: _selectedCategory == null,
          onSelected: (_) => setState(() => _selectedCategory = null),
        ),
        for (final category in categories)
          ChoiceChip(
            label: Text(category),
            selected: _selectedCategory == category,
            onSelected: (_) {
              setState(() {
                _selectedCategory = _selectedCategory == category
                    ? null
                    : category;
              });
            },
          ),
      ],
    );
  }

  Widget _buildCompactTopicDetail(
    BuildContext context,
    AppLocalizations l10n,
    String lang,
    HelpTopic topic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(topic.icon, color: Colors.amber),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title(lang),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.category(lang),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade200,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topic.summary(lang),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _DetailCard(
          title: l10n.helpUiHowItWorks,
          icon: Icons.route,
          bullets: topic.howItWorks(lang),
        ),
        const SizedBox(height: 12),
        _DetailCard(
          title: l10n.helpUiTips,
          icon: Icons.lightbulb,
          bullets: topic.tips(lang),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 48, color: Colors.white54),
          const SizedBox(height: 12),
          Text(
            l10n.helpUiNoResultsTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.helpUiNoResultsBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.icon,
    required this.bullets,
  });

  final String title;
  final IconData icon;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(Icons.circle, size: 8, color: Colors.amber),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      bullet,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

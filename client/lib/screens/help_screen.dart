import 'package:flutter/material.dart';

import '../data/help_content.dart';

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

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HelpTopic> _filteredTopics() {
    final query = _query.trim().toLowerCase();
    return helpTopics.where((topic) {
      final categoryMatch =
          _selectedCategory == null ||
          topic.category(_isNl) == _selectedCategory;
      final queryMatch =
          query.isEmpty || topic.searchableText(_isNl).contains(query);
      return categoryMatch && queryMatch;
    }).toList();
  }

  List<String> _categories() {
    final categories =
        helpTopics.map((topic) => topic.category(_isNl)).toSet().toList()
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

  Future<void> _openTopicSheet(HelpTopic topic) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.92,
          child: _HelpTopicDetail(
            topic: topic,
            isNl: _isNl,
            titleHow: _tr('Hoe werkt dit?', 'How does this work?'),
            titleTips: _tr('Handige tips', 'Helpful tips'),
            closeLabel: _tr('Sluiten', 'Close'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topics = _filteredTopics();
    final selectedTopic = _resolveSelectedTopic(topics);
    final isWide = MediaQuery.of(context).size.width >= 960;

    if (selectedTopic != null && _selectedTopicId != selectedTopic.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _selectedTopicId = selectedTopic.id);
        }
      });
    }

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildSearchBar(context),
        const SizedBox(height: 12),
        _buildCategoryChips(),
        const SizedBox(height: 16),
        Expanded(
          child: topics.isEmpty
              ? _buildEmptyState()
              : isWide
              ? _buildWideLayout(topics, selectedTopic!)
              : _buildCompactLayout(topics),
        ),
      ],
    );

    if (widget.embedded) {
      return Padding(padding: const EdgeInsets.all(16), child: body);
    }

    return Scaffold(
      appBar: AppBar(title: Text(_tr('Help & Uitleg', 'Help & Guide'))),
      body: Padding(padding: const EdgeInsets.all(16), child: body),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                      _tr('Spelhandleiding', 'Game Manual'),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tr(
                        'Alles over de huidige spelonderdelen, compact uitgelegd voor spelers.',
                        'Everything about the current game modules, explained compactly for players.',
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoPill(
                icon: Icons.language,
                label: _tr('Meertalig', 'Multilingual'),
              ),
              _InfoPill(
                icon: Icons.smartphone,
                label: _tr(
                  'Mobiel, tablet en desktop',
                  'Mobile, tablet and desktop',
                ),
              ),
              _InfoPill(
                icon: Icons.rule,
                label: _tr(
                  'Gebaseerd op actuele modules',
                  'Based on current modules',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: _tr(
          'Zoek op onderdeel, uitleg of tip',
          'Search by module, explanation or tip',
        ),
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

  Widget _buildCategoryChips() {
    final categories = _categories();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: Text(_tr('Alles', 'All')),
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

  Widget _buildWideLayout(List<HelpTopic> topics, HelpTopic selectedTopic) {
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: Card(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: topics.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final topic = topics[index];
                final selected = topic.id == selectedTopic.id;
                return InkWell(
                  onTap: () => setState(() => _selectedTopicId = topic.id),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.amber.withOpacity(0.16)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? Colors.amber.withOpacity(0.40)
                            : Colors.white12,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(topic.icon, color: selected ? Colors.amber : null),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.title(_isNl),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                topic.category(_isNl),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber.shade200,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                topic.summary(_isNl),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _HelpTopicDetail(
                topic: selectedTopic,
                isNl: _isNl,
                titleHow: _tr('Hoe werkt dit?', 'How does this work?'),
                titleTips: _tr('Handige tips', 'Helpful tips'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(List<HelpTopic> topics) {
    return ListView.separated(
      itemCount: topics.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openTopicSheet(topic),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
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
                          topic.title(_isNl),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          topic.category(_isNl),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade200,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.summary(_isNl),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 48, color: Colors.white54),
          const SizedBox(height: 12),
          Text(
            _tr('Geen onderdelen gevonden', 'No modules found'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            _tr(
              'Pas je zoekterm of categorie aan om weer resultaten te zien.',
              'Adjust your search term or category to see results again.',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _HelpTopicDetail extends StatelessWidget {
  const _HelpTopicDetail({
    required this.topic,
    required this.isNl,
    required this.titleHow,
    required this.titleTips,
    this.closeLabel,
  });

  final HelpTopic topic;
  final bool isNl;
  final String titleHow;
  final String titleTips;
  final String? closeLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (closeLabel != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: Text(closeLabel!),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(topic.icon, color: Colors.amber),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.category(isNl),
                    style: TextStyle(
                      color: Colors.amber.shade200,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.title(isNl),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          topic.summary(isNl),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white70, height: 1.4),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: ListView(
            children: [
              _DetailCard(
                title: titleHow,
                icon: Icons.route,
                bullets: topic.howItWorks(isNl),
              ),
              const SizedBox(height: 12),
              _DetailCard(
                title: titleTips,
                icon: Icons.lightbulb,
                bullets: topic.tips(isNl),
              ),
            ],
          ),
        ),
      ],
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

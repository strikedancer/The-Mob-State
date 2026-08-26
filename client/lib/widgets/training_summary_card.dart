import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';

const Color _gold = Color(0xFFD4AF37);

/// Compact training circuit snapshot for the dashboard home panel.
class TrainingSummaryCard extends StatefulWidget {
  const TrainingSummaryCard({super.key, this.onOpenHub});

  final VoidCallback? onOpenHub;

  @override
  State<TrainingSummaryCard> createState() => _TrainingSummaryCardState();
}

class _TrainingSummaryCardState extends State<TrainingSummaryCard> {
  final ApiClient _apiClient = ApiClient();
  bool _loading = true;
  double _gymBonus = 0;
  double _rangeBonus = 0;
  bool _comboActive = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await _apiClient.get('/training/status');
      if (response.statusCode != 200 || !mounted) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>?;
      final gym = data?['gym'] as Map<String, dynamic>?;
      final shooting = data?['shootingRange'] as Map<String, dynamic>?;
      final combo = data?['trainingComboReadiness'] as Map<String, dynamic>?;
      final comboFrac = (combo?['bonusFraction'] as num?)?.toDouble() ?? 0;
      setState(() {
        _gymBonus = (gym?['strengthBonus'] as num?)?.toDouble() ?? 0;
        _rangeBonus = (shooting?['accuracyBonus'] as num?)?.toDouble() ?? 0;
        _comboActive = combo?['active'] == true && comboFrac > 0;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gymPct = (_gymBonus * 100).toStringAsFixed(1);
    final rangePct = (_rangeBonus * 100).toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A1810).withValues(alpha: 0.95),
            const Color(0xFF120808),
          ],
        ),
        border: Border.all(color: _gold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.red.shade300, size: 20),
              const SizedBox(width: 6),
              Icon(Icons.add, size: 14, color: Colors.white38),
              const SizedBox(width: 6),
              Icon(Icons.gps_fixed, color: Colors.orange.shade300, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n?.trainingSummaryTitle ?? 'Training circuit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              if (widget.onOpenHub != null)
                TextButton(
                  onPressed: widget.onOpenHub,
                  style: TextButton.styleFrom(foregroundColor: _gold),
                  child: Text(l10n?.trainingSummaryOpenHub ?? 'Open hub'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (_loading)
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: _gold),
              ),
            )
          else ...[
            Text(
              l10n?.crimeTrainingBonusStrip(gymPct, rangePct) ??
                  'Bonuses: +$gymPct% gym, +$rangePct% range',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  _comboActive ? Icons.bolt : Icons.bolt_outlined,
                  size: 16,
                  color: _comboActive ? Colors.amber.shade300 : Colors.white38,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _comboActive
                        ? (l10n?.trainingSummaryComboActive ??
                            'Combo active today')
                        : (l10n?.trainingSummaryComboInactive ??
                            'Train gym + range today for combo'),
                    style: TextStyle(
                      color: _comboActive ? Colors.amber.shade200 : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

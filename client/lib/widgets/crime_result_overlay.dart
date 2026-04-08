import 'package:flutter/material.dart';

class CrimeResultOverlay extends StatelessWidget {
  final String crimeName;
  final int reward;
  final int xpGained;
  final VoidCallback onContinue;
  final bool embedded;

  const CrimeResultOverlay({
    super.key,
    required this.crimeName,
    required this.reward,
    required this.xpGained,
    required this.onContinue,
    this.embedded = false,
  });

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: const EdgeInsets.all(24),
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 48, color: Color(0xFFFFC107)),
            const SizedBox(height: 12),
            Text(
              crimeName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ResultStat(
                  icon: Icons.euro,
                  label: 'Geld',
                  value: '+€${_formatNumber(reward)}',
                  color: Colors.green,
                ),
                _ResultStat(
                  icon: Icons.auto_awesome,
                  label: 'XP',
                  value: '+$xpGained',
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                child: const Text('Verder'),
              ),
            ),
          ],
        ),
      ),
    );

    if (embedded) {
      return Center(child: card);
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(child: card),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResultStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

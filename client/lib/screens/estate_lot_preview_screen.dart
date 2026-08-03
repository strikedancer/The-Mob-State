import 'package:flutter/material.dart';
import '../widgets/estate_lot_view.dart';

/// Preview: one composite estate image with independent upgrade sliders.
class EstateLotPreviewScreen extends StatefulWidget {
  const EstateLotPreviewScreen({super.key});

  @override
  State<EstateLotPreviewScreen> createState() => _EstateLotPreviewScreenState();
}

class _EstateLotPreviewScreenState extends State<EstateLotPreviewScreen> {
  int _house = 1;
  int _parking = 1;
  int _shed = 1;
  int _fence = 1;

  Widget _slider(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value / ${EstateLotView.maxLevel}'),
        Slider(
          value: value.toDouble(),
          min: EstateLotView.minLevel.toDouble(),
          max: EstateLotView.maxLevel.toDouble(),
          divisions: EstateLotView.maxLevel - EstateLotView.minLevel,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estate lot (composite)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'One image: fixed grass + independently upgradeable house, parking, shed and fence.',
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey.shade900,
            clipBehavior: Clip.antiAlias,
            child: EstateLotView(
              houseLevel: _house,
              parkingLevel: _parking,
              shedLevel: _shed,
              fenceLevel: _fence,
            ),
          ),
          const SizedBox(height: 16),
          _slider('House', _house, (v) => setState(() => _house = v)),
          _slider('Parking', _parking, (v) => setState(() => _parking = v)),
          _slider('Shed', _shed, (v) => setState(() => _shed = v)),
          _slider('Fence / security', _fence, (v) => setState(() => _fence = v)),
        ],
      ),
    );
  }
}

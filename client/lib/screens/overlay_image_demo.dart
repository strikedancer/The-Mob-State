import 'package:flutter/material.dart';
import '../widgets/overlay_image.dart';

/// Demo screen to test OverlayImage widget with different overlay combinations
class OverlayImageDemo extends StatefulWidget {
  const OverlayImageDemo({super.key});

  @override
  State<OverlayImageDemo> createState() => _OverlayImageDemoState();
}

class _OverlayImageDemoState extends State<OverlayImageDemo> {
  bool _showDamaged = false;
  bool _showLocked = false;
  bool _showUpgraded = false;
  bool _showInTransit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlay Image Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Phase 13.1: Image Overlays Test',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Toggle overlays below to test compositing:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Vehicle Image with Overlays
              Center(
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: OverlayImageBuilder()
                        .base('images/vehicles/toyota_corolla.png')
                        .damaged(when: _showDamaged)
                        .locked(when: _showLocked)
                        .upgraded(when: _showUpgraded)
                        .inTransit(when: _showInTransit)
                        .fit(BoxFit.cover)
                        .build(),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Controls
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overlay Controls',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Damaged Overlay'),
                        subtitle: const Text('Shows vehicle damage'),
                        value: _showDamaged,
                        onChanged: (value) {
                          setState(() {
                            _showDamaged = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Locked Overlay'),
                        subtitle: const Text('Shows item is locked'),
                        value: _showLocked,
                        onChanged: (value) {
                          setState(() {
                            _showLocked = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Upgraded Overlay'),
                        subtitle: const Text('Shows item is upgraded'),
                        value: _showUpgraded,
                        onChanged: (value) {
                          setState(() {
                            _showUpgraded = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('In Transit Overlay'),
                        subtitle: const Text('Shows vehicle in transport'),
                        value: _showInTransit,
                        onChanged: (value) {
                          setState(() {
                            _showInTransit = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Examples of different vehicles
              const Text(
                'Multiple Vehicle Examples',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildExampleCard(
                    'Old Sedan',
                    'old_sedan.png',
                    overlays: [],
                  ),
                  _buildExampleCard(
                    'Damaged Corolla',
                    'toyota_corolla.png',
                    overlays: [VehicleOverlays.damaged],
                  ),
                  _buildExampleCard(
                    'Locked Sports Car',
                    'sports_car.png',
                    overlays: [VehicleOverlays.locked],
                  ),
                  _buildExampleCard(
                    'In Transit Van',
                    'delivery_van.png',
                    overlays: [VehicleOverlays.inTransit],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(String title, String imagePath,
      {List<String> overlays = const []}) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: OverlayImage(
              base: 'images/vehicles/$imagePath',
              overlays: overlays,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

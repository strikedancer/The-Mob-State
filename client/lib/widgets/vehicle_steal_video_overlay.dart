import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class VehicleStealVideoOverlay extends StatefulWidget {
  final String videoPath;
  final VoidCallback onComplete;
  final int durationSeconds;

  const VehicleStealVideoOverlay({
    super.key,
    required this.videoPath,
    required this.onComplete,
    this.durationSeconds = 10,
  });

  @override
  State<VehicleStealVideoOverlay> createState() =>
      _VehicleStealVideoOverlayState();
}

class _VehicleStealVideoOverlayState extends State<VehicleStealVideoOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _secondsLeft = 10;
  Timer? _timer;
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.durationSeconds;
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _setupVideo();
    _startTimer();
  }

  void _setupVideo() {
    _viewType = 'vehicle-steal-video-${DateTime.now().millisecondsSinceEpoch}';
    final videoElement = html.VideoElement()
      ..src = widget.videoPath
      ..autoplay = true
      ..loop = false
      ..muted = false
      ..controls = false
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover';

    videoElement.onCanPlay.listen((_) {
      videoElement.play().catchError((e) {
        print('[VehicleStealVideoOverlay] Auto-play failed: $e');
      });
    });

    videoElement.onError.listen((_) {
      print('[VehicleStealVideoOverlay] Video load error: ${widget.videoPath}');
    });

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      return videoElement;
    });
  }

  void _startTimer() {
    _fadeController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        _fadeController.reverse().then((_) {
          if (mounted) {
            widget.onComplete();
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _secondsLeft--;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      Future.microtask(() => widget.onComplete());
      return const Center(child: CircularProgressIndicator());
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: Colors.black,
        child: HtmlElementView(viewType: _viewType),
      ),
    );
  }
}

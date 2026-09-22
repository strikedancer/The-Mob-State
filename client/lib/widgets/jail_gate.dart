import 'package:flutter/material.dart';

import '../services/jail_service.dart';
import 'jail_screen.dart';

/// Replaces [child] with [JailOverlay] while the player is jailed.
///
/// Use on screens where gameplay actions are blocked in jail. Do not wrap
/// prison, world chat, training hub, court, messages, or other allowlisted hubs.
class JailGate extends StatefulWidget {
  final Widget child;
  final bool embedded;

  /// When false, always shows [child] (e.g. parent already gates).
  final bool enabled;

  const JailGate({
    super.key,
    required this.child,
    this.embedded = false,
    this.enabled = true,
  });

  @override
  State<JailGate> createState() => _JailGateState();
}

class _JailGateState extends State<JailGate> {
  final JailService _jailService = JailService();
  int? _remainingSeconds;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _refresh();
    } else {
      _loading = false;
    }
  }

  @override
  void didUpdateWidget(covariant JailGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    if (!widget.enabled) {
      if (mounted) {
        setState(() {
          _remainingSeconds = null;
          _loading = false;
        });
      }
      return;
    }
    final seconds = await _jailService.checkJailStatus();
    if (!mounted) return;
    setState(() {
      _remainingSeconds = seconds > 0 ? seconds : null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final remaining = _remainingSeconds;
    if (remaining != null && remaining > 0) {
      return JailOverlay(
        embedded: widget.embedded,
        remainingSeconds: remaining,
        onReleased: () {
          setState(() => _remainingSeconds = null);
          _refresh();
        },
      );
    }
    return widget.child;
  }
}

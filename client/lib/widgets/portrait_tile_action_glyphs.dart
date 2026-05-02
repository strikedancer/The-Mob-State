import 'package:flutter/widgets.dart';

/// Vector-drawn action glyphs for custom portrait tiles in Settings.
///
/// Flutter web often fails to paint [Icon] / icon-font glyphs inside overlays
/// (empty colored circles; console may mention Noto font fallback). Canvas paths
/// do not depend on font loading — see `docs/module-protocols/player-portraits.md`.
class PortraitTileDownloadGlyph extends StatelessWidget {
  const PortraitTileDownloadGlyph({
    super.key,
    this.color = const Color(0xFFFFFFFF),
    this.size = 17,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DownloadArrowPainter(color: color),
    );
  }
}

class PortraitTileTrashGlyph extends StatelessWidget {
  const PortraitTileTrashGlyph({
    super.key,
    this.color = const Color(0xFFFFFFFF),
    this.size = 17,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrashCanPainter(color: color),
    );
  }
}

class _DownloadArrowPainter extends CustomPainter {
  _DownloadArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    canvas.drawLine(Offset(w * 0.18, h * 0.78), Offset(w * 0.82, h * 0.78), p);
    canvas.drawLine(Offset(cx, h * 0.16), Offset(cx, h * 0.62), p);
    final head = Path()
      ..moveTo(cx - w * 0.15, h * 0.52)
      ..lineTo(cx, h * 0.68)
      ..lineTo(cx + w * 0.15, h * 0.52);
    canvas.drawPath(head, p);
  }

  @override
  bool shouldRepaint(covariant _DownloadArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _TrashCanPainter extends CustomPainter {
  _TrashCanPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    canvas.drawLine(Offset(w * 0.12, h * 0.24), Offset(w * 0.88, h * 0.24), p);
    canvas.drawLine(Offset(cx, h * 0.12), Offset(cx, h * 0.24), p);

    final body = Path()
      ..moveTo(w * 0.22, h * 0.30)
      ..lineTo(w * 0.78, h * 0.30)
      ..lineTo(w * 0.72, h * 0.88)
      ..lineTo(w * 0.28, h * 0.88)
      ..close();
    canvas.drawPath(body, p);

    canvas.drawLine(Offset(w * 0.36, h * 0.40), Offset(w * 0.34, h * 0.76), p);
    canvas.drawLine(Offset(cx, h * 0.40), Offset(cx, h * 0.76), p);
    canvas.drawLine(Offset(w * 0.64, h * 0.40), Offset(w * 0.66, h * 0.76), p);
  }

  @override
  bool shouldRepaint(covariant _TrashCanPainter oldDelegate) =>
      oldDelegate.color != color;
}

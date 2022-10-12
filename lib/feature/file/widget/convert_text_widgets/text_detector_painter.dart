import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements, this.isSelectAll, this.elementsOrigin);

  final Size absoluteImageSize;
  final List<TextElement> elements;
  final List<TextElement> elementsOrigin;
  final bool isSelectAll;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextElement container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint line = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red.withOpacity(0.2)
      ..strokeWidth = 1.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
    for (TextElement elementsOrigin in elementsOrigin) {
      canvas.drawRect(scaleRect(elementsOrigin), line);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
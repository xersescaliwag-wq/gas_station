import 'package:flutter/cupertino.dart';

import '../core/app_colors.dart';

/// Renders a digital 7-segment LED digit or character.
class SevenSegmentDigit extends StatelessWidget {
  final String char;
  final Color color;
  final double width;
  final double height;
  final bool showOffSegments;

  const SevenSegmentDigit({
    super.key,
    required this.char,
    required this.color,
    this.width = 34,
    this.height = 52,
    this.showOffSegments = true,
  });

  static const Map<String, List<bool>> _segmentMap = {
    //           a      b      c      d      e      f      g
    '0': [true, true, true, true, true, true, false],
    '1': [false, true, true, false, false, false, false],
    '2': [true, true, false, true, true, false, true],
    '3': [true, true, true, true, false, false, true],
    '4': [false, true, true, false, false, true, true],
    '5': [true, false, true, true, false, true, true],
    '6': [true, false, true, true, true, true, true],
    '7': [true, true, true, false, false, false, false],
    '8': [true, true, true, true, true, true, true],
    '9': [true, true, true, true, false, true, true],
    '-': [false, false, false, false, false, false, true],
    ' ': [false, false, false, false, false, false, false],
  };

  @override
  Widget build(BuildContext context) {
    final activeSegments = _segmentMap[char] ?? _segmentMap[' '];

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SevenSegmentPainter(
          activeSegments: activeSegments!,
          color: color,
          showOffSegments: showOffSegments,
        ),
      ),
    );
  }
}

class _SevenSegmentPainter extends CustomPainter {
  final List<bool> activeSegments;
  final Color color;
  final bool showOffSegments;

  _SevenSegmentPainter({
    required this.activeSegments,
    required this.color,
    required this.showOffSegments,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final t = w * 0.20; // wider segment thickness
    final gap = t * 0.18; // gap between segments

    final offColor = color.withValues(alpha: 0.08);
    final onColor = color;

    Paint paintFor(bool active) {
      final p = Paint()
        ..style = PaintingStyle.fill
        ..color = active ? onColor : (showOffSegments ? offColor : const Color(0x00000000));

      if (active) {
        p.maskFilter = const MaskFilter.blur(BlurStyle.solid, 2.0);
      }
      return p;
    }

    final halfH = h / 2;

    // Segment a (top)
    final pathA = Path()
      ..moveTo(gap, 0)
      ..lineTo(w - gap, 0)
      ..lineTo(w - t - gap, t)
      ..lineTo(t + gap, t)
      ..close();

    // Segment g (middle)
    final pathG = Path()
      ..moveTo(gap + t / 2, halfH)
      ..lineTo(t + gap, halfH - t / 2)
      ..lineTo(w - t - gap, halfH - t / 2)
      ..lineTo(w - gap - t / 2, halfH)
      ..lineTo(w - t - gap, halfH + t / 2)
      ..lineTo(t + gap, halfH + t / 2)
      ..close();

    // Segment d (bottom)
    final pathD = Path()
      ..moveTo(t + gap, h - t)
      ..lineTo(w - t - gap, h - t)
      ..lineTo(w - gap, h)
      ..lineTo(gap, h)
      ..close();

    // Segment f (top-left)
    final pathF = Path()
      ..moveTo(0, gap)
      ..lineTo(t, t + gap)
      ..lineTo(t, halfH - t / 2 - gap)
      ..lineTo(0, halfH - gap)
      ..close();

    // Segment b (top-right)
    final pathB = Path()
      ..moveTo(w - t, t + gap)
      ..lineTo(w, gap)
      ..lineTo(w, halfH - gap)
      ..lineTo(w - t, halfH - t / 2 - gap)
      ..close();

    // Segment e (bottom-left)
    final pathE = Path()
      ..moveTo(0, halfH + gap)
      ..lineTo(t, halfH + t / 2 + gap)
      ..lineTo(t, h - t - gap)
      ..lineTo(0, h - gap)
      ..close();

    // Segment c (bottom-right)
    final pathC = Path()
      ..moveTo(w - t, halfH + t / 2 + gap)
      ..lineTo(w, halfH + gap)
      ..lineTo(w, h - gap)
      ..lineTo(w - t, h - t - gap)
      ..close();

    canvas.drawPath(pathA, paintFor(activeSegments[0]));
    canvas.drawPath(pathB, paintFor(activeSegments[1]));
    canvas.drawPath(pathC, paintFor(activeSegments[2]));
    canvas.drawPath(pathD, paintFor(activeSegments[3]));
    canvas.drawPath(pathE, paintFor(activeSegments[4]));
    canvas.drawPath(pathF, paintFor(activeSegments[5]));
    canvas.drawPath(pathG, paintFor(activeSegments[6]));
  }

  @override
  bool shouldRepaint(covariant _SevenSegmentPainter oldDelegate) {
    return oldDelegate.activeSegments != activeSegments || oldDelegate.color != color;
  }
}

/// A 4-digit digital 7-segment display board showing currency + price digits (XX.XX).
class SevenSegmentDisplay extends StatelessWidget {
  final double value;
  final Color color;
  final double digitWidth;
  final double digitHeight;
  final bool editable;
  final bool isWide;
  final ValueChanged<double>? onChanged;

  const SevenSegmentDisplay({
    super.key,
    required this.value,
    this.color = AppColors.green,
    this.digitWidth = 32,
    this.digitHeight = 50,
    this.editable = false,
    this.isWide = true,
    this.onChanged,
  });

  String _formatValue(double val) {
    if (val >= 1000) {
      return val.toStringAsFixed(0).padLeft(4, '0');
    } else if (val >= 100) {
      return val.toStringAsFixed(1).padLeft(5, '0');
    } else {
      return val.toStringAsFixed(2).padLeft(5, '0');
    }
  }

  void _adjustDigit(int digitPosition, int delta) {
    if (onChanged == null) return;
    String priceStr = _formatValue(value);
    List<String> chars = priceStr.split('');

    if (digitPosition < 0 || digitPosition >= chars.length || chars[digitPosition] == '.') {
      return;
    }

    int currentDigit = int.tryParse(chars[digitPosition]) ?? 0;
    int newDigit = (currentDigit + delta) % 10;
    if (newDigit < 0) newDigit += 10;

    chars[digitPosition] = newDigit.toString();
    double? newValue = double.tryParse(chars.join(''));
    if (newValue != null && newValue >= 0) {
      onChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedStr = _formatValue(value);

    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xEE04060C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: isWide ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Currency symbol "₱"
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              '₱',
              style: TextStyle(
                fontSize: digitHeight * 0.7,
                fontWeight: FontWeight.bold,
                color: color,
                shadows: [
                  Shadow(color: color.withValues(alpha: 0.8), blurRadius: 10),
                ],
              ),
            ),
          ),
          // 4 7-Segment Digits + Decimal Point
          for (int i = 0; i < formattedStr.length; i++) ...[
            if (formattedStr[i] == '.')
              _DecimalDot(
                size: digitWidth * 0.35,
                height: digitHeight,
                color: color,
              )
            else
              _DigitColumn(
                char: formattedStr[i],
                color: color,
                width: digitWidth,
                height: digitHeight,
                editable: editable,
                onIncrement: () => _adjustDigit(i, 1),
                onDecrement: () => _adjustDigit(i, -1),
              ),
          ],
        ],
      ),
    );
  }
}

class _DigitColumn extends StatelessWidget {
  final String char;
  final Color color;
  final double width;
  final double height;
  final bool editable;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _DigitColumn({
    required this.char,
    required this.color,
    required this.width,
    required this.height,
    required this.editable,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    if (!editable) {
      return SevenSegmentDigit(
        char: char,
        color: color,
        width: width,
        height: height,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onIncrement,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Icon(
              CupertinoIcons.chevron_up,
              size: width * 0.6,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ),
        GestureDetector(
          onTap: onIncrement,
          child: SevenSegmentDigit(
            char: char,
            color: color,
            width: width,
            height: height,
          ),
        ),
        GestureDetector(
          onTap: onDecrement,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Icon(
              CupertinoIcons.chevron_down,
              size: width * 0.6,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}

class _DecimalDot extends StatelessWidget {
  final double size;
  final double height;
  final Color color;

  const _DecimalDot({
    required this.size,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 4,
      height: height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

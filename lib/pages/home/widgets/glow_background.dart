import 'package:flutter/cupertino.dart';

class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'asset/background.jpg',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

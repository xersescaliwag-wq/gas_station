import 'package:flutter/cupertino.dart';

class Fuel {
  final String name;
  final Color color;

  /// Tank level, 0..1
  final double tank;

  /// Price when the app loaded (used to show the change badge).
  final double original;

  double price;

  Fuel({
    required this.name,
    required this.color,
    required this.tank,
    required this.price,
  }) : original = price;

  double get delta => price - original;
  bool get changed => delta.abs() >= 0.005;
}

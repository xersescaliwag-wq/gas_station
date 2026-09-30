import 'package:flutter/foundation.dart';

import '../core/app_colors.dart';
import '../models/fuel.dart';
import '../services/pi_service.dart';

/// Holds the state + logic of the home page so the UI stays dumb.
class HomeController extends ChangeNotifier {
  HomeController({PiService? pi}) : _pi = pi ?? const PiService();

  static const double step = 0.10;

  final PiService _pi;
  String get piHost => _pi.host;

  final List<Fuel> fuels = [
    Fuel(name: 'Premium', color: AppColors.red, tank: 0.72, price: 68.40),
    Fuel(name: 'Unleaded', color: AppColors.lightGreen, tank: 0.54, price: 62.90),
    Fuel(name: 'Diesel', color: AppColors.orange, tank: 0.31, price: 58.25),
  ];

  int selectedIndex = 0;
  bool piOnline = false;
  bool checking = true;
  bool syncing = false;
  DateTime? lastSync;

  Fuel get current => fuels[selectedIndex];
  bool get canPush => piOnline && !syncing;

  void select(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void adjust(double amount) {
    current.price = ((current.price + amount) * 100).round() / 100;
    notifyListeners();
  }

  void setPrice(double newPrice, {int? index}) {
    final target = index != null ? fuels[index] : current;
    target.price = (newPrice * 100).round() / 100;
    notifyListeners();
  }

  Future<void> checkPi() async {
    checking = true;
    notifyListeners();
    piOnline = await _pi.ping();
    checking = false;
    notifyListeners();
  }

  Future<void> push() async {
    if (!canPush) return;
    syncing = true;
    notifyListeners();
    final ok = await _pi.pushPrices({for (final f in fuels) f.name: f.price});
    syncing = false;
    if (ok) lastSync = DateTime.now();
    notifyListeners();
  }
}

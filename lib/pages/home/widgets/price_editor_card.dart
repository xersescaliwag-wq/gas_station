import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:ArPIpie/core/app_colors.dart';
import 'package:ArPIpie/models/fuel.dart';
import 'package:ArPIpie/widgets/seven_segment_display.dart';
import 'round_icon_button.dart';

class PriceEditorCard extends StatelessWidget {
  final Fuel fuel;
  final bool canPush;
  final bool syncing;
  final DateTime? lastSync;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final ValueChanged<double>? onPriceChanged;
  final VoidCallback onPush;

  const PriceEditorCard({
    super.key,
    required this.fuel,
    required this.canPush,
    required this.syncing,
    required this.lastSync,
    required this.onDecrease,
    required this.onIncrease,
    this.onPriceChanged,
    required this.onPush,
  });

  String _time(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              '${fuel.name} · Adjust Price Digits',
              style: const TextStyle(fontSize: 14, color: AppColors.grey),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                RoundIconButton(icon: FontAwesomeIcons.minus, onTap: onDecrease),
                const SizedBox(width: 8),
                Expanded(
                  child: SevenSegmentDisplay(
                    value: fuel.price,
                    color: fuel.color,
                    digitWidth: 30,
                    digitHeight: 48,
                    editable: true,
                    isWide: true,
                    onChanged: onPriceChanged,
                  ),
                ),
                const SizedBox(width: 8),
                RoundIconButton(icon: FontAwesomeIcons.plus, onTap: onIncrease),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(18),
                onPressed: canPush ? onPush : null,
                child: syncing
                    ? const CupertinoActivityIndicator(color: AppColors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.cloudArrowUp, size: 16),
                          SizedBox(width: 10),
                          Text('Send to Raspberry Pi',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              lastSync == null ? 'Not synced yet' : 'Last synced at ${_time(lastSync!)}',
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:ArPIpie/core/app_colors.dart';
import 'package:ArPIpie/models/fuel.dart';
import 'package:ArPIpie/widgets/seven_segment_display.dart';

class FuelCard extends StatelessWidget {
  final Fuel fuel;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<double>? onPriceChanged;

  const FuelCard({
    super.key,
    required this.fuel,
    required this.selected,
    required this.onTap,
    this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: fuel.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.gasPump, size: 16, color: fuel.color),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    fuel.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SevenSegmentDisplay(
                        value: fuel.price,
                        color: fuel.color,
                        digitWidth: selected ? 30 : 32,
                        digitHeight: selected ? 46 : 50,
                        editable: selected,
                        isWide: true,
                        onChanged: onPriceChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '/ L',
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

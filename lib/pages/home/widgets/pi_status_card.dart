import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:ArPIpie/core/app_colors.dart';

class PiStatusCard extends StatelessWidget {
  final String host;
  final bool checking;
  final bool online;
  final VoidCallback onRefresh;

  const PiStatusCard({
    super.key,
    required this.host,
    required this.checking,
    required this.online,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final color = checking ? AppColors.grey : (online ? AppColors.green : AppColors.red);
    final label = checking ? 'Connecting…' : (online ? 'Connected' : 'Offline');

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
              child: Center(child: FaIcon(FontAwesomeIcons.microchip, size: 18, color: color)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Raspberry Pi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text('$label · $host',
                          style: const TextStyle(fontSize: 13, color: AppColors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 36),
              onPressed: checking ? null : onRefresh,
              child: checking
                  ? const CupertinoActivityIndicator()
                  : const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

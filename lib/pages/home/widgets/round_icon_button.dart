import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ArPIpie/core/app_colors.dart';

class RoundIconButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onTap;

  const RoundIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(color: AppColors.glassFill, shape: BoxShape.circle),
        child: Center(child: FaIcon(icon, size: 18, color: AppColors.white)),
      ),
    );
  }
}

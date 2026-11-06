import 'package:flutter/material.dart';
import '../app/constants.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;

  const StatusBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor = KebuninColors.lightGreenPill,
    this.textColor = KebuninColors.forestGreen,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  factory StatusBadge.organic({double fontSize = 11}) {
    return StatusBadge(
      label: '100% Organik',
      icon: Icons.verified_rounded,
      backgroundColor: const Color(0xFFEBF5EE),
      textColor: KebuninColors.forestGreen,
      fontSize: fontSize,
    );
  }

  factory StatusBadge.fresh({double fontSize = 11}) {
    return StatusBadge(
      label: 'Panen Subuh',
      icon: Icons.water_drop_rounded,
      backgroundColor: const Color(0xFFE6F4EA),
      textColor: KebuninColors.leafGreen,
      fontSize: fontSize,
    );
  }

  factory StatusBadge.discount(int percent, {double fontSize = 11}) {
    return StatusBadge(
      label: '-$percent%',
      icon: Icons.local_offer_rounded,
      backgroundColor: const Color(0xFFFFF0E0),
      textColor: KebuninColors.carrotOrange,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(KebuninRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 3, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}


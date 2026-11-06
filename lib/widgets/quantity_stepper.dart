import 'package:flutter/material.dart';
import '../app/constants.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double size;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KebuninColors.warmCream,
        borderRadius: BorderRadius.circular(KebuninRadius.pill),
        border: Border.all(color: KebuninColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: onDecrement,
            isDestructive: quantity == 1,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 28),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: KebuninColors.charcoal,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onTap: onIncrement,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(KebuninRadius.pill),
      child: Container(
        width: size - 4,
        height: size - 4,
        decoration: BoxDecoration(
          color: isPrimary
              ? KebuninColors.forestGreen
              : (isDestructive
                  ? const Color(0xFFFDE8E8)
                  : KebuninColors.white),
          shape: BoxShape.circle,
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: KebuninColors.forestGreen.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 16,
          color: isPrimary
              ? KebuninColors.white
              : (isDestructive ? KebuninColors.error : KebuninColors.charcoal),
        ),
      ),
    );
  }
}


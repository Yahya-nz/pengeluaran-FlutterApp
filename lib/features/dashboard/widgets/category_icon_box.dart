import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CategoryIconBox extends StatelessWidget {
  const CategoryIconBox({
    super.key,
    required this.asset,
    this.size = 58,
    this.iconSize = 34,
    this.fallbackIcon = Icons.wallet_rounded,
  });

  final String asset;
  final double size;
  final double iconSize;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final isPng = asset.toLowerCase().endsWith('.png');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: SakuColors.white,
        border: Border.all(color: SakuColors.neutral300, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: isPng
            ? Image.asset(
                asset,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  fallbackIcon,
                  color: SakuColors.neutral700,
                  size: iconSize,
                ),
              )
            : Icon(
                fallbackIcon,
                color: SakuColors.neutral700,
                size: iconSize,
              ),
      ),
    );
  }
}

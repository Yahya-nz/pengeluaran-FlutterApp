import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: SakuColors.neutral50,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SizedBox(
              height: 104,
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Beranda',
                    selected: currentIndex == 0,
                    onTap: () => onSelected(0),
                  ),
                  _NavItem(
                    icon: Icons.article_rounded,
                    label: 'Riwayat',
                    selected: currentIndex == 1,
                    onTap: () => onSelected(1),
                  ),
                  const SizedBox(width: 88),
                  _NavItem(
                    icon: Icons.pie_chart_rounded,
                    label: 'Grafik',
                    selected: false,
                    onTap: () => onSelected(2),
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profil',
                    selected: false,
                    onTap: () => onSelected(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? SakuColors.blue300 : SakuColors.neutral300;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 34),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 36 : 0,
              height: 5,
              decoration: BoxDecoration(
                color: SakuColors.blue300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

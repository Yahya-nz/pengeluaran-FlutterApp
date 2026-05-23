import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/dashboard_data.dart';
import '../models/finance_entry.dart';
import '../widgets/mobile_page.dart';
import '../widgets/transaction_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onOpenHistory});

  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return MobilePage(
      backgroundColor: SakuColors.white,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroBalanceCard()),
          SliverToBoxAdapter(child: _QuickActions()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 22, 30, 0),
              child: _RecentRecordsCard(onOpenHistory: onOpenHistory),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 28, 30, 132),
              child: _ActiveDebtsCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 315,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.asset(
              'background beranda biru.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            top: 54,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
              decoration: BoxDecoration(
                color: SakuColors.blue900.withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: SakuColors.mango100,
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: SakuColors.blue900,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          'Hei, Asadel!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: SakuColors.white,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total Saldo',
                          style: TextStyle(
                            color: SakuColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.visibility_outlined,
                        color: SakuColors.white,
                        size: 34,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _PillValue(
                    child: Text(
                      '12.000.000',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: SakuColors.neutral700,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _PillValue(
                    child: Row(
                      children: [
                        Expanded(
                          child: _SummaryMetric(
                            label: 'Pengeluaran',
                            amount: '1.000.000',
                            icon: Icons.trending_down_rounded,
                            color: SakuColors.danger,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _SummaryMetric(
                            label: 'Pemasukan',
                            amount: '13.000.000',
                            icon: Icons.trending_up_rounded,
                            color: SakuColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillValue extends StatelessWidget {
  const _PillValue({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: SakuColors.blue50,
        border: Border.all(color: SakuColors.blue300, width: 2),
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String label;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 27),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: SizedBox(
        height: 128,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 202,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: SakuColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: SakuColors.black.withValues(alpha: 0.14),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: _QuickActionItem(
                        icon: Icons.savings_rounded,
                        label: 'Budgeting',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: _QuickActionItem(
                        icon: Icons.insights_rounded,
                        label: 'Saku Insight',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 10,
              child: Image.asset(
                'Maskot-dashboard.png',
                width: 135,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 54,
          decoration: BoxDecoration(
            color: SakuColors.blue50,
            border: Border.all(color: SakuColors.blue100, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(icon, color: SakuColors.blue300, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: SakuColors.black,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RecentRecordsCard extends StatelessWidget {
  const _RecentRecordsCard({required this.onOpenHistory});

  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    return _HomeSectionCard(
      title: 'Catatan Terakhir',
      headerColor: SakuColors.white,
      children: [
        const _DateSummary(
            day: 18, month: 'April', weekday: 'Sabtu', total: 11970000),
        ...recentEntries.map(
          (entry) => TransactionTile(entry: entry, compact: true),
        ),
        InkWell(
          onTap: onOpenHistory,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Lihat riwayat lainnya',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: SakuColors.neutral600,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.chevron_right_rounded,
                  color: SakuColors.neutral600,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveDebtsCard extends StatelessWidget {
  const _ActiveDebtsCard();

  @override
  Widget build(BuildContext context) {
    return _HomeSectionCard(
      title: 'Hutang Aktif',
      children: activeDebts
          .map(
            (entry) => TransactionTile(
              entry: entry,
              compact: true,
              showDivider: entry != activeDebts.last,
            ),
          )
          .toList(),
    );
  }
}

class _HomeSectionCard extends StatelessWidget {
  const _HomeSectionCard({
    required this.title,
    required this.children,
    this.headerColor,
  });

  final String title;
  final List<Widget> children;
  final Color? headerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: SakuColors.white,
        border: Border.all(color: SakuColors.neutral100, width: 1.4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SakuColors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: headerColor ?? SakuColors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                title,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _DateSummary extends StatelessWidget {
  const _DateSummary({
    required this.day,
    required this.month,
    required this.weekday,
    required this.total,
  });

  final int day;
  final String month;
  final String weekday;
  final int total;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: SakuColors.blue50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            Text(
              '$day',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    month,
                    style: const TextStyle(
                      color: SakuColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    weekday,
                    style: const TextStyle(
                      color: SakuColors.neutral300,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 124,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  formatRupiah(total),
                  maxLines: 1,
                  style: const TextStyle(
                    color: SakuColors.neutral700,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

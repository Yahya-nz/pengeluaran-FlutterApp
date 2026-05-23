import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/dashboard_data.dart';
import '../models/finance_entry.dart';
import '../widgets/mobile_page.dart';
import '../widgets/transaction_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groupedDays = <int, List<FinanceEntry>>{};
    for (final entry in historyEntries) {
      groupedDays.putIfAbsent(entry.day, () => []).add(entry);
    }

    return MobilePage(
      backgroundColor: SakuColors.white,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _HistorySearchBar()),
          const SliverToBoxAdapter(child: _MonthHeader()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final day = groupedDays.keys.elementAt(index);
                final entries = groupedDays[day]!;

                return _HistoryDayGroup(
                  day: day,
                  month: entries.first.month,
                  weekday: entries.first.weekday,
                  entries: entries,
                );
              },
              childCount: groupedDays.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 132)),
        ],
      ),
    );
  }
}

class _HistorySearchBar extends StatelessWidget {
  const _HistorySearchBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 28, 30, 28),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: SakuColors.neutral300, width: 1.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: SakuColors.neutral300,
                      size: 30,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Cari catatan...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: SakuColors.neutral300,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 18),
            SizedBox.square(
              dimension: 56,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filter akan dibuat nanti.')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: SakuColors.neutral700,
                  side: const BorderSide(
                    color: SakuColors.neutral300,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(Icons.filter_alt_rounded, size: 34),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: SakuColors.blue100,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 26, 30, 26),
        child: Row(
          children: [
            Icon(
              Icons.chevron_left_rounded,
              color: SakuColors.blue900,
              size: 42,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'April',
                    style: TextStyle(
                      color: SakuColors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '2026',
                    style: TextStyle(
                      color: SakuColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: SakuColors.blue900,
              size: 42,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryDayGroup extends StatelessWidget {
  const _HistoryDayGroup({
    required this.day,
    required this.month,
    required this.weekday,
    required this.entries,
  });

  final int day;
  final String month;
  final String weekday;
  final List<FinanceEntry> entries;

  int get total {
    var value = 0;
    for (final entry in entries) {
      if (entry.isIncome) value += entry.amount;
      if (entry.isExpense) value -= entry.amount;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
          color: SakuColors.blue50,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
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
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        weekday,
                        style: const TextStyle(
                          color: SakuColors.neutral300,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  total == 0
                      ? '0'
                      : '${total < 0 ? '-' : ''}${formatRupiah(total)}',
                  style: const TextStyle(
                    color: SakuColors.neutral700,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...entries.map(
          (entry) => TransactionTile(
            entry: entry,
            showDivider: true,
          ),
        ),
      ],
    );
  }
}

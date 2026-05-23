import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/finance_entry.dart';
import 'category_icon_box.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.entry,
    this.compact = false,
    this.showDivider = true,
  });

  final FinanceEntry entry;
  final bool compact;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context);
    final titleSize = compact ? 22.0 : 19.0;
    final noteSize = compact ? 16.0 : 14.0;
    final amountSize = compact ? 22.0 : 18.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: SakuColors.neutral100, width: 1.2),
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 0 : 16,
          vertical: compact ? 14 : 12,
        ),
        child: Row(
          children: [
            CategoryIconBox(
              asset: entry.iconAsset,
              size: compact ? 58 : 50,
              iconSize: compact ? 34 : 30,
              fallbackIcon: _fallbackIcon(entry),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleWithStatus(entry: entry, fontSize: titleSize),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: SakuColors.neutral700,
                        size: 17,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '- ${entry.note}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaler: textScale,
                          style: TextStyle(
                            color: SakuColors.neutral300,
                            fontSize: noteSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  entry.signedAmount,
                  maxLines: 1,
                  style: TextStyle(
                    color: entry.amountColor,
                    fontSize: amountSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                if (entry.dueDate != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.hourglass_bottom_rounded,
                        size: 16,
                        color: SakuColors.neutral300,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        entry.dueDate!,
                        style: const TextStyle(
                          color: SakuColors.neutral300,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    entry.time,
                    style: TextStyle(
                      color: SakuColors.neutral300,
                      fontSize: compact ? 16 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _fallbackIcon(FinanceEntry entry) {
    switch (entry.type) {
      case EntryType.income:
        return Icons.card_giftcard_rounded;
      case EntryType.expense:
        return Icons.restaurant_rounded;
      case EntryType.loanGiven:
        return Icons.payments_rounded;
      case EntryType.debt:
        return Icons.handshake_rounded;
    }
  }
}

class _TitleWithStatus extends StatelessWidget {
  const _TitleWithStatus({required this.entry, required this.fontSize});

  final FinanceEntry entry;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final status = entry.status;

    if (status == null) {
      return Text(
        entry.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: SakuColors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          color: SakuColors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
        ),
        children: [
          TextSpan(text: entry.title),
          const TextSpan(text: ' '),
          TextSpan(
            text: status,
            style: TextStyle(
              color: status == 'Lunas' ? SakuColors.success : SakuColors.danger,
              fontSize: fontSize * 0.6,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum EntryType { income, expense, loanGiven, debt }

class FinanceEntry {
  const FinanceEntry({
    required this.title,
    required this.note,
    required this.amount,
    required this.type,
    required this.day,
    required this.month,
    required this.weekday,
    required this.time,
    required this.iconAsset,
    this.status,
    this.dueDate,
  });

  final String title;
  final String note;
  final int amount;
  final EntryType type;
  final int day;
  final String month;
  final String weekday;
  final String time;
  final String iconAsset;
  final String? status;
  final String? dueDate;

  bool get isIncome => type == EntryType.income;
  bool get isExpense => type == EntryType.expense;
  bool get isLoan => type == EntryType.loanGiven || type == EntryType.debt;

  Color get amountColor {
    if (isIncome) return const Color(0xFF06B800);
    if (isExpense) return const Color(0xFFE20000);
    return const Color(0xFF171717);
  }

  String get signedAmount {
    if (isIncome) return '+ ${formatRupiah(amount)}';
    if (isExpense) return '- ${formatRupiah(amount)}';
    return formatRupiah(amount);
  }
}

String formatRupiah(int amount) {
  final value = amount.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < value.length; i++) {
    final positionFromEnd = value.length - i;
    buffer.write(value[i]);
    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return buffer.toString();
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum DashboardSurface {
  main,
  budget,
  insight,
  notifications,
  addExpense,
  addIncome,
  addDebt,
  addLoan,
  editTransaction,
}

enum AddNoteMode { expense, income, debt, loan }

DashboardSurface surfaceForMode(AddNoteMode mode) {
  return switch (mode) {
    AddNoteMode.expense => DashboardSurface.addExpense,
    AddNoteMode.income => DashboardSurface.addIncome,
    AddNoteMode.debt => DashboardSurface.addDebt,
    AddNoteMode.loan => DashboardSurface.addLoan,
  };
}

class DashboardBudget {
  const DashboardBudget({
    required this.title,
    required this.amountValue,
    required this.remaining,
    required this.progress,
    required this.icon,
  });

  final String title;
  final int amountValue;
  final String remaining;
  final double progress;
  final IconData icon;
}

class DashboardTransaction {
  const DashboardTransaction({
    required this.title,
    required this.note,
    required this.amountValue,
    required this.date,
    required this.time,
    required this.icon,
    required this.color,
    this.settled = false,
    this.apiId,
    this.apiType,
  });

  final String title;
  final String note;
  final int amountValue;
  final String date;
  final String time;
  final IconData icon;
  final Color color;
  final bool settled;
  final int? apiId;
  final String? apiType;

  String get amount {
    final sign = amountValue < 0 ? '-' : '+';
    return '$sign ${_formatPlainAmount(amountValue.abs())}';
  }

  DashboardTransaction copyWith({
    String? title,
    String? note,
    int? amountValue,
    String? date,
    String? time,
    IconData? icon,
    Color? color,
    bool? settled,
    Object? apiId = _noValue,
    Object? apiType = _noValue,
  }) {
    return DashboardTransaction(
      title: title ?? this.title,
      note: note ?? this.note,
      amountValue: amountValue ?? this.amountValue,
      date: date ?? this.date,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      settled: settled ?? this.settled,
      apiId: apiId == _noValue ? this.apiId : apiId as int?,
      apiType: apiType == _noValue ? this.apiType : apiType as String?,
    );
  }
}

const _noValue = Object();

const _initialTransactions = [
  DashboardTransaction(
    title: 'Makanan',
    note: 'Beli jajan kopi sama temen',
    amountValue: -30000,
    date: '18 April 2026',
    time: '11:55 AM',
    icon: Icons.restaurant_rounded,
    color: SakuColors.danger,
  ),
  DashboardTransaction(
    title: 'Hadiah',
    note: 'THR dari bos',
    amountValue: 30000,
    date: '18 April 2026',
    time: '11:55 AM',
    icon: Icons.card_giftcard_rounded,
    color: SakuColors.success,
  ),
  DashboardTransaction(
    title: 'Transportasi',
    note: 'Bensin pulang kampus',
    amountValue: -45000,
    date: '17 April 2026',
    time: '09:20 AM',
    icon: Icons.directions_car_rounded,
    color: SakuColors.danger,
  ),
];

const _initialBudgets = [
  DashboardBudget(
    title: 'Transportasi',
    amountValue: 200000,
    remaining: 'sisa 50%',
    progress: 0.5,
    icon: Icons.directions_car_rounded,
  ),
  DashboardBudget(
    title: 'Belanja',
    amountValue: 150000,
    remaining: 'sisa 40%',
    progress: 0.4,
    icon: Icons.shopping_cart_rounded,
  ),
  DashboardBudget(
    title: 'Skincare',
    amountValue: 300000,
    remaining: 'sisa 35%',
    progress: 0.35,
    icon: Icons.spa_rounded,
  ),
];

String formatPlainAmount(int value) => _formatPlainAmount(value);

String _formatPlainAmount(int value) {
  final text = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final position = text.length - i;
    buffer.write(text[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

List<DashboardTransaction> get initialTransactions => _initialTransactions;
List<DashboardBudget> get initialBudgets => _initialBudgets;

part of '../dashboard_page.dart';

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.state,
    required this.userName,
    required this.userEmail,
    required this.onRequestHomeWidget,
  });

  final DashboardState state;
  final String userName;
  final String userEmail;
  final VoidCallback onRequestHomeWidget;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return switch (state.surface) {
      _DashboardSurface.budget => _BudgetDashboard(
          budgets: state.budgets,
          onBack: cubit.showMain,
        ),
      _DashboardSurface.insight => _InsightDashboard(onBack: cubit.showMain),
      _DashboardSurface.notifications => _NotificationsDashboard(
          onBack: cubit.showMain,
        ),
      _DashboardSurface.addExpense => _AddNoteDashboard(
          mode: _AddNoteMode.expense,
          onBack: cubit.showMain,
          onSwitchMode: cubit.showAddNote,
          onSave: cubit.addTransaction,
        ),
      _DashboardSurface.addIncome => _AddNoteDashboard(
          mode: _AddNoteMode.income,
          onBack: cubit.showMain,
          onSwitchMode: cubit.showAddNote,
          onSave: cubit.addTransaction,
        ),
      _DashboardSurface.addDebt => _AddNoteDashboard(
          mode: _AddNoteMode.debt,
          onBack: cubit.showMain,
          onSwitchMode: cubit.showAddNote,
          onSave: cubit.addTransaction,
        ),
      _DashboardSurface.addLoan => _AddNoteDashboard(
          mode: _AddNoteMode.loan,
          onBack: cubit.showMain,
          onSwitchMode: cubit.showAddNote,
          onSave: cubit.addTransaction,
        ),
      _DashboardSurface.editTransaction => _EditTransactionDashboard(
          item: state.editingTransaction,
          onBack: cubit.showMain,
          onSave: cubit.updateTransaction,
        ),
      _DashboardSurface.main => switch (state.currentIndex) {
          0 => _HomeDashboard(
              userName: userName,
              transactions: state.transactions,
              onOpenHistory: () => cubit.selectTab(1),
              onOpenBudget: () => cubit.showSurface(_DashboardSurface.budget),
              onOpenInsight: () => cubit.showSurface(_DashboardSurface.insight),
            ),
          1 => _HistoryDashboard(
              transactions: state.transactions,
              onDelete: cubit.deleteTransaction,
              onEdit: cubit.openEditTransaction,
              onMarkSettled: cubit.markTransactionSettled,
            ),
          2 => _ChartDashboard(transactions: state.transactions),
          _ => _ProfileDashboard(
              initialName: userName,
              initialEmail: userEmail,
              onOpenNotifications: () =>
                  cubit.showSurface(_DashboardSurface.notifications),
              onAddHomeWidget: onRequestHomeWidget,
            ),
        },
    };
  }
}

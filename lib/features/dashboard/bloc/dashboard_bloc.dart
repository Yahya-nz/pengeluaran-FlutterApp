import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../../core/api/laravel_api_service.dart';
import 'dashboard_event.dart';
import 'dashboard_models.dart';
import 'dashboard_state.dart';

export 'budget_bloc.dart';
export 'budget_event.dart';
export 'budget_state.dart';
export 'dashboard_event.dart';
export 'dashboard_models.dart';
export 'dashboard_state.dart';
export 'notification_bloc.dart';
export 'notification_event.dart';
export 'notification_state.dart';
export 'transaction_bloc.dart';
export 'transaction_event.dart';
export 'transaction_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({bool openAddNote = false})
      : super(DashboardState.initial(openAddNote: openAddNote)) {
    on<DashboardStarted>(_onStarted);
    on<DashboardMainShown>(_onMainShown);
    on<DashboardSurfaceShown>(_onSurfaceShown);
    on<DashboardAddNoteShown>(_onAddNoteShown);
    on<DashboardTabSelected>(_onTabSelected);
    on<DashboardTransactionAdded>(_onTransactionAdded);
    on<DashboardBudgetAdded>(_onBudgetAdded);
    on<DashboardTransactionDeleted>(_onTransactionDeleted);
    on<DashboardTransactionSettled>(_onTransactionSettled);
    on<DashboardEditTransactionOpened>(_onEditTransactionOpened);
    on<DashboardTransactionUpdated>(_onTransactionUpdated);
  }

  static const _homeWidgetProvider = 'SakuSummaryWidgetProvider';

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    await _syncHomeWidget();
  }

  void _onMainShown(
    DashboardMainShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: DashboardSurface.main));
  }

  void _onSurfaceShown(
    DashboardSurfaceShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: event.surface));
  }

  void _onAddNoteShown(
    DashboardAddNoteShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(surface: surfaceForMode(event.mode)));
  }

  void _onTabSelected(
    DashboardTabSelected event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }

  Future<void> _onTransactionAdded(
    DashboardTransactionAdded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        transactions: [event.item, ...state.transactions],
        surface: DashboardSurface.main,
        currentIndex: 1,
      ),
    );
    await _syncHomeWidget();
    await _syncTransactionToApi(event.item, emit);
  }

  void _onBudgetAdded(
    DashboardBudgetAdded event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(budgets: [event.item, ...state.budgets]));
  }

  Future<void> _onTransactionDeleted(
    DashboardTransactionDeleted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        transactions:
            state.transactions.where((entry) => entry != event.item).toList(),
      ),
    );
    await _syncHomeWidget();
  }

  Future<void> _onTransactionSettled(
    DashboardTransactionSettled event,
    Emitter<DashboardState> emit,
  ) async {
    final updated = state.transactions
        .map((entry) =>
            entry == event.item ? entry.copyWith(settled: true) : entry)
        .toList();
    emit(state.copyWith(transactions: updated));
    await _syncHomeWidget();
    try {
      await LaravelApiService.instance.markSettled(
        apiId: event.item.apiId,
        apiType: event.item.apiType,
      );
    } catch (_) {
      // The app remains local-first when the Laravel API is not reachable yet.
    }
  }

  void _onEditTransactionOpened(
    DashboardEditTransactionOpened event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      state.copyWith(
        editingTransaction: event.item,
        surface: DashboardSurface.editTransaction,
      ),
    );
  }

  Future<void> _onTransactionUpdated(
    DashboardTransactionUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    final updated = state.transactions
        .map((entry) => entry == event.oldItem ? event.newItem : entry)
        .toList();
    emit(
      state.copyWith(
        transactions: updated,
        editingTransaction: null,
        surface: DashboardSurface.main,
        currentIndex: 1,
      ),
    );
    await _syncHomeWidget();
  }

  Future<void> _syncHomeWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'balance',
        'Rp ${formatPlainAmount(state.currentBalance)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'expense',
        'Rp ${formatPlainAmount(state.currentExpense)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'latest',
        state.transactions.isEmpty
            ? 'Belum ada catatan'
            : '${state.transactions.first.title} ${state.transactions.first.amount}',
      );
      await HomeWidget.updateWidget(name: _homeWidgetProvider);
    } catch (_) {
      // Platform channel is not available on web and widget tests.
    }
  }

  Future<void> _syncTransactionToApi(
    DashboardTransaction item,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await LaravelApiService.instance.createTransaction(
        LaravelTransactionDraft(
          title: item.title,
          note: item.note,
          amountValue: item.amountValue,
        ),
      );
    } catch (_) {
      // Keep local state even if API sync fails.
    }
  }
}

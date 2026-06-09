import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_models.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc()
      : super(BudgetState(
          budgets: initialBudgets,
        )) {
    on<BudgetLoaded>(_onLoaded);
    on<BudgetAdded>(_onAdded);
    on<BudgetDeleted>(_onDeleted);
  }

  void _onLoaded(BudgetLoaded event, Emitter<BudgetState> emit) {
    emit(state.copyWith(budgets: initialBudgets));
  }

  void _onAdded(BudgetAdded event, Emitter<BudgetState> emit) {
    emit(state.copyWith(budgets: [event.item, ...state.budgets]));
  }

  void _onDeleted(BudgetDeleted event, Emitter<BudgetState> emit) {
    emit(
      state.copyWith(
        budgets: state.budgets.where((entry) => entry != event.item).toList(),
      ),
    );
  }
}

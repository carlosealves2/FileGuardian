import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/domain/usecases/list_processes.dart';

import 'process_list_event.dart';
import 'process_list_state.dart';

class ProcessListBloc extends Bloc<ProcessListEvent, ProcessListState> {
  final ListProcesses listProcesses;

  ProcessListBloc({required this.listProcesses})
      : super(const ProcessListInitial()) {
    on<ProcessListLoadRequested>(_onLoadRequested);
    on<ProcessListNextPageRequested>(_onNextPageRequested);
    on<ProcessListRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    ProcessListLoadRequested event,
    Emitter<ProcessListState> emit,
  ) async {
    emit(const ProcessListLoading());

    final result = await listProcesses(cursor: '');
    result.fold(
      (failure) => emit(ProcessListError(failure.message)),
      (data) => emit(ProcessListLoaded(
        processes: data.processes,
        nextCursor: data.nextCursor,
      )),
    );
  }

  Future<void> _onNextPageRequested(
    ProcessListNextPageRequested event,
    Emitter<ProcessListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProcessListLoaded || !currentState.hasMore) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await listProcesses(cursor: currentState.nextCursor);
    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (data) => emit(ProcessListLoaded(
        processes: [...currentState.processes, ...data.processes],
        nextCursor: data.nextCursor,
      )),
    );
  }

  Future<void> _onRefreshRequested(
    ProcessListRefreshRequested event,
    Emitter<ProcessListState> emit,
  ) async {
    final result = await listProcesses(cursor: '');
    result.fold(
      (failure) => emit(ProcessListError(failure.message)),
      (data) => emit(ProcessListLoaded(
        processes: data.processes,
        nextCursor: data.nextCursor,
      )),
    );
  }
}

import 'package:equatable/equatable.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';

sealed class ProcessListState extends Equatable {
  const ProcessListState();

  @override
  List<Object?> get props => [];
}

class ProcessListInitial extends ProcessListState {
  const ProcessListInitial();
}

class ProcessListLoading extends ProcessListState {
  const ProcessListLoading();
}

class ProcessListLoaded extends ProcessListState {
  final List<ProcessEntity> processes;
  final String nextCursor;
  final bool isLoadingMore;

  const ProcessListLoaded({
    required this.processes,
    required this.nextCursor,
    this.isLoadingMore = false,
  });

  bool get hasMore => nextCursor.isNotEmpty;

  ProcessListLoaded copyWith({
    List<ProcessEntity>? processes,
    String? nextCursor,
    bool? isLoadingMore,
  }) {
    return ProcessListLoaded(
      processes: processes ?? this.processes,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [processes, nextCursor, isLoadingMore];
}

class ProcessListError extends ProcessListState {
  final String message;

  const ProcessListError(this.message);

  @override
  List<Object?> get props => [message];
}

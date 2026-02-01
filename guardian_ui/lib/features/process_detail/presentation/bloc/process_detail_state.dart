import 'package:equatable/equatable.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/process_detail/domain/entities/upload_entity.dart';

sealed class ProcessDetailState extends Equatable {
  const ProcessDetailState();

  @override
  List<Object?> get props => [];
}

class ProcessDetailInitial extends ProcessDetailState {
  const ProcessDetailInitial();
}

class ProcessDetailLoading extends ProcessDetailState {
  const ProcessDetailLoading();
}

class ProcessDetailLoaded extends ProcessDetailState {
  final ProcessEntity process;
  final List<UploadEntity> uploads;
  final String? actionError;

  const ProcessDetailLoaded({
    required this.process,
    required this.uploads,
    this.actionError,
  });

  ProcessDetailLoaded copyWith({
    ProcessEntity? process,
    List<UploadEntity>? uploads,
    String? actionError,
  }) {
    return ProcessDetailLoaded(
      process: process ?? this.process,
      uploads: uploads ?? this.uploads,
      actionError: actionError,
    );
  }

  @override
  List<Object?> get props => [process, uploads, actionError];
}

class ProcessDetailError extends ProcessDetailState {
  final String message;

  const ProcessDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

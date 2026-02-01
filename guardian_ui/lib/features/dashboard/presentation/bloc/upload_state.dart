import 'package:equatable/equatable.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';

sealed class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

class UploadIdle extends UploadState {
  const UploadIdle();
}

class UploadInProgress extends UploadState {
  final Map<String, UploadProgressEntity> progressByUploadId;

  const UploadInProgress({required this.progressByUploadId});

  @override
  List<Object?> get props => [progressByUploadId];
}

class UploadActionError extends UploadState {
  final String message;

  const UploadActionError(this.message);

  @override
  List<Object?> get props => [message];
}

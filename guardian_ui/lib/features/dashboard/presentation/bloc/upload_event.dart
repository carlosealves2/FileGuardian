import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';

sealed class UploadEvent {
  const UploadEvent();
}

class UploadFileRequested extends UploadEvent {
  final String filePath;

  const UploadFileRequested({required this.filePath});
}

class UploadFolderRequested extends UploadEvent {
  final String folderPath;

  const UploadFolderRequested({required this.folderPath});
}

class UploadPauseRequested extends UploadEvent {
  final String processId;

  const UploadPauseRequested({required this.processId});
}

class UploadResumeRequested extends UploadEvent {
  final String processId;

  const UploadResumeRequested({required this.processId});
}

class UploadCancelRequested extends UploadEvent {
  final String processId;

  const UploadCancelRequested({required this.processId});
}

class UploadProgressUpdated extends UploadEvent {
  final UploadProgressEntity progress;
  const UploadProgressUpdated(this.progress);
}

class UploadProgressErrorOccurred extends UploadEvent {
  final String message;
  const UploadProgressErrorOccurred(this.message);
}

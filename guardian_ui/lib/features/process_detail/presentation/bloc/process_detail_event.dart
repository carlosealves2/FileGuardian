import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';

sealed class ProcessDetailEvent {
  const ProcessDetailEvent();
}

class ProcessDetailLoadRequested extends ProcessDetailEvent {
  const ProcessDetailLoadRequested();
}

class ProcessDetailPauseRequested extends ProcessDetailEvent {
  const ProcessDetailPauseRequested();
}

class ProcessDetailResumeRequested extends ProcessDetailEvent {
  const ProcessDetailResumeRequested();
}

class ProcessDetailCancelRequested extends ProcessDetailEvent {
  const ProcessDetailCancelRequested();
}

class ProcessDetailUploadProgressReceived extends ProcessDetailEvent {
  final Map<String, UploadProgressEntity> progressByUploadId;

  const ProcessDetailUploadProgressReceived(this.progressByUploadId);
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/cancel_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/pause_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/resume_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/upload_file.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/upload_folder.dart';

import 'upload_event.dart';
import 'upload_state.dart';

typedef ProcessChangedCallback = void Function();

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadFile uploadFile;
  final UploadFolder uploadFolder;
  final PauseProcess pauseProcess;
  final ResumeProcess resumeProcess;
  final CancelProcess cancelProcess;

  ProcessChangedCallback? onProcessChanged;

  final Map<String, StreamSubscription<dynamic>> _activeStreams = {};
  final Map<String, UploadProgressEntity> _progressMap = {};
  final Set<String> _knownProcessIds = {};

  static const _terminalStatuses = {
    ProcessStatus.completed,
    ProcessStatus.failed,
    ProcessStatus.cancelled,
  };

  UploadBloc({
    required this.uploadFile,
    required this.uploadFolder,
    required this.pauseProcess,
    required this.resumeProcess,
    required this.cancelProcess,
  }) : super(const UploadIdle()) {
    on<UploadFileRequested>(_onFileRequested);
    on<UploadFolderRequested>(_onFolderRequested);
    on<UploadPauseRequested>(_onPauseRequested);
    on<UploadResumeRequested>(_onResumeRequested);
    on<UploadCancelRequested>(_onCancelRequested);
    on<UploadProgressUpdated>(_onProgressUpdate);
    on<UploadProgressErrorOccurred>(_onProgressError);
  }

  void _onFileRequested(
    UploadFileRequested event,
    Emitter<UploadState> emit,
  ) {
    final stream = uploadFile(filePath: event.filePath);
    _listenToStream(stream);
    emit(UploadInProgress(progressByUploadId: Map.from(_progressMap)));
  }

  void _onFolderRequested(
    UploadFolderRequested event,
    Emitter<UploadState> emit,
  ) {
    final stream = uploadFolder(folderPath: event.folderPath);
    _listenToStream(stream);
    emit(UploadInProgress(progressByUploadId: Map.from(_progressMap)));
  }

  void _listenToStream(Stream<dynamic> stream) {
    final tempKey = DateTime.now().microsecondsSinceEpoch.toString();
    final subscription = stream.listen(
      (either) {
        either.fold(
          (failure) => add(UploadProgressErrorOccurred(failure.message)),
          (progress) => add(UploadProgressUpdated(progress)),
        );
      },
    );
    _activeStreams[tempKey] = subscription;
  }

  void _onProgressUpdate(
    UploadProgressUpdated event,
    Emitter<UploadState> emit,
  ) {
    final progress = event.progress;

    // First time we see this processId — refresh list so it appears
    if (_knownProcessIds.add(progress.processId)) {
      _notifyProcessChanged();
    }

    if (_terminalStatuses.contains(progress.status)) {
      // Emit the terminal status so listeners see it before removal
      _progressMap[progress.uploadId] = progress;
      _emitCurrentState(emit);

      // Then remove from active tracking
      _progressMap.remove(progress.uploadId);
      _notifyProcessChanged();
    } else {
      _progressMap[progress.uploadId] = progress;
    }

    _emitCurrentState(emit);
  }

  void _onProgressError(
    UploadProgressErrorOccurred event,
    Emitter<UploadState> emit,
  ) {
    emit(UploadActionError(event.message));
    _emitCurrentState(emit);
    _notifyProcessChanged();
  }

  Future<void> _onPauseRequested(
    UploadPauseRequested event,
    Emitter<UploadState> emit,
  ) async {
    final result = await pauseProcess(processId: event.processId);
    result.fold(
      (failure) => emit(UploadActionError(failure.message)),
      (_) => _notifyProcessChanged(),
    );
  }

  void _onResumeRequested(
    UploadResumeRequested event,
    Emitter<UploadState> emit,
  ) {
    final stream = resumeProcess(processId: event.processId);
    _listenToStream(stream);
    _notifyProcessChanged();
  }

  Future<void> _onCancelRequested(
    UploadCancelRequested event,
    Emitter<UploadState> emit,
  ) async {
    final result = await cancelProcess(processId: event.processId);
    result.fold(
      (failure) => emit(UploadActionError(failure.message)),
      (_) {
        _progressMap.removeWhere((_, v) => v.processId == event.processId);
        _emitCurrentState(emit);
        _notifyProcessChanged();
      },
    );
  }

  void _emitCurrentState(Emitter<UploadState> emit) {
    if (_progressMap.isEmpty) {
      emit(const UploadIdle());
    } else {
      emit(UploadInProgress(progressByUploadId: Map.from(_progressMap)));
    }
  }

  void _notifyProcessChanged() {
    onProcessChanged?.call();
  }

  @override
  Future<void> close() {
    for (final sub in _activeStreams.values) {
      sub.cancel();
    }
    _activeStreams.clear();
    return super.close();
  }
}

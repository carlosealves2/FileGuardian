import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_ui/features/dashboard/domain/usecases/cancel_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/pause_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/resume_process.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_state.dart';
import 'package:guardian_ui/features/process_detail/domain/entities/upload_entity.dart';
import 'package:guardian_ui/features/process_detail/domain/usecases/get_process_detail.dart';

import 'process_detail_event.dart';
import 'process_detail_state.dart';

class ProcessDetailBloc
    extends Bloc<ProcessDetailEvent, ProcessDetailState> {
  final String processId;
  final GetProcessDetail getProcessDetail;
  final PauseProcess pauseProcess;
  final ResumeProcess resumeProcess;
  final CancelProcess cancelProcess;
  final UploadBloc uploadBloc;

  late final StreamSubscription<UploadState> _uploadBlocSubscription;

  ProcessDetailBloc({
    required this.processId,
    required this.getProcessDetail,
    required this.pauseProcess,
    required this.resumeProcess,
    required this.cancelProcess,
    required this.uploadBloc,
  }) : super(const ProcessDetailInitial()) {
    on<ProcessDetailLoadRequested>(_onLoadRequested);
    on<ProcessDetailPauseRequested>(_onPauseRequested);
    on<ProcessDetailResumeRequested>(_onResumeRequested);
    on<ProcessDetailCancelRequested>(_onCancelRequested);
    on<ProcessDetailUploadProgressReceived>(_onUploadProgressReceived);

    _uploadBlocSubscription = uploadBloc.stream.listen((uploadState) {
      if (uploadState is UploadInProgress) {
        final relevant = Map.fromEntries(
          uploadState.progressByUploadId.entries
              .where((e) => e.value.processId == processId),
        );
        if (relevant.isNotEmpty) {
          add(ProcessDetailUploadProgressReceived(relevant));
        }
      }
    });
  }

  Future<void> _onLoadRequested(
    ProcessDetailLoadRequested event,
    Emitter<ProcessDetailState> emit,
  ) async {
    emit(const ProcessDetailLoading());

    final result = await getProcessDetail(processId: processId);
    result.fold(
      (failure) => emit(ProcessDetailError(failure.message)),
      (data) => emit(ProcessDetailLoaded(
        process: data.process,
        uploads: data.uploads,
      )),
    );
  }

  void _onUploadProgressReceived(
    ProcessDetailUploadProgressReceived event,
    Emitter<ProcessDetailState> emit,
  ) {
    final currentState = state;
    if (currentState is! ProcessDetailLoaded) return;

    final updatedUploads = currentState.uploads.map((upload) {
      final progress = event.progressByUploadId[upload.id];
      if (progress == null) return upload;

      return UploadEntity(
        id: upload.id,
        processId: upload.processId,
        filePath: progress.filePath,
        storageKey: upload.storageKey,
        fileSize: progress.fileSize,
        bytesUploaded: progress.bytesUploaded,
        status: progress.status,
        errorMessage: progress.errorMessage,
        checksum: upload.checksum,
        createdAt: upload.createdAt,
        updatedAt: DateTime.now(),
      );
    }).toList();

    emit(currentState.copyWith(uploads: updatedUploads));
  }

  Future<void> _onPauseRequested(
    ProcessDetailPauseRequested event,
    Emitter<ProcessDetailState> emit,
  ) async {
    final result = await pauseProcess(processId: processId);
    result.fold(
      (failure) {
        if (state is ProcessDetailLoaded) {
          emit((state as ProcessDetailLoaded)
              .copyWith(actionError: failure.message));
        }
      },
      (_) => add(const ProcessDetailLoadRequested()),
    );
  }

  Future<void> _onResumeRequested(
    ProcessDetailResumeRequested event,
    Emitter<ProcessDetailState> emit,
  ) async {
    // Resume starts a stream; for the detail page we just reload after triggering
    resumeProcess(processId: processId).listen((_) {
      add(const ProcessDetailLoadRequested());
    });
  }

  Future<void> _onCancelRequested(
    ProcessDetailCancelRequested event,
    Emitter<ProcessDetailState> emit,
  ) async {
    final result = await cancelProcess(processId: processId);
    result.fold(
      (failure) {
        if (state is ProcessDetailLoaded) {
          emit((state as ProcessDetailLoaded)
              .copyWith(actionError: failure.message));
        }
      },
      (_) => add(const ProcessDetailLoadRequested()),
    );
  }

  @override
  Future<void> close() {
    _uploadBlocSubscription.cancel();
    return super.close();
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/cancel_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/pause_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/resume_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/upload_file.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/upload_folder.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_event.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_state.dart';

class MockUploadFile extends Mock implements UploadFile {}

class MockUploadFolder extends Mock implements UploadFolder {}

class MockPauseProcess extends Mock implements PauseProcess {}

class MockResumeProcess extends Mock implements ResumeProcess {}

class MockCancelProcess extends Mock implements CancelProcess {}

void main() {
  late MockUploadFile mockUploadFile;
  late MockUploadFolder mockUploadFolder;
  late MockPauseProcess mockPauseProcess;
  late MockResumeProcess mockResumeProcess;
  late MockCancelProcess mockCancelProcess;

  const inProgressProgress = UploadProgressEntity(
    processId: 'proc-1',
    uploadId: 'up-1',
    filePath: '/tmp/test.txt',
    fileSize: 1024,
    bytesUploaded: 512,
    status: ProcessStatus.inProgress,
  );

  const completedProgress = UploadProgressEntity(
    processId: 'proc-1',
    uploadId: 'up-1',
    filePath: '/tmp/test.txt',
    fileSize: 1024,
    bytesUploaded: 1024,
    status: ProcessStatus.completed,
  );

  const failedProgress = UploadProgressEntity(
    processId: 'proc-1',
    uploadId: 'up-1',
    filePath: '/tmp/test.txt',
    fileSize: 1024,
    bytesUploaded: 512,
    status: ProcessStatus.failed,
    errorMessage: 'upload failed',
  );

  setUp(() {
    mockUploadFile = MockUploadFile();
    mockUploadFolder = MockUploadFolder();
    mockPauseProcess = MockPauseProcess();
    mockResumeProcess = MockResumeProcess();
    mockCancelProcess = MockCancelProcess();
  });

  UploadBloc buildBloc() => UploadBloc(
        uploadFile: mockUploadFile,
        uploadFolder: mockUploadFolder,
        pauseProcess: mockPauseProcess,
        resumeProcess: mockResumeProcess,
        cancelProcess: mockCancelProcess,
      );

  group('UploadProgressUpdated', () {
    blocTest<UploadBloc, UploadState>(
      'emits UploadInProgress when progress is in progress',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const UploadProgressUpdated(inProgressProgress)),
      expect: () => [
        const UploadInProgress(
          progressByUploadId: {'up-1': inProgressProgress},
        ),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits UploadInProgress with completed status then UploadIdle '
      'when terminal status received',
      build: buildBloc,
      act: (bloc) {
        bloc.add(const UploadProgressUpdated(inProgressProgress));
        bloc.add(const UploadProgressUpdated(completedProgress));
      },
      expect: () => [
        // First: in-progress update
        const UploadInProgress(
          progressByUploadId: {'up-1': inProgressProgress},
        ),
        // Second: terminal status emitted with completed progress
        const UploadInProgress(
          progressByUploadId: {'up-1': completedProgress},
        ),
        // Third: removed from map, now idle
        const UploadIdle(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits UploadInProgress with failed status then UploadIdle '
      'when failed status received',
      build: buildBloc,
      act: (bloc) {
        bloc.add(const UploadProgressUpdated(inProgressProgress));
        bloc.add(const UploadProgressUpdated(failedProgress));
      },
      expect: () => [
        const UploadInProgress(
          progressByUploadId: {'up-1': inProgressProgress},
        ),
        const UploadInProgress(
          progressByUploadId: {'up-1': failedProgress},
        ),
        const UploadIdle(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'keeps other uploads in progress when one completes',
      build: buildBloc,
      act: (bloc) {
        const otherProgress = UploadProgressEntity(
          processId: 'proc-2',
          uploadId: 'up-2',
          filePath: '/tmp/other.txt',
          fileSize: 2048,
          bytesUploaded: 1024,
          status: ProcessStatus.inProgress,
        );
        bloc.add(const UploadProgressUpdated(inProgressProgress));
        bloc.add(const UploadProgressUpdated(otherProgress));
        bloc.add(const UploadProgressUpdated(completedProgress));
      },
      expect: () => [
        const UploadInProgress(
          progressByUploadId: {'up-1': inProgressProgress},
        ),
        const UploadInProgress(
          progressByUploadId: {
            'up-1': inProgressProgress,
            'up-2': UploadProgressEntity(
              processId: 'proc-2',
              uploadId: 'up-2',
              filePath: '/tmp/other.txt',
              fileSize: 2048,
              bytesUploaded: 1024,
              status: ProcessStatus.inProgress,
            ),
          },
        ),
        // Completed emitted with both uploads, up-1 now completed
        const UploadInProgress(
          progressByUploadId: {
            'up-1': completedProgress,
            'up-2': UploadProgressEntity(
              processId: 'proc-2',
              uploadId: 'up-2',
              filePath: '/tmp/other.txt',
              fileSize: 2048,
              bytesUploaded: 1024,
              status: ProcessStatus.inProgress,
            ),
          },
        ),
        // After removal, only up-2 remains
        const UploadInProgress(
          progressByUploadId: {
            'up-2': UploadProgressEntity(
              processId: 'proc-2',
              uploadId: 'up-2',
              filePath: '/tmp/other.txt',
              fileSize: 2048,
              bytesUploaded: 1024,
              status: ProcessStatus.inProgress,
            ),
          },
        ),
      ],
    );
  });

  group('UploadProgressErrorOccurred', () {
    blocTest<UploadBloc, UploadState>(
      'emits UploadActionError then current state',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const UploadProgressErrorOccurred('network error')),
      expect: () => [
        const UploadActionError('network error'),
        const UploadIdle(),
      ],
    );
  });
}

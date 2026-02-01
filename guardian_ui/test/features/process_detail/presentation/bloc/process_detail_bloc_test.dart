import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/cancel_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/pause_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/resume_process.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_event.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_state.dart';
import 'package:guardian_ui/features/process_detail/domain/entities/upload_entity.dart';
import 'package:guardian_ui/features/process_detail/domain/repositories/process_detail_repository.dart';
import 'package:guardian_ui/features/process_detail/domain/usecases/get_process_detail.dart';
import 'package:guardian_ui/features/process_detail/presentation/bloc/process_detail_bloc.dart';
import 'package:guardian_ui/features/process_detail/presentation/bloc/process_detail_event.dart';
import 'package:guardian_ui/features/process_detail/presentation/bloc/process_detail_state.dart';

class MockGetProcessDetail extends Mock implements GetProcessDetail {}

class MockPauseProcess extends Mock implements PauseProcess {}

class MockResumeProcess extends Mock implements ResumeProcess {}

class MockCancelProcess extends Mock implements CancelProcess {}

class MockUploadBloc extends MockBloc<UploadEvent, UploadState>
    implements UploadBloc {}

void main() {
  late MockGetProcessDetail mockGetProcessDetail;
  late MockPauseProcess mockPauseProcess;
  late MockResumeProcess mockResumeProcess;
  late MockCancelProcess mockCancelProcess;
  late MockUploadBloc mockUploadBloc;

  final process = ProcessEntity(
    id: 'proc-1',
    type: ProcessType.file,
    status: ProcessStatus.inProgress,
    provider: 'S3',
    sourcePath: '/tmp/test.txt',
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
  );

  final uploads = [
    UploadEntity(
      id: 'up-1',
      processId: 'proc-1',
      filePath: '/tmp/test.txt',
      storageKey: 'test.txt',
      fileSize: 1024,
      bytesUploaded: 512,
      status: ProcessStatus.inProgress,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
  ];

  setUp(() {
    mockGetProcessDetail = MockGetProcessDetail();
    mockPauseProcess = MockPauseProcess();
    mockResumeProcess = MockResumeProcess();
    mockCancelProcess = MockCancelProcess();
    mockUploadBloc = MockUploadBloc();
  });

  ProcessDetailBloc buildBloc() => ProcessDetailBloc(
        processId: 'proc-1',
        getProcessDetail: mockGetProcessDetail,
        pauseProcess: mockPauseProcess,
        resumeProcess: mockResumeProcess,
        cancelProcess: mockCancelProcess,
        uploadBloc: mockUploadBloc,
      );

  group('ProcessDetailLoadRequested', () {
    blocTest<ProcessDetailBloc, ProcessDetailState>(
      'emits [Loading, Loaded] on success',
      setUp: () {
        when(() => mockGetProcessDetail(processId: 'proc-1')).thenAnswer(
          (_) async => Right(ProcessDetailResult(
            process: process,
            uploads: uploads,
          )),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ProcessDetailLoadRequested()),
      expect: () => [
        const ProcessDetailLoading(),
        ProcessDetailLoaded(process: process, uploads: uploads),
      ],
    );

    blocTest<ProcessDetailBloc, ProcessDetailState>(
      'emits [Loading, Error] on failure',
      setUp: () {
        when(() => mockGetProcessDetail(processId: 'proc-1')).thenAnswer(
          (_) async => const Left(NotFoundFailure('not found')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ProcessDetailLoadRequested()),
      expect: () => [
        const ProcessDetailLoading(),
        const ProcessDetailError('not found'),
      ],
    );
  });

  group('ProcessDetailPauseRequested', () {
    blocTest<ProcessDetailBloc, ProcessDetailState>(
      'reloads process after successful pause',
      setUp: () {
        when(() => mockPauseProcess(processId: 'proc-1'))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetProcessDetail(processId: 'proc-1')).thenAnswer(
          (_) async => Right(ProcessDetailResult(
            process: process,
            uploads: uploads,
          )),
        );
      },
      build: buildBloc,
      seed: () => ProcessDetailLoaded(process: process, uploads: uploads),
      act: (bloc) => bloc.add(const ProcessDetailPauseRequested()),
      expect: () => [
        const ProcessDetailLoading(),
        ProcessDetailLoaded(process: process, uploads: uploads),
      ],
    );
  });

  group('UploadBloc stream subscription', () {
    blocTest<ProcessDetailBloc, ProcessDetailState>(
      'reloads process detail when UploadIdle is emitted',
      setUp: () {
        final completedProcess = ProcessEntity(
          id: 'proc-1',
          type: ProcessType.file,
          status: ProcessStatus.completed,
          provider: 'S3',
          sourcePath: '/tmp/test.txt',
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );
        final completedUploads = [
          UploadEntity(
            id: 'up-1',
            processId: 'proc-1',
            filePath: '/tmp/test.txt',
            storageKey: 'test.txt',
            fileSize: 1024,
            bytesUploaded: 1024,
            status: ProcessStatus.completed,
            createdAt: DateTime(2025, 1, 1),
            updatedAt: DateTime(2025, 1, 1),
          ),
        ];

        whenListen(
          mockUploadBloc,
          Stream<UploadState>.fromIterable([const UploadIdle()]),
          initialState: const UploadIdle(),
        );

        when(() => mockGetProcessDetail(processId: 'proc-1')).thenAnswer(
          (_) async => Right(ProcessDetailResult(
            process: completedProcess,
            uploads: completedUploads,
          )),
        );
      },
      build: buildBloc,
      seed: () => ProcessDetailLoaded(process: process, uploads: uploads),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const ProcessDetailLoading(),
        isA<ProcessDetailLoaded>().having(
          (s) => s.process.status,
          'process status',
          ProcessStatus.completed,
        ),
      ],
      verify: (_) {
        verify(() => mockGetProcessDetail(processId: 'proc-1')).called(1);
      },
    );

    blocTest<ProcessDetailBloc, ProcessDetailState>(
      'updates upload progress when UploadInProgress with relevant uploads',
      setUp: () {
        whenListen(
          mockUploadBloc,
          Stream<UploadState>.fromIterable([
            const UploadInProgress(
              progressByUploadId: {
                'up-1': UploadProgressEntity(
                  processId: 'proc-1',
                  uploadId: 'up-1',
                  filePath: '/tmp/test.txt',
                  fileSize: 1024,
                  bytesUploaded: 768,
                  status: ProcessStatus.inProgress,
                ),
              },
            ),
          ]),
          initialState: const UploadIdle(),
        );
      },
      build: buildBloc,
      seed: () => ProcessDetailLoaded(process: process, uploads: uploads),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ProcessDetailLoaded>().having(
          (s) => s.uploads.first.bytesUploaded,
          'bytesUploaded',
          768,
        ),
      ],
    );

    blocTest<ProcessDetailBloc, ProcessDetailState>(
      'updates upload status to completed when terminal status received',
      setUp: () {
        whenListen(
          mockUploadBloc,
          Stream<UploadState>.fromIterable([
            const UploadInProgress(
              progressByUploadId: {
                'up-1': UploadProgressEntity(
                  processId: 'proc-1',
                  uploadId: 'up-1',
                  filePath: '/tmp/test.txt',
                  fileSize: 1024,
                  bytesUploaded: 1024,
                  status: ProcessStatus.completed,
                ),
              },
            ),
          ]),
          initialState: const UploadIdle(),
        );
      },
      build: buildBloc,
      seed: () => ProcessDetailLoaded(process: process, uploads: uploads),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ProcessDetailLoaded>()
            .having(
              (s) => s.uploads.first.status,
              'upload status',
              ProcessStatus.completed,
            )
            .having(
              (s) => s.uploads.first.bytesUploaded,
              'bytesUploaded',
              1024,
            ),
      ],
    );
  });
}

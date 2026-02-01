import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/list_processes.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_event.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_state.dart';

class MockListProcesses extends Mock implements ListProcesses {}

void main() {
  late MockListProcesses mockListProcesses;

  final processes = [
    ProcessEntity(
      id: '1',
      type: ProcessType.file,
      status: ProcessStatus.completed,
      provider: 'S3',
      sourcePath: '/tmp/test.txt',
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    ),
  ];

  setUp(() {
    mockListProcesses = MockListProcesses();
  });

  ProcessListBloc buildBloc() =>
      ProcessListBloc(listProcesses: mockListProcesses);

  group('ProcessListLoadRequested', () {
    blocTest<ProcessListBloc, ProcessListState>(
      'emits [Loading, Loaded] on success',
      setUp: () {
        when(() => mockListProcesses(
              cursor: any(named: 'cursor'),
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => Right(ProcessListResult(
              processes: processes,
              nextCursor: '',
            )));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ProcessListLoadRequested()),
      expect: () => [
        const ProcessListLoading(),
        ProcessListLoaded(processes: processes, nextCursor: ''),
      ],
    );

    blocTest<ProcessListBloc, ProcessListState>(
      'emits [Loading, Error] on failure',
      setUp: () {
        when(() => mockListProcesses(
              cursor: any(named: 'cursor'),
              limit: any(named: 'limit'),
            )).thenAnswer(
          (_) async => const Left(ServerUnavailableFailure('offline')),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ProcessListLoadRequested()),
      expect: () => [
        const ProcessListLoading(),
        const ProcessListError('offline'),
      ],
    );
  });

  group('ProcessListNextPageRequested', () {
    blocTest<ProcessListBloc, ProcessListState>(
      'appends next page to existing list',
      setUp: () {
        when(() => mockListProcesses(
              cursor: 'page2',
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => Right(ProcessListResult(
              processes: [
                ProcessEntity(
                  id: '2',
                  type: ProcessType.folder,
                  status: ProcessStatus.pending,
                  provider: 'S3',
                  sourcePath: '/tmp/folder',
                  createdAt: DateTime(2025, 1, 2),
                  updatedAt: DateTime(2025, 1, 2),
                ),
              ],
              nextCursor: '',
            )));
      },
      build: buildBloc,
      seed: () => ProcessListLoaded(
        processes: processes,
        nextCursor: 'page2',
      ),
      act: (bloc) => bloc.add(const ProcessListNextPageRequested()),
      expect: () => [
        ProcessListLoaded(
          processes: processes,
          nextCursor: 'page2',
          isLoadingMore: true,
        ),
        isA<ProcessListLoaded>()
            .having((s) => s.processes.length, 'count', 2)
            .having((s) => s.nextCursor, 'cursor', ''),
      ],
    );

    blocTest<ProcessListBloc, ProcessListState>(
      'does nothing when no more pages',
      build: buildBloc,
      seed: () => ProcessListLoaded(
        processes: processes,
        nextCursor: '',
      ),
      act: (bloc) => bloc.add(const ProcessListNextPageRequested()),
      expect: () => <ProcessListState>[],
    );
  });
}

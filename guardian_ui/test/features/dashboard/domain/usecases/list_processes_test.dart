import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/list_processes.dart';

class MockUploadRepository extends Mock implements UploadRepository {}

void main() {
  late ListProcesses useCase;
  late MockUploadRepository mockRepository;

  setUp(() {
    mockRepository = MockUploadRepository();
    useCase = ListProcesses(repository: mockRepository);
  });

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

  test('returns process list on success', () async {
    when(() => mockRepository.listProcesses(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => Right(ProcessListResult(
          processes: processes,
          nextCursor: 'abc',
        )));

    final result = await useCase(cursor: '', limit: 20);

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('expected Right'),
      (data) {
        expect(data.processes.length, 1);
        expect(data.nextCursor, 'abc');
      },
    );
  });

  test('returns failure on error', () async {
    when(() => mockRepository.listProcesses(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => const Left(ServerFailure('error')));

    final result = await useCase(cursor: '');

    expect(result.isLeft(), true);
  });
}

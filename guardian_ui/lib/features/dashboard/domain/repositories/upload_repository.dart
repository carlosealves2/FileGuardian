import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';

class ProcessListResult {
  final List<ProcessEntity> processes;
  final String nextCursor;

  const ProcessListResult({
    required this.processes,
    required this.nextCursor,
  });
}

abstract class UploadRepository {
  Future<Either<Failure, ProcessListResult>> listProcesses({
    required String cursor,
    required int limit,
  });

  Stream<Either<Failure, UploadProgressEntity>> uploadFile({
    required String filePath,
  });

  Stream<Either<Failure, UploadProgressEntity>> uploadFolder({
    required String folderPath,
  });

  Future<Either<Failure, void>> pauseProcess({required String processId});

  Stream<Either<Failure, UploadProgressEntity>> resumeProcess({
    required String processId,
  });

  Future<Either<Failure, void>> cancelProcess({required String processId});
}

import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';

class ListProcesses {
  final UploadRepository repository;

  const ListProcesses({required this.repository});

  Future<Either<Failure, ProcessListResult>> call({
    required String cursor,
    int limit = 20,
  }) {
    return repository.listProcesses(cursor: cursor, limit: limit);
  }
}

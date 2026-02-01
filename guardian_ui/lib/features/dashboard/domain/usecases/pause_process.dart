import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';

class PauseProcess {
  final UploadRepository repository;

  const PauseProcess({required this.repository});

  Future<Either<Failure, void>> call({required String processId}) {
    return repository.pauseProcess(processId: processId);
  }
}

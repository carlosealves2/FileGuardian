import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';

class UploadFolder {
  final UploadRepository repository;

  const UploadFolder({required this.repository});

  Stream<Either<Failure, UploadProgressEntity>> call({
    required String folderPath,
  }) {
    return repository.uploadFolder(folderPath: folderPath);
  }
}

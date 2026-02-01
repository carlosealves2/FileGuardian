import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/upload_progress_entity.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';

class UploadFile {
  final UploadRepository repository;

  const UploadFile({required this.repository});

  Stream<Either<Failure, UploadProgressEntity>> call({
    required String filePath,
  }) {
    return repository.uploadFile(filePath: filePath);
  }
}

import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/dashboard/domain/entities/process_entity.dart';
import 'package:guardian_ui/features/process_detail/domain/entities/upload_entity.dart';

class ProcessDetailResult {
  final ProcessEntity process;
  final List<UploadEntity> uploads;

  const ProcessDetailResult({
    required this.process,
    required this.uploads,
  });
}

abstract class ProcessDetailRepository {
  Future<Either<Failure, ProcessDetailResult>> getProcessDetail({
    required String processId,
  });
}

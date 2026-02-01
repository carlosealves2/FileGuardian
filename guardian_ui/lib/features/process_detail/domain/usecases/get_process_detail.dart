import 'package:fpdart/fpdart.dart';

import 'package:guardian_ui/core/error/failures.dart';
import 'package:guardian_ui/features/process_detail/domain/repositories/process_detail_repository.dart';

class GetProcessDetail {
  final ProcessDetailRepository repository;

  const GetProcessDetail({required this.repository});

  Future<Either<Failure, ProcessDetailResult>> call({
    required String processId,
  }) {
    return repository.getProcessDetail(processId: processId);
  }
}

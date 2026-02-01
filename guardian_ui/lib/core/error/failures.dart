sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ServerUnavailableFailure extends Failure {
  const ServerUnavailableFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class CancelledFailure extends Failure {
  const CancelledFailure(super.message);
}

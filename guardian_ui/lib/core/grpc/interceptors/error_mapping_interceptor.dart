import 'package:grpc/grpc.dart';
import 'package:guardian_ui/core/error/failures.dart';

class ErrorMappingInterceptor extends ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    return invoker(method, request, options);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    return invoker(method, requests, options);
  }

  static Failure mapGrpcError(GrpcError error) {
    return switch (error.code) {
      StatusCode.notFound =>
        NotFoundFailure(error.message ?? 'Resource not found'),
      StatusCode.invalidArgument =>
        ValidationFailure(error.message ?? 'Invalid input'),
      StatusCode.unavailable =>
        ServerUnavailableFailure(error.message ?? 'Server unavailable'),
      StatusCode.cancelled =>
        CancelledFailure(error.message ?? 'Operation cancelled'),
      _ => ServerFailure(error.message ?? 'Unexpected server error'),
    };
  }
}

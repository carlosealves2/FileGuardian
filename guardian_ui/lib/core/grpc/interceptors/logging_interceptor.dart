import 'dart:developer' as developer;

import 'package:grpc/grpc.dart';

class LoggingInterceptor extends ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    developer.log(
      '-> ${method.path}',
      name: 'gRPC',
    );

    final response = invoker(method, request, options);

    response.then(
      (_) => developer.log(
        '<- ${method.path} OK',
        name: 'gRPC',
      ),
      onError: (Object error) => developer.log(
        '<- ${method.path} ERROR: $error',
        name: 'gRPC',
        level: 900,
      ),
    );

    return response;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    developer.log(
      '-> ${method.path} (stream)',
      name: 'gRPC',
    );

    return invoker(method, requests, options);
  }
}

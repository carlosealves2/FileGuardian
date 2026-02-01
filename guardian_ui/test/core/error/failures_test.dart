import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_ui/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure stores message', () {
      const failure = ServerFailure('server error');
      expect(failure.message, 'server error');
    });

    test('ServerUnavailableFailure stores message', () {
      const failure = ServerUnavailableFailure('unavailable');
      expect(failure.message, 'unavailable');
    });

    test('NotFoundFailure stores message', () {
      const failure = NotFoundFailure('not found');
      expect(failure.message, 'not found');
    });

    test('ValidationFailure stores message', () {
      const failure = ValidationFailure('invalid');
      expect(failure.message, 'invalid');
    });

    test('CancelledFailure stores message', () {
      const failure = CancelledFailure('cancelled');
      expect(failure.message, 'cancelled');
    });

    test('toString includes runtime type', () {
      const failure = ServerFailure('test');
      expect(failure.toString(), 'ServerFailure: test');
    });

    test('pattern matching works on sealed class', () {
      const Failure failure = NotFoundFailure('gone');
      final result = switch (failure) {
        ServerFailure() => 'server',
        ServerUnavailableFailure() => 'unavailable',
        NotFoundFailure() => 'not_found',
        ValidationFailure() => 'validation',
        CancelledFailure() => 'cancelled',
      };
      expect(result, 'not_found');
    });
  });
}

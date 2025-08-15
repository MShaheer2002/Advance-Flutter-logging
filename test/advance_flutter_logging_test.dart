// test/advanced_logger_test.dart
import 'package:advance_flutter_logging/advance_flutter_logging.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdvancedLogger Tests', () {
    late AdvancedLogger logger;

    setUp(() {
      logger = AdvancedLogger.instance;
    });

    test('should log messages correctly', () {
      logger.info('Test message');
      expect(logger.logs.isNotEmpty, true);
      expect(logger.logs.last.message, 'Test message');
      expect(logger.logs.last.level, LogLevel.info);
    });

    test('should filter logs by level', () {
      logger.debug('Debug message');
      logger.error('Error message');

      final errorLogs = logger.getLogsByLevel(LogLevel.error);
      expect(errorLogs.length, 1);
      expect(errorLogs.first.message, 'Error message');
    });
  });
}
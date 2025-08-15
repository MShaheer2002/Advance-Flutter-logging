

import 'package:advance_flutter_logging/advance_flutter_logging.dart';

class LoggingConfig {
  final bool enableConsoleOutput;
  final bool enableFileStorage;
  final LogLevel minimumLogLevel;
  final int maxLogEntries;
  final bool enablePrettyPrint;
  final String? logBoxName;
  final String? feedbackApiUrl;
  final Map<String, String>? apiHeaders;

  const LoggingConfig({
    this.enableConsoleOutput = true,
    this.enableFileStorage = true,
    this.minimumLogLevel = LogLevel.debug,
    this.maxLogEntries = 10000,
    this.enablePrettyPrint = true,
    this.logBoxName = 'app_logs',
    this.feedbackApiUrl,
    this.apiHeaders,
  });

  LoggingConfig copyWith({
    bool? enableConsoleOutput,
    bool? enableFileStorage,
    LogLevel? minimumLogLevel,
    int? maxLogEntries,
    bool? enablePrettyPrint,
    String? logBoxName,
    String? feedbackApiUrl,
    Map<String, String>? apiHeaders,
  }) {
    return LoggingConfig(
      enableConsoleOutput: enableConsoleOutput ?? this.enableConsoleOutput,
      enableFileStorage: enableFileStorage ?? this.enableFileStorage,
      minimumLogLevel: minimumLogLevel ?? this.minimumLogLevel,
      maxLogEntries: maxLogEntries ?? this.maxLogEntries,
      enablePrettyPrint: enablePrettyPrint ?? this.enablePrettyPrint,
      logBoxName: logBoxName ?? this.logBoxName,
      feedbackApiUrl: feedbackApiUrl ?? this.feedbackApiUrl,
      apiHeaders: apiHeaders ?? this.apiHeaders,
    );
  }
}
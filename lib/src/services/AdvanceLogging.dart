

import 'dart:io';

import 'package:advance_flutter_logging/advance_flutter_logging.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;

class AdvancedLogger {
  static AdvancedLogger? _instance;
  static AdvancedLogger get instance => _instance ??= AdvancedLogger._internal();

  factory AdvancedLogger() => instance;
  AdvancedLogger._internal();

  final List<LogEntry> _logs = [];
  Box<LogEntry>? _logBox;
  LoggingConfig _config = const LoggingConfig();
  bool _isInitialized = false;

  LoggingConfig get config => _config;
  bool get isInitialized => _isInitialized;
  List<LogEntry> get logs => List.unmodifiable(_logs);

  /// Initialize the logger with configuration
  Future<void> initialize({LoggingConfig? config}) async {
    if (_isInitialized) return;

    _config = config ?? const LoggingConfig();

    try {
      if (_config.enableFileStorage) {
        await Hive.initFlutter();

        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter(LogLevelAdapter());
        }
        if (!Hive.isAdapterRegistered(1)) {
          Hive.registerAdapter(LogLevelAdapter());
        }

        _logBox = await Hive.openBox<LogEntry>(_config.logBoxName!);
        _logs.clear();
        _logs.addAll(_logBox!.values.toList());

        // Clean old logs if exceeding max entries
        if (_logs.length > _config.maxLogEntries) {
          final toRemove = _logs.length - _config.maxLogEntries;
          _logs.removeRange(0, toRemove);
          await _logBox!.clear();
          await _logBox!.addAll(_logs);
        }
      }

      _isInitialized = true;
      info('AdvancedLogger initialized with ${_logs.length} existing logs');
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing AdvancedLogger: $e');
      }
    }
  }

  /// Log a message with specified level and optional tag
  void log(
    String message, {
    LogLevel level = LogLevel.info,
    String? tag,
  }) async {
    if (!_shouldLog(level)) return;

    final entry = LogEntry(
      message: message,
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
    );

    _logs.add(entry);

    // Save to Hive if enabled
    if (_config.enableFileStorage) {
      await _saveToHive(entry);
    }

    // Console output
    if (_config.enableConsoleOutput) {
      _logToConsole(entry);
    }

    // Maintain max entries
    if (_logs.length > _config.maxLogEntries) {
      _logs.removeAt(0);
    }
  }

  bool _shouldLog(LogLevel level) {
    return level.priority >= _config.minimumLogLevel.priority;
  }

  void _logToConsole(LogEntry entry) {
    final levelName = entry.level.name.toUpperCase();
    final tag = entry.tag != null ? '[${entry.tag}] ' : '';
    final emoji = _config.enablePrettyPrint ? '${entry.level.emoji} ' : '';
    final message = '$emoji$tag${entry.message}';

    dev.log(message, name: 'Logger-$levelName');

    if (kDebugMode && _config.enablePrettyPrint) {
      print('${entry.timestamp.toIso8601String()} [$levelName] $message');
    }
  }

  Future<void> _saveToHive(LogEntry entry) async {
    try {
      if (_logBox != null && _logBox!.isOpen) {
        await _logBox!.add(entry);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving log to Hive: $e');
      }
    }
  }

  /// Clear all logs
  Future<void> clearLogs() async {
    _logs.clear();
    try {
      if (_logBox != null && _logBox!.isOpen) {
        await _logBox!.clear();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing logs: $e');
      }
    }
  }

  /// Get logs by level
  List<LogEntry> getLogsByLevel(LogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  /// Get logs by time range
  List<LogEntry> getLogsByTimeRange(DateTime start, DateTime end) {
    return _logs.where((log) =>
      log.timestamp.isAfter(start) && log.timestamp.isBefore(end)
    ).toList();
  }

  /// Create a log file for export
  Future<String> createLogFile({
    List<LogLevel>? levelFilter,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      var logsToExport = List<LogEntry>.from(_logs);

      // Apply filters
      if (levelFilter != null && levelFilter.isNotEmpty) {
        logsToExport = logsToExport.where((log) => levelFilter.contains(log.level)).toList();
      }

      if (startTime != null) {
        logsToExport = logsToExport.where((log) => log.timestamp.isAfter(startTime)).toList();
      }

      if (endTime != null) {
        logsToExport = logsToExport.where((log) => log.timestamp.isBefore(endTime)).toList();
      }

      // Sort by timestamp
      logsToExport.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Generate log content
      final buffer = StringBuffer();
      buffer.writeln('=== ADVANCED LOGGER EXPORT ===');
      buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
      buffer.writeln('Total entries: ${logsToExport.length}');
      if (levelFilter != null) {
        buffer.writeln('Filtered levels: ${levelFilter.map((l) => l.name).join(', ')}');
      }
      if (startTime != null) buffer.writeln('Start time: ${startTime.toIso8601String()}');
      if (endTime != null) buffer.writeln('End time: ${endTime.toIso8601String()}');
      buffer.writeln('');

      for (var logEntry in logsToExport) {
        buffer.writeln(logEntry.toString());
      }

      buffer.writeln('');
      buffer.writeln('=== END EXPORT ===');

      // Save to file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final logFile = File('${tempDir.path}/advanced_logs_$timestamp.log');

      await logFile.writeAsString(buffer.toString());
      debug('Log file created: ${logFile.path}');
      return logFile.path;
    } catch (e) {
      error('Error creating log file: $e');
      rethrow;
    }
  }

  /// Send feedback with logs to backend
  Future<ResponseClass<Map<String, dynamic>>> sendFeedback({
    required String feedbackText,
    List<PlatformFile> attachments = const [],
    bool includeLogs = true,
    List<LogLevel>? logLevelFilter,
    Map<String, dynamic>? additionalData,
  }) async {
    if (_config.feedbackApiUrl == null) {
      return ResponseClass.error('Feedback API URL not configured');
    }

    try {
      final formMap = <String, dynamic>{
        'feedbackText': feedbackText,
      };

      // Add app info
      try {
        final info = await PackageInfo.fromPlatform();
        formMap['appVersion'] = info.version;
        formMap['appName'] = info.appName;
        formMap['packageName'] = info.packageName;
      } catch (e) {
        debug('Could not get package info: $e');
      }

      // Add logs if requested
      if (includeLogs) {
        final logFilePath = await createLogFile(levelFilter: logLevelFilter);
        final logFile = File(logFilePath);

        if (await logFile.exists()) {
          formMap['logs'] = await MultipartFile.fromFile(
            logFilePath,
            filename: logFile.uri.pathSegments.last,
          );
        }
      }

      // Add attachments
      if (attachments.isNotEmpty) {
        final attachmentFiles = <MultipartFile>[];
        for (var file in attachments) {
          if (file.path != null) {
            attachmentFiles.add(
              await MultipartFile.fromFile(
                file.path!,
                filename: file.name,
              ),
            );
          }
        }
        if (attachmentFiles.isNotEmpty) {
          formMap['attachments'] = attachmentFiles;
        }
      }

      // Add additional data
      if (additionalData != null) {
        formMap.addAll(additionalData);
      }

      final data = FormData.fromMap(formMap);

      // Create Dio instance
      final dio = Dio();
      if (_config.apiHeaders != null) {
        dio.options.headers.addAll(_config.apiHeaders!);
      }

      debug('Sending feedback to: ${_config.feedbackApiUrl}');
      final response = await dio.post(_config.feedbackApiUrl!, data: data);

      // Clean up log file
      if (includeLogs) {
        try {
          final logFilePath = await createLogFile(levelFilter: logLevelFilter);
          final logFile = File(logFilePath);
          if (await logFile.exists()) {
            await logFile.delete();
          }
        } catch (e) {
          debug('Error cleaning up log file: $e');
        }
      }

      return ResponseClass.success(
        response.data as Map<String, dynamic>? ?? {},
        message: 'Feedback sent successfully',
        statusCode: response.statusCode,
      );
    } on DioException catch (dioErr) {
      final resp = dioErr.response;
      String message;
      if (resp?.data is Map && resp!.data.containsKey('message')) {
        message = resp.data['message'];
      } else {
        message = resp?.statusMessage ?? 'Server error (${resp?.statusCode})';
      }
      error('Feedback API error: $message');
      return ResponseClass.error(message, statusCode: resp?.statusCode);
    } catch (err) {
      error('Feedback unknown error: $err');
      return ResponseClass.error(err.toString());
    }
  }

  /// Update logger configuration
  void updateConfig(LoggingConfig newConfig) {
    _config = newConfig;
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      if (_logBox != null && _logBox!.isOpen) {
        await _logBox!.close();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error disposing AdvancedLogger: $e');
      }
    }
    _isInitialized = false;
  }

  // Convenience methods for different log levels
  void debug(String message, {String? tag}) => log(message, level: LogLevel.debug, tag: tag);
  void info(String message, {String? tag}) => log(message, level: LogLevel.info, tag: tag);
  void warning(String message, {String? tag}) => log(message, level: LogLevel.warning, tag: tag);
  void error(String message, {String? tag}) => log(message, level: LogLevel.error, tag: tag);
  void critical(String message, {String? tag}) => log(message, level: LogLevel.critical, tag: tag);
}
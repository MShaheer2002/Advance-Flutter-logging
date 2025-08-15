import 'package:hive/hive.dart';

part 'LogEntry.g.dart';

@HiveType(typeId: 0)
class LogEntry extends HiveObject {
  @HiveField(0)
  final String message;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final LogLevel level;

  @HiveField(3)
  final String? tag;

  LogEntry({
    required this.message,
    required this.timestamp,
    required this.level,
    this.tag,
  });

  @override
  String toString() {
    return '${timestamp.toIso8601String()} [${level.name.toUpperCase()}] ${tag != null ? '[$tag] ' : ''}$message';
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'tag': tag,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      level: LogLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => LogLevel.info,
      ),
      tag: json['tag'] as String?,
    );
  }
}

@HiveType(typeId: 1)
enum LogLevel {
  @HiveField(0)
  debug,

  @HiveField(1)
  info,

  @HiveField(2)
  warning,

  @HiveField(3)
  error,

  @HiveField(4)
  critical,
}

extension LogLevelExtension on LogLevel {
  String get emoji {
    switch (this) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.critical:
        return '🚨';
    }
  }

  int get priority {
    switch (this) {
      case LogLevel.debug:
        return 0;
      case LogLevel.info:
        return 1;
      case LogLevel.warning:
        return 2;
      case LogLevel.error:
        return 3;
      case LogLevel.critical:
        return 4;
    }
  }
}
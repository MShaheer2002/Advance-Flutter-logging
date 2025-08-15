// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LogEntry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogEntryAdapter extends TypeAdapter<LogEntry> {
  @override
  final int typeId = 0;

  @override
  LogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogEntry(
      message: fields[0] as String,
      timestamp: fields[1] as DateTime,
      level: fields[2] as LogLevel,
      tag: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LogEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LogLevelAdapter extends TypeAdapter<LogLevel> {
  @override
  final int typeId = 1;

  @override
  LogLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LogLevel.debug;
      case 1:
        return LogLevel.info;
      case 2:
        return LogLevel.warning;
      case 3:
        return LogLevel.error;
      case 4:
        return LogLevel.critical;
      default:
        return LogLevel.debug;
    }
  }

  @override
  void write(BinaryWriter writer, LogLevel obj) {
    switch (obj) {
      case LogLevel.debug:
        writer.writeByte(0);
        break;
      case LogLevel.info:
        writer.writeByte(1);
        break;
      case LogLevel.warning:
        writer.writeByte(2);
        break;
      case LogLevel.error:
        writer.writeByte(3);
        break;
      case LogLevel.critical:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



// Global convenience functions for easy logging
import 'package:flutter_advanced_logging/src/services/AdvanceLogging.dart';

void logDebug(String message, {String? tag}) => AdvancedLogger.instance.debug(message, tag: tag);
void logInfo(String message, {String? tag}) => AdvancedLogger.instance.info(message, tag: tag);
void logWarning(String message, {String? tag}) => AdvancedLogger.instance.warning(message, tag: tag);
void logError(String message, {String? tag}) => AdvancedLogger.instance.error(message, tag: tag);
void logCritical(String message, {String? tag}) => AdvancedLogger.instance.critical(message, tag: tag);
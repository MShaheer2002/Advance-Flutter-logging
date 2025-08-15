Flutter Advanced Logger
A comprehensive Flutter logging package with multiple log levels, persistent storage, file export, and feedback API integration.

Features
-> Multiple Log Levels: Debug, Info, Warning, Error, Critical
-> Persistent Storage: Uses Hive for efficient local storage
-> File Export: Export logs to files with filtering options
-> Feedback API: Send logs and feedback to your backend
-> Flexible Configuration: Customizable settings for different needs
-> Tagging Support: Organize logs with custom tags
-> Log Statistics: Built-in methods to analyze log data
-> Pretty Console Output: Beautiful console logging with emojis
-> High Performance: Efficient memory and storage management
Installation
Add this to your package's pubspec.yaml file:

yaml
dependencies:
  flutter_advanced_logger: ^1.0.0
Then run:

bash
flutter pub get
Quick Start
1. Initialize the Logger
dart
import 'package:flutter_advanced_logger/flutter_advanced_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize with default configuration
  await AdvancedLogger.instance.initialize();

  // Or initialize with custom configuration
  await AdvancedLogger.instance.initialize(
    config: LoggerConfig(
      enableConsoleOutput: true,
      enableFileStorage: true,
      minimumLogLevel: LogLevel.debug,
      maxLogEntries: 10000,
      enablePrettyPrint: true,
      feedbackApiUrl: 'https://your-api.com/feedback',
    ),
  );

  runApp(MyApp());
}
2. Basic Logging
dart
// Using global functions (easiest)
logDebug('This is a debug message');
logInfo('User logged in successfully');
logWarning('Network connection is slow');
logError('Failed to save data');
logCritical('System failure detected');

// Using the logger instance directly
AdvancedLogger.instance.debug('Debug with tag', tag: 'NETWORK');
AdvancedLogger.instance.info('Info message', tag: 'AUTH');
AdvancedLogger.instance.warning('Warning message');
AdvancedLogger.instance.error('Error message', tag: 'DATABASE');
AdvancedLogger.instance.critical('Critical issue', tag: 'SYSTEM');
3. Advanced Usage
dart
// Get logs by level
List<LogEntry> errorLogs = AdvancedLogger.instance.getLogsByLevel(LogLevel.error);

// Get logs by time range
DateTime start = DateTime.now().subtract(Duration(hours: 1));
DateTime end = DateTime.now();
List<LogEntry> recentLogs = AdvancedLogger.instance.getLogsByTimeRange(start, end);

// Export logs to file
String logFilePath = await AdvancedLogger.instance.createLogFile(
  levelFilter: [LogLevel.error, LogLevel.critical],
  startTime: DateTime.now().subtract(Duration(days: 1)),
);

// Clear all logs
await AdvancedLogger.instance.clearLogs();
4. Send Feedback with Logs
dart
final response = await AdvancedLogger.instance.sendFeedback(
  feedbackText: 'The app crashed when I tried to save my profile',
  includeLogs: true,
  logLevelFilter: [LogLevel.error, LogLevel.critical],
  additionalData: {
    'userId': '12345',
    'deviceModel': 'iPhone 12',
    'appVersion': '1.2.0',
  },
);

if (response.isSuccess) {
  print('Feedback sent successfully!');
} else {
  print('Failed to send feedback: ${response.message}');
}
Configuration Options
dart
LoggerConfig(
  enableConsoleOutput: true,        // Show logs in console
  enableFileStorage: true,          // Save logs to local storage
  minimumLogLevel: LogLevel.debug,  // Minimum level to log
  maxLogEntries: 10000,            // Maximum logs to keep
  enablePrettyPrint: true,         // Use emojis and formatting
  logBoxName: 'app_logs',          // Hive box name
  feedbackApiUrl: 'https://...',   // Your feedback API endpoint
  apiHeaders: {                    // Custom headers for API requests
    'Authorization': 'Bearer token',
    'Content-Type': 'application/json',
  },
);
Log Levels
Level	Priority	Emoji	Description
Debug	0	    Detailed information for debugging
Info	1	    General information
Warning	2	    Warning messages
Error	3	    Error conditions
Critical	4	Critical failures
API Integration
To integrate with your backend for feedback submission, your API endpoint should accept a multipart form with these fields:

feedbackText (string): The user's feedback
logs (file): Log file (if includeLogs is true)
attachments (files): Any additional files
appVersion (string): App version from package info
appName (string): App name from package info
packageName (string): Package name from package info
Any additional fields from additionalData
Best Practices
Initialize Early: Initialize the logger in your main() function before running the app.
Use Appropriate Levels:
Use debug for development information
Use info for general app flow
Use warning for recoverable issues
Use error for handled exceptions
Use critical for system failures
Add Tags: Use tags to categorize logs for easier filtering and analysis.
Handle Storage: Set appropriate maxLogEntries to manage storage usage.
Configure for Environment: Use different configurations for debug/release builds.
dart
final config = LoggerConfig(
  enableConsoleOutput: kDebugMode,
  minimumLogLevel: kDebugMode ? LogLevel.debug : LogLevel.info,
  enablePrettyPrint: kDebugMode,
);
Performance Considerations
The logger uses efficient memory management with configurable limits
Hive provides fast, local storage for persistence
Console output can be disabled in production builds
Log file creation is done asynchronously
Example Project
Check out the /example folder for a complete demonstration of all features.

Contributing
Contributions are welcome! Please read our contributing guidelines and submit pull requests to our repository.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Support
If you encounter any issues or have questions, please file an issue on our GitHub repository.


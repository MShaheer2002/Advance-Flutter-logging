import 'package:flutter/material.dart';
import 'package:flutter_advanced_logging/advance_flutter_logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logger with configuration
  await AdvancedLogger.instance.initialize(
    config: const LoggingConfig(
      enableConsoleOutput: true,
      enableFileStorage: true,
      minimumLogLevel: LogLevel.debug,
      maxLogEntries: 5000,
      enablePrettyPrint: true,
      feedbackApiUrl: 'https://your-api.com/feedback',
      apiHeaders: {
        'Authorization': 'Bearer your-token',
        'Content-Type': 'multipart/form-data',
      },
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Logger Example',
      home: LoggerDemo(),
    );
  }
}

class LoggerDemo extends StatefulWidget {
  @override
  _LoggerDemoState createState() => _LoggerDemoState();
}

class _LoggerDemoState extends State<LoggerDemo> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Log app startup
    logInfo('App started successfully', tag: 'STARTUP');
    logDebug('Debug mode enabled', tag: 'CONFIG');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Logger Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Manual logging section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manual Logging',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Log Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        labelText: 'Tag (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => _logMessage(LogLevel.debug),
                          child: const Text('Debug'),
                        ),
                        ElevatedButton(
                          onPressed: () => _logMessage(LogLevel.info),
                          child: const Text('Info'),
                        ),
                        ElevatedButton(
                          onPressed: () => _logMessage(LogLevel.warning),
                          child: const Text('Warning'),
                        ),
                        ElevatedButton(
                          onPressed: () => _logMessage(LogLevel.error),
                          child: const Text('Error'),
                        ),
                        ElevatedButton(
                          onPressed: () => _logMessage(LogLevel.critical),
                          child: const Text('Critical'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _generateSampleLogs,
                          child: const Text('Generate Sample Logs'),
                        ),
                        ElevatedButton(
                          onPressed: _exportLogs,
                          child: const Text('Export Logs'),
                        ),
                        ElevatedButton(
                          onPressed: _clearLogs,
                          child: const Text('Clear Logs'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Feedback section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Feedback',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Your Feedback',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _sendFeedback,
                      child: const Text('Send Feedback with Logs'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log Statistics',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text('Total Logs: ${AdvancedLogger.instance.logs.length}'),
                    Text('Debug: ${AdvancedLogger.instance.getLogsByLevel(LogLevel.debug).length}'),
                    Text('Info: ${AdvancedLogger.instance.getLogsByLevel(LogLevel.info).length}'),
                    Text('Warning: ${AdvancedLogger.instance.getLogsByLevel(LogLevel.warning).length}'),
                    Text('Error: ${AdvancedLogger.instance.getLogsByLevel(LogLevel.error).length}'),
                    Text('Critical: ${AdvancedLogger.instance.getLogsByLevel(LogLevel.critical).length}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logMessage(LogLevel level) {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    final tag = _tagController.text.trim().isEmpty ? null : _tagController.text.trim();

    switch (level) {
      case LogLevel.debug:
        logDebug(message, tag: tag);
        break;
      case LogLevel.info:
        logInfo(message, tag: tag);
        break;
      case LogLevel.warning:
        logWarning(message, tag: tag);
        break;
      case LogLevel.error:
        logError(message, tag: tag);
        break;
      case LogLevel.critical:
        logCritical(message, tag: tag);
        break;
    }

    _messageController.clear();
    setState(() {}); // Refresh stats

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${level.name.toUpperCase()} log added')),
    );
  }

  void _generateSampleLogs() {
    final samples = [
      ('User logged in successfully', LogLevel.info, 'AUTH'),
      ('Network timeout occurred', LogLevel.warning, 'NETWORK'),
      ('Failed to save user preferences', LogLevel.error, 'STORAGE'),
      ('Database connection established', LogLevel.debug, 'DB'),
      ('Critical system failure detected', LogLevel.critical, 'SYSTEM'),
      ('API request completed', LogLevel.info, 'API'),
      ('Cache miss for user data', LogLevel.debug, 'CACHE'),
      ('Invalid input detected', LogLevel.warning, 'VALIDATION'),
    ];

    for (final sample in samples) {
      AdvancedLogger.instance.log(sample.$1, level: sample.$2, tag: sample.$3);
    }

    setState(() {}); // Refresh stats
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generated ${samples.length} sample logs')),
    );
  }

  Future<void> _exportLogs() async {
    try {
      final filePath = await AdvancedLogger.instance.createLogFile();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logs exported to: $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export logs: $e')),
      );
    }
  }

  Future<void> _clearLogs() async {
    await AdvancedLogger.instance.clearLogs();
    setState(() {}); // Refresh stats
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All logs cleared')),
    );
  }

  Future<void> _sendFeedback() async {
    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter feedback text')),
      );
      return;
    }

    try {
      final response = await AdvancedLogger.instance.sendFeedback(
        feedbackText: feedback,
        includeLogs: true,
        additionalData: {
          'userType': 'demo_user',
          'platform': 'mobile',
        },
      );

      if (response.isSuccess) {
        _feedbackController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send feedback: ${response.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending feedback: $e')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _tagController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
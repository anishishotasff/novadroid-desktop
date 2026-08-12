import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AppLogger {
  static Logger? _instance;
  static File? _logFile;

  static Future<Logger> getInstance() async {
    if (_instance == null) {
      await _initLogger();
    }
    return _instance!;
  }

  static Future<void> _initLogger() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final logsDir = Directory(p.join(appDir.path, 'logs'));
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      _logFile = File(p.join(logsDir.path, 'novadroid_$timestamp.log'));

      _instance = Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
        output: MultiOutput([
          ConsoleOutput(),
          FileOutput(file: _logFile!),
        ]),
      );
    } catch (e) {
      _instance = Logger();
      // ignore: avoid_print
      print('Failed to initialize file logging: $e');
    }
  }

  static void debug(String message) {
    _instance?.d(message);
  }

  static void info(String message) {
    _instance?.i(message);
  }

  static void warning(String message) {
    _instance?.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _instance?.e(message, error: error, stackTrace: stackTrace);
  }

  static File? get logFile => _logFile;
}

class FileOutput extends LogOutput {
  final File file;
  
  FileOutput({required this.file});

  @override
  void output(OutputEvent event) {
    try {
      final buffer = StringBuffer();
      for (var line in event.lines) {
        buffer.writeln(line);
      }
      file.writeAsStringSync(buffer.toString(), mode: FileMode.append, flush: true);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to write log: $e');
    }
  }
}

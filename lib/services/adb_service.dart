import 'dart:io';
import 'dart:convert';
import 'package:process_run/shell.dart';
import '../core/logging/app_logger.dart';
import '../core/errors/app_exception.dart';
import '../models/device_model.dart';

class AdbService {
  static AdbService? _instance;
  String? _adbPath;
  final Shell _shell = Shell();

  static AdbService get instance {
    _instance ??= AdbService._();
    return _instance!;
  }

  AdbService._();

  /// Initialize ADB by finding the executable
  Future<void> initialize() async {
    AppLogger.info('Initializing ADB service');
    
    try {
      _adbPath = await _findAdbPath();
      if (_adbPath == null) {
        throw AdbException(
          message: 'ADB not found',
          details: 'Android Debug Bridge (ADB) could not be located on your system.',
          suggestedFix: 'Please install Android Platform Tools or set the ADB path in Settings.',
        );
      }
      
      AppLogger.info('ADB found at: $_adbPath');
      
      // Test ADB
      final version = await getAdbVersion();
      AppLogger.info('ADB version: $version');
    } catch (e) {
      AppLogger.error('Failed to initialize ADB', e);
      rethrow;
    }
  }

  /// Find ADB executable path
  Future<String?> _findAdbPath() async {
    // Common ADB locations
    final List<String> possiblePaths = [
      // User's Android SDK
      Platform.environment['LOCALAPPDATA'] != null
          ? '${Platform.environment['LOCALAPPDATA']}\\Android\\Sdk\\platform-tools\\adb.exe'
          : '',
      Platform.environment['ANDROID_SDK_ROOT'] != null
          ? '${Platform.environment['ANDROID_SDK_ROOT']}\\platform-tools\\adb.exe'
          : '',
      Platform.environment['ANDROID_HOME'] != null
          ? '${Platform.environment['ANDROID_HOME']}\\platform-tools\\adb.exe'
          : '',
      // System PATH
      'adb.exe',
      'adb',
      // Common installation paths
      'C:\\Android\\platform-tools\\adb.exe',
      'C:\\Program Files\\Android\\platform-tools\\adb.exe',
      'C:\\Program Files (x86)\\Android\\platform-tools\\adb.exe',
    ];

    for (final path in possiblePaths) {
      if (path.isEmpty) continue;
      
      try {
        if (path == 'adb.exe' || path == 'adb') {
          // Check if adb is in PATH
          final result = await Process.run('where', ['adb'], runInShell: true);
          if (result.exitCode == 0 && result.stdout.toString().isNotEmpty) {
            return result.stdout.toString().trim().split('\n').first;
          }
        } else {
          // Check if file exists
          final file = File(path);
          if (await file.exists()) {
            return path;
          }
        }
      } catch (e) {
        // Continue checking other paths
        continue;
      }
    }

    return null;
  }

  /// Get ADB version
  Future<String> getAdbVersion() async {
    _ensureInitialized();
    
    try {
      final result = await Process.run(_adbPath!, ['version']);
      if (result.exitCode != 0) {
        throw AdbException(
          message: 'Failed to get ADB version',
          details: result.stderr.toString(),
        );
      }
      return result.stdout.toString().split('\n').first;
    } catch (e) {
      throw AdbException(
        message: 'Failed to execute ADB',
        originalError: e,
      );
    }
  }

  /// Start ADB server
  Future<void> startServer() async {
    _ensureInitialized();
    AppLogger.info('Starting ADB server');
    
    try {
      final result = await Process.run(_adbPath!, ['start-server']);
      if (result.exitCode != 0) {
        throw AdbException(
          message: 'Failed to start ADB server',
          details: result.stderr.toString(),
        );
      }
      AppLogger.info('ADB server started successfully');
    } catch (e) {
      throw AdbException(
        message: 'Failed to start ADB server',
        originalError: e,
      );
    }
  }

  /// Kill ADB server
  Future<void> killServer() async {
    _ensureInitialized();
    AppLogger.info('Killing ADB server');
    
    try {
      await Process.run(_adbPath!, ['kill-server']);
      AppLogger.info('ADB server killed');
    } catch (e) {
      AppLogger.error('Failed to kill ADB server', e);
    }
  }

  /// Get list of connected devices
  Future<List<DeviceModel>> getDevices() async {
    _ensureInitialized();
    
    try {
      final result = await Process.run(_adbPath!, ['devices', '-l']);
      if (result.exitCode != 0) {
        throw AdbException(
          message: 'Failed to list devices',
          details: result.stderr.toString(),
        );
      }

      final output = result.stdout.toString();
      final lines = output.split('\n');
      final List<DeviceModel> devices = [];

      for (final line in lines) {
        if (line.isEmpty || line.startsWith('List of devices')) continue;
        
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length < 2) continue;

        final deviceId = parts[0];
        final status = parts[1];

        // Parse device state
        DeviceState state;
        if (status == 'device') {
          state = DeviceState.connected;
        } else if (status == 'unauthorized') {
          state = DeviceState.unauthorized;
        } else if (status == 'offline') {
          state = DeviceState.disconnected;
        } else {
          continue;
        }

        // Determine connection type
        DeviceConnectionType connectionType = DeviceConnectionType.usb;
        String? ipAddress;
        int? port;

        if (deviceId.contains(':')) {
          connectionType = DeviceConnectionType.wireless;
          final ipPort = deviceId.split(':');
          ipAddress = ipPort[0];
          port = int.tryParse(ipPort[1]);
        }

        // Parse additional info
        String? model;
        for (final part in parts.skip(2)) {
          if (part.startsWith('model:')) {
            model = part.substring(6);
          }
        }

        final device = DeviceModel(
          id: deviceId,
          model: model,
          connectionType: connectionType,
          ipAddress: ipAddress,
          port: port,
          state: state,
        );

        devices.add(device);
      }

      AppLogger.info('Found ${devices.length} device(s)');
      return devices;
    } catch (e) {
      if (e is AdbException) rethrow;
      throw AdbException(
        message: 'Failed to get device list',
        originalError: e,
      );
    }
  }

  /// Get device properties
  Future<Map<String, String>> getDeviceProperties(String deviceId) async {
    _ensureInitialized();
    
    try {
      final properties = <String, String>{};
      
      // Get various device properties
      final propCommands = {
        'name': 'ro.product.name',
        'model': 'ro.product.model',
        'manufacturer': 'ro.product.manufacturer',
        'android_version': 'ro.build.version.release',
        'sdk_version': 'ro.build.version.sdk',
        'serial': 'ro.serialno',
      };

      for (final entry in propCommands.entries) {
        try {
          final result = await Process.run(
            _adbPath!,
            ['-s', deviceId, 'shell', 'getprop', entry.value],
          );
          if (result.exitCode == 0) {
            properties[entry.key] = result.stdout.toString().trim();
          }
        } catch (e) {
          AppLogger.warning('Failed to get property ${entry.key}: $e');
        }
      }

      return properties;
    } catch (e) {
      throw AdbException(
        message: 'Failed to get device properties',
        originalError: e,
      );
    }
  }

  /// Get battery level
  Future<int?> getBatteryLevel(String deviceId) async {
    _ensureInitialized();
    
    try {
      final result = await Process.run(
        _adbPath!,
        ['-s', deviceId, 'shell', 'dumpsys', 'battery'],
      );
      
      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        final levelMatch = RegExp(r'level:\s*(\d+)').firstMatch(output);
        if (levelMatch != null) {
          return int.parse(levelMatch.group(1)!);
        }
      }
      return null;
    } catch (e) {
      AppLogger.warning('Failed to get battery level: $e');
      return null;
    }
  }

  /// Check if device is charging
  Future<bool?> isCharging(String deviceId) async {
    _ensureInitialized();
    
    try {
      final result = await Process.run(
        _adbPath!,
        ['-s', deviceId, 'shell', 'dumpsys', 'battery'],
      );
      
      if (result.exitCode == 0) {
        final output = result.stdout.toString();
        final statusMatch = RegExp(r'status:\s*(\d+)').firstMatch(output);
        if (statusMatch != null) {
          final status = int.parse(statusMatch.group(1)!);
          return status == 2; // 2 = charging
        }
      }
      return null;
    } catch (e) {
      AppLogger.warning('Failed to check charging status: $e');
      return null;
    }
  }

  /// Connect to wireless device
  Future<bool> connectWireless(String ipAddress, int port) async {
    _ensureInitialized();
    AppLogger.info('Connecting to $ipAddress:$port');
    
    try {
      final result = await Process.run(
        _adbPath!,
        ['connect', '$ipAddress:$port'],
      );
      
      final output = result.stdout.toString().toLowerCase();
      if (output.contains('connected') || output.contains('already connected')) {
        AppLogger.info('Successfully connected to $ipAddress:$port');
        return true;
      }
      
      throw ConnectionException(
        message: 'Failed to connect to device',
        details: result.stdout.toString(),
        suggestedFix: 'Ensure wireless debugging is enabled and the device is on the same network.',
      );
    } catch (e) {
      if (e is ConnectionException) rethrow;
      throw ConnectionException(
        message: 'Failed to connect to $ipAddress:$port',
        originalError: e,
      );
    }
  }

  /// Disconnect from wireless device
  Future<void> disconnectWireless(String ipAddress, int port) async {
    _ensureInitialized();
    AppLogger.info('Disconnecting from $ipAddress:$port');
    
    try {
      await Process.run(
        _adbPath!,
        ['disconnect', '$ipAddress:$port'],
      );
      AppLogger.info('Disconnected from $ipAddress:$port');
    } catch (e) {
      AppLogger.error('Failed to disconnect', e);
    }
  }

  /// Execute shell command on device
  Future<String> executeShellCommand(String deviceId, List<String> command) async {
    _ensureInitialized();
    
    try {
      final args = ['-s', deviceId, 'shell', ...command];
      final result = await Process.run(_adbPath!, args);
      
      if (result.exitCode != 0) {
        throw AdbException(
          message: 'Shell command failed',
          details: result.stderr.toString(),
        );
      }
      
      return result.stdout.toString();
    } catch (e) {
      if (e is AdbException) rethrow;
      throw AdbException(
        message: 'Failed to execute shell command',
        originalError: e,
      );
    }
  }

  /// Check if ADB is initialized
  void _ensureInitialized() {
    if (_adbPath == null) {
      throw AdbException(
        message: 'ADB not initialized',
        suggestedFix: 'Call initialize() first',
      );
    }
  }

  /// Get ADB path
  String? get adbPath => _adbPath;

  /// Set custom ADB path
  void setAdbPath(String path) {
    _adbPath = path;
    AppLogger.info('ADB path set to: $path');
  }

  /// Check if ADB is available
  bool get isAvailable => _adbPath != null;
}

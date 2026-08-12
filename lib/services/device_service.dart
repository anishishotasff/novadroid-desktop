import 'dart:async';
import '../models/device_model.dart';
import '../core/logging/app_logger.dart';
import 'adb_service.dart';

class DeviceService {
  static DeviceService? _instance;
  final AdbService _adbService = AdbService.instance;
  
  Timer? _deviceScanTimer;
  Timer? _deviceUpdateTimer;
  
  final StreamController<List<DeviceModel>> _devicesController =
      StreamController<List<DeviceModel>>.broadcast();
  
  final StreamController<DeviceModel?> _currentDeviceController =
      StreamController<DeviceModel?>.broadcast();

  static DeviceService get instance {
    _instance ??= DeviceService._();
    return _instance!;
  }

  DeviceService._();

  Stream<List<DeviceModel>> get devicesStream => _devicesController.stream;
  Stream<DeviceModel?> get currentDeviceStream => _currentDeviceController.stream;

  /// Initialize device service
  Future<void> initialize() async {
    AppLogger.info('Initializing Device Service');
    await _adbService.initialize();
    await _adbService.startServer();
  }

  /// Start periodic device scanning
  void startDeviceScan({Duration interval = const Duration(seconds: 5)}) {
    AppLogger.info('Starting device scan');
    _deviceScanTimer?.cancel();
    
    _deviceScanTimer = Timer.periodic(interval, (timer) async {
      try {
        await scanDevices();
      } catch (e) {
        AppLogger.error('Error during device scan', e);
      }
    });
    
    // Initial scan
    scanDevices();
  }

  /// Stop device scanning
  void stopDeviceScan() {
    AppLogger.info('Stopping device scan');
    _deviceScanTimer?.cancel();
    _deviceScanTimer = null;
  }

  /// Scan for devices
  Future<List<DeviceModel>> scanDevices() async {
    try {
      final devices = await _adbService.getDevices();
      
      // Enrich device info
      final enrichedDevices = <DeviceModel>[];
      for (final device in devices) {
        final enriched = await _enrichDeviceInfo(device);
        enrichedDevices.add(enriched);
      }
      
      _devicesController.add(enrichedDevices);
      return enrichedDevices;
    } catch (e) {
      AppLogger.error('Failed to scan devices', e);
      return [];
    }
  }

  /// Enrich device with additional information
  Future<DeviceModel> _enrichDeviceInfo(DeviceModel device) async {
    if (device.state != DeviceState.connected) {
      return device;
    }

    try {
      final props = await _adbService.getDeviceProperties(device.id);
      final batteryLevel = await _adbService.getBatteryLevel(device.id);
      final isCharging = await _adbService.isCharging(device.id);

      return device.copyWith(
        name: props['name'],
        model: props['model'] ?? device.model,
        androidVersion: props['android_version'],
        batteryLevel: batteryLevel,
        isCharging: isCharging,
      );
    } catch (e) {
      AppLogger.warning('Failed to enrich device info for ${device.id}: $e');
      return device;
    }
  }

  /// Connect to device
  Future<DeviceModel> connectToDevice(DeviceModel device) async {
    AppLogger.info('Connecting to device ${device.id}');
    
    try {
      // If wireless, ensure connection
      if (device.connectionType == DeviceConnectionType.wireless) {
        if (device.ipAddress != null && device.port != null) {
          await _adbService.connectWireless(device.ipAddress!, device.port!);
        }
      }

      // Verify connection and get updated device info
      final devices = await _adbService.getDevices();
      final connectedDevice = devices.firstWhere(
        (d) => d.id == device.id,
        orElse: () => device,
      );

      if (connectedDevice.state == DeviceState.connected) {
        final enriched = await _enrichDeviceInfo(connectedDevice);
        _currentDeviceController.add(enriched);
        
        // Start monitoring device
        _startDeviceMonitoring(enriched);
        
        return enriched;
      } else {
        throw Exception('Device not connected: ${connectedDevice.stateString}');
      }
    } catch (e) {
      AppLogger.error('Failed to connect to device', e);
      rethrow;
    }
  }

  /// Disconnect from device
  Future<void> disconnectFromDevice(DeviceModel device) async {
    AppLogger.info('Disconnecting from device ${device.id}');
    
    try {
      _stopDeviceMonitoring();
      
      if (device.connectionType == DeviceConnectionType.wireless) {
        if (device.ipAddress != null && device.port != null) {
          await _adbService.disconnectWireless(device.ipAddress!, device.port!);
        }
      }
      
      _currentDeviceController.add(null);
    } catch (e) {
      AppLogger.error('Failed to disconnect from device', e);
    }
  }

  /// Connect to wireless device by IP and port
  Future<DeviceModel> connectWireless(String ipAddress, int port) async {
    AppLogger.info('Connecting to wireless device $ipAddress:$port');
    
    try {
      final success = await _adbService.connectWireless(ipAddress, port);
      
      if (!success) {
        throw Exception('Failed to connect to device');
      }

      // Wait a bit for device to appear
      await Future.delayed(const Duration(seconds: 2));
      
      // Find the device
      final devices = await _adbService.getDevices();
      final device = devices.firstWhere(
        (d) => d.ipAddress == ipAddress && d.port == port,
        orElse: () => throw Exception('Device not found after connection'),
      );

      return await connectToDevice(device);
    } catch (e) {
      AppLogger.error('Failed to connect to wireless device', e);
      rethrow;
    }
  }

  /// Start monitoring current device
  void _startDeviceMonitoring(DeviceModel device) {
    _stopDeviceMonitoring();
    
    _deviceUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final updated = await _enrichDeviceInfo(device);
        _currentDeviceController.add(updated);
      } catch (e) {
        AppLogger.warning('Failed to update device info: $e');
      }
    });
  }

  /// Stop monitoring current device
  void _stopDeviceMonitoring() {
    _deviceUpdateTimer?.cancel();
    _deviceUpdateTimer = null;
  }

  /// Dispose service
  void dispose() {
    stopDeviceScan();
    _stopDeviceMonitoring();
    _devicesController.close();
    _currentDeviceController.close();
  }
}

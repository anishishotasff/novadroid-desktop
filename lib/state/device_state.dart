import 'package:flutter/foundation.dart';
import '../models/device_model.dart' as model;

class DeviceState extends ChangeNotifier {
  model.DeviceModel? _currentDevice;
  List<model.DeviceModel> _availableDevices = [];
  String? _errorMessage;
  bool _isScanning = false;

  model.DeviceModel? get currentDevice => _currentDevice;
  List<model.DeviceModel> get availableDevices => _availableDevices;
  String? get errorMessage => _errorMessage;
  bool get isScanning => _isScanning;
  bool get hasDevice => _currentDevice != null;
  bool get isConnected => _currentDevice?.isConnected ?? false;

  void setCurrentDevice(model.DeviceModel? device) {
    _currentDevice = device;
    _errorMessage = null;
    notifyListeners();
  }

  /// Pick a device from the available list by id, mark it as connected,
  /// and set it as the current device immediately (enrichment happens later).
  void setCurrentDeviceFromList(String deviceId) {
    final index = _availableDevices.indexWhere((d) => d.id == deviceId);
    if (index >= 0) {
      _currentDevice = _availableDevices[index].copyWith(
        state: model.DeviceState.connected,
      );
    } else {
      // Fallback: create a minimal device entry
      _currentDevice = model.DeviceModel(
        id: deviceId,
        state: model.DeviceState.connected,
        connectionType: deviceId.contains(':')
            ? model.DeviceConnectionType.wireless
            : model.DeviceConnectionType.usb,
      );
    }
    _errorMessage = null;
    notifyListeners();
  }

  void updateDeviceState(model.DeviceState newState) {
    if (_currentDevice != null) {
      _currentDevice = _currentDevice!.copyWith(state: newState);
      notifyListeners();
    }
  }

  void setAvailableDevices(List<model.DeviceModel> devices) {
    _availableDevices = devices;
    
    // If current device is no longer in available devices and not connected, clear it
    if (_currentDevice != null && 
        !devices.any((d) => d.id == _currentDevice!.id) &&
        _currentDevice!.state != model.DeviceState.connected) {
      _currentDevice = null;
    }
    
    notifyListeners();
  }

  void addDevice(model.DeviceModel device) {
    final index = _availableDevices.indexWhere((d) => d.id == device.id);
    if (index >= 0) {
      _availableDevices[index] = device;
    } else {
      _availableDevices.add(device);
    }
    notifyListeners();
  }

  void removeDevice(String deviceId) {
    _availableDevices.removeWhere((d) => d.id == deviceId);
    if (_currentDevice?.id == deviceId) {
      _currentDevice = null;
    }
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
    if (_currentDevice != null && _currentDevice!.state != model.DeviceState.connected) {
      _currentDevice = _currentDevice!.copyWith(state: model.DeviceState.error);
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clear() {
    _currentDevice = null;
    _errorMessage = null;
    notifyListeners();
  }

  void setScanning(bool scanning) {
    _isScanning = scanning;
    notifyListeners();
  }

  void disconnect() {
    _currentDevice = null;
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _currentDevice = null;
    _availableDevices = [];
    _errorMessage = null;
    _isScanning = false;
    notifyListeners();
  }
}

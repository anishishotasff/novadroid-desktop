import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isInitializing = false;
  String _initializationStage = '';
  bool _showDeviceManager = false;
  bool _showSettings = false;
  bool _showQuickSettings = false;
  bool _showNotifications = false;

  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
  String get initializationStage => _initializationStage;
  bool get showDeviceManager => _showDeviceManager;
  bool get showSettings => _showSettings;
  bool get showQuickSettings => _showQuickSettings;
  bool get showNotifications => _showNotifications;

  void setInitialized(bool initialized) {
    _isInitialized = initialized;
    _isInitializing = false;
    notifyListeners();
  }

  void setInitializing(bool initializing, [String stage = '']) {
    _isInitializing = initializing;
    _initializationStage = stage;
    notifyListeners();
  }

  void setInitializationStage(String stage) {
    _initializationStage = stage;
    notifyListeners();
  }

  void toggleDeviceManager() {
    _showDeviceManager = !_showDeviceManager;
    if (_showDeviceManager) {
      _showSettings = false;
      _showQuickSettings = false;
      _showNotifications = false;
    }
    notifyListeners();
  }

  void closeDeviceManager() {
    _showDeviceManager = false;
    notifyListeners();
  }

  void toggleSettings() {
    _showSettings = !_showSettings;
    if (_showSettings) {
      _showDeviceManager = false;
      _showQuickSettings = false;
      _showNotifications = false;
    }
    notifyListeners();
  }

  void closeSettings() {
    _showSettings = false;
    notifyListeners();
  }

  void toggleQuickSettings() {
    _showQuickSettings = !_showQuickSettings;
    if (_showQuickSettings) {
      _showDeviceManager = false;
      _showSettings = false;
      _showNotifications = false;
    }
    notifyListeners();
  }

  void closeQuickSettings() {
    _showQuickSettings = false;
    notifyListeners();
  }

  void toggleNotifications() {
    _showNotifications = !_showNotifications;
    if (_showNotifications) {
      _showDeviceManager = false;
      _showSettings = false;
      _showQuickSettings = false;
    }
    notifyListeners();
  }

  void closeNotifications() {
    _showNotifications = false;
    notifyListeners();
  }

  void closeAll() {
    _showDeviceManager = false;
    _showSettings = false;
    _showQuickSettings = false;
    _showNotifications = false;
    notifyListeners();
  }
}

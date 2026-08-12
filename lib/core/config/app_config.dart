class AppConfig {
  static const String appName = 'NovaDroid Desktop';
  static const String appVersion = '1.0.0';
  
  // ADB Configuration
  static const String defaultAdbPath = r'C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools\adb.exe';
  static const int adbConnectionTimeout = 10000; // milliseconds
  static const int adbRetryAttempts = 3;
  
  // Mirroring Configuration
  static const int defaultBitrate = 8000000; // 8 Mbps
  static const int defaultMaxFps = 60;
  static const int defaultMaxSize = 1920;
  
  // Network Configuration
  static const int defaultWebSocketPort = 8765;
  static const int defaultTcpPort = 5555;
  
  // UI Configuration
  static const double taskbarHeight = 60.0;
  static const double windowHeaderHeight = 36.0;
  static const Duration animationDuration = Duration(milliseconds: 200);
  
  // Directories
  static const String screenshotsDir = 'screenshots';
  static const String logsDir = 'logs';
  static const String configDir = 'config';
}

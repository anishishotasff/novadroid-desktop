enum DeviceConnectionType {
  usb,
  wireless,
  unknown,
}

enum DeviceState {
  noDevice,
  detecting,
  connecting,
  unauthorized,
  connected,
  reconnecting,
  disconnected,
  error,
}

class DeviceModel {
  final String id;
  final String? name;
  final String? model;
  final String? androidVersion;
  final DeviceConnectionType connectionType;
  final String? ipAddress;
  final int? port;
  final DeviceState state;
  final int? batteryLevel;
  final bool? isCharging;

  DeviceModel({
    required this.id,
    this.name,
    this.model,
    this.androidVersion,
    this.connectionType = DeviceConnectionType.unknown,
    this.ipAddress,
    this.port,
    this.state = DeviceState.disconnected,
    this.batteryLevel,
    this.isCharging,
  });

  DeviceModel copyWith({
    String? id,
    String? name,
    String? model,
    String? androidVersion,
    DeviceConnectionType? connectionType,
    String? ipAddress,
    int? port,
    DeviceState? state,
    int? batteryLevel,
    bool? isCharging,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      androidVersion: androidVersion ?? this.androidVersion,
      connectionType: connectionType ?? this.connectionType,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      state: state ?? this.state,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isCharging: isCharging ?? this.isCharging,
    );
  }

  String get displayName => name ?? model ?? id;

  String get connectionTypeString {
    switch (connectionType) {
      case DeviceConnectionType.usb:
        return 'USB';
      case DeviceConnectionType.wireless:
        return 'Wireless';
      default:
        return 'Unknown';
    }
  }

  String get stateString {
    switch (state) {
      case DeviceState.noDevice:
        return 'No Device';
      case DeviceState.detecting:
        return 'Detecting...';
      case DeviceState.connecting:
        return 'Connecting...';
      case DeviceState.unauthorized:
        return 'Unauthorized';
      case DeviceState.connected:
        return 'Connected';
      case DeviceState.reconnecting:
        return 'Reconnecting...';
      case DeviceState.disconnected:
        return 'Disconnected';
      case DeviceState.error:
        return 'Error';
    }
  }

  bool get isConnected => state == DeviceState.connected;
  bool get isConnecting => state == DeviceState.connecting || state == DeviceState.reconnecting;
  bool get hasError => state == DeviceState.error || state == DeviceState.unauthorized;
}

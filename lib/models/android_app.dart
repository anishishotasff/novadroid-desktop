class AndroidApp {
  final String packageName;
  final String appName;
  final String? icon;
  final bool isSystemApp;
  final String? versionName;
  final int? versionCode;
  final bool isFavorite;

  AndroidApp({
    required this.packageName,
    required this.appName,
    this.icon,
    this.isSystemApp = false,
    this.versionName,
    this.versionCode,
    this.isFavorite = false,
  });

  AndroidApp copyWith({
    String? packageName,
    String? appName,
    String? icon,
    bool? isSystemApp,
    String? versionName,
    int? versionCode,
    bool? isFavorite,
  }) {
    return AndroidApp(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      icon: icon ?? this.icon,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'icon': icon,
      'isSystemApp': isSystemApp,
      'versionName': versionName,
      'versionCode': versionCode,
      'isFavorite': isFavorite,
    };
  }

  factory AndroidApp.fromJson(Map<String, dynamic> json) {
    return AndroidApp(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      icon: json['icon'] as String?,
      isSystemApp: json['isSystemApp'] as bool? ?? false,
      versionName: json['versionName'] as String?,
      versionCode: json['versionCode'] as int?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}

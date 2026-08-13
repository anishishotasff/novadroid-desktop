import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/taskbar.dart';
import '../../state/app_state.dart';
import '../../state/device_state.dart';
import '../../models/device_model.dart' as model;
import '../device_manager/device_manager_panel.dart';
import '../settings/settings_panel.dart';
import '../quick_controls/quick_settings_panel.dart';
import '../notifications/notifications_panel.dart';
import '../launcher/android_launcher.dart';
import '../../services/adb_service.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceState>(
      builder: (context, deviceState, _) {
        final connected = deviceState.isConnected;
        final device = deviceState.currentDevice;

        return Scaffold(
          body: Stack(
            children: [
              // Background wallpaper
              connected && device != null
                  ? _buildPhoneWallpaper(device)
                  : _buildBackground(),

              // Main content layer
              if (connected && device != null)
                _buildConnectedDesktop(context, device)
              else
                Column(
                  children: [
                    Expanded(child: _buildWelcomeArea(context)),
                    const Taskbar(),
                  ],
                ),

              // Overlay panels (device manager, settings, etc.)
              _buildOverlayPanels(context),
            ],
          ),
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  Not-connected state
  // ──────────────────────────────────────────────────────────────

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.secondaryColor.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeArea(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: AppTheme.elevatedShadow,
            ),
            child: const Icon(Icons.phone_android, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text('NovaDroid Desktop', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 16),
          Text(
            'Connect your Android device to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.read<AppState>().toggleDeviceManager(),
            icon: const Icon(Icons.add_link),
            label: const Text('Connect Device'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  Connected desktop state
  // ──────────────────────────────────────────────────────────────

  Widget _buildPhoneWallpaper(model.DeviceModel device) {
    // Deterministic gradient derived from the device id
    final colors = _wallpaperColorsForDevice(device);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildConnectedDesktop(BuildContext context, model.DeviceModel device) {
    return Stack(
      children: [
        // Top status bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(device: device),
        ),

        // Main app grid (between top bar and dock)
        Positioned(
          top: 48,
          bottom: 120,
          left: 0,
          right: 0,
          child: AndroidLauncher(deviceId: device.id),
        ),

        // Bottom dock
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: _buildDock(context),
        ),

        // Taskbar at very bottom
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Taskbar(),
        ),
      ],
    );
  }

  Widget _buildDock(BuildContext context) {
    final dockApps = [
      _DockApp(icon: Icons.phone, label: 'Phone', packageName: 'com.android.dialer'),
      _DockApp(icon: Icons.message, label: 'Messages', packageName: 'com.google.android.apps.messaging'),
      _DockApp(icon: Icons.camera_alt, label: 'Camera', packageName: 'com.android.camera2'),
      _DockApp(icon: Icons.language, label: 'Chrome', packageName: 'com.android.chrome'),
      _DockApp(icon: Icons.settings, label: 'Settings', packageName: 'com.android.settings'),
    ];

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Consumer<DeviceState>(
          builder: (context, deviceState, _) {
            final deviceId = deviceState.currentDevice?.id ?? '';
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: dockApps.map((app) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _DockIcon(app: app, deviceId: deviceId),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  Overlay panels
  // ──────────────────────────────────────────────────────────────

  Widget _buildOverlayPanels(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Stack(
          children: [
            // Backdrop
            if (appState.showDeviceManager ||
                appState.showSettings ||
                appState.showQuickSettings ||
                appState.showNotifications)
              GestureDetector(
                onTap: () => appState.closeAll(),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),

            // Device Manager
            if (appState.showDeviceManager)
              Positioned(
                top: 0,
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
                    child: const DeviceManagerPanel(),
                  ),
                ),
              ),

            // Settings
            if (appState.showSettings)
              Positioned(
                top: 0,
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
                    child: const SettingsPanel(),
                  ),
                ),
              ),

            // Quick Settings
            if (appState.showQuickSettings)
              const Positioned(
                bottom: 80,
                right: 20,
                child: QuickSettingsPanel(),
              ),

            // Notifications
            if (appState.showNotifications)
              const Positioned(
                bottom: 80,
                right: 20,
                child: NotificationsPanel(),
              ),
          ],
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────────────────────────────

  List<Color> _wallpaperColorsForDevice(model.DeviceModel device) {
    final hash = device.id.codeUnits.fold(0, (prev, e) => prev + e);
    const palettes = [
      [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
      [Color(0xFF0D0D0D), Color(0xFF1a1a2e), Color(0xFF6A0572)],
      [Color(0xFF134E5E), Color(0xFF71B280)],
      [Color(0xFF232526), Color(0xFF414345)],
      [Color(0xFF1D4350), Color(0xFFA43931)],
    ];
    return palettes[hash % palettes.length];
  }
}

// ──────────────────────────────────────────────────────────────
//  Top Bar Widget
// ──────────────────────────────────────────────────────────────

class _TopBar extends StatefulWidget {
  final model.DeviceModel device;

  const _TopBar({required this.device});

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final timeStr = DateFormat('HH:mm').format(_now);
    final batteryLevel = device.batteryLevel;
    final isCharging = device.isCharging ?? false;
    final androidVer = device.androidVersion ?? '';
    final connectionType = device.connectionType == model.DeviceConnectionType.wireless
        ? 'WiFi'
        : 'USB';

    return Container(
      height: 48,
      color: Colors.black.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Left: device info
          const Icon(Icons.android, color: Color(0xFF78C257), size: 18),
          const SizedBox(width: 8),
          Text(
            device.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (androidVer.isNotEmpty) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Android $androidVer',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
          ],

          // Center: clock
          const Spacer(),
          Text(
            timeStr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),

          // Right: battery + connection
          if (batteryLevel != null) ...[
            Icon(
              isCharging ? Icons.battery_charging_full : _batteryIcon(batteryLevel),
              color: batteryLevel <= 20 ? Colors.redAccent : Colors.white,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '$batteryLevel%',
              style: TextStyle(
                color: batteryLevel <= 20 ? Colors.redAccent : Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Icon(
            device.connectionType == model.DeviceConnectionType.wireless
                ? Icons.wifi
                : Icons.usb,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            connectionType,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  IconData _batteryIcon(int level) {
    if (level >= 90) return Icons.battery_full;
    if (level >= 60) return Icons.battery_5_bar;
    if (level >= 40) return Icons.battery_3_bar;
    if (level >= 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }
}

// ──────────────────────────────────────────────────────────────
//  Dock helpers
// ──────────────────────────────────────────────────────────────

class _DockApp {
  final IconData icon;
  final String label;
  final String packageName;

  const _DockApp({
    required this.icon,
    required this.label,
    required this.packageName,
  });
}

class _DockIcon extends StatelessWidget {
  final _DockApp app;
  final String deviceId;

  const _DockIcon({required this.app, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: app.label,
      child: InkWell(
        onTap: () => _launch(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(app.icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }

  Future<void> _launch(BuildContext context) async {
    if (deviceId.isEmpty) return;
    try {
      await AdbService.instance.launchApp(deviceId, app.packageName);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch ${app.label}'),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

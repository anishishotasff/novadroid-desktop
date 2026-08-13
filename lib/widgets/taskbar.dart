import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../core/config/app_config.dart';
import '../state/app_state.dart';
import '../state/device_state.dart';
import '../models/device_model.dart' as model;

class Taskbar extends StatelessWidget {
  const Taskbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConfig.taskbarHeight,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          _buildStartButton(context),
          const SizedBox(width: 24),
          _buildSearchBox(context),
          const Spacer(),
          _buildSystemTray(context),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Open app launcher
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.apps, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Apps',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.textDisabled.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search apps...',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildSystemTray(BuildContext context) {
    return Row(
      children: [
        _buildDeviceIndicator(context),
        const SizedBox(width: 12),
        _buildQuickSettingsButton(context),
        const SizedBox(width: 12),
        _buildNotificationsButton(context),
        const SizedBox(width: 12),
        _buildClock(context),
      ],
    );
  }

  Widget _buildDeviceIndicator(BuildContext context) {
    return Consumer<DeviceState>(
      builder: (context, deviceState, child) {
        final device = deviceState.currentDevice;
        final isConnected = device?.isConnected ?? false;
        final hasDevice = device != null;

        // Determine color and icon based on state
        Color indicatorColor;
        Color borderColor;
        IconData iconData;
        String displayText;

        if (!hasDevice) {
          // No device at all
          indicatorColor = AppTheme.backgroundColor.withValues(alpha: 0.5);
          borderColor = AppTheme.textDisabled.withValues(alpha: 0.3);
          iconData = Icons.phonelink_off;
          displayText = 'No Device';
        } else if (isConnected) {
          // Connected
          indicatorColor = AppTheme.successColor.withValues(alpha: 0.2);
          borderColor = AppTheme.successColor;
          iconData = Icons.phone_android;
          displayText = device.displayName;
        } else if (device.state == model.DeviceState.connecting || 
                   device.state == model.DeviceState.reconnecting) {
          // Connecting
          indicatorColor = AppTheme.warningColor.withValues(alpha: 0.2);
          borderColor = AppTheme.warningColor;
          iconData = Icons.sync;
          displayText = device.stateString;
        } else if (device.state == model.DeviceState.unauthorized) {
          // Unauthorized
          indicatorColor = AppTheme.errorColor.withValues(alpha: 0.2);
          borderColor = AppTheme.errorColor;
          iconData = Icons.lock_outline;
          displayText = 'Unauthorized';
        } else {
          // Disconnected or error
          indicatorColor = AppTheme.backgroundColor.withValues(alpha: 0.5);
          borderColor = AppTheme.errorColor.withValues(alpha: 0.5);
          iconData = Icons.phonelink_off;
          displayText = 'Disconnected';
        }

        return InkWell(
          onTap: () {
            context.read<AppState>().toggleDeviceManager();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  iconData,
                  color: isConnected ? AppTheme.successColor : AppTheme.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  displayText,
                  style: TextStyle(
                    color: isConnected ? AppTheme.successColor : AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (device != null && device.batteryLevel != null && isConnected) ...[
                  const SizedBox(width: 8),
                  Icon(
                    device.isCharging == true ? Icons.battery_charging_full : Icons.battery_std,
                    color: AppTheme.successColor,
                    size: 16,
                  ),
                  Text(
                    '${device.batteryLevel}%',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickSettingsButton(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final isActive = appState.showQuickSettings;
        return _buildTrayIcon(
          context,
          icon: Icons.tune,
          onTap: () => appState.toggleQuickSettings(),
          isActive: isActive,
        );
      },
    );
  }

  Widget _buildNotificationsButton(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final isActive = appState.showNotifications;
        return _buildTrayIcon(
          context,
          icon: Icons.notifications_outlined,
          onTap: () => appState.toggleNotifications(),
          isActive: isActive,
          badge: 0, // TODO: Add notification count
        );
      },
    );
  }

  Widget _buildTrayIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
    int? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
              size: 20,
            ),
            if (badge != null && badge > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badge > 99 ? '99+' : badge.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClock(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm');
        final dateFormat = DateFormat('MMM dd');

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeFormat.format(now),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              dateFormat.format(now),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        );
      },
    );
  }
}

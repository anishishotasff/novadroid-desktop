import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/taskbar.dart';
import '../../state/app_state.dart';
import '../device_manager/device_manager_panel.dart';
import '../settings/settings_panel.dart';
import '../quick_controls/quick_settings_panel.dart';
import '../notifications/notifications_panel.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background wallpaper
          _buildBackground(),
          
          // Main desktop area
          Column(
            children: [
              Expanded(
                child: _buildDesktopArea(context),
              ),
              const Taskbar(),
            ],
          ),
          
          // Overlay panels
          _buildOverlayPanels(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Decorative elements
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
                    AppTheme.primaryColor.withOpacity(0.1),
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
                    AppTheme.secondaryColor.withOpacity(0.1),
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

  Widget _buildDesktopArea(BuildContext context) {
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
            child: const Icon(
              Icons.phone_android,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'NovaDroid Desktop',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Connect your Android device to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AppState>().toggleDeviceManager();
            },
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

  Widget _buildOverlayPanels(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Stack(
          children: [
            // Semi-transparent backdrop
            if (appState.showDeviceManager ||
                appState.showSettings ||
                appState.showQuickSettings ||
                appState.showNotifications)
              GestureDetector(
                onTap: () => appState.closeAll(),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            
            // Device Manager Panel
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
            
            // Settings Panel
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
            
            // Quick Settings Panel
            if (appState.showQuickSettings)
              Positioned(
                bottom: 80,
                right: 20,
                child: const QuickSettingsPanel(),
              ),
            
            // Notifications Panel
            if (appState.showNotifications)
              Positioned(
                bottom: 80,
                right: 20,
                child: const NotificationsPanel(),
              ),
          ],
        );
      },
    );
  }
}

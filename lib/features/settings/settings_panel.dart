import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../state/app_state.dart';
import '../../core/config/app_config.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  int _selectedIndex = 0;

  final List<_SettingsSection> _sections = [
    _SettingsSection(
      icon: Icons.settings_outlined,
      label: 'General',
    ),
    _SettingsSection(
      icon: Icons.cable,
      label: 'Connection',
    ),
    _SettingsSection(
      icon: Icons.screen_share,
      label: 'Mirroring',
    ),
    _SettingsSection(
      icon: Icons.notifications_outlined,
      label: 'Notifications',
    ),
    _SettingsSection(
      icon: Icons.keyboard,
      label: 'Input',
    ),
    _SettingsSection(
      icon: Icons.tune,
      label: 'Advanced',
    ),
    _SettingsSection(
      icon: Icons.info_outline,
      label: 'About',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Text(
            'Settings',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.read<AppState>().closeSettings();
            },
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: AppTheme.backgroundColor.withOpacity(0.5),
      child: ListView.builder(
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final section = _sections[index];
          final isSelected = index == _selectedIndex;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor.withOpacity(0.2)
                    : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    section.icon,
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    section.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: _buildSectionContent(_selectedIndex),
    );
  }

  Widget _buildSectionContent(int index) {
    switch (index) {
      case 0:
        return _buildGeneralSettings();
      case 1:
        return _buildConnectionSettings();
      case 2:
        return _buildMirroringSettings();
      case 3:
        return _buildNotificationSettings();
      case 4:
        return _buildInputSettings();
      case 5:
        return _buildAdvancedSettings();
      case 6:
        return _buildAboutSettings();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        _buildSettingTile(
          'Start with Windows',
          'Launch NovaDroid Desktop when Windows starts',
          Switch(value: false, onChanged: (value) {}),
        ),
        _buildSettingTile(
          'Minimize to tray',
          'Keep app running in system tray when closed',
          Switch(value: true, onChanged: (value) {}),
        ),
        _buildSettingTile(
          'Theme',
          'Choose app appearance',
          DropdownButton<String>(
            value: 'Dark',
            items: ['Dark', 'Light', 'System'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Connection', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        _buildSettingTile(
          'ADB Path',
          'Path to Android Debug Bridge executable',
          TextButton(
            onPressed: () {},
            child: const Text('Browse'),
          ),
        ),
        _buildSettingTile(
          'Connection Timeout',
          'Timeout for device connection attempts (seconds)',
          SizedBox(
            width: 100,
            child: TextField(
              decoration: const InputDecoration(
                hintText: '10',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        _buildSettingTile(
          'Auto Reconnect',
          'Automatically reconnect when connection is lost',
          Switch(value: true, onChanged: (value) {}),
        ),
      ],
    );
  }

  Widget _buildMirroringSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mirroring', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        _buildSettingTile(
          'Max Resolution',
          'Maximum screen resolution',
          SizedBox(
            width: 120,
            child: TextField(
              decoration: InputDecoration(
                hintText: AppConfig.defaultMaxSize.toString(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        _buildSettingTile(
          'Bitrate',
          'Video bitrate (bps)',
          SizedBox(
            width: 150,
            child: TextField(
              decoration: InputDecoration(
                hintText: AppConfig.defaultBitrate.toString(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        _buildSettingTile(
          'Max FPS',
          'Maximum frames per second',
          SizedBox(
            width: 100,
            child: TextField(
              decoration: InputDecoration(
                hintText: AppConfig.defaultMaxFps.toString(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notifications', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        _buildSettingTile(
          'Enable Notifications',
          'Show Android notifications on desktop',
          Switch(value: true, onChanged: (value) {}),
        ),
        _buildSettingTile(
          'Notification Sounds',
          'Play notification sounds',
          Switch(value: false, onChanged: (value) {}),
        ),
      ],
    );
  }

  Widget _buildInputSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Keyboard & Mouse', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        _buildSettingTile(
          'Mouse Sensitivity',
          'Adjust mouse tracking sensitivity',
          Slider(
            value: 0.5,
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Advanced', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        _buildSettingTile(
          'Debug Mode',
          'Enable detailed logging',
          Switch(value: false, onChanged: (value) {}),
        ),
        _buildSettingTile(
          'View Logs',
          'Open log files directory',
          TextButton(
            onPressed: () {},
            child: const Text('Open'),
          ),
        ),
        _buildSettingTile(
          'Reset Configuration',
          'Reset all settings to default',
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Reset'),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                ),
                child: const Icon(
                  Icons.phone_android,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConfig.appName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Version ${AppConfig.appVersion}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Control your Android device from your Windows PC',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(String title, String subtitle, Widget trailing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}

class _SettingsSection {
  final IconData icon;
  final String label;

  _SettingsSection({
    required this.icon,
    required this.label,
  });
}

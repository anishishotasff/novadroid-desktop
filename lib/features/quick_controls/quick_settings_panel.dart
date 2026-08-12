import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../state/app_state.dart';

class QuickSettingsPanel extends StatelessWidget {
  const QuickSettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      constraints: const BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.wifi,
                    label: 'Wi-Fi',
                    isActive: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildQuickAction(
                    context,
                    icon: Icons.bluetooth,
                    label: 'Bluetooth',
                    isActive: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildQuickAction(
                    context,
                    icon: Icons.screen_rotation,
                    label: 'Auto Rotate',
                    isActive: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildQuickAction(
                    context,
                    icon: Icons.do_not_disturb,
                    label: 'Do Not Disturb',
                    isActive: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  _buildSlider(context, 'Brightness', Icons.brightness_6, 0.7),
                  const SizedBox(height: 16),
                  _buildSlider(context, 'Volume', Icons.volume_up, 0.5),
                  const SizedBox(height: 24),
                  _buildActionButton(
                    context,
                    icon: Icons.screenshot,
                    label: 'Screenshot',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context,
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      context.read<AppState>().closeQuickSettings();
                      context.read<AppState>().toggleSettings();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune, color: Colors.white),
          const SizedBox(width: 12),
          Text(
            'Quick Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => context.read<AppState>().closeQuickSettings(),
            icon: const Icon(Icons.close, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppTheme.primaryColor
                : AppTheme.textDisabled.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isActive ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            Switch(
              value: isActive,
              onChanged: (value) => onTap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context, String label, IconData icon, double value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.textSecondary, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: AppTheme.textDisabled.withOpacity(0.2),
              thumbColor: AppTheme.primaryColor,
              overlayColor: AppTheme.primaryColor.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              onChanged: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../state/device_state.dart';
import '../../state/app_state.dart';
import '../../models/device_model.dart' as model;
import '../../services/device_service.dart';
import '../../core/errors/app_exception.dart';

class DeviceManagerPanel extends StatefulWidget {
  const DeviceManagerPanel({super.key});

  @override
  State<DeviceManagerPanel> createState() => _DeviceManagerPanelState();
}

class _DeviceManagerPanelState extends State<DeviceManagerPanel> {
  final _ipController = TextEditingController();
  final _portController = TextEditingController(text: '5555');
  final DeviceService _deviceService = DeviceService.instance;

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

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
            child: _buildContent(context),
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
          const Icon(Icons.devices, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Text(
            'Device Manager',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.read<AppState>().closeDeviceManager();
            },
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<DeviceState>(
      builder: (context, deviceState, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConnectionMethods(context),
              const SizedBox(height: 32),
              _buildAvailableDevices(context, deviceState),
              if (deviceState.errorMessage != null) ...[
                const SizedBox(height: 24),
                _buildErrorMessage(context, deviceState.errorMessage!),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionMethods(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connection Methods',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildConnectionCard(
                context,
                icon: Icons.usb,
                title: 'USB Connection',
                description: 'Connect via USB cable',
                onTap: () {
                  _scanUsbDevices();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildConnectionCard(
                context,
                icon: Icons.wifi,
                title: 'Wireless',
                description: 'Connect over WiFi',
                onTap: () {
                  _showWirelessDialog(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.textDisabled.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableDevices(BuildContext context, DeviceState deviceState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Available Devices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: deviceState.isScanning ? null : _scanUsbDevices,
              icon: deviceState.isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(deviceState.isScanning ? 'Scanning...' : 'Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (deviceState.availableDevices.isEmpty && !deviceState.isScanning)
          _buildEmptyState(context)
        else
          ...deviceState.availableDevices.map((device) => _buildDeviceCard(context, device)),
      ],
    );
  }

  Widget _buildDeviceCard(BuildContext context, model.DeviceModel device) {
    final isConnected = device.isConnected;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected
              ? AppTheme.successColor
              : AppTheme.textDisabled.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppTheme.successColor.withOpacity(0.2)
                  : AppTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.phone_android,
              color: isConnected ? AppTheme.successColor : AppTheme.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.displayName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${device.connectionTypeString} • ${device.stateString}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (device.model != null || device.androidVersion != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      [device.model, device.androidVersion]
                          .where((e) => e != null)
                          .join(' • '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textDisabled,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: isConnected ? () => _disconnectDevice(device) : () => _connectDevice(device),
            style: ElevatedButton.styleFrom(
              backgroundColor: isConnected ? AppTheme.errorColor : AppTheme.primaryColor,
            ),
            child: Text(isConnected ? 'Disconnect' : 'Connect'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.devices_other,
              size: 64,
              color: AppTheme.textDisabled,
            ),
            const SizedBox(height: 16),
            Text(
              'No devices found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect a device via USB or wireless',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorColor, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<DeviceState>().clearError();
            },
            icon: const Icon(Icons.close, color: AppTheme.errorColor, size: 20),
          ),
        ],
      ),
    );
  }

  void _showWirelessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Wireless Connection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'IP Address',
                hintText: '192.168.1.100',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '5555',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _connectWireless();
              Navigator.pop(context);
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _scanUsbDevices() async {
    final deviceState = context.read<DeviceState>();
    deviceState.setScanning(true);
    deviceState.clearError();
    
    try {
      final devices = await _deviceService.scanDevices();
      if (mounted) {
        deviceState.setAvailableDevices(devices);
        deviceState.setScanning(false);
      }
    } catch (e) {
      if (mounted) {
        deviceState.setScanning(false);
        deviceState.setError(_getErrorMessage(e));
      }
    }
  }

  void _connectWireless() async {
    final ip = _ipController.text.trim();
    final port = int.tryParse(_portController.text) ?? 5555;
    
    if (ip.isEmpty) {
      context.read<DeviceState>().setError('Please enter an IP address');
      return;
    }
    
    final deviceState = context.read<DeviceState>();
    deviceState.setScanning(true);
    deviceState.clearError();
    
    try {
      final device = await _deviceService.connectWireless(ip, port);
      if (mounted) {
        deviceState.setCurrentDevice(device);
        deviceState.setScanning(false);
        context.read<AppState>().closeDeviceManager();
      }
    } catch (e) {
      if (mounted) {
        deviceState.setScanning(false);
        deviceState.setError(_getErrorMessage(e));
      }
    }
  }

  void _connectDevice(model.DeviceModel device) async {
    final deviceState = context.read<DeviceState>();
    deviceState.clearError();
    
    try {
      final connectedDevice = await _deviceService.connectToDevice(device);
      if (mounted) {
        deviceState.setCurrentDevice(connectedDevice);
        context.read<AppState>().closeDeviceManager();
      }
    } catch (e) {
      if (mounted) {
        deviceState.setError(_getErrorMessage(e));
      }
    }
  }

  void _disconnectDevice(model.DeviceModel device) async {
    final deviceState = context.read<DeviceState>();
    
    try {
      await _deviceService.disconnectFromDevice(device);
      if (mounted) {
        deviceState.disconnect();
      }
    } catch (e) {
      if (mounted) {
        deviceState.setError(_getErrorMessage(e));
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.toDetailedString();
    }
    return error.toString();
  }
}

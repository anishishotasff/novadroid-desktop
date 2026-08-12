import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'state/device_state.dart';
import 'features/desktop/desktop_screen.dart';
import 'core/logging/app_logger.dart';
import 'core/config/app_config.dart';
import 'services/device_service.dart';
import 'core/errors/app_exception.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  await AppLogger.getInstance();
  AppLogger.info('Starting ${AppConfig.appName}');

  // Initialize window manager for Windows
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(1024, 600),
      center: true,
      backgroundColor: Color(0xFF0F172A),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: AppConfig.appName,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(true);
      await Future.delayed(const Duration(milliseconds: 100));
      await windowManager.setAlwaysOnTop(false);
    });
  }

  runApp(const NovaDroidApp());
}

class NovaDroidApp extends StatelessWidget {
  const NovaDroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => DeviceState()),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const InitializationScreen(),
      ),
    );
  }
}

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to run after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final appState = context.read<AppState>();
    
    try {
      appState.setInitializing(true, 'Initializing application...');
      await Future.delayed(const Duration(milliseconds: 500));

      appState.setInitializationStage('Checking ADB...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      try {
        await DeviceService.instance.initialize();
        AppLogger.info('ADB initialized successfully');
      } catch (e) {
        if (e is AdbException) {
          throw e;
        }
        throw AdbException(
          message: 'Failed to initialize ADB',
          details: e.toString(),
          suggestedFix: 'Please install Android Platform Tools and ensure ADB is in your system PATH.',
        );
      }

      appState.setInitializationStage('Starting services...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Start device scanning
      DeviceService.instance.startDeviceScan();

      appState.setInitializationStage('Ready!');
      await Future.delayed(const Duration(milliseconds: 500));

      appState.setInitialized(true);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DesktopScreen()),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Initialization failed', e, stackTrace);
      appState.setInitializing(false);
      
      if (mounted) {
        _showErrorDialog(e);
      }
    }
  }

  void _showErrorDialog(dynamic error) {
    String message = error.toString();
    String? details;
    String? suggestedFix;

    if (error is AppException) {
      message = error.message;
      details = error.details;
      suggestedFix = error.suggestedFix;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppTheme.errorColor),
            SizedBox(width: 12),
            Text('Initialization Failed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
            if (details != null) ...[
              const SizedBox(height: 16),
              Text(
                'Details:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                details,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (suggestedFix != null) ...[
              const SizedBox(height: 16),
              Text(
                'Suggested Fix:',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.successColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                suggestedFix,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initialize();
            },
            child: const Text('Retry'),
          ),
          ElevatedButton(
            onPressed: () {
              exit(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Center(
          child: Consumer<AppState>(
            builder: (context, appState, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                      boxShadow: AppTheme.elevatedShadow,
                    ),
                    child: const Icon(
                      Icons.phone_android,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    AppConfig.appName,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        const LinearProgressIndicator(
                          backgroundColor: AppTheme.surfaceColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          appState.initializationStage,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/adb_service.dart';
import '../../theme/app_theme.dart';
import '../../core/logging/app_logger.dart';

/// Represents a single installed app fetched from the phone.
class _AppInfo {
  final String packageName;
  final String label;

  const _AppInfo({required this.packageName, required this.label});
}

/// Full Android-like launcher showing user-installed apps from a connected device.
class AndroidLauncher extends StatefulWidget {
  final String deviceId;

  const AndroidLauncher({super.key, required this.deviceId});

  @override
  State<AndroidLauncher> createState() => _AndroidLauncherState();
}

class _AndroidLauncherState extends State<AndroidLauncher> {
  final AdbService _adb = AdbService.instance;
  final TextEditingController _searchController = TextEditingController();

  List<_AppInfo> _apps = [];
  List<_AppInfo> _filteredApps = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchApps();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredApps = query.isEmpty
          ? List.of(_apps)
          : _apps
              .where((a) =>
                  a.label.toLowerCase().contains(query) ||
                  a.packageName.toLowerCase().contains(query))
              .toList();
    });
  }

  Future<void> _fetchApps() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final packages = await _adb.getUserPackages(widget.deviceId);
      AppLogger.info('Fetched ${packages.length} packages from ${widget.deviceId}');

      // Resolve labels concurrently in small batches to avoid overloading adb
      final apps = <_AppInfo>[];
      const batchSize = 10;
      for (var i = 0; i < packages.length; i += batchSize) {
        final batch = packages.skip(i).take(batchSize).toList();
        final labels = await Future.wait(
          batch.map((pkg) => _adb.getAppLabel(widget.deviceId, pkg)),
        );
        for (var j = 0; j < batch.length; j++) {
          apps.add(_AppInfo(packageName: batch[j], label: labels[j]));
        }
        // Update UI incrementally
        if (mounted) {
          setState(() {
            _apps = List.of(apps);
            _filteredApps = List.of(apps);
          });
        }
      }

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Failed to fetch apps', e);
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildStatusRow(),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search apps...',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white70, size: 18),
                onPressed: () => _searchController.clear(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    String label;
    if (_loading && _apps.isEmpty) {
      label = 'Loading apps...';
    } else if (_error != null) {
      label = 'Error loading apps';
    } else {
      label = '${_filteredApps.length} app${_filteredApps.length != 1 ? 's' : ''}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Row(
        children: [
          if (_loading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white70,
              ),
            ),
          if (_loading) const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          if (!_loading)
            TextButton.icon(
              onPressed: _fetchApps,
              icon: const Icon(Icons.refresh, size: 14, color: Colors.white54),
              label: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _apps.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white70),
            SizedBox(height: 16),
            Text(
              'Fetching apps from your phone...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_error != null && _apps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              'Could not load apps',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetchApps,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredApps.isEmpty) {
      return const Center(
        child: Text(
          'No apps found',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredApps.length,
      itemBuilder: (context, index) => _buildAppTile(_filteredApps[index]),
    );
  }

  Widget _buildAppTile(_AppInfo app) {
    final gradient = _gradientForPackage(app.packageName);

    return GestureDetector(
      onTap: () => _launchApp(app),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: gradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                app.label.isNotEmpty ? app.label[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            app.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchApp(_AppInfo app) async {
    try {
      await _adb.launchApp(widget.deviceId, app.packageName);
    } catch (e) {
      AppLogger.warning('Failed to launch ${app.packageName}: $e');
      if (mounted) {
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

  /// Deterministic gradient based on the package name hash.
  LinearGradient _gradientForPackage(String packageName) {
    final hash = packageName.codeUnits.fold(0, (prev, e) => prev + e);
    final gradients = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // indigo→purple
      [const Color(0xFF06B6D4), const Color(0xFF3B82F6)], // cyan→blue
      [const Color(0xFF10B981), const Color(0xFF059669)], // green shades
      [const Color(0xFFF59E0B), const Color(0xFFEF4444)], // amber→red
      [const Color(0xFFEC4899), const Color(0xFF8B5CF6)], // pink→purple
      [const Color(0xFF14B8A6), const Color(0xFF06B6D4)], // teal→cyan
      [const Color(0xFFF97316), const Color(0xFFFBBF24)], // orange→yellow
      [const Color(0xFF6366F1), const Color(0xFF06B6D4)], // indigo→cyan
    ];
    final pair = gradients[hash % gradients.length];
    return LinearGradient(
      colors: pair,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

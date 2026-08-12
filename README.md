# NovaDroid Desktop

**Control your Android device from your Windows PC**

NovaDroid Desktop is a modern desktop application that allows you to connect an Android phone to a Windows PC and use it through a polished desktop-style interface with real-time screen mirroring, app launching, and device control.

## Features

### ✅ Phase 1 - Complete
- ✅ Modern desktop UI with dark theme
- ✅ Full-screen desktop environment
- ✅ Bottom taskbar with system tray
- ✅ Device Manager panel
- ✅ Settings panel with multiple sections
- ✅ Quick Settings panel
- ✅ Notifications panel
- ✅ State management with Provider
- ✅ Professional theme with Google Fonts
- ✅ Smooth animations
- ✅ Error handling framework
- ✅ Logging system

### 🚧 Upcoming Phases
- Phase 2: ADB integration, USB/Wireless device connection
- Phase 3: Screen mirroring with scrcpy
- Phase 4: Android app launcher and window management
- Phase 5: Notifications, media controls, clipboard sync
- Phase 6: Screenshots, file transfer, advanced features
- Phase 7: Performance optimization and packaging

## Requirements

### System Requirements
- Windows 10/11 (64-bit)
- 4GB RAM minimum (8GB recommended)
- 500MB free disk space
- USB port (for USB connection) or WiFi (for wireless connection)

### Development Requirements
- Flutter SDK 3.44.0 or higher
- Dart SDK 3.12.0 or higher
- Visual Studio 2022 with C++ desktop development workload
- Android SDK Platform Tools (ADB)
- **Windows Developer Mode enabled** (required for symlink support)

## Setup Instructions

### 1. Enable Windows Developer Mode

NovaDroid Desktop requires Developer Mode for plugin symlink support:

1. Open Windows Settings
2. Go to "Privacy & Security" → "For developers"
3. Enable "Developer Mode"
4. Restart your computer if prompted

Alternatively, run this command:
```cmd
start ms-settings:developers
```

### 2. Install Flutter

1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract to a location (e.g., `C:\flutter`)
3. Add Flutter to your PATH:
   ```cmd
   setx PATH "%PATH%;C:\flutter\bin"
   ```
4. Verify installation:
   ```cmd
   flutter doctor
   ```

### 3. Install Android Platform Tools

1. Download from https://developer.android.com/studio/releases/platform-tools
2. Extract to `C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools\`
3. Or install Android Studio which includes ADB

### 4. Install Dependencies

```cmd
cd novadroid_desktop
flutter pub get
```

### 5. Run the Application

```cmd
flutter run -d windows
```

### 6. Build Release Version

```cmd
flutter build windows --release
```

The built application will be in:
```
novadroid_desktop\build\windows\x64\runner\Release\
```

## Project Structure

```
novadroid_desktop/
├── lib/
│   ├── core/
│   │   ├── adb/              # ADB integration (Phase 2)
│   │   ├── config/           # App configuration
│   │   ├── errors/           # Exception classes
│   │   ├── logging/          # Logging system
│   │   └── networking/       # Network utilities (Phase 2+)
│   ├── features/
│   │   ├── desktop/          # Desktop environment UI
│   │   ├── device_manager/   # Device connection manager
│   │   ├── settings/         # Settings panel
│   │   ├── quick_controls/   # Quick settings panel
│   │   ├── notifications/    # Notifications panel
│   │   ├── launcher/         # App launcher (Phase 4)
│   │   ├── mirroring/        # Screen mirroring (Phase 3)
│   │   ├── windows/          # Window management (Phase 4)
│   │   ├── media/            # Media controls (Phase 5)
│   │   ├── clipboard/        # Clipboard sync (Phase 5)
│   │   └── screenshots/      # Screenshot manager (Phase 6)
│   ├── models/               # Data models
│   ├── services/             # Business logic services
│   ├── state/                # State management
│   ├── theme/                # Theme and styling
│   ├── widgets/              # Reusable widgets
│   └── main.dart             # Application entry point
├── windows/                  # Windows-specific configuration
├── assets/                   # Images, icons, wallpapers
└── pubspec.yaml             # Dependencies
```

## Architecture

### State Management
- **Provider** for reactive state management
- **AppState**: Global application state
- **DeviceState**: Device connection and management

### Core Components
1. **Desktop Screen**: Main desktop environment
2. **Taskbar**: Bottom taskbar with system tray
3. **Device Manager**: Device discovery and connection
4. **Settings**: Application configuration
5. **Quick Settings**: Quick access controls
6. **Notifications**: Notification center

### Device States
- `NoDevice`: No device detected
- `Detecting`: Scanning for devices
- `Connecting`: Establishing connection
- `Unauthorized`: Device needs authorization
- `Connected`: Successfully connected
- `Reconnecting`: Attempting reconnection
- `Disconnected`: Device disconnected
- `Error`: Connection error

## Configuration

### Default Settings
- ADB Path: Auto-detected from Android SDK
- Connection Timeout: 10 seconds
- Auto Reconnect: Enabled
- Max Resolution: 1920px
- Bitrate: 8 Mbps
- Max FPS: 60

### Customization
All settings can be modified through the Settings panel:
1. Click the gear icon in the taskbar
2. Navigate through different sections
3. Adjust settings as needed

## Troubleshooting

### ADB Not Found
If ADB is not detected:
1. Install Android Platform Tools
2. Add ADB to system PATH
3. Or manually set ADB path in Settings → Connection

### Device Not Detected
1. Enable USB Debugging on your Android device:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go to Settings → Developer Options
   - Enable "USB Debugging"
2. Connect via USB cable
3. Accept the authorization dialog on your phone

### Wireless Connection Issues
1. Ensure device and PC are on the same WiFi network
2. Enable "Wireless Debugging" on Android 11+
3. Use the IP address shown in Wireless Debugging settings

### Build Errors
If you see "Building with plugins requires symlink support":
1. Enable Windows Developer Mode (see Setup Instructions)
2. Restart your computer
3. Try building again

## Development

### Adding New Features
1. Create feature folder in `lib/features/`
2. Implement UI components
3. Add service logic in `lib/services/`
4. Update state management if needed
5. Test thoroughly

### Code Style
- Follow Dart conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small
- Use const constructors where possible

### Testing
```cmd
flutter test
```

### Analyzing Code
```cmd
flutter analyze
```

## Roadmap

### Phase 2: Device Connection (Next)
- [ ] Real ADB detection and initialization
- [ ] USB device discovery
- [ ] Wireless ADB connection
- [ ] Device authorization handling
- [ ] Connection state management
- [ ] Error handling for common ADB issues

### Phase 3: Screen Mirroring
- [ ] scrcpy integration
- [ ] Real-time screen capture
- [ ] Mouse and keyboard input
- [ ] Touch gesture mapping
- [ ] Screen rotation support

### Phase 4: App Management
- [ ] Fetch installed apps list
- [ ] App icons extraction
- [ ] Launch Android apps
- [ ] Multi-window system
- [ ] Window controls (minimize, maximize, close)

### Phase 5: Advanced Features
- [ ] Android notification bridge
- [ ] Media player controls
- [ ] Clipboard synchronization
- [ ] Screenshot capture

### Phase 6: File & Polish
- [ ] File transfer (PC ↔ Android)
- [ ] Drag-and-drop support
- [ ] Performance optimization
- [ ] Installer creation

### Phase 7: Cross-Platform
- [ ] macOS support
- [ ] Linux support

## Contributing

This is an independent implementation inspired by Android desktop control functionality. Contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is an independent implementation. Check LICENSE file for details.

## Credits

- Flutter Team for the amazing framework
- Google Fonts for typography
- Material Design for UI guidelines
- scrcpy project for Android screen mirroring inspiration

## Support

For issues, questions, or feature requests, please create an issue in the repository.

---

**Note**: This application requires proper USB debugging and wireless debugging permissions on your Android device. Never use this application without the device owner's explicit consent.

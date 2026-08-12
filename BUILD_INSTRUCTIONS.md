# NovaDroid Desktop - Build Instructions

## Complete Build Guide for Windows

### Prerequisites Checklist

#### 1. Windows Developer Mode (REQUIRED)
- [ ] Open Windows Settings
- [ ] Navigate to "Privacy & Security" → "For developers"
- [ ] Enable "Developer Mode"  
- [ ] Restart your PC
- [ ] Verify by running: `whoami /priv | findstr SeCreateSymbolicLinkPrivilege`

#### 2. Flutter SDK
- [ ] Download Flutter 3.44+ from https://flutter.dev
- [ ] Extract to `C:\flutter`
- [ ] Add to PATH: `C:\flutter\bin`
- [ ] Run `flutter doctor` to verify

#### 3. Visual Studio Build Tools
- [ ] Install Visual Studio 2022 (Community Edition is fine)
- [ ] During install, select "Desktop development with C++"
- [ ] Include: MSVC, Windows SDK, CMake tools

#### 4. Android Platform Tools
- [ ] Download from https://developer.android.com/studio/releases/platform-tools
- [ ] Extract to `C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools\`
- [ ] Add to PATH or the app will auto-detect it

### Build Steps

#### Step 1: Clone/Download Project
```cmd
cd E:\android dexxx
cd novadroid_desktop
```

#### Step 2: Install Dependencies
```cmd
flutter pub get
```

Expected output:
```
Resolving dependencies...
Got dependencies!
```

#### Step 3: Verify Setup
```cmd
flutter doctor -v
```

Check that all items have ✓ marks:
- [✓] Flutter
- [✓] Windows Version
- [✓] Visual Studio
- [✓] Connected device (Windows)

#### Step 4: Run in Debug Mode
```cmd
flutter run -d windows
```

This will:
1. Build the application
2. Launch the window
3. Show the initialization screen
4. Detect ADB
5. Open the desktop interface

#### Step 5: Build Release Version
```cmd
flutter build windows --release
```

Output location:
```
novadroid_desktop\build\windows\x64\runner\Release\
```

Files created:
- `novadroid_desktop.exe` - Main executable
- `flutter_windows.dll` - Flutter engine
- `data\` - App resources
- Other DLL dependencies

### Running the Application

#### From Debug Build
```cmd
flutter run -d windows
```

#### From Release Build
```cmd
cd build\windows\x64\runner\Release
novadroid_desktop.exe
```

### First Run Experience

When you launch NovaDroid Desktop for the first time:

1. **Initialization Screen**
   - Shows NovaDroid logo
   - Displays initialization progress
   - Checks for ADB

2. **If ADB is Found**
   - Starts ADB server
   - Proceeds to desktop

3. **If ADB is Not Found**
   - Shows error dialog with:
     - Error message
     - Details about what's missing
     - Suggested fix

4. **Desktop Screen**
   - Background with gradients
   - Taskbar at bottom
   - "Connect Device" button in center

### Connecting Your Android Device

#### Method 1: USB Connection

1. **On Android Device:**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times to enable Developer Options
   - Go to Settings → Developer Options
   - Enable "USB Debugging"

2. **Connect to PC:**
   - Connect device via USB cable
   - Accept "Allow USB debugging?" dialog on phone

3. **In NovaDroid Desktop:**
   - Click "Connect Device" or device icon in taskbar
   - Click "USB Connection"
   - Your device should appear in the list
   - Click "Connect"

#### Method 2: Wireless Connection (Android 11+)

1. **On Android Device:**
   - Go to Settings → Developer Options
   - Enable "Wireless debugging"
   - Tap "Wireless debugging" to see IP and Port
   - Note the IP address and port (e.g., `192.168.1.100:35807`)

2. **In NovaDroid Desktop:**
   - Click "Connect Device"
   - Click "Wireless"
   - Enter IP address: `192.168.1.100`
   - Enter Port: `35807`
   - Click "Connect"

### Troubleshooting

#### "Building with plugins requires symlink support"
**Solution:** Enable Windows Developer Mode (see Prerequisites)

#### "ADB not found"
**Solutions:**
1. Install Android Platform Tools
2. Add ADB to system PATH:
   ```cmd
   setx PATH "%PATH%;C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools"
   ```
3. Or manually set path in Settings

#### "Device unauthorized"
**Solution:** Accept USB debugging authorization on your Android device

#### "Flutter doctor shows issues"
**Solution:** Run suggested fixes:
```cmd
flutter doctor --android-licenses
```

#### Build fails with MSBuild errors
**Solution:**
1. Ensure Visual Studio 2022 is installed
2. Verify C++ desktop development workload is installed
3. Run from "Developer Command Prompt for VS 2022"

#### App crashes on startup
**Solution:**
1. Check logs in: `%APPDATA%\novadroid_desktop\logs\`
2. Verify ADB is accessible: `adb version`
3. Try running from terminal to see error messages

### Creating Installer (Optional)

To create an installer for distribution:

1. Install Inno Setup: https://jrsoftware.org/isdl.php

2. Create installer script `installer.iss`:
```iss
[Setup]
AppName=NovaDroid Desktop
AppVersion=1.0.0
DefaultDirName={pf}\NovaDroid Desktop
DefaultGroupName=NovaDroid Desktop
OutputDir=installer
OutputBaseFilename=NovaDroid_Desktop_Setup

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\NovaDroid Desktop"; Filename: "{app}\novadroid_desktop.exe"
Name: "{userdesktop}\NovaDroid Desktop"; Filename: "{app}\novadroid_desktop.exe"
```

3. Compile:
```cmd
iscc installer.iss
```

### Development Mode

For development with hot reload:

```cmd
flutter run -d windows
```

Then press:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit
- `h` - Help

### Performance Profiling

```cmd
flutter run --profile -d windows
```

### Project Structure Quick Reference

```
novadroid_desktop/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── core/
│   │   ├── adb/                     # ADB integration
│   │   ├── config/app_config.dart   # Configuration
│   │   ├── errors/                  # Exceptions
│   │   └── logging/app_logger.dart  # Logging
│   ├── services/
│   │   ├── adb_service.dart         # ADB commands
│   │   └── device_service.dart      # Device management
│   ├── features/
│   │   ├── desktop/                 # Main desktop UI
│   │   ├── device_manager/          # Device connection
│   │   └── settings/                # Settings panel
│   ├── state/                       # State management
│   └── theme/                       # Theme configuration
└── build/                           # Build output
```

### Current Implementation Status

**Phase 1: Desktop UI** ✅ Complete
- Modern desktop interface
- Taskbar with system tray
- Device Manager
- Settings panel
- Quick Settings
- Notifications panel

**Phase 2: ADB Integration** ✅ Complete
- ADB detection and initialization
- USB device scanning
- Wireless device connection
- Device information fetching
- Battery level monitoring
- Connection state management

**Phase 3: Screen Mirroring** 🚧 Next
- scrcpy integration
- Real-time mirroring

**Phase 4-7** 📋 Planned

### Next Steps

After successful build:

1. Test USB device connection
2. Test wireless connection  
3. Verify device information display
4. Check error handling
5. Review logs for issues

### Support

For issues during build:
1. Check logs in `%APPDATA%\novadroid_desktop\logs\`
2. Run `flutter doctor -v` and share output
3. Check GitHub issues or create new one

### License

See LICENSE file for details.

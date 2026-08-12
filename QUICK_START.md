# NovaDroid Desktop - Quick Start Guide

## What is NovaDroid Desktop?

NovaDroid Desktop is a modern Windows application that lets you control your Android phone from your PC through a beautiful desktop-style interface. Think of it as running your Android device in a window on your computer!

## Features

- 🖥️ **Modern Desktop UI** - Beautiful dark theme with smooth animations
- 📱 **Device Connection** - Connect via USB or WiFi
- ⚡ **Real-time Updates** - See battery level, connection status
- 🎨 **Glassmorphism Design** - Modern, polished interface
- ⚙️ **Comprehensive Settings** - Customize everything
- 🔔 **Notifications** - (Coming soon) See Android notifications on PC
- 🖼️ **Screen Mirroring** - (Coming soon) See and control your phone screen

## System Requirements

- Windows 10/11 (64-bit)
- 4GB RAM (8GB recommended)
- 500MB disk space
- Android device with USB debugging enabled

## Installation

### Option 1: Quick Install (Recommended)

1. **Enable Developer Mode**
   ```cmd
   start ms-settings:developers
   ```
   Toggle "Developer Mode" to ON

2. **Download & Extract**
   - Extract the novadroid_desktop folder
   - No installation needed!

3. **Run**
   ```cmd
   cd novadroid_desktop
   flutter run -d windows
   ```

### Option 2: Build from Source

See [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) for detailed steps.

## First-Time Setup

### Step 1: Enable Android USB Debugging

1. On your Android phone:
   - Go to **Settings** → **About Phone**
   - Tap **Build Number** 7 times
   - Go back to **Settings** → **Developer Options**
   - Enable **USB Debugging**

### Step 2: Connect Your Device

**USB Connection (Easiest):**
1. Connect phone to PC with USB cable
2. Accept "Allow USB debugging?" on phone
3. Launch NovaDroid Desktop
4. Click "Connect Device" button
5. Select your device and click "Connect"

**Wireless Connection (Android 11+):**
1. Connect phone and PC to same WiFi
2. On phone: **Settings** → **Developer Options** → **Wireless debugging**
3. Note the IP and Port shown
4. In NovaDroid Desktop: Click "Connect Device" → "Wireless"
5. Enter IP and Port → Click "Connect"

## Using NovaDroid Desktop

### Main Interface

```
┌─────────────────────────────────────────┐
│                                         │
│     NovaDroid Desktop                   │
│     [Connect Device Button]             │
│                                         │
├─────────────────────────────────────────┤
│ [Apps] [Search...] │ [📱Device] [⚙️] [🔔] [🕐] │
└─────────────────────────────────────────┘
```

### Taskbar Controls

- **Apps Button** (Left) - Opens app launcher (Coming soon)
- **Search Box** - Search for Android apps (Coming soon)
- **Device Indicator** (Right) - Shows connection status, click to manage devices
- **Quick Settings** (⚙️) - Quick access to device controls
- **Notifications** (🔔) - Android notifications (Coming soon)
- **Clock** - Current time and date

### Device Manager

Access by clicking the device indicator or "Connect Device" button.

**Features:**
- View all connected devices
- Connect/disconnect devices
- See device info (model, Android version, battery)
- Add wireless devices

### Quick Settings

Click the gear icon (⚙️) in taskbar for quick access to:
- WiFi toggle (Coming soon)
- Bluetooth toggle (Coming soon)
- Screen rotation
- Do Not Disturb
- Brightness slider (Coming soon)
- Volume slider (Coming soon)
- Screenshot button (Coming soon)

### Settings

Click Settings in Quick Settings panel for full configuration:

- **General**
  - Start with Windows
  - Minimize to tray
  - Theme

- **Connection**
  - ADB path
  - Connection timeout
  - Auto reconnect

- **Mirroring** (Coming soon)
  - Resolution
  - Bitrate
  - FPS

## Troubleshooting

### "ADB not found"
**Fix:** Install Android Platform Tools
```cmd
# Download from:
# https://developer.android.com/studio/releases/platform-tools
# Extract to C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools\
```

### "Device unauthorized"
**Fix:** Check your phone for USB debugging authorization dialog and tap "Allow"

### "Building with plugins requires symlink support"
**Fix:** Enable Windows Developer Mode
```cmd
start ms-settings:developers
```

### Device not showing up
**Fixes:**
1. Ensure USB debugging is enabled
2. Try a different USB cable
3. Try a different USB port
4. Click "Refresh" in Device Manager
5. Restart ADB:
   ```cmd
   adb kill-server
   adb start-server
   ```

### App won't start
**Fix:** Check logs at:
```
%APPDATA%\novadroid_desktop\logs\
```

## Keyboard Shortcuts

*Coming in future versions*

- `Ctrl+D` - Open Device Manager
- `Ctrl+,` - Open Settings
- `Ctrl+Q` - Quit
- `Ctrl+F` - Search apps

## Tips & Tricks

1. **Faster Connection:** Keep your device plugged in - it will auto-connect
2. **Wireless is Slower:** USB provides better performance
3. **Check Battery:** Device indicator shows battery level when connected
4. **Multiple Devices:** You can connect multiple devices simultaneously (Coming soon)

## What's Working Now (Phase 1 & 2)

✅ Beautiful desktop interface
✅ Device connection (USB & Wireless)
✅ Device information display
✅ Battery monitoring
✅ Settings management
✅ Modern UI with animations

## Coming Soon

### Phase 3 (Next)
- 🔄 Screen mirroring
- 🖱️ Mouse control
- ⌨️ Keyboard input

### Phase 4
- 📱 App launcher
- 🪟 Window management
- 📲 App launching

### Phase 5
- 🔔 Notifications bridge
- 🎵 Media controls
- 📋 Clipboard sync
- 📸 Screenshots

### Phase 6
- 📁 File transfer
- 🎨 UI polish
- ⚡ Performance optimization

## Support

**Documentation:**
- [README.md](README.md) - Full documentation
- [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) - Build from source
- [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) - Development status

**Getting Help:**
1. Check troubleshooting section above
2. Review logs in `%APPDATA%\novadroid_desktop\logs\`
3. Check [GitHub Issues](https://github.com/your-repo/issues)
4. Create new issue with:
   - Your Windows version
   - Flutter/Dart version
   - Error messages
   - Log files

## Contributing

Want to help build NovaDroid Desktop?

1. Read [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)
2. Pick a feature from Phase 3+
3. Follow the existing code structure
4. Submit a pull request

## Safety & Privacy

⚠️ **Important:**
- Only connect devices you own
- USB debugging gives full device access
- NovaDroid Desktop does not collect any data
- All communication is local (PC ↔ Phone)
- No internet connection required

## License

This is an independent implementation inspired by Android desktop control functionality. See LICENSE file for details.

---

**Version:** 1.0.0  
**Status:** Phase 2 Complete  
**Platform:** Windows 10/11  
**Last Updated:** August 12, 2026

---

Enjoy controlling your Android device from your PC! 🚀📱

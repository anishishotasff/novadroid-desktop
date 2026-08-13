<div align="center">

# 🤖 NovaDroid Desktop

### Control your Android device from your Windows PC

[![Version](https://img.shields.io/badge/version-1.0.0-6366f1?style=for-the-badge)](https://github.com/anishishotasff/novadroid-desktop/releases)
[![Platform](https://img.shields.io/badge/Windows-10%2F11-0078d4?style=for-the-badge&logo=windows)](https://github.com/anishishotasff/novadroid-desktop/releases)
[![Flutter](https://img.shields.io/badge/Flutter-3.44.0-54c5f8?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-10b981?style=for-the-badge)](LICENSE.txt)
[![GitHub Stars](https://img.shields.io/github/stars/anishishotasff/novadroid-desktop?style=for-the-badge&color=f59e0b)](https://github.com/anishishotasff/novadroid-desktop/stargazers)

<br/>

**NovaDroid Desktop** is a modern Windows application that lets you connect your Android phone to your PC and control it through a beautiful desktop-style interface — wirelessly or via USB.

<br/>

[⬇️ Download Now](#-download) • [🚀 Quick Start](#-quick-start) • [✨ Features](#-features) • [🛠️ Build from Source](#️-build-from-source) • [🤝 Contributing](#-contributing)

</div>

---

## ✨ Features

### 🖥️ Modern Desktop Interface
- Beautiful **dark theme** with glassmorphism effects
- Smooth animations and hover effects
- **Bottom taskbar** with system tray
- Live **clock & date**
- Professional typography with Google Fonts

### 📱 Device Connection
| Feature | USB | WiFi |
|---------|-----|------|
| Auto device detection | ✅ | ✅ |
| Manual connect | ✅ | ✅ |
| Battery monitoring | ✅ | ✅ |
| Multiple devices | ✅ | ✅ |
| Auto reconnect | ✅ | ✅ |

### 🔌 Connection States
```
NO DEVICE  →  DETECTING  →  CONNECTING  →  CONNECTED
                                        ↘  UNAUTHORIZED
                                        ↘  ERROR
```

### ⚙️ Settings Panel
- **General** — startup, tray, theme
- **Connection** — ADB path, timeout, reconnect
- **Mirroring** — resolution, bitrate, FPS (Phase 3)
- **Notifications** — enable/disable
- **Advanced** — debug mode, logs, reset

### 🎛️ Quick Controls
- WiFi / Bluetooth toggles
- Brightness & Volume sliders
- Screen rotation
- Do Not Disturb
- Screenshot (Phase 3)

---

## 📸 Screenshots

> *Screenshots coming soon — Phase 1 UI is complete and running!*

---

## ⬇️ Download

### 🟢 Latest Release — v1.0.0

| File | Size | Description |
|------|------|-------------|
| [`NovaDroid_Desktop_v1.0.0_Portable.zip`](https://github.com/anishishotasff/novadroid-desktop/releases/latest) | ~12 MB | ✅ No install needed — just extract & run |

> **No Flutter required!** The portable version includes everything you need.

---

## 🚀 Quick Start

### Step 1 — Enable USB Debugging on your Android phone

```
Settings → About Phone → Tap "Build Number" 7 times
Settings → Developer Options → Enable "USB Debugging"
```

### Step 2 — Download & Run

1. Download `NovaDroid_Desktop_v1.0.0_Portable.zip`
2. Extract to any folder
3. Run `novadroid_desktop.exe`

### Step 3 — Connect your device

**Via USB:**
- Plug in your USB cable
- Accept the "Allow USB debugging?" dialog on your phone
- Your device appears in NovaDroid automatically ✅

**Via WiFi (Android 11+):**
```
Settings → Developer Options → Wireless Debugging → Note the IP and Port
```
Then in NovaDroid:
- Click device indicator in taskbar → **Connect Device** → **Wireless**
- Enter the IP address and port
- Click **Connect** ✅

---

## 💻 System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| OS | Windows 10 64-bit | Windows 11 64-bit |
| RAM | 4 GB | 8 GB |
| Disk Space | 100 MB | 500 MB |
| Android | 6.0+ | 11.0+ |
| USB Debugging | Required | Required |

---

## 🗺️ Roadmap

| Phase | Feature | Status |
|-------|---------|--------|
| **Phase 1** | Desktop UI, Taskbar, Settings, Device Manager | ✅ **Complete** |
| **Phase 2** | ADB integration, USB & WiFi connection, Battery | ✅ **Complete** |
| **Phase 3** | Screen mirroring, Mouse & keyboard input | 🔄 In Progress |
| **Phase 4** | Android app launcher, Window management | 📋 Planned |
| **Phase 5** | Notifications, Media controls, Clipboard sync | 📋 Planned |
| **Phase 6** | File transfer, Screenshots, Performance | 📋 Planned |
| **Phase 7** | macOS & Linux support | 📋 Planned |

---

## 🛠️ Build from Source

### Prerequisites

- [Flutter SDK 3.44.0+](https://flutter.dev/docs/get-started/install/windows)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) with **C++ Desktop Development** workload
- [Android Platform Tools (ADB)](https://developer.android.com/studio/releases/platform-tools)
- Windows 10/11 with **Developer Mode enabled**

### Enable Developer Mode

```
Windows Settings → Privacy & Security → For Developers → Developer Mode → ON
```

### Clone & Run

```bash
# Clone the repository
git clone https://github.com/anishishotasff/novadroid-desktop.git
cd novadroid-desktop

# Install dependencies
flutter pub get

# Run in debug mode
flutter run -d windows

# Build release version
flutter build windows --release
```

The release build will be at:
```
build\windows\x64\runner\Release\novadroid_desktop.exe
```

---

## 📁 Project Structure

```
novadroid_desktop/
├── lib/
│   ├── main.dart                        # Entry point
│   ├── core/
│   │   ├── config/app_config.dart       # App configuration
│   │   ├── errors/app_exception.dart    # Error handling
│   │   └── logging/app_logger.dart      # Logging system
│   ├── services/
│   │   ├── adb_service.dart             # ADB commands & detection
│   │   └── device_service.dart          # Device management
│   ├── features/
│   │   ├── desktop/                     # Main desktop UI
│   │   ├── device_manager/              # Device connection panel
│   │   ├── settings/                    # Settings panel
│   │   ├── quick_controls/              # Quick settings panel
│   │   ├── notifications/               # Notifications panel
│   │   ├── mirroring/                   # Screen mirror (Phase 3)
│   │   ├── launcher/                    # App launcher (Phase 4)
│   │   └── windows/                     # Window manager (Phase 4)
│   ├── models/                          # Data models
│   ├── state/                           # Provider state management
│   ├── theme/                           # Dark theme & colors
│   └── widgets/                         # Taskbar & shared widgets
├── windows/                             # Windows platform config
├── assets/                              # Images, icons, wallpapers
├── installer/setup.iss                  # Inno Setup installer script
└── release/                             # Built portable version
```

---

## 🔧 Troubleshooting

<details>
<summary><b>❌ "ADB not found" error</b></summary>

Install Android Platform Tools:
1. Download from [developer.android.com/studio/releases/platform-tools](https://developer.android.com/studio/releases/platform-tools)
2. Extract to `C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools\`
3. Restart NovaDroid Desktop

</details>

<details>
<summary><b>❌ Device not detected</b></summary>

1. Make sure **USB Debugging** is enabled on your phone
2. Accept the "Allow USB debugging?" dialog on your phone
3. Try a different USB cable or port
4. Click **Refresh** in the Device Manager panel
5. Run `adb devices` in terminal to verify ADB works

</details>

<details>
<summary><b>❌ "Unauthorized" status</b></summary>

Your phone is showing a USB debugging authorization dialog.
- Unlock your phone and look for the dialog
- Tap **"Allow"**
- Check **"Always allow from this computer"**

</details>

<details>
<summary><b>❌ App won't start</b></summary>

1. Make sure you're on Windows 10/11 **64-bit**
2. Try running as Administrator
3. Check logs at: `%APPDATA%\novadroid_desktop\logs\`
4. Make sure antivirus isn't blocking the app

</details>

<details>
<summary><b>❌ Build error "requires symlink support"</b></summary>

Enable Windows Developer Mode:
```
Settings → Privacy & Security → For Developers → Developer Mode → ON
```
Then restart your computer and try building again.

</details>

---

## 🤝 Contributing

Contributions are welcome! Here's how to get started:

1. **Fork** the repository
2. **Create** a feature branch
   ```bash
   git checkout -b feature/screen-mirroring
   ```
3. **Commit** your changes
   ```bash
   git commit -m "Add screen mirroring support"
   ```
4. **Push** to your fork
   ```bash
   git push origin feature/screen-mirroring
   ```
5. Open a **Pull Request**

### 🎯 Good First Issues
- Add screen mirroring (Phase 3)
- Implement notification bridge
- Add clipboard sync
- Create file transfer UI
- Add more themes

See [`TODO.md`](TODO.md) for the full feature roadmap.

---

## 📄 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.44** | UI framework |
| **Dart 3.12** | Programming language |
| **Provider** | State management |
| **ADB** | Android device communication |
| **window_manager** | Windows title bar & controls |
| **tray_manager** | System tray integration |
| **Google Fonts** | Typography (Inter) |
| **process_run** | ADB process management |
| **logger** | Structured logging |
| **shared_preferences** | Settings persistence |

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE.txt](LICENSE.txt) file for details.

---

## ⭐ Support the Project

If you find NovaDroid Desktop useful:

- ⭐ **Star this repository**
- 🐛 **Report bugs** via [Issues](https://github.com/anishishotasff/novadroid-desktop/issues)
- 💡 **Suggest features** via [Issues](https://github.com/anishishotasff/novadroid-desktop/issues)
- 🤝 **Contribute** code or documentation
- 📢 **Share** with others who might find it useful

---

## 📬 Contact

- **GitHub Issues:** [Report a bug or request a feature](https://github.com/anishishotasff/novadroid-desktop/issues)
- **Repository:** [github.com/anishishotasff/novadroid-desktop](https://github.com/anishishotasff/novadroid-desktop)

---

<div align="center">

Made with ❤️ using Flutter

**[⬆ Back to Top](#-novadroid-desktop)**

</div>

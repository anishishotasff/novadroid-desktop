# Creating Portable & Installable Versions

## ✅ Release Build Complete!

The Windows release build is ready at:
```
build\windows\x64\runner\Release\
```

## 📦 Option 1: Portable Version (No Installation Needed)

### What Users Need:
1. Download the `NovaDroid_Desktop_Portable.zip`
2. Extract anywhere
3. Run `novadroid_desktop.exe`

### To Create Portable ZIP:

```powershell
# Navigate to project
cd "E:\android dexxx\novadroid_desktop"

# Create release folder
mkdir release -ErrorAction SilentlyContinue

# Copy release files
Copy-Item "build\windows\x64\runner\Release\*" -Destination "release\NovaDroid_Desktop_Portable" -Recurse -Force

# Create README
@"
# NovaDroid Desktop - Portable Version

## Quick Start:
1. Run novadroid_desktop.exe
2. Enable USB Debugging on your Android phone
3. Connect phone via USB or WiFi
4. Enjoy!

## Requirements:
- Windows 10/11 (64-bit)
- Android device with USB debugging enabled

## Need Help?
Visit: https://github.com/anishishotasff/novadroid-desktop

"@ | Out-File "release\NovaDroid_Desktop_Portable\README.txt"

# Compress to ZIP
Compress-Archive -Path "release\NovaDroid_Desktop_Portable\*" -DestinationPath "release\NovaDroid_Desktop_v1.0.0_Portable.zip" -Force

Write-Host "✅ Portable version created: release\NovaDroid_Desktop_v1.0.0_Portable.zip"
```

## 🔧 Option 2: Installer (Professional)

### Requirements:
Download Inno Setup: https://jrsoftware.org/isdl.php

### To Create Installer:

1. **Install Inno Setup**
2. **Open** `installer\setup.iss` in Inno Setup Compiler
3. **Click** "Build" → "Compile"
4. **Find installer** at: `release\NovaDroid_Desktop_Setup_v1.0.0.exe`

### Or use command line:
```powershell
# If Inno Setup is installed
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" "installer\setup.iss"
```

## 📤 Upload to GitHub Releases

### Step 1: Create GitHub Release

```bash
# Create a new release
git tag -a v1.0.0 -m "Version 1.0.0 - Phase 1 & 2 Complete"
git push origin v1.0.0
```

### Step 2: Upload Files

Go to: https://github.com/anishishotasff/novadroid-desktop/releases/new

- **Tag:** v1.0.0
- **Title:** NovaDroid Desktop v1.0.0
- **Description:**
```markdown
## 🚀 NovaDroid Desktop v1.0.0

Control your Android device from Windows PC!

### ✨ Features:
- ✅ Modern desktop interface
- ✅ USB & WiFi connection
- ✅ Device management
- ✅ Real-time battery monitoring
- ✅ Settings & quick controls

### 📥 Downloads:
- **For regular users:** Download `NovaDroid_Desktop_Setup_v1.0.0.exe` (Recommended)
- **For portable:** Download `NovaDroid_Desktop_v1.0.0_Portable.zip`

### 📋 Requirements:
- Windows 10/11 (64-bit)
- Android device with USB debugging

### 🔧 Installation:
1. Download the setup file
2. Run the installer
3. Launch NovaDroid Desktop
4. Connect your Android device

### 📖 Documentation:
See [README.md](../README.md) for full documentation.
```

Attach files:
- `NovaDroid_Desktop_Setup_v1.0.0.exe` (if created)
- `NovaDroid_Desktop_v1.0.0_Portable.zip`

### Step 3: Publish Release

Click **"Publish release"**

## 📊 File Sizes

Typical sizes:
- Portable ZIP: ~50-70 MB
- Installer EXE: ~50-70 MB

## ✅ Users Can Now:

1. **Download** from GitHub Releases
2. **Install** with one click (or extract portable)
3. **Run** without Flutter installed
4. **Use** like any Windows app

## 🎯 What's Included:

- ✅ novadroid_desktop.exe (main app)
- ✅ flutter_windows.dll (Flutter engine)
- ✅ All required DLLs
- ✅ Data files and assets
- ✅ No Flutter SDK required!

---

**Note:** ADB (Android Platform Tools) is still required for device connection. The app will detect it automatically or show instructions if not found.

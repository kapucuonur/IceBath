# IceBath - Quick Start Guide

## Step 1: Install SDK Manager ✅ (Completed)

You've already downloaded the SDK Manager. Now:

1. Open the `.dmg` file
2. Drag SDK Manager to Applications folder
3. Launch SDK Manager
4. Login with your Garmin Connect account
5. Download the latest SDK
6. Download device support files (Fenix 7, Epix 2, etc.)

## Step 2: Install VS Code Extension

1. Open Visual Studio Code
2. Press `Cmd + Shift + X` (Extensions)
3. Search for "Monkey C"
4. Install the official **Monkey C** extension by Garmin
5. Restart VS Code

## Step 3: Verify Installation

1. In VS Code, press `Cmd + Shift + P`
2. Type "Monkey C: Verify Installation"
3. Select it and check if everything is configured correctly

## Step 4: Generate Developer Key

1. Press `Cmd + Shift + P`
2. Type "Monkey C: Generate a Developer Key"
3. Choose a secure location to save it
4. **IMPORTANT**: Keep this key safe! You'll need it to update your app later

## Step 5: Build the IceBath App

### Option A: Build for Simulator
```
1. Open IceBath project in VS Code
2. Press Cmd + Shift + P
3. Type "Monkey C: Build for Simulator"
4. Select target device (e.g., Fenix 7)
```

### Option B: Run in Simulator
```
1. Press Cmd + Shift + P
2. Type "Monkey C: Run"
3. Select target device
4. Simulator will launch with your app
```

### Option C: Build for Real Device
```
1. Press Cmd + Shift + P
2. Type "Monkey C: Build for Device"
3. Find the .prg file in bin/ folder
4. Copy to your Garmin device's GARMIN/APPS/ folder
```

## Step 6: Test the App

### In Simulator:
- Use mouse to click buttons
- Test start/stop functionality
- Check if metrics display correctly
- Verify safety warnings

### On Real Device:
1. Connect Garmin watch via USB
2. Copy `bin/IceBath.prg` to `GARMIN/APPS/`
3. Disconnect device
4. Find IceBath in your watch's app menu
5. Test with real sensors!

## Troubleshooting

### SDK Manager Issues
- **Can't login**: Check internet connection
- **SDK download fails**: Try again or use different network

### VS Code Extension Issues
- **Extension not found**: Make sure you're searching "Monkey C" exactly
- **Build fails**: Verify SDK is installed via SDK Manager

### Build Errors
- **Missing SDK**: Open SDK Manager and download SDK
- **Device not found**: Download device support files in SDK Manager
- **Syntax errors**: Check the error message and file location

## Next Steps After Testing

1. ✅ Test in simulator
2. ✅ Test on real device
3. 📸 Take screenshots for app store
4. 📝 Prepare app description
5. 🚀 Submit to Connect IQ Store

## Need Help?

- Check [DEVELOPMENT.md](DEVELOPMENT.md) for detailed guide
- See [README.md](README.md) for app features
- Review [USER_GUIDE.md](USER_GUIDE.md) for usage instructions

---

**Ready to test your IceBath app! ❄️**

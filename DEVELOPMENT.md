# IceBath Development Guide

## Documentation

- **README**: [README.md](README.md) (English) | [README_TR.md](README_TR.md) (Turkish)
- **User Guide**: [USER_GUIDE.md](USER_GUIDE.md) (English) | [USER_GUIDE_TR.md](USER_GUIDE_TR.md) (Turkish)

## Development Setup

### Prerequisites
1. Install Java JRE 1.8+
2. Install Visual Studio Code
3. Download Garmin SDK Manager from [developer.garmin.com](https://developer.garmin.com/connect-iq/sdk)

### Initial Setup
```bash
# 1. Install SDK Manager (Mac)
# Download .dmg file and drag to Applications

# 2. Launch SDK Manager
# Login with Garmin Connect credentials
# Download latest SDK and device support files

# 3. Install VS Code Extension
# Open VS Code
# Extensions → Search "Monkey C"
# Install official Garmin extension

# 4. Generate Developer Key
# In VS Code: Cmd+Shift+P
# Select "Monkey C: Generate a Developer Key"
# Save in a secure location
```

## Building the App

### Compile for Simulator
```bash
# In VS Code
Cmd + Shift + P
> Monkey C: Build for Simulator
```

### Run in Simulator
```bash
# In VS Code
Cmd + Shift + P
> Monkey C: Run
# Select target device (e.g., Fenix 7)
```

### Build for Device
```bash
# In VS Code
Cmd + Shift + P
> Monkey C: Build for Device
# Output: bin/IceBath.prg
```

## Testing

### Simulator Testing
1. Build for simulator
2. Run application
3. Use simulator controls to test:
   - Start/Stop recording
   - Menu navigation
   - Settings changes

### Device Testing
1. Connect Garmin device via USB
2. Copy `bin/IceBath.prg` to `GARMIN/APPS/` folder
3. Disconnect device
4. Find app in device menu

### Test Scenarios
- [ ] Start activity and verify timer starts
- [ ] Check heart rate display updates
- [ ] Verify temperature readings (if available)
- [ ] Test safety warnings at thresholds
- [ ] Confirm save/discard functionality
- [ ] Test settings persistence

## Code Structure

### Main Components
- **IceBathApp.mc**: Application entry point
- **IceBathView.mc**: UI rendering and display logic
- **IceBathDelegate.mc**: Input handling
- **DataManager.mc**: Sensor data collection
- **SafetyMonitor.mc**: Safety threshold monitoring

### Adding New Features

#### Add a New Metric
1. Update `DataManager.mc` to collect data
2. Add display logic in `IceBathView.mc`
3. Update `strings.xml` for labels
4. Test in simulator

#### Add a New Setting
1. Add property in `resources/settings.xml`
2. Add string in `resources/strings.xml`
3. Use in code via `App.getProperty()`

## Debugging

### Enable Debug Logging
```monkey-c
using Toybox.System as Sys;

Sys.println("Debug message: " + variable);
```

### View Logs
```bash
# In VS Code Output panel
# Select "Monkey C" from dropdown
```

### Common Issues

**Issue**: Sensor data not available
**Solution**: Check device compatibility, ensure sensors are enabled

**Issue**: Build fails
**Solution**: Verify SDK version, check manifest.xml syntax

**Issue**: App crashes on device
**Solution**: Check memory usage, verify API compatibility

## Publishing

### Prepare for Store
1. Test on multiple devices
2. Create app screenshots
3. Write store description
4. Set pricing (free/paid)

### Submit to Connect IQ Store
1. Go to [apps.garmin.com](https://apps.garmin.com)
2. Login with developer account
3. Upload .iq file
4. Fill in app details
5. Submit for review

### Review Process
- Typically 1-2 weeks
- Garmin tests on real devices
- May request changes

## Best Practices

### Performance
- Minimize memory allocations in `onUpdate()`
- Use efficient data structures
- Cache frequently used values

### Battery Life
- Reduce update frequency when possible
- Disable unused sensors
- Optimize GPS usage

### User Experience
- Clear, readable fonts
- Intuitive button mappings
- Helpful error messages
- Smooth animations

## Resources

- [Connect IQ Documentation](https://developer.garmin.com/connect-iq/api-docs/)
- [Monkey C Language Guide](https://developer.garmin.com/connect-iq/monkey-c/)
- [Connect IQ Forums](https://forums.garmin.com/developer/connect-iq/)
- [Sample Apps](https://github.com/garmin/connectiq-apps)

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## Version History

### v1.0.0 (2025-12-24)
- Initial release
- Core metrics: duration, heart rate, body temp, calories
- Advanced metrics: HRV, respiration, stress
- Safety monitoring with alerts
- Bilingual support (EN/TR)
- Configurable settings

---

Happy coding! ❄️💻

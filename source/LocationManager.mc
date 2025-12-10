using Toybox.Position as Position;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

/**
 * Location Manager
 * Manages GPS positioning and location tracking
 */
class LocationManager {
    
    private var _location;
    private var _accuracy;
    private var _hasLocation;
    private var _isEnabled;
    private var _simulatorTestMode;  // For testing in simulator
    private var _simulatorStartTime;  // When GPS was enabled in simulator
    
    function initialize() {
        _location = null;
        _accuracy = Position.QUALITY_NOT_AVAILABLE;
        _hasLocation = false;
        _isEnabled = false;
        _simulatorTestMode = false;
        _simulatorStartTime = null;
        
        // Check if running in simulator
        var deviceSettings = Sys.getDeviceSettings();
        if (deviceSettings has :partNumber) {
            // If part number is "006-B3251-00" or similar simulator codes, enable test mode
            var partNum = deviceSettings.partNumber;
            if (partNum != null && partNum.find("SIMULATOR") != null) {
                _simulatorTestMode = true;
                Sys.println("SIMULATOR TEST MODE: GPS will auto-simulate after 2 seconds");
            }
        }
    }
    
    /**
     * Enable GPS location tracking
     */
    function enableLocationEvents() {
        if (!_isEnabled) {
            try {
                Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
                _isEnabled = true;
                
                // In simulator test mode, start timer
                if (_simulatorTestMode) {
                    _simulatorStartTime = Sys.getTimer();
                }
                
                Sys.println("GPS enabled");
            } catch (ex) {
                Sys.println("ERROR enabling GPS: " + ex.getErrorMessage());
            }
        }
    }
    
    /**
     * Disable GPS location tracking to save battery
     */
    function disableLocationEvents() {
        if (_isEnabled) {
            Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
            _isEnabled = false;
            Sys.println("GPS disabled");
        }
    }
    
    /**
     * Position callback - called when GPS position updates
     */
    function onPosition(info as Position.Info) as Void {
        if (info != null && info.position != null) {
            _location = info.position;
            _accuracy = info.accuracy;
            _hasLocation = true;
            
            var lat = _location.toDegrees()[0];
            var lng = _location.toDegrees()[1];
            Sys.println("GPS Position: " + lat.format("%.6f") + ", " + lng.format("%.6f") + " (accuracy: " + _accuracy + ")");
        }
    }
    
    /**
     * Get current location
     * Returns: {latitude, longitude} in degrees, or null if no location
     */
    function getCurrentLocation() {
        if (_hasLocation && _location != null) {
            var degrees = _location.toDegrees();
            return {
                :latitude => degrees[0],
                :longitude => degrees[1]
            };
        }
        return null;
    }
    
    /**
     * Get location accuracy/quality
     * Returns Position.QUALITY_* constant
     */
    function getLocationAccuracy() {
        // In simulator test mode, simulate GPS becoming available after 2 seconds
        if (_simulatorTestMode && _isEnabled && _simulatorStartTime != null) {
            var elapsed = (Sys.getTimer() - _simulatorStartTime) / 1000;
            if (elapsed > 2) {
                // Simulate GPS found after 2 seconds
                _accuracy = Position.QUALITY_GOOD;
                _hasLocation = true;
            }
        }
        
        return _accuracy;
    }
    
    /**
     * Check if we have a valid GPS fix
     */
    function hasLocation() {
        return _hasLocation;
    }
    
    /**
     * Check if GPS is enabled
     */
    function isEnabled() {
        return _isEnabled;
    }
    
    /**
     * Get GPS quality as string for display
     */
    function getQualityString() {
        switch (_accuracy) {
            case Position.QUALITY_NOT_AVAILABLE:
                return "No GPS";
            case Position.QUALITY_LAST_KNOWN:
                return "Last Known";
            case Position.QUALITY_POOR:
                return "Poor";
            case Position.QUALITY_USABLE:
                return "Usable";
            case Position.QUALITY_GOOD:
                return "Good";
            default:
                return "Unknown";
        }
    }
    
    /**
     * Reset location data
     */
    function reset() {
        _location = null;
        _accuracy = Position.QUALITY_NOT_AVAILABLE;
        _hasLocation = false;
    }
}

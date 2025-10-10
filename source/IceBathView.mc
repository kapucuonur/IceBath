using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Activity as Activity;
using Toybox.ActivityRecording as Recording;
using Toybox.Timer as Timer;
using Toybox.Position as Position;

/**
 * IceBath View
 * Main view that displays all metrics during the activity
 */
class IceBathView extends Ui.View {

    private var _dataManager;
    private var _safetyMonitor;
    private var _locationManager;  // GPS location manager
    private var _session;  // Activity recording session
    private var _updateTimer;  // Timer for updating display
    private var _startTime;  // Track start time for manual duration calculation
    
    // Display values
    private var _elapsedTime = 0; // Accumulated time from previous segments (seconds)
    private var _duration = 0; // Total duration to display
    private var _heartRate = 0;
    private var _bodyTemp = 0.0;
    private var _calories = 0;
    public var _isRecording = false;  // Public so delegate can check state
    
    // Location data
    private var _startLocation = null;  // GPS coordinates when activity started
    private var _locationAccuracy = null;  // GPS accuracy
    private var _gpsFoundTime = null;  // When GPS was found (for auto-hide)
    private var _showGpsMessage = false;  // Show GPS found message
    private var _lastGpsQuality = Position.QUALITY_NOT_AVAILABLE;  // Track GPS quality changes
    
    // Statistics for summary
    private var _totalHR = 0;
    private var _hrSamples = 0;
    private var _minTemp = 999.0;
    private var _maxTemp = 0.0;
    private var _totalTemp = 0.0;
    private var _tempSamples = 0;
    
    // Data history for charts (max ~100 points to save memory)
    private var _hrHistory = [];
    private var _tempHistory = [];
    private var _calHistory = [];
    private var _sampleTimer = 0;
    private const SAMPLE_INTERVAL = 5; // Sample every 5 seconds for better graph resolution
    
    // Warning flags
    private var _showWarning = false;
    private var _warningMessage = "";

    function initialize() {
        View.initialize();
        _dataManager = new DataManager();
        _safetyMonitor = new SafetyMonitor();
        _locationManager = new LocationManager();
        _session = null;
        _updateTimer = null;
        _startTime = null;
        _elapsedTime = 0;
        _hrHistory = [];
        _tempHistory = [];
        _calHistory = [];
    }

    /**
     * Called when this View is brought to the foreground
     */
    function onShow() {
        // Start GPS acquisition immediately when app opens
        // This allows GPS to get a fix before user starts recording
        _locationManager.enableLocationEvents();
        
        // Request initial update
        Ui.requestUpdate();
    }

    /**
     * Update the view
     */
    function onUpdate(dc) {
        // Clear screen first
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        // Calculate duration: accumulated time + current segment
        _duration = _elapsedTime;
        if (_isRecording && _startTime != null) {
            var now = Sys.getTimer();
            var currentSegment = (now - _startTime) / 1000;
            _duration += currentSegment;
        }
        
        // Get current activity info
        var info = Activity.getActivityInfo();
        
        if (info != null) {
            // Update heart rate
            if (info.currentHeartRate != null) {
                _heartRate = info.currentHeartRate;
                
                // Track for average
                if (_isRecording && _heartRate > 0) {
                    _totalHR += _heartRate;
                    _hrSamples++;
                }
            }
        }
        
        // Calculate calories using ice bath-specific formula
        _calories = _dataManager.getCalories(_duration, _bodyTemp);
        
        
        // Get body temperature from sensor (keep trying even during recording)
        var newTemp = _dataManager.getBodyTemperature();
        
        // If we got a valid temperature, use it
        if (newTemp > 0) {
            _bodyTemp = newTemp;
            
            // Track temperature statistics during recording
            if (_isRecording) {
                // Track minimum temperature
                if (_bodyTemp < _minTemp) {
                    _minTemp = _bodyTemp;
                }
                
                // Track maximum temperature
                if (_bodyTemp > _maxTemp) {
                    _maxTemp = _bodyTemp;
                }
                
                // Track for average
                _totalTemp += _bodyTemp;
                _tempSamples++;
            }
            
            Sys.println("Temperature updated: " + _bodyTemp + "°C");
        } else {
            // Keep the last valid temperature if sensor stops providing data
            Sys.println("No temperature data, keeping last value: " + _bodyTemp + "°C");
        }
        
        // Check GPS quality and show "GPS Bulundu" message when found
        var currentGpsQuality = _locationManager.getLocationAccuracy();
        
        // If GPS just became good/usable (and wasn't before), show message
        if (!_isRecording) {  // Only show before recording starts
            if ((currentGpsQuality == Position.QUALITY_GOOD || currentGpsQuality == Position.QUALITY_USABLE) &&
                (_lastGpsQuality != Position.QUALITY_GOOD && _lastGpsQuality != Position.QUALITY_USABLE)) {
                _showGpsMessage = true;
                _gpsFoundTime = Sys.getTimer();
                Sys.println("GPS FOUND! Quality: " + _locationManager.getQualityString());
            }
            
            // Auto-hide GPS message after 3 seconds
            if (_showGpsMessage && _gpsFoundTime != null) {
                var elapsed = (Sys.getTimer() - _gpsFoundTime) / 1000;
                if (elapsed > 3) {
                    _showGpsMessage = false;
                    _gpsFoundTime = null;
                }
            }
        }
        
        _lastGpsQuality = currentGpsQuality;
        
        // Check safety thresholds
        var safetyCheck = _safetyMonitor.checkSafety(_heartRate, _bodyTemp, _duration);
        _showWarning = safetyCheck[:warning];
        _warningMessage = safetyCheck[:message];
        
        // Debug logging
        Sys.println("WARNING CHECK: show=" + _showWarning + " msg=" + _warningMessage + " HR=" + _heartRate + " Temp=" + _bodyTemp);
        
        // Clear warning message if no warning
        if (!_showWarning) {
            _warningMessage = "";
        }
        
        // Draw background image with proper scaling
        try {
            var bg = Ui.loadResource(Rez.Drawables.BackgroundImage);
            if (bg != null) {
                var width = dc.getWidth();
                var height = dc.getHeight();
                
                // Scale and center the background image
                // Assuming image is 500x500, center it on the screen
                var offsetX = (width - 500) / 2;
                var offsetY = (height - 500) / 2;
                
                dc.drawBitmap(offsetX, offsetY, bg);
            } else {
                // Fallback gradient
                dc.setColor(0x001a33, Gfx.COLOR_BLACK);
                dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
            }
        } catch (ex) {
            // If background fails, use fallback
            dc.setColor(0x001a33, Gfx.COLOR_BLACK);
            dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        }
        
        // Draw the interface on top
        drawInterface(dc);
    }

    /**
     * Draw the main interface
     */
    /**
     * Draw the main interface
     */
    private function drawInterface(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        
        // Title at top
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, 15, Gfx.FONT_SMALL, "IceBath", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Duration (large, center-top)
        var durationStr = formatDuration(_duration);
        dc.drawText(centerX, 45, Gfx.FONT_NUMBER_HOT, durationStr, Gfx.TEXT_JUSTIFY_CENTER);
        
        // Metrics section - organized in a clean layout
        var metricsY = height / 2 - 30; // Moved higher for better spacing
        var leftX = 30;
        var rightX = width - 30;
        
        // Heart Rate (left side)
        var hrColor = _heartRate > 0 ? Gfx.COLOR_RED : Gfx.COLOR_DK_GRAY;
        dc.setColor(hrColor, Gfx.COLOR_TRANSPARENT);
        // Stack: bpm (Top) -> Number (Middle) -> HR (Bottom)
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(leftX, metricsY, Gfx.FONT_XTINY, "bpm", Gfx.TEXT_JUSTIFY_LEFT);
        
        // HR Value: White for better visibility
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(leftX, metricsY + 25, Gfx.FONT_SYSTEM_LARGE, _heartRate.toString(), Gfx.TEXT_JUSTIFY_LEFT);
        
        // HR Label: Red (or Gray if 0)
        dc.setColor(hrColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(leftX, metricsY + 85, Gfx.FONT_XTINY, "HR", Gfx.TEXT_JUSTIFY_LEFT);
        
        // Body Temperature (right side)
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        // Stack: C (Top) -> Number (Middle) -> TEMP (Bottom)
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(rightX, metricsY, Gfx.FONT_XTINY, "°C", Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Temp Value: Blue
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        var tempStr = _bodyTemp > 0 ? _bodyTemp.format("%.1f") : "--";
        dc.drawText(rightX, metricsY + 25, Gfx.FONT_SYSTEM_LARGE, tempStr, Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Temp Label: Blue (moved down)
        dc.drawText(rightX, metricsY + 85, Gfx.FONT_XTINY, "TEMP", Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Calories & GPS Coordinates (bottom area)
        var bottomY = height - 120;
        
        // Calories (center)
        dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, bottomY, Gfx.FONT_XTINY, "CAL", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, bottomY + 20, Gfx.FONT_SYSTEM_LARGE, _calories.toString(), Gfx.TEXT_JUSTIFY_CENTER);
        
        // GPS Coordinates (very bottom, small)
        var loc = _locationManager.getCurrentLocation();
        var gpsStr = "No GPS";
        var gpsColor = Gfx.COLOR_DK_GRAY;
        
        if (loc != null) {
            gpsStr = loc[:latitude].format("%.5f") + "\n" + loc[:longitude].format("%.5f");
            gpsColor = Gfx.COLOR_GREEN;
            
            dc.setColor(gpsColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, height - 40, Gfx.FONT_XTINY, gpsStr, Gfx.TEXT_JUSTIFY_CENTER);
        } else {
             gpsStr = "GPS Searching...";
             if (_locationManager.getLocationAccuracy() <= Position.QUALITY_LAST_KNOWN) {
                 gpsColor = Gfx.COLOR_RED;
             }
             
             // Draw Searching in the middle
             dc.setColor(gpsColor, Gfx.COLOR_TRANSPARENT);
             // Stack: GPS (Top) -> Searching... (Bottom)
             dc.drawText(centerX, height / 2 - 15, Gfx.FONT_XTINY, "GPS", Gfx.TEXT_JUSTIFY_CENTER);
             dc.drawText(centerX, height / 2 + 5, Gfx.FONT_XTINY, "Searching...", Gfx.TEXT_JUSTIFY_CENTER);
        }

        
        // Warning indicator
        if (_showWarning) {
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
            dc.fillRectangle(0, height - 35, width, 35);
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, height - 30, Gfx.FONT_SMALL, "⚠ " + _warningMessage, Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        // GPS Found message (centered, green, auto-hides after 3 seconds)
        // Only shows when GPS becomes available and before recording starts
        if (_showGpsMessage && !_isRecording) {
            // Semi-transparent background for better visibility
            dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(centerX - 80, height / 2 - 25, 160, 50, 10);
            
            // Green "GPS Ready" text
            dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, height / 2 - 10, Gfx.FONT_MEDIUM, "GPS Ready", Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        // Recording status indicator (top-right corner)
        if (_isRecording) {
            var circleX = width - 20;
            var circleY = 20;
            // Red circle with white border
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.fillCircle(circleX, circleY, 8);
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
            dc.fillCircle(circleX, circleY, 6);
        }
    }

    /**
     * Format duration as MM:SS
     */
    private function formatDuration(seconds) {
        var mins = seconds / 60;
        var secs = seconds % 60;
        return mins.format("%02d") + ":" + secs.format("%02d");
    }

    /**
     * Called when this View is removed from the screen
     */
    function onHide() {
        // Disable GPS when app is closed to save battery
        // GPS will restart when app is opened again
        _locationManager.disableLocationEvents();
    }

    /**
     * Timer callback to update display
     */
    function onTimerCallback() {
        Ui.requestUpdate();
        
        // Data sampling for charts
        if (_isRecording) {
            _sampleTimer++;
            if (_sampleTimer >= SAMPLE_INTERVAL) {
                _sampleTimer = 0;
                
                // Add valid data points
                if (_heartRate > 0) {
                    _hrHistory.add(_heartRate);
                } else if (_hrHistory.size() > 0) {
                    // Duplicate last known if invalid (to keep graph continuity)
                    _hrHistory.add(_hrHistory[_hrHistory.size()-1]);
                }
                
                // Add temp data (allow 0 if no sensor, handled in graph)
                if (_bodyTemp > 0) {
                    _tempHistory.add(_bodyTemp);
                } else if (_tempHistory.size() > 0) {
                    _tempHistory.add(_tempHistory[_tempHistory.size()-1]);
                }
                
                // Add calorie data
                _calHistory.add(_calories);
            }
        }
    }

    /**
     * Start recording
     */
    function startRecording() {
        if (_session == null) {
            // New Session: Initialize
            try {
                _session = Recording.createSession({:name=>"IceBath", :sport=>Recording.SPORT_GENERIC});
                _session.start();
                
                // Reset stats only on NEW session
                _totalHR = 0;
                _hrSamples = 0;
                _minTemp = 999.0;
                _maxTemp = 0.0;
                _totalTemp = 0.0;
                _tempSamples = 0;
                _hrHistory = [];
                _tempHistory = [];
                _calHistory = [];
                _sampleTimer = 0;
                _elapsedTime = 0; // Reset accumulated time
            } catch (ex) {
                Sys.println("ERROR creating session: " + ex.getErrorMessage());
            }
        } else {
             // Resuming: Just start the session again
             if (!_session.isRecording()) {
                 _session.start();
             }
        }
        
        _isRecording = true;
        _startTime = Sys.getTimer(); // Start tracking this segment
        
        // Hide GPS message when recording starts
        _showGpsMessage = false;
        _gpsFoundTime = null;
        
        // Enable GPS to capture location
        _locationManager.enableLocationEvents();
        
        // Capture start location (may take a moment to get GPS fix)
        // We'll store whatever location we have, even if it's not perfect yet
        _startLocation = _locationManager.getCurrentLocation();
        _locationAccuracy = _locationManager.getLocationAccuracy();
        
        if (_startLocation != null) {
            Sys.println("Activity started at: " + _startLocation[:latitude].format("%.6f") + ", " + _startLocation[:longitude].format("%.6f"));
        } else {
            Sys.println("Activity started, waiting for GPS fix...");
        }
        
        // Start update timer (1 second interval)
        if (_updateTimer == null) {
            _updateTimer = new Timer.Timer();
        }
        _updateTimer.start(method(:onTimerCallback), 1000, true);
        
        Ui.requestUpdate();
    }

    /**
     * Stop recording
     */
    function stopRecording() {
        // Calculate and save the duration of this segment
        if (_isRecording && _startTime != null) {
            var now = Sys.getTimer();
            var segmentDuration = (now - _startTime) / 1000;
            _elapsedTime += segmentDuration;
            _startTime = null; // Clear start time so we don't double count if called again
        }

        if (_session != null && _session.isRecording()) {
            _session.stop();
        }
        _isRecording = false;
        
        // Disable GPS to save battery
        _locationManager.disableLocationEvents();
        
        // Stop update timer
        if (_updateTimer != null) {
            _updateTimer.stop();
            _updateTimer = null;
        }
        
        Ui.requestUpdate();
    }

    /**
     * Add a lap
     */
    function addLap() {
        if (_isRecording && _session != null) {
            _session.addLap();
            Sys.println("Lap added");
        }
    }

    /**
     * Save activity and show summary
     */
    function saveActivity() {
        // Stop timer first
        if (_updateTimer != null) {
            _updateTimer.stop();
            _updateTimer = null;
        }
        
        if (_session != null) {
            _session.save();
            _session = null;
        }
        
        // Calculate average HR
        var avgHR = 0;
        if (_hrSamples > 0) {
            avgHR = _totalHR / _hrSamples;
        }
        
        // Calculate average temperature
        var avgTemp = 0.0;
        if (_tempSamples > 0) {
            avgTemp = _totalTemp / _tempSamples;
        }
        
        // Note: Temperature data is shown in summary but may not appear in Garmin Connect
        // Garmin Connect IQ API doesn't easily support custom FIT fields for temperature
        
        // Show summary screen with history data
        var summaryView = new SummaryView(_duration, avgHR, _minTemp, _calories, _hrHistory, _tempHistory, _calHistory);
        var summaryDelegate = new SummaryDelegate(summaryView);
        Ui.switchToView(summaryView, summaryDelegate, Ui.SLIDE_LEFT);
    }

    /**
     * Discard activity
     */
    function discardActivity() {
        // Stop timer first
        if (_updateTimer != null) {
            _updateTimer.stop();
            _updateTimer = null;
        }
        
        if (_session != null) {
            _session.discard();
            _session = null;
        }
        
        // Disable GPS and reset location
        _locationManager.disableLocationEvents();
        _locationManager.reset();
        _startLocation = null;
        _locationAccuracy = null;
        
        _isRecording = false;
        _duration = 0;
        _elapsedTime = 0;
        _startTime = null;
        
        Ui.requestUpdate();
    }
}

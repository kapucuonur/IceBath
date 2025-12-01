using Toybox.System as Sys;
using Toybox.Attention as Attention;
using Toybox.Application.Properties as Properties;

/**
 * Safety Monitor
 * Monitors vital signs and provides safety warnings
 */
class SafetyMonitor {

    // Default safety thresholds
    private var _maxHeartRate;
    private var _minHeartRate;
    private var _minBodyTemp;
    private var _maxDuration;
    private var _alertsEnabled;
    
    // Alert cooldown to prevent continuous alerts
    private var _lastAlertTime = 0;
    private var _alertCooldown = 60000; // 60 seconds between alerts

    function initialize() {
        // Load settings or use defaults
        loadSettings();
    }

    /**
     * Load safety settings from app properties
     */
    private function loadSettings() {
        // Heart rate thresholds (bpm)
        _maxHeartRate = Properties.getValue("maxHeartRate");
        if (_maxHeartRate == null) {
            _maxHeartRate = 160; // Default max
        }
        
        _minHeartRate = Properties.getValue("minHeartRate");
        if (_minHeartRate == null) {
            _minHeartRate = 40; // Default min
        }
        
        // Body temperature threshold (Celsius)
        _minBodyTemp = Properties.getValue("minBodyTemp");
        if (_minBodyTemp == null || _minBodyTemp > 25) {
            _minBodyTemp = 10.0; // Skin temperature warning threshold (ice bath safe range: 12-16°C)
        }
        
        // Force correct value if old settings cached
        if (_minBodyTemp > 25) {
            _minBodyTemp = 10.0;
        }
        
        Sys.println("SafetyMonitor: minBodyTemp set to " + _minBodyTemp);
        
        // Maximum duration (seconds)
        _maxDuration = Properties.getValue("targetDuration");
        if (_maxDuration == null) {
            _maxDuration = 600; // Default 10 minutes
        }
        
        // Alerts enabled
        _alertsEnabled = Properties.getValue("enableAlerts");
        if (_alertsEnabled == null) {
            _alertsEnabled = true;
        }
    }

    /**
     * Check safety conditions
     * Returns a dictionary with warning flag and message
     */
    function checkSafety(heartRate, bodyTemp, duration) {
        // Always start fresh - no warnings unless explicitly set
        var warning = false;
        var message = "";
        var severity = 0; // 0=none, 1=caution, 2=warning, 3=critical
        
        if (!_alertsEnabled) {
            return {:warning => false, :message => "", :severity => 0};
        }
        
        // Check heart rate - HIGH
        if (heartRate > _maxHeartRate) {
            warning = true;
            message = "High HR!";
            severity = 2;
            playAlertWithCooldown(Attention.TONE_ALARM);
        }
        
        // Check heart rate - LOW (more critical in cold water)
        else if (heartRate > 0 && heartRate < _minHeartRate) {
            warning = true;
            message = "Low HR!";
            severity = 3;
            playAlertWithCooldown(Attention.TONE_ALARM);
        }
        
        
        // Check skin temperature (sensor shows skin temp, not core body temp)
        // Normal ice bath: 12-16°C, Warning if below 10°C
        else if (bodyTemp > 0 && bodyTemp < _minBodyTemp) {
            Sys.println("TEMP WARNING TRIGGERED: " + bodyTemp + " < " + _minBodyTemp);
            warning = true;
            message = "Skin Too Cold!";
            severity = 3;
            playAlertWithCooldown(Attention.TONE_ALARM);
        }
        
        // Check duration
        else if (duration >= _maxDuration) {
            warning = true;
            message = "Time Up!";
            severity = 1;
            playAlertWithCooldown(Attention.TONE_INTERVAL_ALERT);
        }
        
        // Duration check removed - "Almost Done" warning was annoying
        // Only alert when time is actually up
        
        return {
            :warning => warning,
            :message => message,
            :severity => severity
        };
    }

    /**
     * Play alert with cooldown to prevent continuous alerts
     */
    private function playAlertWithCooldown(tone) {
        var now = Sys.getTimer();
        
        // Only play alert if cooldown period has passed
        if (now - _lastAlertTime > _alertCooldown) {
            playAlert(tone);
            _lastAlertTime = now;
        }
    }

    /**
     * Play alert tone and vibration
     */
    private function playAlert(tone) {
        if (Attention has :playTone) {
            Attention.playTone(tone);
        }
        
        if (Attention has :vibrate) {
            var vibeData = [
                new Attention.VibeProfile(50, 200),  // 50% intensity, 200ms
                new Attention.VibeProfile(0, 100),   // pause
                new Attention.VibeProfile(50, 200)   // repeat
            ];
            Attention.vibrate(vibeData);
        }
    }

    /**
     * Get safety recommendations based on current conditions
     */
    function getRecommendations(heartRate, bodyTemp, duration) {
        var recommendations = [];
        
        // Duration recommendations
        if (duration < 120) {
            recommendations.add("Warm up slowly");
        } else if (duration > 300) {
            recommendations.add("Consider exiting soon");
        }
        
        // Heart rate recommendations
        if (heartRate > _maxHeartRate * 0.9) {
            recommendations.add("Slow your breathing");
        }
        
        // Temperature recommendations
        if (bodyTemp < _minBodyTemp + 1.0 && bodyTemp > 0) {
            recommendations.add("Exit and warm up");
        }
        
        return recommendations;
    }

    /**
     * Check if it's safe to continue
     */
    function isSafeToContinue(heartRate, bodyTemp, duration) {
        // Critical conditions that require immediate exit
        if (bodyTemp > 0 && bodyTemp < _minBodyTemp) {
            return false; // Hypothermia risk
        }
        
        if (heartRate > 0 && heartRate < _minHeartRate) {
            return false; // Bradycardia risk
        }
        
        if (heartRate > _maxHeartRate * 1.1) {
            return false; // Tachycardia risk
        }
        
        return true;
    }
}

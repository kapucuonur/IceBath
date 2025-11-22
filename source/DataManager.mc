using Toybox.Activity as Activity;
using Toybox.System as Sys;
using Toybox.Sensor as Sensor;
using Toybox.Lang as Lang;
using Toybox.UserProfile as UserProfile;
using Toybox.SensorHistory as SensorHistory;

/**
 * Data Manager
 * Manages sensor data collection and processing
 */
class DataManager {

    private var _bodyTemp;
    private var _heartRate;
    private var _calories;
    private var _stress;
    private var _respirationRate;

    function initialize() {
        _bodyTemp = 0.0;
        _heartRate = 0;
        _calories = 0;
        _stress = 0;
        _respirationRate = 0;
        
        // Enable sensor data
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
    }

    /**
     * Get current body temperature
     * Returns temperature in Celsius
     */
    function getBodyTemperature() {
        var temp = 0.0;
        
        // Method 1: Try UserProfile for skin temperature
        try {
            var profile = UserProfile.getProfile();
            if (profile != null) {
                if (profile has :temperature && profile.temperature != null) {
                    temp = profile.temperature;
                    if (temp > 0) { return temp; }
                }
            }
        } catch (ex) {
            // UserProfile not available
        }
        
        // Method 2: Try Activity Info
        var info = Activity.getActivityInfo();
        if (info != null) {
            // Check for currentBodyTemperature
            if (info has :currentBodyTemperature && info.currentBodyTemperature != null) {
                temp = info.currentBodyTemperature;
                if (temp > 0) { return temp; }
            }
            
            // Check for skinTemperature
            if (info has :skinTemperature && info.skinTemperature != null) {
                temp = info.skinTemperature;
                if (temp > 0) { return temp; }
            }
            
            // Check for ambientTemperature
            if (info has :ambientTemperature && info.ambientTemperature != null) {
                temp = info.ambientTemperature;
                if (temp > 0) { return temp; }
            }
        }
        
        // Method 3: Try SensorInfo
        var sensorInfo = Sensor.getInfo();
        if (sensorInfo != null) {
            if (sensorInfo has :temperature && sensorInfo.temperature != null) {
                temp = sensorInfo.temperature;
                if (temp > 0) { return temp; }
            }
        }
        
        // Method 4: Try SensorHistory for latest temperature
        try {
            if (Toybox has :SensorHistory) {
                if (Toybox.SensorHistory has :getTemperatureHistory) {
                    var tempIterator = Toybox.SensorHistory.getTemperatureHistory({});
                    if (tempIterator != null) {
                        var sample = tempIterator.next();
                        if (sample != null && sample.data != null) {
                            temp = sample.data;
                            if (temp > 0) { return temp; }
                        }
                    }
                }
            }
        } catch (ex) {
            // SensorHistory not available
        }
        
        // No temperature data available
        return 0.0;
    }

    /**
     * Get current heart rate
     */
    function getHeartRate() {
        var info = Activity.getActivityInfo();
        if (info != null && info.currentHeartRate != null) {
            return info.currentHeartRate;
        }
        return _heartRate;
    }

    /**
     * Get calories burned during ice bath
     * Based on cold exposure research:
     * - 1-3 min: 10-25 calories
     * - 5 min: 25-50 calories
     * - Afterburn effect adds 50-100% more
     */
    function getCalories(duration, skinTemp) {
        if (duration == 0) {
            return 0;
        }
        
        var minutes = duration / 60.0;
        var calories = 0;
        
        // Base calorie burn (progressive rate)
        if (minutes <= 1) {
            calories = minutes * 10; // ~10 cal/min for first minute
        } else if (minutes <= 3) {
            calories = 10 + ((minutes - 1) * 7.5); // 10 + ~7.5 cal/min for next 2 min
        } else if (minutes <= 5) {
            calories = 25 + ((minutes - 3) * 12.5); // 25 + ~12.5 cal/min for next 2 min
        } else {
            calories = 50 + ((minutes - 5) * 8); // 50 + ~8 cal/min after 5 min
        }
        
        // Temperature multiplier (colder = more calories)
        // Below 15°C: significant shivering and metabolic increase
        var tempMultiplier = 1.0;
        if (skinTemp > 0 && skinTemp < 15) {
            // 10°C = 1.5x, 5°C = 2.0x multiplier
            tempMultiplier = 1.0 + ((15 - skinTemp) / 10.0);
        }
        
        calories = calories * tempMultiplier;
        
        // Add afterburn effect (50% of active burn)
        var afterburn = calories * 0.5;
        
        return (calories + afterburn).toNumber();
    }

    /**
     * Get stress level (0-100)
     */
    function getStressLevel() {
        var info = Activity.getActivityInfo();
        if (info != null && info has :currentStress && info.currentStress != null) {
            return info.currentStress;
        }
        return _stress;
    }

    /**
     * Get respiration rate (breaths per minute)
     */
    function getRespirationRate() {
        var info = Activity.getActivityInfo();
        if (info != null && info has :currentRespirationRate && info.currentRespirationRate != null) {
            return info.currentRespirationRate;
        }
        return _respirationRate;
    }

    /**
     * Get Heart Rate Variability (HRV)
     */
    function getHRV() {
        // HRV is typically available through SensorHistory
        // This is a simplified version
        var info = Activity.getActivityInfo();
        if (info != null && info has :currentHeartRateVariability && info.currentHeartRateVariability != null) {
            return info.currentHeartRateVariability;
        }
        return 0;
    }
}

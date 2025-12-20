using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

/**
 * Summary View
 * Shows activity summary after saving
 */
class SummaryView extends Ui.View {
    
    private var _duration;
    private var _avgHR;
    private var _minTemp;
    private var _calories;
    private var _hrHistory;
    private var _tempHistory;
    private var _calHistory;
    
    public var _pageIndex = 0; // 0=Overview, 1=HR Chart, 2=Temp Chart, 3=Cal Chart
    
    function initialize(duration, avgHR, minTemp, calories, hrHistory, tempHistory, calHistory) {
        View.initialize();
        _duration = duration;
        _avgHR = avgHR;
        _minTemp = minTemp;
        _calories = calories;
        _hrHistory = hrHistory;
        _tempHistory = tempHistory;
        _calHistory = calHistory;
    }
    
    function onLayout(dc) {
        // No layout needed
    }
    
    function onShow() {
        Ui.requestUpdate();
    }
    
    function onUpdate(dc) {
        // Clear screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        switch (_pageIndex) {
            case 0:
                drawOverview(dc);
                break;
            case 1:
                drawChart(dc, _hrHistory, "Heart Rate", Gfx.COLOR_RED, "bpm");
                break;
            case 2:
                drawChart(dc, _tempHistory, "Temperature", Gfx.COLOR_BLUE, "°C");
                break;
            case 3:
                drawChart(dc, _calHistory, "Calories", Gfx.COLOR_ORANGE, "kcal");
                break;
            default:
                drawOverview(dc);
        }
        
        // Draw page indicators
        drawPageIndicator(dc);
    }
    
    private function drawOverview(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        
        // Dynamic stats positions
        var titleY = height * 0.20; // 20% down
        var startY = height * 0.35; // 35% down
        var lineHeight = height * 0.12; // Increased spacing (12% per line)
        
        // Title
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, titleY, Gfx.FONT_SMALL, "Activity Saved!", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Summary
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        var y = startY;
        
        // Duration
        var mins = _duration / 60;
        var secs = _duration % 60;
        var durationStr = mins.format("%d") + ":" + secs.format("%02d");
        dc.drawText(width * 0.15, y, Gfx.FONT_TINY, "Duration:", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(width * 0.85, y, Gfx.FONT_TINY, durationStr, Gfx.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Heart Rate
        dc.drawText(width * 0.15, y, Gfx.FONT_TINY, "Avg HR:", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(width * 0.85, y, Gfx.FONT_TINY, _avgHR.toString() + " bpm", Gfx.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Temperature
        dc.drawText(width * 0.15, y, Gfx.FONT_TINY, "Min Temp:", Gfx.TEXT_JUSTIFY_LEFT);
        var tempStr = _minTemp > 0 ? _minTemp.format("%.1f") + " °C" : "--"; // Added space before °C
        dc.drawText(width * 0.85, y, Gfx.FONT_TINY, tempStr, Gfx.TEXT_JUSTIFY_RIGHT);
        y += lineHeight;
        
        // Calories
        dc.drawText(width * 0.15, y, Gfx.FONT_TINY, "Calories:", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(width * 0.85, y, Gfx.FONT_TINY, _calories.toString(), Gfx.TEXT_JUSTIFY_RIGHT);
    
        // Hint
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height * 0.85, Gfx.FONT_XTINY, "Scroll for details", Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    private function drawChart(dc, data, title, color, unit) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Dynamic margins (15% side margin for round screens)
        var marginX = width * 0.15;
        var marginY = height * 0.15;
        
        var graphHeight = height - (marginY * 2.5); // Leave space for title/axis
        var graphWidth = width - (marginX * 2);
        
        var x = marginX;
        var y = marginY + (height * 0.05); // Start slightly lower
        
        // Title
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width/2, height * 0.1, Gfx.FONT_SMALL, title, Gfx.TEXT_JUSTIFY_CENTER);
        
        if (data == null || data.size() < 2) {
            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
            dc.drawText(width/2, height/2, Gfx.FONT_SMALL, "Not enough data", Gfx.TEXT_JUSTIFY_CENTER);
            return;
        }
        
        // Find min/max
        var min = 9999.0;
        var max = -9999.0;
        for(var i=0; i<data.size(); i++) {
            var val = data[i];
            if (val < min) { min = val; }
            if (val > max) { max = val; }
        }
        
        // Add padding to range
        var range = max - min;
        if (range < 1) { range = 1.0; } // Prevent div by zero
        
        // Draw axis labels
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(width - (marginX/2), y, Gfx.FONT_XTINY, max.format("%.0f"), Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(width - (marginX/2), y + graphHeight, Gfx.FONT_XTINY, min.format("%.0f"), Gfx.TEXT_JUSTIFY_RIGHT);
        
        // Draw graph
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        // Fix pen width for high res screens
        var penWidth = (width > 300) ? 3 : 2;
        dc.setPenWidth(penWidth);
        
        var xStep = graphWidth.toFloat() / (data.size() - 1);
        var prevX = x;
        var prevY = y + graphHeight - ((data[0] - min) / range * graphHeight);
        
        for(var i=1; i<data.size(); i++) {
            var curX = x + (i * xStep);
            var curY = y + graphHeight - ((data[i] - min) / range * graphHeight);
            
            dc.drawLine(prevX, prevY, curX, curY);
            
            prevX = curX;
            prevY = curY;
        }
    }
    
    private function drawPageIndicator(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width/2;
        var bottomY = height - 15;
        
        for (var i=0; i<4; i++) {
            var x = centerX + ((i-1.5) * 15);
            if (i == _pageIndex) {
                 dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
                 dc.fillCircle(x, bottomY, 4);
            } else {
                 dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
                 dc.fillCircle(x, bottomY, 3);
            }
        }
    }
}

/**
 * Summary Delegate
 * Handles input on summary screen
 */
class SummaryDelegate extends Ui.BehaviorDelegate {
    
    private var _view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }
    
    function onSelect() {
        Sys.exit();
    }
    
    function onBack() {
        Sys.exit();
    }
    
    // Handle Page changes with Up/Down or tap
    function onNextPage() {
        changePage(1);
        return true;
    }
    
    function onPreviousPage() {
        changePage(-1);
        return true;
    }
    
    private function changePage(dir) {
        var newIndex = _view._pageIndex + dir;
        if (newIndex >= 0 && newIndex <= 3) {
            _view._pageIndex = newIndex;
            Ui.requestUpdate();
        }
    }
    
    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        if (key == Ui.KEY_DOWN || key == 8) {
            changePage(1);
            return true;
        } else if (key == Ui.KEY_UP || key == 13) {
            changePage(-1);
            return true;
        } else if (key == Ui.KEY_ENTER || key == Ui.KEY_START || key == 4) {
            Sys.exit();
        }
        return false;
    }
}

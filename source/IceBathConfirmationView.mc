using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

/**
 * Custom Confirmation View
 * Implements "Sure to delete?" with custom button prompts
 */
class IceBathConfirmationView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        
        // Warning Icon or Text
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 40, Gfx.FONT_MEDIUM, "Sure to delete?", Gfx.TEXT_JUSTIFY_CENTER);
        
        // Custom Button Hints
        
        // Back Button Hint (Bottom Right usually, but device specific)
        // We'll draw generic hints "Back: Yes", "Down: No"
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        // "YES" hint (associated with Back button - typically bottom right physical)
        dc.drawText(width - 40, centerY + 40, Gfx.FONT_TINY, "Back: YES", Gfx.TEXT_JUSTIFY_RIGHT);
        
        // "NO" hint (associated with Down button - typically bottom left physical)
        dc.drawText(40, centerY + 40, Gfx.FONT_TINY, "Down: NO", Gfx.TEXT_JUSTIFY_LEFT);
    }
}

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

/**
 * Delegate to handle Discard Confirmation
 */
class IceBathDiscardDelegate extends Ui.BehaviorDelegate {
    
    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // Handle Back button - mapped to YES (Discard)
    function onBack() {
        // CONFIRM YES logic
        if (_view != null) {
            _view.discardActivity();
        }
        Sys.exit();
        return true;
    }
    
    // Handle Key events
    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        
        // DOWN button - mapped to NO (Cancel)
        if (key == Ui.KEY_DOWN || key == 8) {
             // CONFIRM NO logic -> Pop view to return to app
             Ui.popView(Ui.SLIDE_IMMEDIATE);
             return true;
        }
        
        // Handle physical BACK button if onBack doesn't catch it (some devices)
        if (key == Ui.KEY_ESC || key == 5) {
            onBack();
            return true;
        }
        
        return false;
    }
}

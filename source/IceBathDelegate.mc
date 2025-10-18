using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

/**
 * IceBath Input Delegate
 * Handles user input (button presses, menu navigation)
 */
class IceBathDelegate extends Ui.BehaviorDelegate {

    private var _view;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    /**
     * Set the view reference
     */
    function setView(view) {
        _view = view;
    }

    /**
     * Handle the select button (start/stop)
     */
    function onSelect() {
        if (_view != null) {
            if (_view._isRecording) {
                _view.stopRecording();
                showRecordingMenu();
            } else {
                _view.startRecording();
            }
        }
        return true;
    }

    /**
     * Handle back button
     */
    function onBack() {
        if (_view != null && _view._isRecording) {
            _view.addLap();
            return true;
        }
        return false; // Allow default back behavior (exit) if not recording
    }

    function showRecordingMenu() {
        var menu = new Ui.Menu2({:title=>"IceBath"});
        menu.addItem(new Ui.MenuItem(Rez.Strings.Resume, null, :resume, {}));
        menu.addItem(new Ui.MenuItem(Rez.Strings.Save, null, :save, {}));
        menu.addItem(new Ui.MenuItem(Rez.Strings.Discard, null, :discard, {}));
        menu.addItem(new Ui.MenuItem(Rez.Strings.Exit, null, :exit, {}));
        Ui.pushView(menu, new IceBathMenuDelegate(_view), Ui.SLIDE_UP);
    }

    /**
     * Handle menu button (open settings)
     */
    function onMenu() {
        return false; // Let system handle menu
    }

    /**
     * Handle key presses
     */
    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        
        // Debug: print all key codes
        Sys.println("Key pressed: " + key);
        
        // Key 4 is the SELECT button on FR970
        if (key == 4) {
            if (_view != null) {
                if (_view._isRecording) {
                    _view.stopRecording();
                    showRecordingMenu();
                } else {
                    _view.startRecording();
                }
            }
            return true;
        }
        
        // Key 5 is the BACK button
        if (key == 5) {
            if (_view != null && _view._isRecording) {
                _view.addLap();
                return true;
            }
            return false;
        }
        
        // UP button - try multiple key codes
        if (key == 13 || key == Ui.KEY_UP) {
            Sys.println("UP button detected!");
            if (_view != null && _view._isRecording) {
                // Add a lap marker
                Sys.println("LAP marked");
                Ui.requestUpdate();
            }
            return true;
        }
        
        // DOWN button
        if (key == 8 || key == Ui.KEY_DOWN) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Handle next page (UP button alternative)
     */
    function onNextPage() {
        Sys.println("onNextPage called (UP button)");
        if (_view != null && _view._isRecording) {
            Sys.println("LAP marked via onNextPage");
            Ui.requestUpdate();
        }
        return true;
    }
    
    /**
     * Handle previous page (DOWN button alternative)
     */
    function onPreviousPage() {
        return true;
    }
}

/**
 * Menu Delegate for Save/Discard options
 */
class IceBathMenuDelegate extends Ui.Menu2InputDelegate {
    
    private var _view;

    function initialize(view) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    function onSelect(item) {
        var id = item.getId();
        
        if (id == :save) {
            if (_view != null) {
                _view.saveActivity();
            }
            // Do NOT pop view here. saveActivity calls switchToView, which replaces the menu.
            // If we pop, we would pop the new SummaryView and return to the main view.
        } else if (id == :discard) {
            // Show custom confirmation dialog
            // Back = Yes, Down = No
            var dialog = new IceBathConfirmationView();
            Ui.switchToView(dialog, new IceBathDiscardDelegate(_view), Ui.SLIDE_IMMEDIATE);
        } else if (id == :exit) {
            // Exit directly without saving
            Ui.popView(Ui.SLIDE_DOWN);
            Sys.exit();
        } else if (id == :resume) {
            // Resume recording
            if (_view != null) {
                _view.startRecording();
            }
            Ui.popView(Ui.SLIDE_DOWN);
        }
    }
}

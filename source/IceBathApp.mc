using Toybox.Application as App;
using Toybox.WatchUi as Ui;

/**
 * IceBath Application
 * Main application class for cold water swimming and ice bath activities
 */
class IceBathApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    /**
     * onStart() is called on application start up
     */
    function onStart(state) {
    }

    /**
     * onStop() is called when your application is exiting
     */
    function onStop(state) {
    }

    /**
     * Return the initial view of your application here
     */
    function getInitialView() {
        var view = new IceBathView();
        var delegate = new IceBathDelegate();
        delegate.setView(view);
        return [view, delegate];
    }

}

/**
  * glance
  * A simple, and efficient image viewer written in GTK 3 and D.
  * @Authors: dhilln, dhilln@github.com
  * @License: MIT, see LICENSE
  **/

module mainwindow;

/// Phobos imports
import std.stdio;
import std.string : toStringz;
import std.typecons;
import core.time;
import core.thread.osthread;
import std.functional : toDelegate;

import image;

class MainWindow {    
    // dscanner disable
    import gtk.Builder;
    import gtk.Widget;
    import gdk.Rectangle;
    import gdk.Event;
    import cairo.Context;

    import glib.Timeout;
    import gobject.Signals;

    import gtk.Window, gtk.FileChooserDialog;
    import gtk.Container, gtk.HeaderBar, gtk.ScrolledWindow, gtk.Viewport;
    import gtk.Button, gtk.Image, gtk.ComboBox, gtk.ComboBoxText;
    
    private string _imagePath;
    private ScalingMode _scalingMode = ScalingMode.stretch;

    /// Returns the image path
    public @property string imagePath() { 
        return _imagePath; 
    }
    
    /// Sets the image path
    public @property void imagePath(string path) {
        _imagePath = path;
    }

    /// Returns the scaling mode
    public @property ScalingMode scalingMode() {
        return _scalingMode;
    }

    /// Sets the scaling mode
    public @property void scalingMode(ScalingMode mode) {
        _scalingMode = mode;
    }

    /// UI elements
    private Window window;
    private Builder builder;
    private HeaderBar headerBar;
    private ComboBoxText aspectCombo;
    private ScrolledWindow scrolledWindow;
    private Viewport viewPort;
    private Image imageView;

    public this() {
        builder = new Builder();

        // Load the UI file
	    builder.addFromFile("ui.glade");

        // Get the widgets
        window = cast(Window) builder.getObject("mainWindow");
        headerBar =  cast(HeaderBar) builder.getObject("headerBar");
        scrolledWindow = cast(ScrolledWindow) builder.getObject("scrolledWindow");
        viewPort = cast(Viewport) builder.getObject("viewPort");
        imageView = cast(Image)  builder.getObject("imageView");
        aspectCombo = cast(ComboBoxText) builder.getObject("aspectCombo");
 
        headerBar.setTitle("glance");
        headerBar.setSubtitle("Nothing open");

        version(Windows) {
            // Disable client side decorations on Windows
            window.setDecorated(false);
        }

        // Connect resize event
        scrolledWindow.addOnSizeAllocate(toDelegate(&onSizeAllocate));

        auto openButton = cast(Button) builder.getObject("openButton");
        openButton.addOnClicked(toDelegate(&openButtonPressed));

        aspectCombo.setActive(0);

        window.showAll();
    }

    private void onSizeAllocate(Allocation alloc, Widget widget) {
        // Sanity check to make sure that an image is loaded
        if (imagePath !is null) {
            writefln("image path: %s", imagePath);

            auto scaledImage = scaleImage(imagePath, scrolledWindow, ScalingMode.stretch);
            imageView.setFromPixbuf(scaledImage);
        }
    }

    private void openButtonPressed(Button btn) {
        // Create the dialog
        auto dialog =  new FileChooserDialog(
            "Open Image",
            window,
            FileChooserAction.OPEN,
            ["Cancel", "Ok"],
            [ResponseType.CANCEL, ResponseType.OK]
        );

        const auto response = dialog.run();
        if (response == ResponseType.OK) {
            // Load the image
            imagePath = dialog.getFilename();

            // Update header bar
            headerBar.setSubtitle(imagePath);

            auto scaledImage = scaleImage(imagePath, scrolledWindow, ScalingMode.stretch);
            imageView.setFromPixbuf(scaledImage);

            // Close the dialog after loading
            dialog.close();
        }
        else if (response == ResponseType.CANCEL) {
            // Close the dialog
            dialog.close();
        }
    }

    private void onAspectChanged(ComboBoxText combo) {
	    string selected = combo.getActiveText();
	    writefln("new value %s", selected);
    }
}
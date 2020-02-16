/**
  * glance
  * A simple, and efficient image viewer written in GTK 3 and D.
  * Authors: dhilln, dhilln@github.com
  * License: MIT, see LICENSE
  **/

module mainwindow;

/// Phobos imports
import std.stdio;
import std.string : toStringz;
import std.typecons;
import std.functional : toDelegate;

import image;

class MainWindow {    
    // dscanner disable
    import gtk.Builder;
    import gtk.Widget;
    import gdk.Rectangle;
    import gdk.Event;
    import cairo.Context;

    import gobject.Signals;

    import gtk.Window, gtk.FileChooserDialog;
    import gtk.Container, gtk.HeaderBar;
    import gtk.Button, gtk.Image, gtk.ComboBox, gtk.ComboBoxText;
    
    private string _imagePath;
    private ScalingMode _scalingMode = ScalingMode.stretch;
    private Nullable!int _timerId;
    private ulong _sizeAllocateEventId;
    private GdkRectangle _rememberedSize;

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
    private Image imageView;

    public this() {
        builder = new Builder();

        // Load the UI file
	    builder.addFromFile("ui.glade");

        // Get the window
        window = cast(Window) builder.getObject("mainWindow");
        headerBar =  cast(HeaderBar) builder.getObject("headerBar");

        headerBar.setTitle("glance");
        headerBar.setSubtitle("Nothing open");

        // Connect needed events
        //window.addOnCheckResize(toDelegate(&onWindowResize));
        //imageView.addOnSizeAllocate(toDelegate(&onSizeAllocate));
        //Signals.connect(window, "size-allocate", toDelegate(&onSizeAllocate));
        
        auto openButton = cast(Button) builder.getObject("openButton");
        openButton.addOnClicked(toDelegate(&openButtonPressed));

        imageView = cast(Image)  builder.getObject("imageView");
        aspectCombo = cast(ComboBoxText) builder.getObject("aspectCombo");

        //imageView.addOnDraw(toDelegate(&onImageViewDraw));

        //aspectCombo.addOnChanged(toDelegate(&onAspectChanged));
        aspectCombo.setActive(0);

        window.showAll();
    }

    private void onSizeAllocate(Event event, Widget widget) {
        // Don't install a second timer
        if (!_timerId.isNull()) {
            return;
        }

        // TODO: Figure out a way to detect when the window resize finished

        // Store remembered size and disconnect the event
        //_rememberedSize = GdkRectangle(0, 0, width, height);

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

        // TODO: Make this shit centered
        //dialog.setTransientFor(mainWindow);
        //dialog.setPosition(WindowPosition.CENTER_ON_PARENT);

        const auto response = dialog.run();
        if (response == ResponseType.OK) {
            // Load the image
            string fileName = dialog.getFilename();
            imagePath = fileName;
            //imageView.setFromFile(fileName);

            // Update header bar
            headerBar.setSubtitle(imagePath);

            auto scaledImage = imageWithScalingMode(fileName, window, scalingMode);
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
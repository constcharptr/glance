/**
  * glance
  * A simple, and efficient image viewer written in GTK 3 and D.
  *
  * @Description: Provides useful image manipulation functions.
  * @Authors: dhilln, dhilln@github.com
  * @License: MIT, see LICENSE
  **/

module image;

import gtk.Window;
import gtk.ScrolledWindow;
import gtk.Image;
import gdk.Gdk;
import gdk.Pixbuf;

/// Enumeration of scaling modes
enum ScalingMode: string {
    stretch = "Stretch",
    center = "Center"
}

Pixbuf zoomImage(Pixbuf originalPixbuf, int scale) {
    import std.conv : to;

    Pixbuf zoomedPixbuf;

    int width = originalPixbuf.getWidth();
    int height = originalPixbuf.getHeight();

    int newWidth = (width * scale);
    int newHeight = (height * scale);
    zoomedPixbuf = originalPixbuf.scaleSimple(newWidth, newHeight, GdkInterpType.BILINEAR);

    return zoomedPixbuf;
}

Pixbuf scaleImage(string imagePath, ScrolledWindow scroll, ScalingMode mode) {
    import std.stdio : writefln;

    auto pixbuf = new Pixbuf(imagePath);
    assert(pixbuf !is null);

    Pixbuf scaledPixbuf;

    // Get scrolled window size
    GtkAllocation size;
    int baseline;
    scroll.getAllocatedSize(size, baseline);

    // Scale based of the current scaling mode
    // stretch - stretch the image to fill the window
    // center - center the image inside the window (do nothing)

    if (mode == ScalingMode.stretch) {
        scaledPixbuf = pixbuf.scaleSimple(size.width, size.height, GdkInterpType.BILINEAR);
    }
    else if (mode == ScalingMode.center) {
        // Return the original pixbuf
        scaledPixbuf = pixbuf;
    }

    assert(scaledPixbuf !is null);
    return scaledPixbuf;
}
/**
  * glance
  * A simple, and efficient image viewer written in GTK 3 and D.
  * Authors: dhilln, dhilln@github.com
  * License: MIT, see LICENSE
  **/

module image;

import gtk.Window;
import gtk.Image;
import gdk.Gdk;
import gdk.Pixbuf;

enum ScalingMode: string {
    stretch = "Stretch",
    fill = "Fill",
    center = "Center"
}

Pixbuf imageWithScalingMode(string imagePath, Window window, ScalingMode mode) {
    auto pixbuf = new Pixbuf(imagePath);
	
    // Get window size
    int width, height;
    window.getSize(width, height);

    if (mode == ScalingMode.stretch) {
        // Scale to stretch the image across the window
        pixbuf = pixbuf.scaleSimple(width, height, GdkInterpType.BILINEAR);
	    return pixbuf;
    }
    else { 
        // TODO: Need to handle other scaling modes here
        return null;
    }
}

/*
int width, height;
	    window.getSize(width, height);

        writefln("window size allocate, new size is: %d x %d", width, height);

        if (imagePath !is null) {
            writefln("image path: %s", imagePath);

            auto scaledImage = imageWithScalingMode(imagePath, window, scalingMode);
            imageView.setFromPixbuf(scaledImage);
        }
*/
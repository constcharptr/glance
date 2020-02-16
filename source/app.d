/**
  * glance
  * A simple, and efficient image viewer written in GTK 3 and D.
  * Authors: dhilln, dhilln@github.com
  * License: MIT, see LICENSE
  **/

/// Phobos imports
import std.stdio;
import std.string : toStringz;
import std.functional : toDelegate;
import image;
import mainwindow;

/// GTK imports
import gtk.Main;

/// GDK imports
import gdk.Gdk;
import gdk.Pixbuf;

void main(string[] args) {
	Main.init(args);
	MainWindow win = new MainWindow();
	Main.run();
}
 
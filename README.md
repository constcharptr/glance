# glance
A simple, and efficient image viewer written in GTK 3 and D.

## Usage on Linux/OSX 
```
dub build
chmod +x glance
glance
```

By default, running this command will produce a file called `glance` in the folder `glance`, if you wish to use this commonly it may be useful to either symlink or copy it to `/usr/local/bin`.

To copy it, you can run `cp glance /usr/local/bin/glance`.

## Usage on Windows
Complete the setup for [GtkD on Windows](https://github.com/gtkd-developers/GtkD/wiki/Installing-on-Windows) and run `dub build` as normal. `glance.exe` will be built and is runnable as long as the GtkD runtime is installed on the system.

## Contributing
Read `CONTRIBUTING` for more information about how to contribute to `glance`.
# glance
A simple, and efficient image viewer written in GTK 3 and D.

## Usage on Windows
Currently, there is no support for `glance` on Windows. If you wish to add it, you may fork the repo and add it yourself. If you want to build it using WSL, follow the Linux/OSX instructions below and adjust accordingly to distribution (eg Ubuntu on Windows).

## Usage on Linux/OSX 
```
dub build
chmod +x glance
glance
```

By default, running this command will produce a file called `glance` in the folder `glance`, if you wish to use this commonly it may be useful to either symlink or copy it to `/usr/bin`.

To copy it, you can run `cp glance /usr/bin/glance`.

## Contributing
Read `CONTRIBUTING` for more information about how to contribute to `glance`.
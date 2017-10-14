ShimonBox
=========

ShimonBox is an [OpenSCAD][openscad] project aiming at providing
semi-automatically generated 3D printable cases for development boards.

[openscad]: http://www.openscad.org


Supported boards
----------------

| Board name                                   | Preview                                          |
| -------------------------------------------- | ------------------------------------------------ |
| [BeagleBone Black](boards/bbb.scad)          | ![BeagleBone Black](boards/gif/bbb.gif)          |


Usage
-----

To make all the `.stl` files, run `make`. The resulting files will be found in
the [cases/](cases) directory.

If you're looking at building individual parts, you can use `make
cases/<board>-<part>.stl` where `<board>` is the board name and `<part>` is the
part you want to build (`bottom`, `top`, or `button`).

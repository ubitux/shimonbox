ShimonBox
=========

ShimonBox is an [OpenSCAD][openscad] project aiming at providing
semi-automatically generated 3D printable cases for development boards.

Note: the project is still experimental so the cases may not fit properly the
boards yet. Refer to the "Status" column below.

[openscad]: http://www.openscad.org


Supported boards
----------------

| Board name                                   | Preview                                          |
| -------------------------------------------- | ------------------------------------------------ |
| [BeagleBone Black](boards/bbb.scad)          | ![BeagleBone Black](boards/gif/bbb.gif)          |
| [Cubieboard](boards/cubieboard.scad)         | ![Cubieboard](boards/gif/cubieboard.gif)         |
| [Hikey (LeMaker)](boards/hikey.scad)         | ![Hikey](boards/gif/hikey.gif)                   |
| [NanoPi Neo 2](boards/nanopi_neo2.scad)      | ![NanoPi Neo 2](boards/gif/nanopi_neo2.gif)      |
| [Orange Pi Zero](boards/orangepi_zero.scad)  | ![Orange Pi Zero](boards/gif/orangepi_zero.gif)  |
| [Raspberry Pi 3](boards/rpi3.scad)           | ![Raspberry Pi 3](boards/gif/rpi3.gif)           |


Corresponding cases
-------------------

| Board name                                   | Preview                                          | Status                                                                                   |
| -------------------------------------------- | ------------------------------------------------ | ---------------------------------------------------------------------------------------- |
| [BeagleBone Black](cases/bbb.scad)           | ![BeagleBone Black](cases/gif/bbb.gif)           | [VERIFIED](pics/bbb.jpg):<br />![BeagleBone Black](pics/small/bbb.jpg)                   |
| [Cubieboard](cases/cubieboard.scad)          | ![Cubieboard](cases/gif/cubieboard.gif)          | [VERIFIED](pics/cubieboard.jpg):<br />![Cubieboard](pics/small/cubieboard.jpg)            |
| [Hikey (LeMaker)](cases/hikey.scad)          | ![Hikey](cases/gif/hikey.gif)                    | [VERIFIED](pics/hikey.jpg):<br />![Hikey](pics/small/hikey.jpg)                          |
| [NanoPi Neo 2](cases/nanopi_neo2.scad)       | ![NanoPi Neo 2](cases/gif/nanopi_neo2.gif)       | [VERIFIED](pics/nanopi_neo2.jpg):<br />![NanoPi Neo 2](pics/small/nanopi_neo2.jpg)       |
| [Orange Pi Zero](cases/orangepi_zero.scad)   | ![Orange Pi Zero](cases/gif/orangepi_zero.gif)   | [VERIFIED](pics/orangepi_zero.jpg):<br />![Orange Pi Zero](pics/small/orangepi_zero.jpg) |
| [Raspberry Pi 3](cases/rpi3.scad)            | ![Raspberry Pi 3](cases/gif/rpi3.gif)            | [VERIFIED](pics/rpi3.jpg):<br />![Raspberry Pi 3](pics/small/rpi3.jpg)                   |


Usage
-----

To make all the `.stl` files, run `make`. The resulting files will be found in
the [cases/](cases) directory.

If you're looking at building individual parts, you can use `make
cases/<board>-<part>.stl` where `<board>` is the board name and `<part>` is the
part you want to build (`bottom`, `top`, or `button`).

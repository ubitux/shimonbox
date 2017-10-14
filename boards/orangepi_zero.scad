// Copyright (c) 2017 Clément Bœsch <u pkh.me>
//
// Permission to use, copy, modify, and distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

include <../globals.scad>

use <../case.scad>
use <../utils.scad>
use <../electronics/header.scad>
use <../electronics/misc.scad>
use <../electronics/network.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>


board_dim = [48, 46, 1.5];


/* Plate holes */
hole_d = 3;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 2;
hole_pad = hole_d/2 + 1.5;
hole_pad_t = [1,-1]*hole_pad;
holes_pos = [for (y=hole_pad_t+[0, board_dim[1]],
                  x=hole_pad_t+[0, board_dim[0]]) hole_orig + [x, y]];


/* Components bounding box dimensions */
antenna_dim     = [    5,     5,   60];
ethernet_dim    = [16.15, 16.15,   13];
gpio_dim        = [ 32.6,   2.5, 8.65];
microsdcard_dim = [   15,    11,    1];
microsdslot_dim = [14.75,    15,    2];
microusb_dim    = [    6,     8,    3];
pulse_dim       = [   13,     7,    6];
serial_dim      = [ 7.25,   2.5,  8.5];
usb_dim         = [14.25,    13,    7];

ethusb_dim      = [14.25,  2.35,   13]; // cleanup box


module orangepi_zero_plate_2d() {
    plate_2d(board_dim[0], board_dim[1], corner_radius=2);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [antenna_info(),        antenna_dim,     [ 0, 0,-1], [0,0,0], [ 1, 1, 0], [   -8,    -8,    0]], // arbitrary position
    [chip_info(),           pulse_dim,       [ 1,-1,-1], [0,0,1], [ 1, 1, 1], [  -26,   -15,    0]],
    [ethernet_info(),       ethernet_dim,    [ 1, 1, 1], [0,2,0], [-1, 1, 1], [   -3, -14.5,    0]],
    [microsdcard_info(),    microsdcard_dim, [ 1,-1,-1], [2,0,0], [ 1, 1,-1], [  2.5,-12.75,-0.75]],
    [microsdslot_info(),    microsdslot_dim, [ 1,-1,-1], [2,0,0], [ 1, 1,-1], [    0,   -12,    0]],
    [microusb_info(),       microusb_dim,    [ 1,-1,-1], [0,0,0], [ 1,-1, 1], [ 0.75,     6,    0]],
    [pin_header_info(),     gpio_dim,        [-1,-1,-1], [0,0,0], [-1,-1, 1], [  7.5,     0,    0]],
    [pin_header_info(),     serial_dim,      [-1, 1,-1], [0,0,0], [-1, 1, 1], [  0.2,  -8.3,    0]],
    [usb_info(),            usb_dim,         [ 1,-1,-1], [1,0,2], [-1,-1, 1], [   -3,     6,    0]],

    [unknown_info(),        ethusb_dim,      [-1,-1,-1], [0,0,0], [-1,-1, 1], [   -3,    13,    0]],
];

module orangepi_zero() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_darkblue)
        orangepi_zero_plate_2d(cut=true);

    set_components(board_dim, comp_info) {
        antenna(dim=antenna_dim);
        chip(dim=pulse_dim);
        ethernet(dim=ethernet_dim);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        microusb(dim=microusb_dim);
        pin_header_pitch254(dim=gpio_dim, n=13, m=1);
        pin_header_pitch254(dim=serial_dim, n=3, m=1);
        usb(dim=usb_dim, has_folding=false);

        %cube(ethusb_dim, center=true);
    }
}

function orangepi_zero_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];

demo_board(board_dim) {
    orangepi_zero();
    *#bounding_box(board_dim, comp_info);
}

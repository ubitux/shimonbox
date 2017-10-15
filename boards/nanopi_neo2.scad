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
use <../electronics/network.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>


board_dim = [40, 40, 1.25];


/* Plate holes */
hole_d = 3;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 1.6;
hole_pad = 2.3;
hole_pad_t = [1,-1]*hole_pad;
holes_pos = [for (y=hole_pad_t+[0, board_dim[1]],
                  x=hole_pad_t+[0, board_dim[0]]) hole_orig + [x, y]];


/* Components bounding box dimensions */
ethernet_dim    = [21.5, 15.5, 11.5];
microsdcard_dim = [  15,   11,    1];
microsdslot_dim = [11.5,   12, 1.25];
microusb_dim    = [   6,    8,    3];
serial_dim      = [10.5,  2.5,  8.5];
usb_dim         = [  14,   14,    6];

ethusb_dim      = [  14, 8.75,    3]; // cleanup box


module nanopi_neo2_plate_2d(cut=false) {
    difference() {
        plate_2d(board_dim[0], board_dim[1], corner_radius=3);

        // The plate is actually cut such that the ethernet slot is stuck in
        // the middle. We prevent displaying it in the board here, will still
        // keeping the plate shape untouched by default for the case
        if (cut)
            translate([(board_dim[0]-ethernet_dim[0])/2 + 4,
                       (board_dim[1]-ethernet_dim[1])/2 - 7])
                square([ethernet_dim[0], ethernet_dim[1]], center=true);
    }
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [ethernet_info(),       ethernet_dim,    [ 1,-1, 1], [2,0,0], [ 1, 1,-1], [  4,  -7,-1.5]],
    [microsdcard_info(),    microsdcard_dim, [ 1, 1,-1], [0,0,2], [-1,-1, 1], [ -2,   7,0.25]],
    [microsdslot_info(),    microsdslot_dim, [ 1, 1,-1], [0,0,2], [-1,-1, 1], [  2,6.50,   0]],
    [microusb_info(),       microusb_dim,    [ 1,-1,-1], [0,0,2], [-1, 1, 1], [-.5,  -6,   0]],
    [pin_header_info(),     serial_dim,      [ 1,-1,-1], [0,0,0], [ 1,-1, 1], [ -5,2.25,   0]],
    [usb_info(),            usb_dim,         [ 1,-1, 1], [1,0,0], [ 1,-1, 1], [3.5, 8.5,   0]],

    [unknown_info(),        ethusb_dim,      [ 1,-1, 1], [1,0,0], [ 1,-1, 1], [3.5,14.5,0]],
];

module nanopi_neo2() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_darkblue)
        nanopi_neo2_plate_2d(cut=true);

    set_components(board_dim, comp_info) {
        ethernet(dim=ethernet_dim, swap_led=true);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        microusb(dim=microusb_dim);
        pin_header_pitch254(dim=serial_dim, n=4, m=1);
        usb(dim=usb_dim, has_folding=false);

        %cube(ethusb_dim, center=true);
    }
}

function nanopi_neo2_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];

demo_board(board_dim) {
    nanopi_neo2();
    *#bounding_box(board_dim, comp_info);
}

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
use <../electronics/button.scad>
use <../electronics/hdmi.scad>
use <../electronics/header.scad>
use <../electronics/misc.scad>
use <../electronics/power.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>


board_dim = [85.25, 54, 1.25];


/* Plate holes */
hole_d = 2.5;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 2.5;
hole_pad = 4;
hole_pad_t = [1,-1]*hole_pad;
holes_pos = [for (y=hole_pad_t+[14.5, board_dim[1]],
                  x=hole_pad_t+[   0, board_dim[0]]) hole_orig + [x, y]];


/* Components bounding box dimensions */
capacitor_dim   = [   6,   6,   5];
cfgpins_dim     = [   6,   4,   5];
extio_dim       = [   6,  30,   4];
gpio_dim        = [40.5,   4, 4.5];
hdmi_dim        = [9.25,  15,   6];
microsdcard_dim = [  15,  11,   1];
microsdslot_dim = [15.5,  14,1.25];
microusb_dim    = [   6,   8,   3];
power_box_dim   = [  13,   9,   9]; // The box is larger to allow fitting a large round power cable
power_dim       = [  13,   9,   6];
powerbtn_dim    = [ 3.5,   3,   2];
uart0_dim       = [   4,   4,   5];
usb_dim         = [  14,14.5,   7];


module hikey_plate_2d() {
    plate_2d(board_dim[0], board_dim[1]);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [button_info(),         powerbtn_dim,    [-1, 1,-1], [0,0,0], [-1, 1, 1], [ 52.5,   -1,   0]],
    [capacitor_info(),      capacitor_dim,   [ 1, 1,-1], [0,0,0], [ 1, 1, 1], [  -19,-1.75,   0]],
    [extio_hikey_info(),    extio_dim,       [-1, 1,-1], [0,0,1], [-1,-1, 1], [   18,   12,   0]],
    [female_header_info(),  gpio_dim,        [-1, 1,-1], [0,0,0], [-1, 1, 1], [  9.5,   -2,   0]],
    [hdmi_info(),           hdmi_dim,        [ 1,-1,-1], [0,0,3], [-1,-1, 1], [ 17.5,   -2,   0]],
    [microsdcard_info(),    microsdcard_dim, [ 1,-1,-1], [0,0,3], [-1,-1, 1], [  1.5,   -2,   0]],
    [microsdslot_info(),    microsdslot_dim, [ 1,-1,-1], [0,0,3], [-1,-1, 1], [ 1.25,    0,   0]],
    [microusb_info(),       microusb_dim,    [ 1,-1,-1], [0,0,3], [-1,-1, 1], [37.75,   -1,   0]],
    [pin_header_info(),     cfgpins_dim,     [-1, 1,-1], [0,0,1], [-1,-1, 1], [    1, 40.5,   0]],
    [pin_header_info(),     uart0_dim,       [-1, 1,-1], [0,0,1], [-1,-1, 1], [    1,   36,   0]],
    [power_hikey_info(),    power_box_dim,   [ 1,-1,-1], [0,0,1], [ 1, 1, 1], [ -8.5,    0,-1.5]],
    [usb_info(),            usb_dim,         [ 1,-1,-1], [0,0,3], [-1,-1, 1], [   49,    0,   0]],
    [usb_info(),            usb_dim,         [ 1,-1,-1], [0,0,3], [-1,-1, 1], [   69,    0,   0]],
];

module hikey() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off)
        hikey_plate_2d();

    set_components(board_dim, comp_info) {
        button(dim=powerbtn_dim, pusher_type="circle");
        capacitor(dim=capacitor_dim);
        extio_hikey(dim=extio_dim);
        female_header_pitch200(dim=gpio_dim, n=20, m=2);
        hdmi(dim=hdmi_dim);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        microusb(dim=microusb_dim);
        pin_header_pitch200(dim=cfgpins_dim, n=3, m=2);
        pin_header_pitch200(dim=uart0_dim, n=2, m=2);
        power_hikey(dim=power_dim);
        usb(dim=usb_dim);
        usb(dim=usb_dim);
    }
}

function hikey_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];

demo_board(board_dim) {
    hikey();
    *#bounding_box(board_dim, comp_info);
}

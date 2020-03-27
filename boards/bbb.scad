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
use <../electronics/network.scad>
use <../electronics/power.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>


board_dim = [in2mm(3400), in2mm(2150), 1.75];


/* Plate holes */
hole_d = in2mm(125);
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 1;
holes_pos = [
    hole_orig + [in2mm( 575), in2mm(2025)],
    hole_orig + [in2mm( 575), in2mm( 125)],
    hole_orig + [in2mm(3175), in2mm( 250)],
    hole_orig + [in2mm(3175), in2mm(1900)],
];


/* Components bounding box dimensions */
button_dim      = [  4,                3,    2];
ethernet_dim    = [ 21,               16, 13.5];
gpio_dim        = [ 59,                5,  8.5];
microhdmi_dim   = [7.5, in2mm(1110- 850),    3];
microsdcard_dim = [ 15,               11,    1];
microsdslot_dim = [ 15, in2mm(1755-1205),    2];
miniusb_dim     = [7.1, in2mm(1880-1575),    4];
power_dim       = [ 14,                9,   11];
rt1_dim         = [3.5,                8, 10.5];
serial_dim      = [ 15,              2.5,  8.5];
usb_dim         = [ 14,             14.5,    8];


module beaglebone_black_plate_2d() {
    /* This is a custom 2D plate module because the corner radius are not even
     * and thus we can not use a simple minkowski() */
    l = board_dim[0];
    w = board_dim[1];
    ledgesz = in2mm(250);
    redgesz = in2mm(500);
    difference() {
        square([l, w], center=true);
        difference() {
            union() {
                translate([-l/2,           -w/2        ]) square(ledgesz);
                translate([-l/2,            w/2-ledgesz]) square(ledgesz);
                translate([ l/2 - redgesz,  w/2-redgesz]) square(redgesz);
                translate([ l/2 - redgesz, -w/2        ]) square(redgesz);
            }
            translate([-l/2 + ledgesz, -w/2 + ledgesz]) circle(ledgesz);
            translate([-l/2 + ledgesz,  w/2 - ledgesz]) circle(ledgesz);
            translate([ l/2 - redgesz,  w/2 - redgesz]) circle(redgesz);
            translate([ l/2 - redgesz, -w/2 + redgesz]) circle(redgesz);
        }
    }
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [button_info(),         button_dim,      [-1,-1,-1], [0,0,0], [-1,-1, 1], [ 74, 41.5, 0]],
    [button_info(),         button_dim,      [-1,-1,-1], [0,0,0], [-1,-1, 1], [5.5,   40, 0]],
    [button_info(),         button_dim,      [-1,-1,-1], [0,0,0], [-1,-1, 1], [5.5, 49.5, 0]],
    [ethernet_info(),       ethernet_dim,    [ 1, 1,-1], [0,0,2], [-1,-1, 1], [-in2mm(100), in2mm(855), 0]],
    [female_header_info(),  gpio_dim,        [-1, 1,-1], [0,0,0], [-1, 1, 1], [18, -0.5, 0]],
    [female_header_info(),  gpio_dim,        [-1,-1,-1], [0,0,0], [-1,-1, 1], [18,  0.5, 0]],
    [microhdmi_info(),      microhdmi_dim,   [ 1, 1,-1], [2,0,0], [ 1,-1,-1], [ in2mm(25), in2mm(850),  0]],
    [microsdcard_info(),    microsdcard_dim, [ 1,-1, 1], [0,0,0], [ 1,-1,-1], [in2mm(110), in2mm(1205)+.5, 0]],
    [microsdslot_info(),    microsdslot_dim, [ 1,-1, 1], [0,0,0], [ 1,-1,-1], [0, in2mm(1205), 0]],
    [miniusb_info(),        miniusb_dim,     [ 1, 1, 1], [0,0,2], [-1,-1,-1], [-in2mm(25), in2mm(1575), 0]],
    [pin_header_info(),     serial_dim,      [-1,-1,-1], [0,0,0], [-1,-1, 1], [41, 6, 0]],
    [power_bbb_info(),      power_dim,       [ 1, 1,-1], [0,0,2], [-1,-1, 1], [-in2mm(100), in2mm(215), 0]],
    [rt_bbb_info(),         rt1_dim,         [-1,-1,-1], [0,0,0], [-1,-1, 1], [68, 6.5, 0]],
    [usb_info(),            usb_dim,         [ 1,-1,-1], [0,0,0], [ 1,-1, 1], [0, in2mm(405) - .6, 0]],
];

module beaglebone_black() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off)
        beaglebone_black_plate_2d();

    set_components(board_dim, comp_info) {
        button(dim=button_dim, pusher_type="square");
        button(dim=button_dim, pusher_type="square");
        button(dim=button_dim, pusher_type="square");
        ethernet(dim=ethernet_dim);
        female_header_pitch254(dim=gpio_dim, n=23, m=2);
        female_header_pitch254(dim=gpio_dim, n=23, m=2);
        microhdmi(dim=microhdmi_dim, l_fold=0);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        miniusb(dim=miniusb_dim);
        pin_header_pitch254(dim=serial_dim, n=6, m=1);
        power_bbb(dim=power_dim);
        rt_bbb(dim=rt1_dim);
        usb(dim=usb_dim);
    }
}

function beaglebone_black_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];

demo_board(board_dim) {
   beaglebone_black();
   *#bounding_box(board_dim, comp_info);
}

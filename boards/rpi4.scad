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
use <../electronics/hdmi.scad>
use <../electronics/header.scad>
use <../electronics/jack.scad>
use <../electronics/misc.scad>
use <../electronics/network.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>


board_dim = [85, 56, 1.25];


/* Plate holes */
hole_d = 2.75;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 5.6 - hole_d;
hole_pad = 3.5;
holes_pos = [for (y=[0, 49], x=[0, 58]) hole_orig + [x, y] + hole_pad*[1,1]];

lusb = 17.5;
wusb = 15;
husb = 16;

/* Components bounding box dimensions */
ethernet_dim    = [21.25,   16,13.75];
gpio_dim        = [   51,    5,  8.5];
microhdmi_dim   = [  7.3,  6.5, 3.25];
jack_dim        = [ 14.5,    7,    6];
microsdcard_dim = [   15,   11,    1];
microsdslot_dim = [ 11.5,   12, 1.25];
usbc_dim        = [ 7.35,  8.94, 3.2];
serialcon_dim   = [  2.5,   22,  5.5];
usbx2_dim       = [ lusb, wusb, husb];
cpu_dim         = [   15,   15,  2.4]; // draw cpu to assist fan aligmnent

ethusb_dim      = [ lusb, 3.25, husb]; // cleanup box
usbusb_dim      = [ lusb,    3, husb]; // cleanup box


module raspberry_pi_4_plate_2d() {
    plate_2d(board_dim[0], board_dim[1], 3);
}


// 


comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [ethernet_info(),       ethernet_dim,    [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [   3,45.75,0]],
    [microhdmi_info(),      microhdmi_dim,   [ 1, 0,-1], [0,0,3], [-1,-1, 1], [  26,-1.65,0]],
    [microhdmi_info(),      microhdmi_dim,   [ 1, 0,-1], [0,0,3], [-1,-1, 1], [39.5,-1.65,0]],
    [jack_info(),           jack_dim,        [ 1, 0,-1], [0,0,3], [-1,-1, 1], [  54,   -2,0]],
    [microsdcard_info(),    microsdcard_dim, [ 1, 0,-1], [2,0,2], [-1, 0,-1], [-2.25,   0,0]],
    [microsdslot_info(),    microsdslot_dim, [ 1, 0,-1], [2,0,2], [-1, 0,-1], [ 1.75,   0,0]],
    [usbc_info(),           usbc_dim,        [ 1, 0,-1], [0,0,3], [-1,-1, 1], [11.2, -1.2,0]],
    [pin_header_info(),     gpio_dim,        [ 0, 0,-1], [0,0,0], [-1, 1, 1], [32.5, -3.5,0]],
    [serialcon_rpi_info(),  serialcon_dim,   [ 0,-1,-1], [0,0,0], [-1,-1, 1], [ 46.5, 0.5,0]], // camera
    [serialcon_rpi_info(),  serialcon_dim,   [ 1, 0,-1], [0,0,2], [-1,-1, 1], [    4,  28,0]], // display
    [usbx2_info(),          usbx2_dim,       [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [  3.2,  9, 0]],
    [usbx2_info(),          usbx2_dim,       [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [  3.2,  27,0]],
    [chip_info(),           cpu_dim,         [ 0, 0,-1], [0,0,3], [-1,-1, 1], [29.25,32.5,0]],

    [unknown_info(),        ethusb_dim,      [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [  3.2,  36,0]],
    [unknown_info(),        usbusb_dim,      [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [  3.2,  18,0]],
];

module raspberry_pi_4() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_green_pcb, clr_ring=c_yellow)
        raspberry_pi_4_plate_2d();

    set_components(board_dim, comp_info) {
        ethernet(dim=ethernet_dim, swap_led=true);
        microhdmi(dim=microhdmi_dim);
        microhdmi(dim=microhdmi_dim);
        jack(dim=jack_dim);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        usbc(dim=usbc_dim);
        pin_header_pitch254(dim=gpio_dim, n=20, m=2);
        serialcon_rpi(dim=serialcon_dim);
        serialcon_rpi(dim=serialcon_dim);
        usbx2(dim=usbx2_dim);
        usbx2(dim=usbx2_dim, clr=c_usb_blue);
        chip(dim=cpu_dim, c=c_metal);
        %cube(ethusb_dim, center=true);
        %cube(usbusb_dim, center=true);
    }
}

function raspberry_pi_4_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];


demo_board(board_dim) {
    raspberry_pi_4();
    *#bounding_box(board_dim, comp_info);
}

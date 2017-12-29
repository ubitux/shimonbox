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
use <../electronics/network.scad>
use <../electronics/sd.scad>
use <../electronics/misc.scad>
use <../electronics/usb.scad>


board_dim = [85, 56, 1.4];


/* Plate holes */
hole_d = 2.8;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 6.6 - hole_d;
holes_pos = [hole_orig + [25.3, 18],
             hole_orig + [board_dim[0] - 5, board_dim[1] - 12.4]];


/* Components bounding box dimensions */
capacitor_dim   = [  6.5,   6.5,   7.8];
ethernet_dim    = [ 21.3,    16,  13.5];
gpio_dim        = [32.75,     5,   8.5];
hdmi_dim        = [11.75,    15,   5.75];
jack_dim        = [   15,    12,    10];
microusb_dim    = [  5.6,     8,  2.75];
rca_dim         = [ 19.5,    10,    13];
sdcard_dim      = [   32,    24,     2];
sdslot_dim      = [   17, 28.35,  3.75];
serialcon_dim   = [    4,  22.3,   5.5];
usbx2_dim       = [   17, 15.35, 15.75];



module raspberry_pi_1_plate_2d() {
    plate_2d(board_dim[0], board_dim[1]);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [capacitor_info(),      capacitor_dim,   [-1,-1,-1], [0,0,0], [-1,-1, 1], [  9.6,     4,   0]],
    [ethernet_info(),       ethernet_dim,    [ 1,-1,-1], [0,0,0], [ 1,-1, 1], [    1,     2,   0]],
    [hdmi_info(),           hdmi_dim,        [ 1,-1,-1], [0,0,3], [-1,-1, 1], [36.75,    -1,   0]],
    [jack_rpi1_info(),      jack_dim,        [ 1,-1,-1], [0,0,1], [ 1, 1, 1], [-14.5,  3.15,   0]],
    [microusb_info(),       microusb_dim,    [ 1, 1,-1], [0,0,2], [-1,-1, 1], [-0.75,   3.5,   0]],
    [pin_header_info(),     gpio_dim,        [-1, 1,-1], [0,0,0], [-1, 1, 1], [ 0.85, -1.15,   0]],
    [rca_info(),            rca_dim,         [ 1, 1,-1], [0,0,1], [-1, 1, 1], [ 41.1,     7,   0]],
    [sdcard_info(),         sdcard_dim,      [ 1,-1,-1], [2,0,2], [-1,-1,-1], [-17.5,  18.5,-0.8]],
    [sdslot_info(),         sdslot_dim,      [ 1,-1,-1], [2,0,2], [-1,-1,-1], [  0.5,  15.5,   0]],
    [serialcon_rpi_info(),  serialcon_dim,   [ 1, 0,-1], [0,0,2], [-1, 0, 1], [ 9.75,     0,   0]], // display
    [serialcon_rpi_info(),  serialcon_dim,   [-1,-1,-1], [0,0,0], [-1,-1, 1], [ 57.5,  -0.4,   0]], // camera
    [usbx2_info(),          usbx2_dim,       [ 1, 1,-1], [0,0,0], [ 1, 1, 1], [  7.1,   -17,   0]],
];

module raspberry_pi_1() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_green_pcb, clr_ring=c_gold)
        raspberry_pi_1_plate_2d();

    set_components(board_dim, comp_info) {
        capacitor(dim=capacitor_dim);
        ethernet(dim=ethernet_dim, has_led=false);
        hdmi(dim=hdmi_dim);
        jack_rpi1(dim=jack_dim);
        microusb(dim=microusb_dim);
        pin_header_pitch254(dim=gpio_dim, n=13, m=2);
        rca();
        sdcard(dim=sdcard_dim);
        sdslot(dim=sdslot_dim);
        serialcon_rpi(dim=serialcon_dim, clr1=c_black);
        serialcon_rpi(dim=serialcon_dim, clr1=c_black);
        usbx2(dim=usbx2_dim);
    }
}

function raspberry_pi_1_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];


demo_board(board_dim) {
    raspberry_pi_1();
    *#bounding_box(board_dim, comp_info);
}

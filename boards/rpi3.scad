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
ring_off = 6.2 - hole_d;
hole_pad = 3.5;
holes_pos = [for (y=[0, 49], x=[0, 58]) hole_orig + [x, y] + hole_pad*[1,1]];


/* Components bounding box dimensions */
ethernet_dim    = [   21, 16, 13.5];
gpio_dim        = [   51,  5,  8.5];
hdmi_dim        = [ 11.5, 15,  6.5];
jack_dim        = [ 14.5,  7,    6];
microsdcard_dim = [   15, 11,    1];
microsdslot_dim = [ 11.5, 12, 1.25];
microusb_dim    = [    6,  8,    3];
serialcon_dim   = [  2.5, 22,  5.5];
usbx2_dim       = [17.25, 15, 16.5];


module raspberry_pi_3_plate_2d() {
    plate_2d(board_dim[0], board_dim[1], 3);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [ethernet_info(),       ethernet_dim,    [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [   2,10.25,0]],
    [hdmi_info(),           hdmi_dim,        [ 1, 0,-1], [0,0,3], [-1,-1, 1], [  32,   -1,0]],
    [jack_info(),           jack_dim,        [ 1, 0,-1], [0,0,3], [-1,-1, 1], [53.5,   -2,0]],
    [microsdcard_info(),    microsdcard_dim, [ 1, 0,-1], [2,0,2], [-1, 0,-1], [-2.25,   0,0]],
    [microsdslot_info(),    microsdslot_dim, [ 1, 0,-1], [2,0,2], [-1, 0,-1], [ 1.75,   0,0]],
    [microusb_info(),       microusb_dim,    [ 1, 0,-1], [0,0,3], [-1,-1, 1], [10.6,   -1,0]],
    [pin_header_info(),     gpio_dim,        [ 0, 0,-1], [0,0,0], [-1, 1, 1], [32.5, -3.5,0]],
    [serialcon_rpi_info(),  serialcon_dim,   [ 0,-1,-1], [0,0,0], [-1,-1, 1], [   45, .25,0]], // camera
    [serialcon_rpi_info(),  serialcon_dim,   [ 1, 0,-1], [0,0,2], [-1,-1, 1], [    3,  28,0]], // display
    [usbx2_info(),          usbx2_dim,       [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [    2,  29,0]],
    [usbx2_info(),          usbx2_dim,       [ 1, 0,-1], [0,0,0], [ 1,-1, 1], [    2,  47,0]],
];

module raspberry_pi_3() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_green_pcb, clr_ring=c_yellow)
        raspberry_pi_3_plate_2d();

    set_components(board_dim, comp_info) {
        ethernet(dim=ethernet_dim, swap_led=true);
        hdmi(dim=hdmi_dim);
        jack(dim=jack_dim);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        microusb(dim=microusb_dim);
        pin_header_pitch254(dim=gpio_dim, n=20, m=2);
        serialcon_rpi(dim=serialcon_dim);
        serialcon_rpi(dim=serialcon_dim);
        usbx2(dim=usbx2_dim);
        usbx2(dim=usbx2_dim);
    }
}

function raspberry_pi_3_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];


demo_board(board_dim) {
    raspberry_pi_3();
    *#bounding_box(board_dim, comp_info);
}

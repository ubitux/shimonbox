// Copyright (c) 2020 Ed Lafargue <ed wizkers.io>
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


board_dim = [65, 30, 1.25];


/* Plate holes */
hole_d = 2.75;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 6.2 - hole_d;
hole_pad = 3.5;
holes_pos = [for (y=[0, board_dim[1]-hole_pad*2], x=[0, board_dim[0]-hole_pad*2]) hole_orig + [x, y] + hole_pad*[1,1]];


/* Components bounding box dimensions */
gpio_dim        = [   51,  5,  8.5];
microsdcard_dim = [   15, 11,    1];
microsdslot_dim = [ 11.5, 12, 1.25];
microusb_dim    = [    6,  8,    3];

module raspberry_pi_zero_plate_2d() {
    plate_2d(board_dim[0], board_dim[1], 3);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [microsdcard_info(),    microsdcard_dim, [ 1, 0,2], [2,0,2], [-1, -1,-1], [-2.25,   16.9,0]],
    [microsdslot_info(),    microsdslot_dim, [ 1, 0,2], [2,0,2], [-1, -1,-1], [ 1.75,   16.9,0]],
    [microusb_info(),       microusb_dim,    [ 1, 0,-1], [0,0,3], [-1,-1, 1], [54,   -1,0]],
    [microusb2_info(),      microusb_dim,    [ 1, 0,-1], [0,0,3], [-1,-1, 1], [41.4,   -1,0]],
    [pin_header_info(),     gpio_dim,        [ 0, 0,-1], [0,0,0], [-1, 1, 1], [32.5, -3.5,0]],
];

module raspberry_pi_zero() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_green_pcb, clr_ring=c_yellow)
        raspberry_pi_zero_plate_2d();

    set_components(board_dim, comp_info) {
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        microusb(dim=microusb_dim);
        microusb(dim=microusb_dim);
        pin_header_pitch254(dim=gpio_dim, n=20, m=2);

    }
}

function raspberry_pi_zero_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];


demo_board(board_dim) {
    raspberry_pi_zero();
    *#bounding_box(board_dim, comp_info);
}

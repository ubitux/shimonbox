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
use <../electronics/cpu.scad>
use <../electronics/hdmi.scad>
use <../electronics/header.scad>
use <../electronics/jack.scad>
use <../electronics/misc.scad>
use <../electronics/network.scad>
use <../electronics/power.scad>
use <../electronics/sata.scad>
use <../electronics/sd.scad>
use <../electronics/usb.scad>


board_dim = [100, 60, 1.25];


/* Plate holes */
hole_d = 3;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
ring_off = 1.5;
hole_pad = 3.5;
hole_pad_t = [1,-1]*hole_pad;
holes_pos = [for (y=hole_pad_t+[   0, board_dim[1]],
                  x=hole_pad_t+[19.5, board_dim[0]]) hole_orig + [x, y]];


/* Components bounding box dimensions */
cpu_dim         = [   19,   19, 1.25];
cpurad_dim      = [   19,   19,    5];
ethernet_dim    = [   21,   16, 13.5];
fel_dim         = [  3.5,    7,  3.5];
gpio_dim        = [   50,    6,    6];
hdmi_dim        = [11.25,   15,    6];
ir_dim          = [  3.5,    5,    7];
jack_dim        = [   14,  6.5,    5];
microsdcard_dim = [   15,   11,    1];
microsdslot_dim = [14.75,   15,    2];
otg_dim         = [    9,    7,    4];
power_dim       = [   12,  7.5,    6];
powerbtn_dim    = [  3.5,    7,  3.5];
sata_5v_dim     = [  7.5,    6,  7.5];
sata_data_dim   = [   17,  6.5,    9];
serial_dim      = [10.25,  2.5,  8.5];
usbx2_dim       = [ 17.5, 14.5,   16];


module cubieboard_plate_2d() {
    plate_2d(board_dim[0], board_dim[1]);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [button_drill_info(),   fel_dim,         [-1,-1, 1], [0,1,0], [ 1,-1,-1], [   0,26.5,   0]],
    [button_drill_info(),   powerbtn_dim,    [-1, 1, 1], [0,3,0], [-1, 1, 1], [ -.5, -16,   0]],
    [cpu_info(),            cpu_dim,         [-1,-1,-1], [0,0,0], [-1,-1, 1], [47.5,  28,   0]],
    [cpurad_info(),         cpurad_dim,      [-1,-1,-1], [0,0,0], [-1,-1, 1], [47.5,  28,1.25]],
    [ethernet_info(),       ethernet_dim,    [ 1,-1,-1], [0,0,0], [ 1,-1, 1], [   4,   8,   0]],
    [hdmi_info(),           hdmi_dim,        [ 1, 1,-1], [0,0,2], [-1,-1, 1], [ -.5,  20,   0]],
    [ir_info(),             ir_dim,          [-1,-1,-1], [0,0,3], [-1, 1, 1], [13.5,  .5,   0]],
    [jack_info(),           jack_dim,        [ 1,-1, 1], [0,0,0], [ 1,-1,-1], [   2,  39,   0]], // bottom
    [jack_info(),           jack_dim,        [ 1,-1,-1], [0,0,0], [ 1,-1, 1], [   2,  39,   0]], // top
    [microsdcard_info(),    microsdcard_dim, [ 1,-1,-1], [0,0,3], [-1,-1, 1], [   5, -.5,   1]],
    [microsdslot_info(),    microsdslot_dim, [ 1,-1,-1], [0,0,3], [-1,-1, 1], [   4,1.75,   0]],
    [miniusb_info(),        otg_dim,         [ 1,-1,-1], [0,0,0], [ 1,-1, 1], [   1,26.5,   0]],
    [pin_header_info(),     gpio_dim,        [ 1, 1,-1], [2,0,0], [ 1,-1,-1], [  -6,  .5,   0]],
    [pin_header_info(),     gpio_dim,        [ 1,-1,-1], [2,0,0], [ 1, 1,-1], [  -6, -.5,   0]],
    [pin_header_info(),     serial_dim,      [-1, 1,-1], [0,0,1], [-1,-1, 1], [44.5,  17,   0]],
    [power_cubie_info(),    power_dim,       [ 1,-1,-1], [0,0,2], [-1, 1, 1], [   0,-2.5,   0]],
    [sata_5v_info(),        sata_5v_dim,     [-1,-1,-1], [0,0,0], [-1,-1, 1], [  18,  47,   0]],
    [sata_data_info(),      sata_data_dim,   [ 1,-1,-1], [0,0,2], [-1, 1, 1], [  27,   0,   0]],
    [usbx2_info(),          usbx2_dim,       [ 1,-1,-1], [0,0,3], [-1,-1, 1], [  29, -.5,   0]],
];

module cubieboard() {
    // TODO: ring $fn=8
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off)
        cubieboard_plate_2d();

    set_components(board_dim, comp_info) {
        button(dim=fel_dim);
        button(dim=powerbtn_dim);
        cpu(dim=cpu_dim);
        cpurad(dim=cpurad_dim);
        ethernet(dim=ethernet_dim);
        hdmi(dim=hdmi_dim);
        ir(dim=ir_dim);
        jack(dim=jack_dim);
        jack(dim=jack_dim);
        microsdcard(dim=microsdcard_dim);
        microsdslot(dim=microsdslot_dim);
        miniusb(dim=otg_dim);
        pin_header_pitch200(dim=gpio_dim, n=24, m=2);
        pin_header_pitch200(dim=gpio_dim, n=24, m=2);
        pin_header_pitch254(dim=serial_dim, n=4, m=1);
        power_cubie(dim=power_dim);
        sata_5v(dim=sata_5v_dim);
        sata_data(dim=sata_data_dim);
        usbx2(dim=usbx2_dim);
    }
}

function cubieboard_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];

demo_board(board_dim) {
    cubieboard();
    *#bounding_box(board_dim, comp_info);
}

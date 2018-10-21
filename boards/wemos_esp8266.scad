// Copyright (c) 2018 Dan Kortschak <dan@kortschak.io>
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
use <../electronics/usb.scad>
use <../electronics/misc.scad>


board_dim = [34.5, 25.75, 1];


/* Plate holes */
hole_d = 1;
hole_orig = [board_dim[0], board_dim[1]] * -.5;
hole_off = 8;
pitch = 2.54;
ring_off = 0.5;
hole_pad = 1;
hole_pad_t = [1,1]*hole_pad;
holes_pos = [for (y=hole_pad_t+[0, board_dim[1]-2], x=hole_pad_t+[hole_off, hole_off+7*pitch])
    hole_orig + [x, y]];


/* Components bounding box dimensions */
controller_dim    = [15, 12, 3 ];
power_dim        = [10, 4, 1.5 ];
antenna_dim      = [7.5, 16, 1 ];
antenna_led_dim = [1, 1, 0.2 ];
microusb_dim     = [ 6, 9.5, 5.5 ];
reset_dim         = [ 4.5, 2, 3 ];
reset_recess_dim  = [ 7, 2 ];
pusher_dim       = 1;


module wemos_esp8266_plate_2d(cut=false) {
    if (cut) {
        difference() {
            plate_2d(board_dim[0], board_dim[1], corner_radius=3);
        
            translate([-board_dim[0]/2, -board_dim[1]/2])
                square(reset_recess_dim);
        }
    } else {
        union() {
            plate_2d(board_dim[0], board_dim[1], corner_radius=3);
        
            translate([-board_dim[0]/2, -board_dim[1]/2])
                square(reset_recess_dim+[0, 2]);
        }
    }
    translate([-board_dim[0]/2, board_dim[1]/2-3])
        square([3,3]);
}

comp_info = [
    /* info function        box dimensions   comp-corner rotate  board-corner    position  */
    [cpu_info(),            controller_dim,  [ 1,-1,-1], [0,0,2], [-1, 1, -1], [12, -7, -controller_dim[2]]],
    [chip_info(),           power_dim,       [ 1,-1,-1], [0,0,3], [-1, 1, 1],  [10, -19, 0]],
    [antenna_info(),        antenna_dim,     [ 1,-1,-1], [0,0,2], [1, 1, -1],  [-antenna_dim[0], -5, -antenna_dim[2]]],
    [led_info(),            antenna_led_dim, [ 1,-1,-1], [0,2,0], [1, 1, -1],  [-antenna_dim[0], -7.5, -antenna_dim[2]]],
    [microusb_info(),       microusb_dim,    [ 1,-1,-1], [0,0,2], [-1, 1, 1],  [0, -8.5, -1.25]],
    [button_drill_info(),   reset_dim,       [ 1,-1,-1], [3,0,2], [-1, -1, 1], [1, reset_dim[2]+reset_recess_dim[1]-pusher_dim, 2]],
];

module wemos_esp8266() {
    extrude_plate(board_dim[2], holes_pos, hole_d, ring_off, clr=c_darkblue)
        wemos_esp8266_plate_2d(true);

    set_components(board_dim, comp_info) {
        cpu(dim=controller_dim, clr=c_metal);
        chip(dim=power_dim);
        antenna(dim=antenna_dim);
        led(dim=antenna_led_dim);
        microusb(dim=microusb_dim);
        button(dim=reset_dim, pusher_h=pusher_dim);
    }
}

function wemos_esp8266_info() = [
    ["board_dim",  board_dim],
    ["components", comp_info],
    ["holes_d",    hole_d],
    ["holes_pos",  holes_pos],
];

demo_board(board_dim) {
    wemos_esp8266();
    *#bounding_box(board_dim, comp_info);
}

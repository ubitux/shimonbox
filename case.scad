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

include <globals.scad>
include <boards.scad>
use <utils.scad>

case_thickness  = 1.2;
breath_padding  = 1;
contact_padding = .2;

/* Centered top of the buttons looking at the sky, and their dimensions */
function _get_buttons_pushers_pos_dim(board_dim, cfg, info) = [
    let(comp_info_list = map_get(info, "components"))

    for (comp_info = comp_info_list)
        let(meta         = comp_info[0],
            dim          = comp_info[1],
            corner_comp  = comp_info[2],
            rot          = comp_info[3],
            corner_board = comp_info[4],
            position     = comp_info[5],
            category     = map_get(meta, "category"))

        if (category == "button" && [rot[0], rot[1]] == [0, 0])
            let(rz             = comp_info[3][2] * 90,
                rotm           = [[cos(rz),sin(rz),0], [-sin(rz),cos(rz),0], [0,0,1]],
                corner_pos     = pmul(corner_comp, dim) * -.5,
                postrotate_pos = corner_pos * rotm,
                board_pos      = pmul(corner_board, board_dim) * .5,
                centered_pos   = postrotate_pos + position + board_pos,
                pos            = centered_pos + [0, 0, dim[2]/2])

            [pos, dim]
];

module _vents(vents, w=2.1) {
    if (vents != []) {
        dim = map_get(vents, "dim");
        pos = map_get(vents, "pos");

        length = dim[1];
        n_segments = floor(length / w);
        n_vents    = ceil(n_segments / 2);
        n_segwalls = n_segments - n_vents;
        n_walls    = n_segwalls - (n_segwalls == n_vents ? 1 : 0);
        off        = (length - (n_vents+n_walls)*w) / 2;
        start      = -length/2 + off + w/2;
        translate(pos) {
            intersection() {
                circle(d=max(dim));
                for (i = [0:n_vents-1])
                    translate([0, start + i*w*2])
                        square([dim[0], w], center=true);
            }
        }
    }
}

module _case_plate_2d(case_id) {
    offset(r=case_thickness + breath_padding + _delta)
        boards_get_plate_2d(case_id);
}

module _case_top(case_id, cfg, info, z_offset, buttons_pos_dim) {
    top_border_height = 3; // XXX: maybe auto to (max_z+bp)/2 or /3?

    board_dim = map_get(info, "board_dim");
    comp_info = map_get(info, "components");
    holes_d   = map_get(info, "holes_d");
    holes_pos = map_get(info, "holes_pos");

    vents = map_get(map_get(cfg, "vents"), "top");

    difference() {
        union() {
            // plate
            linear_extrude(height=case_thickness, center=true, convexity=2) {
                difference() {
                    _case_plate_2d(case_id);
                    _vents(vents);
                }
            }

            // borders
            translate([0, 0, -case_thickness/2 - top_border_height]) {
                linear_extrude(height=top_border_height, convexity=2) {
                    difference() {
                        offset(r=breath_padding - contact_padding)
                            boards_get_plate_2d(case_id);
                        offset(r=breath_padding - contact_padding - case_thickness)
                            boards_get_plate_2d(case_id);
                    }
                }
            }

            // board carriers clippers
            h = map_get(cfg, "max_z") + breath_padding - contact_padding;
            for(pos = holes_pos) {
                translate([pos[0], pos[1], -(h+case_thickness)/2]) {
                    difference() {
                        cylinder(h=h, d=holes_d+2, center=true);
                        cylinder(h=h+_delta, d=holes_d, center=true);
                    }
                }
            }

            // button pushers borders
            for (button_pos_dim = buttons_pos_dim) {
                button_pos = button_pos_dim[0];
                button_dim = button_pos_dim[1];
                h = top_border_height;
                d = _get_button_pusher_d(button_dim) + case_thickness*2;
                translate([button_pos[0], button_pos[1], -case_thickness/2-h])
                    cylinder(h=h, d=d);
            }
        }

        translate([0, 0, -z_offset])
            bounding_box(board_dim, comp_info, breath_padding);

        for (button_pos_dim = buttons_pos_dim) {
            button_pos = button_pos_dim[0];
            button_dim = button_pos_dim[1];
            h = top_border_height + case_thickness + _delta;
            d = _get_button_pusher_d(button_dim) + contact_padding;
            translate([button_pos[0], button_pos[1], case_thickness/2-h+_delta/2])
                cylinder(h=h, d=d);
        }
    }
}

module _case_bottom(case_id, cfg, info, z_offset, bottom_border_h) {
    board_dim = map_get(info, "board_dim");
    comp_info = map_get(info, "components");
    holes_d   = map_get(info, "holes_d");
    holes_pos = map_get(info, "holes_pos");

    vents = map_get(map_get(cfg, "vents"), "bottom");

    difference() {
        union() {
            // plate
            linear_extrude(height=case_thickness, center=true) {
                difference() {
                    _case_plate_2d(case_id);
                    _vents(vents);
                }
            }

            // borders
            translate([0, 0, case_thickness/2]) {
                linear_extrude(height=bottom_border_h, convexity=2) {
                    difference() {
                        _case_plate_2d(case_id);
                        offset(r=breath_padding + _delta)
                            boards_get_plate_2d(case_id);
                    }
                }
            }

            // board carriers
            carriers_base_h = -z_offset - board_dim[2]/2 - case_thickness/2;
            for(pos = holes_pos) {
                translate([pos[0], pos[1], case_thickness/2]) {
                    l1 = carriers_base_h;
                    l  = carriers_base_h + board_dim[2] + 1;
                    w0 = holes_d/2 - contact_padding;
                    w1 = w0 + 1;
                    w2 = w0 + 2.5;
                    rotate_extrude()
                        polygon([[0, 0], [w2, 0], [w1, l1], [w0, l1], [w0, l], [0, l]]);
                }
            }
        }
        translate([0, 0, -z_offset])
            bounding_box(board_dim, comp_info, breath_padding);
    }

}

module _button_pushers(board_dim, cfg, info, buttons_pos_dim) {
    for (button_pos_dim = buttons_pos_dim) {
        button_pos = button_pos_dim[0];
        button_dim = button_pos_dim[1];
        translate(button_pos) {
            h = _get_button_pusher_base_h(cfg) - button_dim[2];
            d = _get_button_pusher_d(button_dim);
            cylinder(d=d, h=d/2);
            cylinder(d=2*d/3, h=h);
        }
    }
}

function _get_button_pusher_base_h(info) =
    map_get(info, "max_z") + breath_padding + case_thickness + 1;

function _get_button_pusher_d(button_dim) =
    max(min(button_dim[0], button_dim[1]), 3.5);

module case(name, cfg, mode="demo") {
    case_id = boards_get_id(name);
    info = boards_get_info(case_id);
    comp_info = map_get(info, "components");

    // TODO: find min_z and max_z based on the comp list when not provided
    min_z = map_get(cfg, "min_z");
    max_z = map_get(cfg, "max_z");

    board_dim = map_get(info, "board_dim");
    board_h = board_dim[2];

    bottom_border_h = min_z + max_z + breath_padding*2 + board_h;

    z_offset_base   = board_h/2 + breath_padding + case_thickness/2;
    z_offset_bottom = -z_offset_base - min_z;
    z_offset_top    =  z_offset_base + max_z;

    case_pos_bottom = [0, 0, z_offset_bottom];
    case_pos_top    = [0, 0, z_offset_top];

    buttons_pos_dim = _get_buttons_pushers_pos_dim(board_dim, cfg, info);

    if (mode == "bottom") {
        _case_bottom(case_id, cfg, info, z_offset_bottom, bottom_border_h);
    } else if (mode == "top") {
        rotate([180, 0, 0]) // flip it to be printable friendly
            _case_top(case_id, cfg, info, z_offset_top, buttons_pos_dim);
    } else if (mode == "button") {
        _button_pushers(board_dim, cfg, info, buttons_pos_dim);
    } else if (mode == "check_intersections") {
        intersection() {
            translate(case_pos_bottom)
                _case_bottom(case_id, cfg, info, z_offset_bottom, bottom_border_h);
            boards_get_board(case_id);
            translate(case_pos_top)
                _case_top(case_id, cfg, info, z_offset_top, buttons_pos_dim);
        }
    } else if (mode == "demo") {
        rotate([0, 0, $t*360]) {

            translate(case_pos_bottom)
                _case_bottom(case_id, cfg, info, z_offset_bottom, bottom_border_h);

            if (len(buttons_pos_dim)) {
                stack_animate(time=$t) {
                    boards_get_board(case_id);
                    _button_pushers(board_dim, cfg, info, buttons_pos_dim);
                    translate(case_pos_top)
                        _case_top(case_id, cfg, info, z_offset_top, buttons_pos_dim);
                }
            } else {
                stack_animate(time=$t) {
                    boards_get_board(case_id);
                    translate(case_pos_top)
                        _case_top(case_id, cfg, info, z_offset_top, buttons_pos_dim);
                }
            }

        }
    } else {
        echo(str("Unknown mode ", mode));
    }
}

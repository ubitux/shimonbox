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

function unknown_info() = [
    ["category", "unknown"],
    ["watch", "nowhere"],
];

function unknown_drill_info() = [
    ["category", "unknown"],
    ["watch", "horizon"],
];

function in2mm(v) = 2.54 * v / 100;

function pmul(v,m) = [for (i=[0:len(v)-1]) v[i] * m[i]];

function map_get(data, key) =
    let(s = search([key], data)[0])
    s == [] ? s : data[s][1];

function default_top_vents(board_dim, s=.3) = [
    ["dim", board_dim * s],
    ["pos", [0, 0]],
];

function default_bottom_vents(board_dim, s=.7) = default_top_vents(board_dim, s);

function default_vents(board_dim, bottom_s=.7, top_s=.3) = [
    ["top",     default_top_vents(board_dim, top_s)],
    ["bottom",  default_bottom_vents(board_dim, bottom_s)],
];

module set_component(board_dim, comp_info, debug=false) {
    dim          = comp_info[1];
    corner_comp  = comp_info[2];
    rot          = comp_info[3];
    corner_board = comp_info[4];
    position     = comp_info[5];

    corner_pos = pmul(corner_comp, dim) * -.5;
    board_corner_pos = pmul(corner_board, board_dim) * .5;
    tr = position + board_corner_pos;

    if (debug) {
        translate(tr) {
            color("blue")                     cylinder(h=20, d=.25, center=true);
            color("green") rotate([90, 0, 0]) cylinder(h=20, d=.25, center=true);
            color("red")   rotate([0, 90, 0]) cylinder(h=20, d=.25, center=true);
            color("pink") sphere(.5);
        }
    }

    translate(tr)
        rotate(rot * 90)
            translate(corner_pos)
                children(0);
}

module set_components(board_dim, comp_info_list, debug=false) {
    for (i = [0:len(comp_info_list)-1])
        set_component(board_dim, comp_info_list[i], debug)
            children(i);
}

module bounding_box(board_dim, comp_info_list, padding, extruded_dim=50) {
    for (comp_info = comp_info_list) {
        info = comp_info[0];
        dim  = comp_info[1];
        watch    = map_get(info, "watch");
        category = map_get(info, "category");
        // allow components to override default padding in special cases
        padding = len(comp_info)==7 ? comp_info[6] : padding;

        /* extrude mask and its inverse */
        ex_mask     = [watch == "horizon" ? 1 : 0, 0, watch == "sky" ? 1 : 0];
        ex_mask_inv = [for (i=[0:len(ex_mask)-1]) 1-ex_mask[i]];

        set_component(board_dim, comp_info) {
            box_dim = pmul(ex_mask_inv, dim) + ex_mask*extruded_dim;
            all_tr = [extruded_dim-dim[0], 0, extruded_dim-dim[2]] * .5;
            box_tr  = pmul(all_tr, ex_mask);
            translate(box_tr) {
                minkowski() {
                    cube(box_dim, center=true);
                    sphere(d=2*padding);
                }
            }
        }
    }
}

module demo_board(board_dim) {
    rotate([0, 0, $t*360])
        children();
}

module plate_2d(l, w, corner_radius=0) {
    if (!corner_radius) {
        square([l, w], center=true);
    } else {
        translate([corner_radius - l/2, corner_radius - w/2]) {
            minkowski() {
                square([l - corner_radius*2, w - corner_radius*2]);
                circle(r=corner_radius);
            }
        }
    }
}

module _hole_positions(holes_pos) {
    for (pos = holes_pos)
        translate(pos)
            children();
}

module extrude_plate(height, holes_pos=[], hole_d=1, ring_off=0, clr=c_darkgray, clr_ring=c_gold) {
    translate([0, 0, -height/2]) {
        color(clr) {
            linear_extrude(height) {
                difference() {
                    children(0);
                    _hole_positions(holes_pos)
                        circle(d=hole_d + ring_off);
                }
            }
        }
        if (ring_off) {
            color(clr_ring) {
                linear_extrude(height) {
                    _hole_positions(holes_pos) {
                        difference() {
                            circle(d=hole_d + ring_off);
                            circle(d=hole_d);
                        }
                    }
                }
            }
        }
    }
}

module stack_animate(time, pad=40, axis=[0,0,1]) {
    function slope_a(x1, y1, x2, y2) = (y1 - y2) / (x1 - x2);
    function slope_b(x1, y1, x2, y2) = (x1*y2 - x2*y1) / (x1 - x2);
    function clip_time(t, mint, maxt) = min(max(t, mint), maxt);

    for (i = [0:$children-1]) {
        start_pos = (i + 1) * pad;
        end_pos = 0;
        start_time = i / $children;
        end_time = (i + 1) / $children;
        a = slope_a(start_time, start_pos, end_time, end_pos);
        b = slope_b(start_time, start_pos, end_time, end_pos);
        t = clip_time(time, start_time, end_time);
        translate(axis * (a*t + b))
            children(i);
    }
}

module filter(id) {
    children(id);
}

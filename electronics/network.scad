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

include <_internal.scad>

$vpd = 180;

module antenna(dim=[5, 5, 60]) {
    color(c_black) {
        h_base = dim[2]/3;
        translate([0, 0, (h_base-dim[2])/2+2])
            cylinder(d=dim[0], h=dim[2]/3, center=true);
        difference() {
            cylinder(d=3, h=dim[2], center=true);
            translate([0, 0, _delta])
                cylinder(d=2.5, h=dim[2], center=true);
        }
    }
}

module ethernet(dim=[21, 16, 13.5], has_led=true, swap_led=false) {
    l = dim[0];
    w = dim[1];
    h = dim[2];

    c_green  = [.3, .9, .3];
    c_yellow = [.9, .9, .3];
    c1 = has_led ? (swap_led ? c_yellow : c_green)  : c_metal;
    c2 = has_led ? (swap_led ? c_green  : c_yellow) : c_metal;

    rotate([0, 0, 180]) translate(dim * -.5) { // XXX
        difference() {
            color(c_metal)
                cube(dim);
            translate([-_delta, 2, 0.5])
                color(c_black)
                    cube([l-5, w-4, h-3]);
        }

        color(c_black)
            for (y = [2, w-4])
                translate([0, y, 0.5])
                    cube([l-1, 2, 3]);

        color(c1)
            translate([-_delta, w-4+_delta, .5])
                cube([1, 2.5, 2]);

        color(c2)
            translate([-_delta, 1.5-_delta, .5])
                cube([1, 2.5, 2]);
    }
}

function ethernet_info() = [
    ["category", "network"],
    ["watch", "horizon"],
];

function antenna_info() = [
    ["category", "network"],
    ["watch", "nowhere"],
];

components_demo() {
    ethernet();
    antenna();
}

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

use <misc.scad>

$vpd = 200;

module jack(dim=[14.5, 7, 6]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];

    lcyl = 2;
    rotate([0, 0, 180])
    translate(dim * -.5) { // XXX
        color(c_black) {
            difference() {
                union() {
                    translate([lcyl, 0, 0])
                        cube([l-lcyl, w, h]);
                    translate([0, w/2, h/2])
                        rotate([90, 0, 90])
                            cylinder(d=h, h=lcyl);
                }
                translate([-_delta/2, w/2, h/2])
                    rotate([90, 0, 90])
                        cylinder(d=3.5, h=l+_delta);
            }
        }
    }
}

module jack_rpi1(dim=[15, 12, 10]) {
    plug(dim, clr=c_blue,
         cyl_d=6.5, cyl_l=3.5,
         cyl_clr=c_blue,
         top_pad=.1);
}

function jack_info() = [
    ["category", "jack"],
    ["watch", "horizon"],
];

function jack_rpi1_info() = [
    ["category", "jack"],
    ["watch", "horizon"],
];

components_demo() {
    jack();
    jack_rpi1();
}

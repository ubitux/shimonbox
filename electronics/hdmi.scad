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

$vpd = 150;

module hdmi(dim=[12, 15, 6]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    lowest = h - 5.25;
    hdmi_polygon_pos = [[0, h], [w, h], [w, h-3.25],
                        [w-2, lowest], [2, lowest], [0, h-3.25]];

    rotate([0, 0, 180]) // XXX
    translate(dim * -.5) { // XXX
        color(c_metal) {
            translate([7, 0, 0])
                cube([l-7, w, h]);
            rotate([90, 0, 90]) {
                linear_extrude(height=7) {
                    difference() {
                        polygon(hdmi_polygon_pos);
                        offset(r=-.5)
                            polygon(hdmi_polygon_pos);
                    }
                }
            }
        }
        color(c_black)
            translate([2, 2, 3])
                cube([7, w-2*2, 1]);
    }
}

module microhdmi(dim=[7.5, 6.5, 3]) {
    // TODO
    l = dim[0];
    w = dim[1];
    h = dim[2];
    t = .25;
    rotate([0, 0, 180]) // XXX
    color(c_metal) {
        difference() {
            cube(dim, center=true);
            translate([-t/2,0,0])
                cube([l,w-t,h-t], center=true);
        }
    }


    //    cube(dim, center=true);
}

function hdmi_info() = [
    ["category", "hdmi"],
    ["watch", "horizon"],
];
function microhdmi_info() = hdmi_info();

components_demo() {
    hdmi();
    microhdmi();
}

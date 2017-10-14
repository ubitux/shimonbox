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

module power_bbb(dim=[14, 9, 11]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];

    l1 = 3.5;
    l0 = l - l1;
    h0 = 6.5;

    rotate([0, 0, 180]) translate(dim * -.5) { // XXX
        color(c_black) {
            difference() {
                union() {
                    translate([l1, 0]) {
                        cube([l0, w, h0]);
                        translate([0, w/2, h0])
                            rotate([0, 90])
                                cylinder(d=w-1, h=l0);
                    }
                    cube([l1, w, h]);
                }
                translate([-_delta, w/2, h0])
                    rotate([0, 90])
                        cylinder(d=6.5, h=l0);
            }
        }
        color(c_metal)
            translate([0, w/2, h0])
                rotate([0, 90])
                    cylinder(d=2, h=l0);
    }
}

module power_cubie(dim=[12, 7.5, 6]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    depth = 8; // actual depth
    power_hole_d = 4.5;
    rotate([0, 0, 180]) translate(dim * -.5) { // XXX
    color(c_black) {
        difference() {
            cube(dim);
            translate([-_delta, 1+power_hole_d/2, h/2]) // yes it's misaligned
                rotate([0, 90, 0])
                    cylinder(d=power_hole_d, h=depth);
        }
    }
    color(c_metal)
        translate([0, 1+power_hole_d/2, h/2])
            rotate([0, 90, 0])
                cylinder(d=1.5, h=depth);
    }
}

module power_hikey(dim=[13, 9, 6]) {
    l = dim[1];
    w = dim[0];
    h = dim[2];

    rotate([0, 0, 180]) { // XXX
    translate([w/2, -l/2, -h/2]) // XXX
    rotate([0, 0, 90]) { // XXX
    color(c_black) {
        difference() {
            union() {
                translate([0, w-1])     cube([l, 1, h]);
                translate([0, w-3])     cube([l, 1, h]);
                translate([1.5/2, w-9]) cube([l-1.5, 8, h]);
                translate([3/2, 0])     cube([l-3, w-9, h]);
            }
            translate([l/2, w+_delta, h/2])
                rotate([90, 0, 0])
                    cylinder(d=5, h=9);
        }
    }
    color(c_metal)
        translate([l/2, w-.5, h/2])
            rotate([90, 0, 0])
                cylinder(d=2, h=9);
    }
    }
}

function power_bbb_info() = [
    ["category", "power"],
    ["watch", "horizon"],
];

function power_cubie_info() = [
    ["category", "power"],
    ["watch", "horizon"],
];

function power_hikey_info() = [
    ["category", "power"],
    ["watch", "horizon"],
];

components_demo() {
    power_bbb();
    power_cubie();
    power_hikey();
}

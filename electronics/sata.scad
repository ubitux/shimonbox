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

module sata_data(dim=[17, 6.5, 9]) {
    rotate([0,0,180]) translate(dim * -.5)
    color(c_black) {
        difference() {
            cube(dim);
            translate([1, 1, 2+_delta])
                cube([dim[0]-2, dim[1]-2, dim[2]-2]);
        }
        translate([3, (dim[1]-1)/2])
            cube([dim[0]-3*2, 1, dim[2]]);
        translate([dim[0]-4, (dim[1]-1)/2+1])
            cube([1, 1, dim[2]]);

    }
}

module sata_5v(dim=[7.5, 6, 7.5]) {
    translate(dim * -.5) { // XXX
    color("white") {
        difference() {
            cube(dim);
            translate([1, 1, dim[2] - 6 + _delta])
                cube([dim[0]-2, dim[1]-2, 6]);
            translate([-_delta/2, 1, dim[2]-3])
                cube([dim[0]+_delta, 1, 3+_delta]);
            translate([2, -_delta/2, dim[2]-4])
                cube([dim[0]-4, 1+_delta, 4+_delta]);
        }
    }
    color(c_metal)
        linear_extrude(height=dim[2]-1)
            for (i = [1:2])
                translate([i*dim[0]/3, dim[1]/3])
                    square(.5);
    }
}

function sata_data_info() = [
    ["category", "sata"],
    ["watch", "sky"],
];

function sata_5v_info() = [
    ["category", "sata"],
    ["watch", "sky"],
];

components_demo() {
    sata_data();
    sata_5v();
}

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

$vpd = 300;

module microsdslot(dim=[13, 12, 1.25]) {
    t = .25;
    rotate([0, 0, 180]) // XXX
    color(c_metal) {
        difference() {
            cube(dim, center=true);
            translate([-t, 0, 0])
                cube([dim[0], dim[1]-2*t, dim[2]-2*t], center=true);
        }
    }
}

module microsdcard(dim=[15, 11, 1]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    tip_dim = [2, w, .25];
    tl = tip_dim[0];
    th = tip_dim[2];
    rotate([0, 0, 180]) // XXX
    color(c_black) {
        translate([0, 0, -tip_dim[2]/2])
            cube([l, w, h-.25], center=true);
        translate([(tl-l)/2, 0, (h-th)/2])
            cube(tip_dim, center=true);
    }
}

module sdslot(dim=[17, 28, 4]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];

    pos = [
        [0, 0],
        [0, w],
        [l, w],
        [l, w-2.9],
        [l-11.5, w-2.9],
        [3, w-5.3],
        [3, 4.3],
        [l, 4.3],
        [l, 0],
    ];

    color(c_black)
        translate(dim * -.5)
            linear_extrude(height=dim[2])
                polygon(pos);
}

module sdcard(dim=[32, 24, 2]) {
    pos = [
        [0,          0],
        [0,          24-4],
        [4,          24],
        [4+6.25,     24],
        [4+6.25,     24-0.8],
        [4+6.25-1.5, 24-0.8],
        [4+6.25-1.5, 24],
        [32,         24],
        [32,         0],
        [7.8+6.7,    0],
        [7.8+6.7,    0.8],
        [7.8,        0.8],
        [7.8,        0],
    ];

    color(c_darkblue)
        translate(dim * -.5)
            linear_extrude(height=dim[2])
                polygon(pos);
}

function microsdslot_info() = [
    ["category", "sd"],
    ["watch", "nowhere"],
];
function microsdcard_info() = [
    ["category", "sd"],
    ["watch", "horizon"],
];

function sdslot_info() = [
    ["category", "sd"],
    ["watch", "nowhere"],
];
function sdcard_info() = [
    ["category", "sd"],
    ["watch", "horizon"],
];

components_demo(pad=50) {
    microsdslot();
    microsdcard();
    sdslot();
    sdcard();
}

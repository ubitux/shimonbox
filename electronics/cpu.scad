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

module cpu(dim=[20, 20, 1.25]) {
    color(c_black)
        cube(dim, center=true);
}

module cpurad(dim=[20, 20, 5], stick_dim=[3, 1]) {
    translate(dim * -.5) // XXX
    color(c_black_redish) {
        difference() {
            cube(dim);

            // horizontal
            hh = 3.5;
            nb_hcut = 6;
            hpad = (dim[1] - (nb_hcut + 1) * stick_dim[1]) / nb_hcut;
            translate([0, 0, dim[2]-hh])
                linear_extrude(height=hh + _delta, convexity=4)
                    for (y = [0:nb_hcut-1])
                        translate([-_delta/2, (y + 1) * stick_dim[1] + y * hpad])
                            square([dim[0]+_delta, hpad]);

            // vertical
            nb_vcut = 4;
            vpad = (dim[0] - (nb_vcut + 1) * stick_dim[0]) / nb_vcut;
            hv = 4.5;
            translate([0, 0, dim[2]-hv])
                linear_extrude(height=hv + _delta, convexity=4)
                    for (x = [0:nb_vcut-1])
                        translate([(x + 1) * stick_dim[0] + x * vpad, -_delta/2])
                            square([vpad, dim[1]+_delta]);
        }
    }
}

function cpu_info() = [
    ["category", "cpu"],
    ["watch", "nowhere"],
];
function cpurad_info() = cpu_info();

components_demo(pad=40) {
    cpu();
    cpurad();
}

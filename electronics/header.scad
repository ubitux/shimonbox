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

$vpd = 200;

module _pins_pos(dim, n, m, pins_dist) { // centered position for the pins
    l = dim[0];
    w = dim[1];
    pl = (n - 1) * pins_dist;
    pw = (m - 1) * pins_dist;
    if (l <= pl) echo("WARN: female header length looks too small");
    if (w <= pw) echo("WARN: female header width looks too small");
    translate([(l-pl)/2, (w-pw)/2])
        for (y = [0:m-1])
            for (x = [0:n-1])
                translate([x * pins_dist, y * pins_dist])
                    children();
}

module _female_header(dim, n, m, pins_sz, pins_dist) {
    h = dim[2];
    translate(dim * -.5) { // XXX
        color(c_black) {
            difference() {
                cube(dim);
                translate([0, 0, _delta])
                    linear_extrude(height=h-.25)
                        _pins_pos(dim, n, m, pins_dist)
                            square(pins_sz, center=true);
                translate([0, 0, h-.25])
                    _pins_pos(dim, n, m, pins_dist)
                        rotate(45)
                            cylinder(d1=pins_sz*sqrt(2), d2=1.25+pins_sz, h=.25+_delta, $fn=4);
            }
        }
    }
}

module _pins_slot(n, u) {
    x = u/4;
    z = u/2;
    h = u*n;
    slot_polygons = [
        [-z/2, h/2], [ z/2, h/2], [ u/2, h/2-x], [ u/2,-h/2+x],
        [ z/2,-h/2], [-z/2,-h/2], [-u/2,-h/2+x], [-u/2, h/2-x],
    ];
    polygon(slot_polygons);
}

module _pin_header(dim, n, m, pins_sz, pins_dist) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    translate(dim * -.5) { // XXX
        color(c_metal)
            linear_extrude(height=h)
                _pins_pos(dim, n, m, pins_dist)
                    square(pins_sz, center=true);
        pl = (n - 1) * pins_dist;
        color(c_black)
            linear_extrude(height=h/4)
                translate([(l-pl)/2, w/2])
                    for (x = [0:n-1])
                        translate([x * pins_dist, 0])
                            _pins_slot(m, pins_dist);
    }
}

module female_header_pitch200(dim, n, m) {
    _female_header(dim, n, m, pins_sz=.50, pins_dist=2);
}

module female_header_pitch254(dim, n, m) {
    _female_header(dim, n, m, pins_sz=.64, pins_dist=2.54);
}

module pin_header_pitch200(dim, n, m) {
    _pin_header(dim, n, m, pins_sz=.50, pins_dist=2);
}

module pin_header_pitch254(dim, n, m) {
    _pin_header(dim, n, m, pins_sz=.64, pins_dist=2.54);
}

function header_info() = [
    ["category", "header"],
    ["watch", "sky"],
];
function female_header_info()          = header_info();
function pin_header_info()             = header_info();
function female_header_pitch200_info() = header_info();
function female_header_pitch254_info() = header_info();
function pin_header_pitch200_info()    = header_info();
function pin_header_pitch254_info()    = header_info();

components_demo(pad=50) {
    female_header_pitch254(dim=2.54*[10,2,3], n=10, m=2);
       pin_header_pitch254(dim=2.54*[10,2,3], n=10, m=2);
    female_header_pitch200(dim=2.00*[10,2,2], n=10, m=2);
       pin_header_pitch200(dim=2.00*[10,2,2], n=10, m=2);
}

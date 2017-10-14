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

module usb(dim=[18, 14.5, 8], n=1, clr="white", has_folding=true) {
    pin_l = has_folding ? .6 : 0;

    l = dim[0] - pin_l;
    w = dim[1] - pin_l*2;
    h = dim[2] - pin_l*2;

    t = 0.25;
    p = 0.75;
    z = pin_l * sqrt(2);

    rotate([0, 0, 180]) translate(dim * -.5) { // XXX
        translate([pin_l, pin_l, pin_l]) {
            color(c_metal) {
                difference() {
                    cube([l, w, h]);
                    translate([-_delta, t, t])
                        cube([l-t+_delta, w-t*2, h-t*2]);
                }
                if (has_folding) {
                    translate([0,   p, h-t]) rotate(a= 45, v=[0,1,0]) translate([-z,  0,  0]) cube([z, w - 2*p,       t]);
                    translate([0,   p,   t]) rotate(a=-45, v=[0,1,0]) translate([-z,  0, -t]) cube([z, w - 2*p,       t]);
                    translate([0,   t,   p]) rotate(a= 45, v=[0,0,1]) translate([-z, -t,  0]) cube([z,       t, h - 2*p]);
                    translate([0, w-t,   p]) rotate(a=-45, v=[0,0,1]) translate([-z,  0,  0]) cube([z,       t, h - 2*p]);
                }
            }
            color(clr)
                for (y = [0:n-1])
                    translate([0, 1, h-(3.5+9*y)]) // XXX: random shit
                        cube([l-t, w-2, 2]);
        }
        color(c_metal)
            translate([pin_l+l-l/3, pin_l])
                cube([l/3, w, pin_l]);
    }
}

module usbx2(dim=[18, 14.5, 16], clr=c_black, has_folding=true) {
    usb(dim, n=2, clr=clr, has_folding=has_folding);

    // separator (XXX: random shit)
    pin_l = has_folding ? .6 : 0;
    t = 0.25;
    l = dim[0] - pin_l - t;
    w = dim[1] - pin_l*2 - t*2;
    rotate([0, 0, 180]) translate(dim * -.5) // XXX
        color(c_metal)
            translate([0, (dim[1]-w)/2, (dim[2]-3.5)/2])
                cube([l, w, 3.5]);
}

module microusb(dim=[6, 8, 3]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    microusb_polygon_pos = [[1, h], [w-1, h], [w, h-1],
                            [w-2, 0], [2, 0], [0, h-1]];
    rotate([0, 0, 180]) translate(dim * -.5) { // XXX
        color(c_metal) {
            translate([l-1, 0])
                cube([1, w, h]);
            rotate([90, 0, 90]) {
                linear_extrude(height=l-1) {
                    difference() {
                        polygon(microusb_polygon_pos);
                        offset(r=-.5)
                            polygon(microusb_polygon_pos);
                    }
                }
            }
        }
        color(c_black)
            translate([1.5, (w-4)/2, h-1.5])
                cube([l-2.5, 4, .5]);
    }
}

module miniusb(dim=[7.1, 8, 4]) {
    // TODO: merge with microusb (XXX: HDMI?)
    l = dim[0];
    w = dim[1];
    h = dim[2];
    lowest = h - 4;
    depth = 7;
    otg_polygon_pos = [[0, h], [w, h], [w, h-1.5], [w-.5, h-2],
                       [w-.5, lowest], [.5, lowest], [.5, h-2],
                       [0, h-1.5]];
    translate(dim * -.5) { // XXX
    color(c_metal) {
        cube([l-depth, w, h]);
        translate([l-depth, 0, 0]) {
            rotate([90, 0, 90]) {
                linear_extrude(height=depth) {
                    difference() {
                        polygon(otg_polygon_pos);
                        offset(r=-.5)
                            polygon(otg_polygon_pos);
                    }
                }
            }
        }
    }
    color(c_black)
        translate([l-depth, 1.5, 2])
            cube([6, w-3, 1]);
    }
}

function usb_info() = [
    ["category", "usb"],
    ["watch", "horizon"],
];
function usbx2_info()    = usb_info();
function microusb_info() = usb_info();
function miniusb_info()  = usb_info();

components_demo(pad=40) {
    usb();
    usbx2();
    microusb();
    miniusb();
}

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


module horz_fold(a,l,w,t) {
    rotate(a=a, v=[0,1,0]) translate([l/2,0,sign(a)*t/2]) cube([l, w, t], center=true);
    intersection() { // fold radius
        translate([0,0,0]) rotate([90,0,0]) cylinder(r=t, h=w,center=true);
        translate([t/2,0,sign(a)*t/2]) cube([t,w,t], center=true);
    }
}

module vert_fold(a,l,w,t) {
    rotate(a=a, v=[0,0,1]) translate([l/2,-sign(a)*t/2,0]) cube([l, t, w], center=true);
    intersection() { // fold radius
        translate([0,0,0]) rotate([0,0,90]) cylinder(r=t, h=w,center=true);
        translate([t/2,-sign(a)*t/2,0]) cube([t,t,w], center=true);
    }
}

// VALCON HD-RA-DSF12-TR from RPi4
// dim is dimensions of connector before folds
module microhdmi(dim=[7.3, 6.5, 3.25], l_fold=0.77, t=0.3) {
    tab_h = 0.6;
    tab_w1 = 4.3;
    tab_w2 = 3.7;
    inner_w1 = 5.9;
    inner_w2 = tab_w1;
    inner_h = 2.3;

    l = dim[0];
    w = dim[1];
    h = dim[2];
    l2 = l + l_fold;

    recess_tab = 1.53;
    l_tab = l-recess_tab;
    l_plug = 0.77;

    p = 0.55;
    a_fold = 30;
    z = (l_fold-t*sin(a_fold)) / cos(a_fold);

    translate([l2/2,0,0]) {
        tab_chamfer = (tab_w1-tab_w2)/2;
        tabPoints = [
            [-tab_w1/2,tab_h/2], [tab_w1/2,tab_h/2], 
            [tab_w1/2,tab_chamfer-tab_h/2], [tab_w2/2,-tab_h/2],
            [-tab_w2/2,-tab_h/2], [-tab_w1/2,tab_chamfer-tab_h/2]
        ];
        inner_chamfer = (inner_w1-inner_w2)/2;
        innerPoints = [
            [-inner_w1/2,inner_h/2], [inner_w1/2,inner_h/2], 
            [inner_w1/2,inner_chamfer-inner_h/2], [inner_w2/2,-inner_h/2],
            [-inner_w2/2,-inner_h/2], [-inner_w1/2,inner_chamfer-inner_h/2]
        ];
        if (l_fold > 0) color(c_metal) {
            translate([-l_fold,0, inner_h/2+t]) horz_fold(-a_fold, z, inner_w1, t);
            translate([-l_fold,0,-inner_h/2-t]) horz_fold( a_fold, z, inner_w2, t);
            translate([-l_fold,-w/2,inner_chamfer/2]) vert_fold(-a_fold, z, inner_h-inner_chamfer, t);
            translate([-l_fold, w/2,inner_chamfer/2]) vert_fold( a_fold, z, inner_h-inner_chamfer, t);
        }
        translate([-l2,0,0]) {
            color(c_black) rotate([90,0,90]) {
                linear_extrude(height=l_tab) polygon(tabPoints);
                linear_extrude(height=l_plug) polygon(innerPoints);
            }
            color(c_metal) rotate([90,0,90])
                linear_extrude(height=l) difference() {
                    offset(t) polygon(innerPoints);
                    polygon(innerPoints);
                }
        }
    }
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

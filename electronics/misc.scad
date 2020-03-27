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

module antenna(dim=[7.5, 16, 1]) { // TODO
    color(c_black)
        cube(dim, center=true);
}

module capacitor(dim=[6, 6, 5]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    translate(dim * -.5) {
        color(c_black)
            cube([l, w, 1.5]);
        color(c_metal)
            translate([l/2, w/2, 1.5])
            cylinder(d=l, h=h-1.5);
    }
}

module chip(dim=[10, 5, 2]) {
    color(c_black)
        cube(dim, center=true);
}

module extio_hikey(dim=[6, 30, 4]) {
    l = dim[1];
    w = dim[0];
    h = dim[2];
    rotate([0, 0, 90]) translate([dim[1], dim[0], dim[2]] * -.5) // XXX
    color([.9,.85,.75]) {
        linear_extrude(height=1) {
            square([2.5, w]);
            translate([l-2.5, 0])
                square([2.5, w]);
            translate([0, (w-4)/2])
                square([l, 4]);
        }
        translate([0, 0, 1]) {
            linear_extrude(height=h-1) {
                difference() {
                    translate([1, (w-4)/2])
                        square([l-2, 4]);
                    translate([1.5, (w-4/3)/2])
                        square([l-3, 4/3]);
                }
            }
        }
    }
}

module ir(dim=[3.5, 5, 7]) {
    l = dim[1];
    w = dim[0];
    h = dim[2];
    rotate([0, 0, 90]) translate([dim[1], dim[0], dim[2]] * -.5) { // XXX
    color(c_black) {
        translate([0, 0, 1])
            cube([l, w-1, h-1]);
        translate([l/2, w-1.5, 1])
            cylinder(r=1.5, h=h-3);
        translate([l/2, w-1.5, h-2])
            sphere(r=1.5);
    }
    color(c_metal)
        linear_extrude(height=h/2)
            for (i = [0:2])
                translate([i*(l-.5-_delta)/2 + _delta/2, (w-1)/2])
                    square(.5);
    }
}

module led(dim=[2, 1, 0.5], clr=c_yellow) { // TODO
    color(clr)
        cube(dim, center=true);
}

module rt_bbb(dim=[3.5, 8, 10.5]) {
    rt1_l = dim[0];
    rt1_w = dim[1];
    rt1_h = dim[2];

    head_l = dim[0];
    head_w = dim[1];
    head_h = dim[2] / 3;

    translate(dim * -.5) { // XXX
        color(c_metal)
            for (y = [1, rt1_w-1])
                translate([rt1_l/2, y])
                    cylinder(d=1, h=rt1_h-head_h);

        color(c_gold)
            translate([0, 0, rt1_h-head_h])
                cube([head_l, head_w, head_h]);
    }
}

module serialcon_rpi(dim=[2.5, 22, 5.5]) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    translate(dim * -.5) { // XXX
        color([.9,.85,.75]) {
            translate([0, 1])
                cube([.5+_delta, w-2, h-1.5]);
            translate([l-.5, 1])
                cube([.5, w-2, h-1.5]);
            translate([_delta, 3, h-1.5])
                cube([0.5, w-3*2, 1.5-_delta]);
        }
        color(c_black) {
            difference() {
                union() {
                    translate([.5, 0.5, 0])
                        cube([l-1, w-1, h-1.5+_delta]);
                    translate([0, 0, h-1.5])
                        cube([l, w, 1.5]);
                }
                translate([-_delta, 3, _delta])
                    cube([l-1+_delta, w-3*2, h]);
            }
        }
    }
}

module duct_profile(dim, th=1.2, oneside=false) {
  if (oneside) {
      translate([-dim[0]/2-th,0]) square([th,dim[1]]);
      translate([-dim[0]/2-th,dim[1]]) square([dim[0]+2*th,th]);
      translate([dim[0]/2,0]) square([th,dim[1]]);
  } else {
      difference() {
          square(dim+th*[2,2], center=true);
          square(dim, center=true);
      }
  }
}

module duct(dim_inlet=[20,15, 1.2], dim_outlet=[20,15,3], th=1.2) {
    $fn=120;
    // full distance ~14.4
    inx = dim_inlet[0];
    iny = dim_inlet[1];
    inz = dim_inlet[2];
    inxy = [inx,iny];
    outx = dim_outlet[0];
    outy = dim_outlet[1];
    outz = dim_outlet[2];
    outxy = [outx,outy];
    
    translate([iny/2,0]) {
        rotate([90,0,90]) linear_extrude(inz) 
            duct_profile(inxy, th, true);
        rotate([90,0,0]) rotate_extrude(angle=-90)
            rotate(90) duct_profile(inxy, th, true);
    }
    // reducer
    rotate(90) difference() {
        hull() {
            cube([inx+2*th,iny+2*th,0.001], center=true);
            translate([0,0,-outz]) cube([outx+2*th,outy+2*th,0.001], center=true);
        }
        hull() {
            translate([0,0,0.01]) cube([inx,iny,0.001], center=true);
            translate([0,0,-outz-0.01]) cube([outx,outy,0.001], center=true);
        }
    }
    // bump to stop from falling through case top
    group() {
      d = th;
      $fn = 32;
      translate([-iny/2-th,0,d/2]) rotate([90,0,0]) 
        linear_extrude(inx+2*th, center=true) {
            rotate(180/$fn) circle(d=d);
            translate([0,-d/2]) square([d/3,d]);
        }
      for(i=[0,1]) mirror([0,i,0])
        translate([0,-inx/2-th,d/2]) {
          rotate([0,90,0]) linear_extrude(iny+2*th, center=true) {
              rotate(180/$fn) circle(d=d);
          }
          translate([-iny/2-th,0]) sphere(d=d);
        }
    }
}

function antenna_info() = [
    ["category", "misc"],
    ["watch", "nowhere"],
];

function capacitor_info() = [
    ["category", "misc"],
    ["watch", "nowhere"],
];

function chip_info() = [
    ["category", "misc"],
    ["watch", "nowhere"],
];

function extio_hikey_info() = [
    ["category", "misc"],
    ["watch", "sky"],
];

function ir_info() = [
    ["category", "misc"],
    ["watch", "nowhere"],
];

function led_info() = [
    ["category", "misc"],
    ["watch", "sky"],
];

function rt_bbb_info() = [
    ["category", "misc"],
    ["watch", "nowhere"],
];

function serialcon_rpi_info() = [
    ["category", "misc"],
    ["watch", "sky"],
];

function duct_info() = [
    ["category", "misc"],
    ["watch", "sky"],
];


components_demo(pad=40) {
    antenna();
    capacitor();
    chip();
    extio_hikey();
    ir();
    led();
    serialcon_rpi();
    rt_bbb();
    duct();
}

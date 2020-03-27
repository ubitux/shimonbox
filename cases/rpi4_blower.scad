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

use <../boards/rpi4.scad>
use <../case.scad>
use <../utils.scad>
use <../electronics/misc.scad>

board_dim = map_get(raspberry_pi_4_info(blower=true), "board_dim");

vents = [
    [
        "bottom", [],
    ]
];

cfg = [
    ["min_z", 2.5],
    ["max_z", 15],
    ["vents", vents],
];

//*
!difference() {
  case("rpi4_blower", cfg, "bottom");
  dslot = 4;
  sep = 2;
  translate([-43,0,13])
  rotate([0,-90]) rotate(-90) linear_extrude(100) {
    for(i=[-1:1]) hull() {
      translate([(dslot+sep)*i,-4]) circle(d=dslot, $fn=40);
      translate([(dslot+sep)*i,4]) circle(d=dslot, $fn=40);
    }
    for(i=[-4,-3,-2,2,3,4]) hull() {
      translate([(dslot+sep)*i,-9]) circle(d=dslot, $fn=40);
      translate([(dslot+sep)*i,4]) circle(d=dslot, $fn=40);
    }
  }
}
//*/

mode = "demo";
case("rpi4_blower", cfg, mode);

// Uncomment to export printed duct separately
//!duct();

/*
// External dependency on NopSCADLib only if blower fan mockup is wanted 
//   (does not animate with case demo)
$t=1;
include <../NopSCADlib/core.scad>
include <../NopSCADlib/vitamins/blowers.scad>
translate([-5.8,4.5,17.825]) rotate(-90) translate([-10,0,0]) 
        blower(RB5015);
//*/
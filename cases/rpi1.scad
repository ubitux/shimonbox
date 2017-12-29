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

use <../boards/rpi1.scad>
use <../case.scad>
use <../utils.scad>

board_dim = map_get(raspberry_pi_1_info(), "board_dim");

vents = [
    [
        "bottom", [
            ["dim", [board_dim[0] * .35, board_dim[1] * .6]],
            ["pos", [12, 0]],
        ]
    ],
    [
        "top", [
            ["dim", [board_dim[0] * .2, board_dim[1] * .5]],
            ["pos", [0, -8]],
        ]
    ]
];

cfg = [
    ["min_z", 4],
    ["max_z", 7.5],
    ["vents", vents],
];

mode = "demo";
case("rpi1", cfg, mode);

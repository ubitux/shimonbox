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

use <../boards/orangepi_zero.scad>
use <../case.scad>
use <../utils.scad>

board_dim = map_get(orangepi_zero_info(), "board_dim");

vents = [
    [
        "bottom", default_bottom_vents(board_dim),
    ],[
        "top", [
            ["dim", board_dim * .5],
            ["pos", [1/3*board_dim[0]/2, 0]],
        ],
    ]
];

cfg = [
    ["min_z", 3],
    ["max_z", 6],
    ["vents", vents],
];

mode = "demo";
case("orangepi_zero", cfg, mode);

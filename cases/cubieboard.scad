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

use <../boards/cubieboard.scad>
use <../case.scad>
use <../utils.scad>

board_dim = map_get(cubieboard_info(), "board_dim");

vents = [
    [
        "bottom", default_bottom_vents(board_dim, s=.5),
    ],[
        "top", [
            ["dim", [board_dim[0] * .6, board_dim[1] * .35]],
            ["pos", [15, 10]],
        ]
    ]
];

cfg = [
    ["min_z", 7],
    ["max_z", 7],
    ["vents", vents],
];

mode = "demo";
case("cubieboard", cfg, mode);

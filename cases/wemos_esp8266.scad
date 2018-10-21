// Copyright (c) 2018 Dan Kortschak <dan@kortschak.io>
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

use <../boards/wemos_esp8266.scad>
use <../case.scad>
use <../utils.scad>

board_dim = map_get(wemos_esp8266_info(), "board_dim");

vents = [
    [
        "bottom",  [
            ["dim", [board_dim[0] * .4, board_dim[1] * .3]],
            ["pos", [board_dim[0]/15, 0]],
        ],
    ]
];

cfg = [
    ["min_z", 2.75],
    ["max_z", 3.75],
    ["vents", vents],
];

mode = "demo";
case("wemos_esp8266", cfg, mode);

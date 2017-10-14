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

include <../globals.scad>

$vpr = [50, 0, 90];

module components_demo(pad=30) {
    n = $children;
    cols = ceil(sqrt(n));
    rows = ceil(n / cols);
    offx = pad * (rows - 1) / 2;
    offy = pad * (cols - 1) / 2;
    for (i = [0:n-1]) {
        x = floor(i / cols);
        y = i % cols;
        translate([x*pad - offx, y*pad - offy])
            rotate(360 * $t)
                children(i);
    }
}

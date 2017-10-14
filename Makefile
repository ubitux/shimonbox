# Copyright (c) 2017 Clément Bœsch <u pkh.me>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

stl:
	$(MAKE) -C cases $@

GIF_MAKE = boards cases electronics
GIF_RULES = $(addprefix gif-,$(GIF_MAKE))
gif: $(GIF_RULES)
$(GIF_RULES):
	$(MAKE) -C $(word 2,$(subst -, ,$@)) gif

clean:
	$(RM) cases/*.stl

.PHONY: stl gif clean $(GIF_RULES)

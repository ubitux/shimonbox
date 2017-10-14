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

OPENSCAD ?= openscad --colorscheme="Tomorrow Night" --imgsize=1024,1024 $(OPENSCAD_EXTRA_SETTINGS)
DSCALE   ?= scale=iw/4:ih/4:flags=lanczos
FFMPEG   ?= ffmpeg -v warning
STEPS    ?= 200
FPS      ?= 30
GIF_FINAL_DELAY ?= -1

define anim_pattern
%$(shell printf $(1) | wc -c)d
endef

define anim_pictures
$(addsuffix .png,$(addprefix anim-$(1)-,$(shell seq -w $(2))))
endef

define dashsplit
$(word $(1),$(subst -, ,$(2)))
endef

define get_openscad_var
$(if $(shell grep ^\$$$(1) $(2)),$(shell sed -nE 's#^\$$$(1)\s*=\s*([0-9]+)\s*;#\1#p' $(2)),$(3))
endef

ANIM_PATTERN := $(call anim_pattern,$(STEPS))
TARGETS = $(sort $(filter-out _internal,$(subst .scad,,$(wildcard *.scad))))
GIFS = $(addsuffix .gif,$(addprefix gif/,$(TARGETS)))
STLS = $(addsuffix -bottom.stl,$(TARGETS)) $(addsuffix -top.stl,$(TARGETS))

gif: $(GIFS)

stl: $(STLS) $(STLS_EXTRA)

.PHONY: gif stl

.SECONDEXPANSION: # XXX: wtf make...
palette-%.png: $$(call anim_pictures,%,$(STEPS))
	$(FFMPEG) -i anim-$*-$(ANIM_PATTERN).png -vf $(DSCALE),palettegen -y $@

gif/%.gif: palette-%.png $$(call anim_pictures,%,$(STEPS))
	$(FFMPEG) -framerate $(FPS) -i anim-$*-$(ANIM_PATTERN).png \
            -i $< -lavfi "$(DSCALE)[x];[x][1:v]paletteuse" \
            -y -frames:v $(STEPS) -loop 0 -final_delay $(GIF_FINAL_DELAY) $@

anim-%.png: NUM = $(shell echo $(call dashsplit,2,$*) | sed 's/^0*//')
anim-%.png: VPD = $(call get_openscad_var,vpd,$<,140)
anim-%.png: $$(call dashsplit,1,%).scad
	$(OPENSCAD) $< -D'$$t=$(NUM)/$(STEPS)' -o $@

%.stl: $$(call dashsplit,1,%).scad
	openscad $< -D'mode="$(call dashsplit,2,$*)"' -o $@

OPENSCAD = /usr/bin/openscad
CONVERT  = /usr/bin/convert
CP       = /bin/cp -a

.PHONY:	ALL

ALL:	TV/star.scad                  \
	TV/star-20-10-8-10-0-1.png    \
	TV/star-25-10-5-10-2-1.png    \
	TV/star-25-20-10-10-2-1.3.png \
	TV/star-25-25-3-15-2-1.png    \
	TV/star-30-8-8-4-0-0.png      \
	TV/star-70-40-5-40-5-1.stl

Clean:
	rm TV/*

file2param = $(subst -, ,$(subst TV/star-,,$(subst .png,,$(subst .stl,,$@))))

paramD = -D outer_radius=$(word 1,$(1)) -D inner_radius=$(word 2,$(1)) -D spikes=$(word 3,$(1)) -D height=$(word 4,$(1)) -D width=$(word 5,$(1)) -D scale=$(word 6,$(1))
paramPng = --imgsize=800,600 --camera=0,0,0,55,0,55,140 --projection=p --render --colorscheme=Metallic
paramStl = 
paramTxt = -gravity SouthWest -fill black -pointsize 25 -annotate +10+10 "Customizer Parameters:\nouter_radius\ninner_radius\nspikes\nheight\nwidth\nscale" -annotate +160+10 "\n= $(word 1,$(1))\n= $(word 2,$(1))\n= $(word 3,$(1))\n= $(word 4,$(1))\n= $(word 5,$(1))\n= $(word 6,$(1))"

TV/star.scad: star.scad
	$(CP) $< $@

TV/star-%.png: star.scad
	$(OPENSCAD) -o $@ $(call paramD,$(call file2param, $<)) $(paramPng) $<
	$(CONVERT) $@ $(call paramTxt,$(call file2param, $<)) $@

TV/star-%.stl: star.scad
	$(OPENSCAD) -o $@ $(call paramD,$(call file2param, $<)) $(paramStl) $<

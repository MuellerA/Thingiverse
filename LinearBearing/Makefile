OPENSCAD = /usr/bin/openscad-nightly
INKSCAPE = /usr/bin/inkscape
CP       = /bin/cp -a
RM       = /bin/rm -f

ALL:	TV/LinearBearing.scad	\
	TV/LinearBearing.stl	\
	TV/LinearBearing.jpg

Clean:
	$(RM) TV/*

TV/%.scad: %.scad
	$(CP) $< $@

TV/LinearBearing.stl:	LinearBearing.scad
	$(OPENSCAD) -o $@ $<

TV/%.jpg: Images/%.jpg
	$(CP) $< $@

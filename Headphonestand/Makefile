OPENSCAD = /usr/bin/openscad
INKSCAPE = /usr/bin/inkscape
CP       = /bin/cp -a
RM       = /bin/rm -f

ALL:	TV/headphonestand-round.stl	\
	TV/headphonestand-complete.stl	\
	TV/headphonestand.stl		\
	TV/headphonestand.scad		\
	TV/headphonestand.png		\
	TV/HeadPhoneStand1.jpg		\
	TV/HeadPhoneStand2.jpg

Clean:
	$(RM) TV/*

TV/headphonestand-round.stl:	headphonestand.scad
	$(OPENSCAD) -o $@ -D split=1 -D roundEdge=1 $<

TV/headphonestand-complete.stl:	headphonestand.scad
	$(OPENSCAD) -o $@ -D split=0 -D roundEdge=1 $<

TV/headphonestand.stl:	headphonestand.scad
	$(OPENSCAD) -o $@ -D split=1 -D roundEdge=0 $<

TV/headphonestand.scad:	headphonestand.scad
	$(CP) $< $@

TV/headphonestand.png:	Images/headphonestand.svg
	$(INKSCAPE) --export-png=$@ $<

TV/%.jpg: Images/%.jpg
	$(CP) $< $@

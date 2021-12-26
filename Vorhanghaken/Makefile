OPENSCAD = /usr/bin/openscad
CP       = /bin/cp -a
RM       = /bin/rm -f

Files = TV/haken1.jpg \
	TV/haken2.jpg \
	TV/haken.scad \
	TV/haken.stl

ALL:	$(Files)

Clean:
	$(RM) TV/*

TV/haken.stl: haken.scad
	$(OPENSCAD) -o $@ $<

TV/haken.scad: haken.scad
	$(CP) $< $@

TV/haken%.jpg: Images/haken%.jpg
	$(CP) $< $@

OPENSCAD = /usr/bin/openscad
CP       = /bin/cp -a

ALL:	TV/batteryC.stl   \
	TV/batteryAA.stl  \
	TV/batteryAAA.stl \
	TV/battery.scad

Clean:
	rm TV/*

file2param = $(subst TV/battery,,$(subst .stl,,$@))


TV/battery%.stl: battery.scad
	$(OPENSCAD) -o $@ -D battery_type='"'$(call file2param, $<)'"' $<

TV/battery.scad: battery.scad
	$(CP) $< $@

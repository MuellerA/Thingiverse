OPENSCAD = /usr/bin/openscad
CP       = /bin/cp -a
RM       = /bin/rm -f

Files   = TV/batteryD.stl   \
	  TV/batteryC.stl   \
	  TV/batteryAA.stl  \
	  TV/batteryAAA.stl \
	  TV/batteryDemo.png\
	  TV/batteryD.tie.stl   \
	  TV/batteryC.tie.stl   \
	  TV/batteryAA.tie.stl  \
	  TV/batteryAAA.tie.stl \
	  TV/battery.scad   \
          TV/battery1.jpg   \
          TV/battery2.jpg   \
          TV/battery3.jpg   \

ALL:	$(Files)

Clean:
	$(RM) TV/*

file2param = $(subst TV/battery,,$(subst .$(2),,$(subst .tie.,.,$(1))))

TV/battery%.tie.stl: battery.scad
	$(OPENSCAD) -o $@ -D battery_type='"'$(call file2param,$@,stl)'"' -D zip_tie='"On"' $<

TV/battery%.stl: battery.scad
	$(OPENSCAD) -o $@ -D battery_type='"'$(call file2param,$@,stl)'"' -D zip_tie='"Off"' $<

TV/battery%.png: battery.scad
	$(OPENSCAD) -o $@ -D battery_type='"'$(call file2param,$@,png)'"' --imgsize=800,600 --autocenter --projection=p --render $<

TV/battery.scad: battery.scad
	$(CP) $< $@

TV/battery%.jpg: Images/battery%.jpg
	$(CP) $< $@

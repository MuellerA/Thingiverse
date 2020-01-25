OPENSCAD = /usr/bin/openscad
CP       = /bin/cp -a
RM       = /bin/rm -f

Files	= TV/PcbNodeMcu2.stl		\
	  TV/PcbArduinoProMini.stl	\
	  TV/PcbLonganNano.stl		\
	  TV/PcbFtdi.stl   		\
	  TV/pcb.scad			\
	  TV/img1.jpg			\
	  TV/img2.jpg			\
	  TV/img3.jpg			\

ALL:	$(Files)

Clean:
	$(RM) TV/*

file2param = $(subst TV/Pcb,,$(subst .$(2),,$(1)))

TV/Pcb%.stl:	pcb.scad
	$(OPENSCAD) -o $@ -D type='"'$(call file2param,$@,stl)'"' $<

TV/Pcb%.png:	pcb.scad
	$(OPENSCAD) -o $@ -D type='"'$(call file2param,$@,stl)'"' --imgsize=800,600 --autocenter --projection=p --render $<

TV/pcb.scad:	pcb.scad
	$(CP) $< $@

TV/%.jpg:	Images/%.jpg
	$(CP) $< $@


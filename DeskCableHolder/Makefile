OPENSCAD = /usr/bin/openscad
CONVERT  = /usr/bin/convert
CP       = /bin/cp -a
RM       = /bin/rm -f

ALL:	TV/DeskCableHolder.scad                   \
	TV/DeskCableHolder-2-26.5-8-10-20-15.png  \
	TV/DeskCableHolder-4-10.5-15-25-40-10.png \
	TV/DeskCableHolder.stl			  \
	TV/DeskCableHolder1.jpg			  \
	TV/DeskCableHolder2.jpg			  \

Clean:
	$(RM) TV/*

file2param = $(subst -, ,$(subst TV/DeskCableHolder-,,$(subst .png,,$(subst .stl,,$@))))

paramD = -D wall=$(word 1,$(1)) -D height1=$(word 2,$(1)) -D height2=$(word 3,$(1)) -D width1=$(word 4,$(1)) -D width2=$(word 5,$(1)) -D depth1=$(word 6,$(1))
paramPng = --imgsize=800,600 --camera=-3,-15,-10,30,0,25,200 --projection=p --render --colorscheme=Cornfield
paramStl = 
paramTxt = -gravity SouthWest -fill black -pointsize 25 -annotate +10+10 "Customizer Parameters:\nwall\nheight1\nheight2\nwidth1\nwidth2\ndepth1" -annotate +160+10 "\n= $(word 1,$(1))\n= $(word 2,$(1))\n= $(word 3,$(1))\n= $(word 4,$(1))\n= $(word 5,$(1))\n= $(word 6,$(1))"\

TV/DeskCableHolder.scad: DeskCableHolder.scad
	$(CP) $< $@

TV/DeskCableHolder-%.png: DeskCableHolder.scad
	$(OPENSCAD) -o $@ $(call paramD,$(call file2param, $<)) $(paramPng) $<
	$(CONVERT) $@ $(call paramTxt,$(call file2param, $<)) $@

TV/DeskCableHolder-%.stl: DeskCableHolder.scad
	$(OPENSCAD) -o $@ $(call paramD,$(call file2param, $<)) $(paramStl) $<

TV/DeskCableHolder.stl: DeskCableHolder.scad
	$(OPENSCAD) -o $@ $<

TV/DeskCableHolder%.jpg: Images/DeskCableHolder%.jpg
	$(CP) $< $@

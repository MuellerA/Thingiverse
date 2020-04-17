OPENSCAD = /usr/bin/openscad
CP       = /bin/cp -a
RM       = /bin/rm -f

Files   = TV/IcBox-Base.stl	\
	  TV/IcBox-Top.stl	\
	  TV/IcBox.scad		\
	  TV/img1.jpg		\
	  TV/img2.jpg		\
	  TV/img3.jpg		\


ALL:	$(Files)

Clean:
	$(RM) TV/*

file2param = $(subst TV/IcBox-,,$(subst .$(2),,$(1)))

TV/IcBox-%.stl:	IcBox.scad
	$(OPENSCAD) -o $@ -D type='"'$(call file2param,$@,stl)'"' $<

TV/IcBox.scad: IcBox.scad
	$(CP) $< $@

TV/%.jpg:	Images/%.jpg
	$(CP) $< $@

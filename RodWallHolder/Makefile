OPENSCAD = /usr/bin/openscad
CP       = /bin/cp -a
RM       = /bin/rm -f

Files   = TV/RodWallHolder.stl \
	  TV/RodWallHolder.jpg \
	  TV/RodWallHolder.png \
	  TV/RodWallHolder.scad \

ALL:	$(Files)

Clean:
	$(RM) TV/*

TV/RodWallHolder.stl: RodWallHolder.scad
	$(OPENSCAD) -o $@  $<

TV/RodWallHolder.png: RodWallHolder.scad RodWallHolderDemo.scad
	$(OPENSCAD) -o $@  --imgsize=800,600 --camera=22.42,-5.21,13.5,56.4,0,325.5,140  --projection=p --render RodWallHolderDemo.scad

TV/RodWallHolder.scad: RodWallHolder.scad
	$(CP) $< $@

TV/RodWallHolder.jpg: Images/RodWallHolder.jpg
	$(CP) $< $@

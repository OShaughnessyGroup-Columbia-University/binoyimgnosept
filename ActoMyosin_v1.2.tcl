# change from original: make Myo2p red, Myp2p green, actin grey
# change from v1.1: make alpha actinin cyan

#tcl file to manipulate the vmd output and render a png image using the input psf, gro and septum.tcl files
#edit this file to make image changes

#loading files
menu files off
menu files on
display resetview

#loading the septum tcl file
source "septum.tcl"

#adding a text box for the time, curly brackets show the xyz coordinates 
draw color black
graphics top text {1050 -2000 0} "time" size 0.75 thickness 1

#loading gro file
mol addfile {test.gro} type {gro} first 0 last -1 step 1 waitfor 1 0

#loading the psf file
mol addfile {test.psf} type {psf} first 0 last -1 step 1 waitfor 1 0

#vmd technical detail, no need to change
animate style Loop
display resetview

#below 4 lines are done to open to tkconsole and graphics menu on vmd 
menu tkconn off
menu tycoon on
menu graphics off
menu graphics on

#below lines 32 to 55 could be deleted, not sure about their purpose
mol color Name
mol representation Lines 1.000000
mol selection all
mol material Opaque
mol addrep 0
mol color Name
mol representation Lines 1.000000
mol selection all
mol material Opaque
mol addrep 0
mol color Name
mol representation Lines 1.000000
mol selection all
mol material Opaque
mol addrep 0
mol color Name
mol representation Lines 1.000000
mol selection all
mol material Opaque
mol addrep 0
mol delrep 1 0
mol delrep 1 0
mol delrep 1 0
mol delrep 1 0

#lines 59 to 80 make 4 differnt representations for Actin,
#Formin, Pointed ends and myp2 tail ends
mol modstyle 0 0 CPK 1.000000 0.300000 12.000000 12.000000
mol color Name
mol modselect 0 0 all
mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection all
mol material Opaque
mol addrep 0
mol color Name
mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection all
mol material Opaque
mol addrep 0
mol color Name
mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection all
mol material Opaque
mol addrep 0
mol color Name
mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection all
mol material Opaque
mol addrep 0

#naming the 4 representations for Actin, Formin, Pointed end 
#and Myp2 tails respectively
mol modselect 1 0 name CA
mol modselect 2 0 name CF
mol modselect 3 0 name CP
mol modselect 4 0 name CM
mol color Name

#making and naming Myo2 middle ghost beads (tail terminus) (CN) 
#and myo2 anchor ghost beads (head terminus) CR
mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection name CM
mol material Opaque
mol addrep 0
mol color Name
mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection name CM
mol material Opaque
mol addrep 0
mol modselect 6 0 name CN
mol modselect 5 0 name CR
mol color Name


mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection name CN
mol material Opaque
mol addrep 0

#CQ is myo2 joint, CJ not used, CB is anchor, CX is xlinker, CEGH, are three myp2 beads
mol modselect 7 0 name CQ 
mol addrep 0
mol modselect 8 0 name CJ 
mol addrep 0
mol modselect 9 0 name CB 
mol addrep 0
mol modselect 10 0 name CX 
mol addrep 0
mol modselect 11 0 name CG
mol addrep 0
mol modselect 12 0 name CE 
mol addrep 0
mol modselect 13 0 name CH 
mol addrep 0
mol modselect 14 0 name CS 
mol addrep 0

# sizes of objects
# first float number: bead diameters * 4 / 3 in nm
# second float number: bond diamter * 2 in nm
# third and fourth: bead/bond resolution, i.e. size of triagles that make them

mol modstyle 00 0 CPK 0.000000 0.000000 12.000000 12.000000 # default bond
mol modstyle 01 0 CPK 9.000000 17.00000 12.000000 12.000000 # actin
#mol modstyle 01 0 CPK 0.000000 00.00000 12.000000 12.000000 # actin
mol modstyle 02 0 CPK 10.00000 17.00000 12.000000 12.000000 # formin
mol modstyle 03 0 CPK 9.000000 17.00000 12.000000 12.000000 # actin pointed end
mol modstyle 04 0 CPK 0.000000 10.00000 12.000000 12.000000 # myp2 tail ends
mol modstyle 05 0 CPK 0.000000 10.00000 12.000000 12.000000 # myo2 tail terminus 
mol modstyle 06 0 CPK 13.30000 8.000000 12.000000 12.000000 # myo2 head terminus
mol modstyle 07 0 CPK 0.000000 10.00000 12.000000 12.000000 # myo2 joint between neck and tail
mol modstyle 08 0 CPK 0.000000 2.500000 12.000000 12.000000 # not used
mol modstyle 09 0 CPK 53.00000 10.00000 12.000000 12.000000 # anchor
mol modstyle 10 0 CPK 13.30000 10.00000 12.000000 12.000000 # xlinker
mol modstyle 11 0 CPK 6.700000 8.000000 100.00000 100.00000 # smallest myp2 head bead
mol modstyle 12 0 CPK 10.00000 0.000000 100.00000 100.00000 # middle myp2 head bead
mol modstyle 13 0 CPK 13.30000 0.000000 100.00000 100.00000 # largest myp2 head bead
mol modstyle 14 0 CPK 18.00000 34.00000 12.000000 12.000000 # highlighted actin



menu tkcon off
menu tkcon on
menu color off
menu color on

#changing the red color on vmd according to customized 
#rgb values from earlier published paper
color change rgb 1 0.600000 0.600000 0.600000
color change rgb 2 1.000000 0.000000 0.000000
color change rgb 3 0.600000 0.340000 0.000000
color change rgb 4 0.000000 0.800000 0.000000
color change rgb 5 0.200000 0.600000 1.000000
color change rgb 7 0.600000 0.800000 1.000000
color change rgb 20 0.900000 0.500000 0.000000

#assigning colors to each bead as specified
mol modcolor 00 0 ColorID 2
mol modcolor 01 0 ColorID 1
mol modcolor 02 0 ColorID 5
mol modcolor 03 0 ColorID 1
mol modcolor 04 0 ColorID 4
mol modcolor 06 0 ColorID 2
mol modcolor 07 0 ColorID 2
mol modcolor 08 0 ColorID 9
mol modcolor 09 0 ColorID 3
mol modcolor 10 0 ColorID 7
mol modcolor 11 0 ColorID 4
mol modcolor 12 0 ColorID 4
mol modcolor 13 0 ColorID 4
mol modcolor 05 0 ColorID 2
mol modcolor 14 0 ColorID 20
# septum bead ColorID 6

# material is transparent
material change opacity Glass1 0.0400
material change opacity Transparent 0.25
material change opacity Opaque 0.25

# st: make myp2 transparent
mol modmaterial 1 0 Glass1
mol modmaterial 2 0 Glass1
mol modmaterial 3 0 Glass1
mol modmaterial 4 0 Transparent
mol modmaterial 5 0 Opaque
mol modmaterial 6 0 Opaque
mol modmaterial 7 0 Opaque
mol modmaterial 8 0 Glass1
mol modmaterial 9 0 Opaque
mol modmaterial 10 0 Glass1
mol modmaterial 11 0 Transparent
mol modmaterial 12 0 Transparent
mol modmaterial 13 0 Transparent
mol modmaterial 14 0 AOShiny
#removing perspective from image
display projection Orthographic 

axes location off

#setting the color of the Background
color Display Background white

#adding light to increase clarity, positioning 4 lights {xyz} to remove shadows 
#and control the brightness
light 0 pos {0 0 5.5}
#light 0 pos {0 1.9 5.2}
light 0 on
light 1 pos {0 0 8}
light 1 off
light 2 pos {0 0 0.1}
light 2 off
light 3 pos {0 0 5}
light 3 off

#improving quality of rendered image using light settings
display shadows off
display ambientocclusion on
display aoambient 1.000000
display aodirect 0.700000 

#to keep consistent location for each image
display resetview 

#syncronize scale for each image
scale to 0.00055 

#size of image in pixels (do not change)
display resize 2300 2300
display resetview
scale to 0.00055


#the following for rotation, center, scale and global matrices
#prevent the drifting of different time images to offset the 
#'adjustments' vmd makes in the viewing coordinates by fixing all 
#images to the same coordinates (no need to change)
set rot_mat {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}}
molinfo set rotate_matrix [list $rot_mat]


set cen_mat {{1 0 0 50.8666} {0 1 0 -81.4157} {0 0 1 -10.3551} {0 0 0 1}}
molinfo top set center_matrix [list $cen_mat]


set scale_mat {{0.000375034 0 0 0} {0 0.000375034 0 0} {0 0 0.000375034 0} {0 0 0 1}}
molinfo top set scale_matrix [list $scale_mat]


set glo_mat {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}}
molinfo top set global_matrix [list $glo_mat]

#CHANGE THE FOLLOWING LINE TO CHANGE THE 'ZOOM' OF THE IMAGE RELATIVE TO THE SIZE
#scale to 0.0006
scale to 0.0006

rotate x by 180.000000

#adding a text box for the time, curly brackets show the xyz coordinates 
draw color black
graphics top text {1500 3800 0} "time" size 0.75 thickness 1

#render command
render TachyonInternal test_top.tga  %s 


menu color off
menu graphics off


# VMD for MACOSXX86, version 1.9.2 (December 29, 2014)
# end of log file.

exit

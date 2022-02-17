# Binoy image making
Scripts that do binoy images are here. Given a bunch of dot mat
files, images are generated in parallel. Read the instructions here
before usage.

## Preamble

These are called binoy images because the person who originated
this image making is Binoy, a masters student who worked with
us a while ago.

Obviously, VMD has to be installed and the paths in some files
edited to ensure that these are pointing to the correct VMD path.

Also, if you want to use OPTION 2 below, you have to install
the 'CGAL' and 'Boost' libraries. Some instructions to do this
are provided in the file cgal\_install\_instructions.txt. These
are not complete instructions, so expect to google and do some
work here (perhaps 1-2 hours for a person with sufficient
linux competence). These libraries are used to triangulate
the surface of the fictional septum, so that such a triangulation
can be used by VMD to make the images.

## Instructions

Put .mat files here, and

OPTION 1 put a suitable septum tcl file here with the
name septum.tcl, and run task\_binoy\_6.sh. So all the .mat files
here will have the same septum given by septum.tcl.

OPTION 2 
a. run mat\_to\_off.sh using sbatch in a slurm-scheduler
based computer or otherwise. This will read all the dot mat files in
the current directory, extract a ring radius from each of them, and
generate septum off files for each one of them. (Off files are
a format used to save geometric objects I think. Say, for instance,
a triangulated surface).NOTE: this step is done sequentially i.e.
each off file is generated from each mat file one after the other instead
of utilizing parallel jobs. Fix this in future iterations.

b. Now run task\_binoy\_6.sh. Each ring will be made with its own
septum. If there exist dot mat files without a corresponding dot off
file, then the fall-back septum.tcl file will be used for these rings.
NOTE: if you want some dot mat files to have their own septum and others
to use the fall back septum.tcl, then simply rename the files of category
2 to have an extension other than dot mat i.e. for instance dot mat 2.
Then run step a above. The shell script will ignore these files as
they do not have a dot mat extension. Then, rename these files back
to dot mat before running this step (step b).

The generated png files are put in the png directory.

# Septum tcl library
As these are big files, they are stored separately in google drive.

# Movie making
For movie, edit make\_movie.sh and run it, after the png files were made.

# Some notes
* Adjust the time per job in task\_binoy\_6.sh depending on whether the septum
tcl file is for 0 min or 10 min etc. i.e. a more grown septum will have more
triangles and will take longer to render.

* ST says on terremoto a 0 min septum takes about 10 min to render when a CPU
with memory of 20 gb is used.

* make\_movie.sh, retrieve\_times\_files.m has to be customized
according to the prefix of the dot mat files etc. i.e. if there
are changes to the naming conventions or prefixes used for dot mat files,
then have a look at these scripts to see if they need to be modified.

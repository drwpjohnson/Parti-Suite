#!/bin/tcsh
set echo
# if using modules, load the correct modules, setting path to compiler and MPI
module purge
module load intel-oneapi-compilers/2021.4.0 openmpi/4.1.1

# for old style shell init scripts
#source /uufs/chpc.utah.edu/sys/pkg/intel/ics/impi/std/bin64/mpivars.csh
setenv PRGDIR "/uufs/chpc.utah.edu/common/home/u0034962/king4/bin"
#setenv BINDIR "/uufs/chpc.utah.edu/common/home/u0034962/geophys/wjohnson/submit_bin"
setenv BINDIR "/uufs/chpc.utah.edu/common/home/u0034962/king4/bin"

#setenv MPIDIR "/uufs/arches/sys/pkg/mpich/std"
# number of particles
set NPART = $1
# number of processors to run on
set NPROC = $2
#@ NPROC1 = `expr $NPROC + 1` 

#echo NPROC1 $NPROC1

#set NNODE = $SLURM_NNODES

# Don't change anything from here on
# For Python binary----------------------------------------------------------
set PROGRAM="python3 $PRGDIR/traj_hap.py"
set OUTPUTDIR=`pwd`

# prepare job list file
echo $NPART > job.list
@ IPART = 1
while ($IPART <= $NPART)
  echo "/usr/bin/python3 $PRGDIR/traj_hap.py $NPART $IPART $OUTPUTDIR" >> job.list
#  for specific starting location with NPART=1
#  echo "/usr/bin/python3 $PRGDIR/traj_hap.py 1 1 $OUTPUTDIR 6.8741727e-07 -3.5873458e-06" >> job.list
  @ IPART = $IPART + 1
end

echo Running and writing output to $OUTPUTDIR

# Ensure job.list is fully flushed before submit reads it
sync

mpirun -np $NPROC $BINDIR/submit $OUTPUTDIR
#mpdallexit

# File names to concatenate and length of headers (in line) to cut out
#set FILENAMES=(P3DDCTRAJATT P3DDCTRAJREM P3DDCTRAJEX P3DDCFLUXATT P3DDCFLUXREM P3DDCFLUXEX)
#set HEADLN=(2 2 2 5 5 5)
set FILENAMES=(HAPHETFLUXATT HAPHETFLUXREM HAPHETFLUXEX)
# Header line count is detected dynamically from the first available
# per-particle file, so hardcoded counts are not needed
@ FILEID = 1
# Seed each final output file with a header, taken from the first particle
# file that exists for that flux type
foreach FILENAME ($FILENAMES)
  set HEADER_WRITTEN = 0
  @ JSEARCH = 1
  while ($JSEARCH <= $NPART && $HEADER_WRITTEN == 0)
    if (-e $FILENAME.$JSEARCH.OUT) then
      # Count header lines dynamically: everything before the first data row
      set HEADLN_DYN = `grep -n '^[[:space:]]*[0-9]' $FILENAME.$JSEARCH.OUT | head -1 | cut -d: -f1`
      @ HEADLN_DYN = $HEADLN_DYN - 1
      head -n $HEADLN_DYN $FILENAME.$JSEARCH.OUT > $FILENAME.OUT
      set HEADER_WRITTEN = 1
    endif
    @ JSEARCH = $JSEARCH + 1
  end
  @ FILEID = $FILEID + 1
end

#exit

# concatenate output files and remove the intermediate ones
@ IPART = 1
while ($IPART <= $NPART)
  @ FILEID = 1
  foreach FILENAME ($FILENAMES)
    # Only one flux file is created per particle; skip the other two
    if (-e $FILENAME.$IPART.OUT) then
      set NUMLNS=`wc -l $FILENAME.$IPART.OUT | cut -f 1 -d " "`
      set HEADLN_DYN = `grep -n '^[[:space:]]*[0-9]' $FILENAME.$IPART.OUT | head -1 | cut -d: -f1`
      @ HEADLN_DYN = $HEADLN_DYN - 1
      @ NMLNS = $NUMLNS - $HEADLN_DYN
      tail -n $NMLNS $FILENAME.$IPART.OUT > $FILENAME.$IPART.OUT.TMP
      cat $FILENAME.$IPART.OUT.TMP >> $FILENAME.OUT
      rm $FILENAME.$IPART.OUT $FILENAME.$IPART.OUT.TMP
    endif
    @ FILEID = $FILEID + 1
  end
  @ IPART = $IPART + 1
end
rm -f $OUTPUTDIR/*.pyc
rm -rf $OUTPUTDIR/__pycache__

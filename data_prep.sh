#! /bin/bash

download_chanda_obsid 17735
cd 17735

punlearn ardlib
chandra_repro . repro

cd repro

## Improving absolute astrometry
# We use the COUP coordinates as the reference frame.
# Those my not be the most accurate, since they pre-date GAIA and are based on
# 2MASS astrometry if I remember correctly, but it will greatly ease the
# comparison to COUP data (and to the Orion VLP project that adopts the 
# same system) if we are on the same coordinate reference.

# The file COUP.fits is from VIZIER
# Go to
# https://vizier.u-strasbg.fr/viz-bin/VizieR-3?-source=J/ApJS/160/319/coup&-out.max=99999&-out.form=FITS%20(binary)%20Table&-out.add=_r&-out.add=_RAJ,_DEJ&-sort=_r&-oc.form=sexa
# and press the "submit" button to download. Save as "COUP.fits"

punlearn dmcopy
dmcopy "acisf17735_repro_evt2.fits[EVENTS][bin x=::1,y=::1]" image option=image clob+

punlearn mkpsfmap
mkpsfmap image psfmap energy=2.3 ecf=0.9 clob+

punlearn wavdetect
wavdetect image \
  outfile=wavedetect.src \
  scell=wavedetect.cell \
  imagefile=wavedetect.recon \
  defnbkgfile=wavedetect.defnbkg \
  psffile=psfmap \
  scales="2 4 8" \
  clob+

punlearn wcs_match
wcs_match infile=wavedetect.src \
  refsrcfile="COUP.fits[cols ra=RAJ2000,dec=DEJ2000]" \
  outfile=wcs_correct \
  wcsfile=acisf17735_repro_evt2.fits \
  verbose=1 clob+ > coord_adjust.log

punlearn wcs_update

wcs_update infile=pcadf596601034N001_asol1.fits \
  outfile=pcadf596601034N001_asol1.fits \
  transformfile=wcs_correct  wcsfile=image clob+ verbose=2

wcs_update infile=acisf17735_repro_evt2.fits \
  outfile=temp \
  transformfile=wcs_correct \
  wcsfile=acisf17735_repro_evt2.fits clob+


## Barycentric correction
# Needed for accurate comparison with NuStar
# We do barycentric correction with center of FOV coordinates
# Since the correction depends on the coordinate, this is inaccurate
# off-center by < 5 s. Good enough for comparison to NuStar.
axbary infile=acisf17735_repro_evt2.fits outfile=evt \
  orbitfile=../primary/orbitf596211304N001_eph1.fits.gz \
  ra=83.8195830 dec=-5.390

# Needed for accurate comparison with NuStar
axbary infile=pcadf596601034N001_asol1.fits outfile=asol \
  orbitfile=../primary/orbitf596211304N001_eph1.fits.gz \
  ra=83.8195830 dec=-5.390

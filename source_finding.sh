# to be tun in directorry "srcfinding"

punlearn dmcopy
dmcopy "../repro/evt[EVENTS][bin x=::1,y=::1]" image option=image clob+

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

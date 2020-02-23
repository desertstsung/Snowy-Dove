.RESET_SESSION

;example: '/home/usr/snydov.sav'
fn='/home/jtsung/snydov.sav'

.COMPILE addmeta
.COMPILE delimg
.COMPILE ffconvert
.COMPILE findpmsimg
.COMPILE gssharpen
.COMPILE log
.COMPILE mosaicgf6
.COMPILE ndvigenerate
.COMPILE opms__define
.COMPILE owfv1__define
.COMPILE owfv6__define
.COMPILE pmshandler
.COMPILE quac
.COMPILE radcal
.COMPILE readjson
.COMPILE rpcortho
.COMPILE rpcredefine
.COMPILE snydov
.COMPILE subsetbyshp
.COMPILE timeex
.COMPILE unzip
.COMPILE wfv1handler
.COMPILE wfv6handler

RESOLVE_ALL, /CONTINUE_ON_ERROR, SKIP_ROUTINES='envi'

SAVE, /ROUTINES, FILENAME=fn, /VERBOSE

exit

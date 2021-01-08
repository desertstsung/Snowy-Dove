;+
;USAGE EXAMPLE UNDER MACOS OR LINUX
;$ idl ./sdRunMain.sh -args /home/jtsung/tds -r /home/jtsung/ds/shp/test_geog.shp -cpq
;$ idl ./sdRunMain.sh -args /home/jtsung/tds
;$ idl ./sdRunMain.sh -args /home/jtsung/tds -d /home/jtsung/ds/dem.tiff -sntc
;-

;+
;   -d path: input [D]EM file
;   -r path: input shapefile [R]egion for subset
;-

;+
;   -c: perform radiance [C]alibration
;   -q: perform [Q]uac
;   -s: reduce the quac outcome to original [S]cale range from 0-1
;         <q> will be set when <s> is set
;   -t: convert envi format outcome to (big)geo[T]iff format
;   -n: generate an extra [N]dvi raster
;   -p: build [P]yramid file (*.enp) to view image in envi quickly
;   -v: explain what is being done in console
;-



;================= compile procedures and functions ================
CD, './src'
.COMPILE sdMain             , sdStructDefine
.COMPILE sdProcessor_PMS    , sdProcessor_GF1_WFV  , sdProcessor_GF6_WFV
.COMPILE sdDecompress       , sdRPCRedefine        , sdRPCWarp
.COMPILE sdSubsetByShp      , sdRadianceCalibration, sdPanSharpen
.COMPILE sdQUAC             , sdQUACDivide         , sdNDVIGenerate
.COMPILE sdConvertToGeoTIFF , sdPyramidCreate      , sdDelTempFiles
.COMPILE sdAddMetadata      , sdDelImageFile       , sdDelTempFiles
.COMPILE sdGetPANMS         , sdLog                , sdLonLatRangeIntersect
.COMPILE sdMosaicGF6        , sdPoint2Underscore   , sdPreLog
.COMPILE sdReadHeader       , sdShpValid           , sdTimeStr
.COMPILE sdValidTempFilename, sdWriteHeader        , sdCommonProcess
RESOLVE_ALL, /CONTINUE_ON_ERROR, SKIP_ROUTINES='envi'



;====================== arguments number check =====================
args      = COMMAND_LINE_ARGS()
nargs     = N_ELEMENTS(args)
errMsg    = 'Invalid number of arguments'
argsLimit = 6
if nargs gt argsLimit or nargs lt 1 then begin & $
  PRINTF, -1, STRJOIN(MAKE_ARRAY(STRLEN(errMsg)+12, VALUE='*', /STRING)) & $
  PRINTF, -1, '***** ' + errMsg + ' *****' & $
  PRINTF, -1, STRJOIN(MAKE_ARRAY(STRLEN(errMsg)+12, VALUE='*', /STRING)) & $
  EXIT & $
endif



;======================= arguments transform =======================
tgzdirIn = args[0]
if nargs then begin & $;1 3 5
  if nargs eq 5 then begin & $
    demfn = args[1] eq '-d' ? args[2] : args[4] & $
    shpfn = args[1] eq '-r' ? args[2] : args[4] & $
  endif else if nargs eq 3 then begin & $
    if args[1] eq '-d' then demfn = args[2] else if args[1] eq '-r' then shpfn = args[2] & $
  endif & $
endif else begin & $;2 4 6
  if STRPOS(args[-1], 'c') ne -1 then CALI    = 1B & $
  if STRPOS(args[-1], 'q') ne -1 then QUAC    = 1B & $
  if STRPOS(args[-1], 's') ne -1 then SCALE   = 1B & $
  if STRPOS(args[-1], 't') ne -1 then TIFF    = 1B & $
  if STRPOS(args[-1], 'n') ne -1 then NDVI    = 1B & $
  if STRPOS(args[-1], 'p') ne -1 then PYRAMID = 1B & $
  if STRPOS(args[-1], 'v') ne -1 then VERBOSE = 1B & $
  if nargs eq 6 then begin & $
    demfn = args[1] eq '-d' ? args[2] : args[4] & $
    shpfn = args[1] eq '-r' ? args[2] : args[4] & $
  endif else if nargs eq 4 then begin & $
    if args[1] eq '-d' then demfn = args[2] else if args[1] eq '-r' then shpfn = args[2] & $
  endif & $
endelse



;============================= execute =============================
sdMain, tgzdirIn, DEM=demfn, REGION=shpfn, CALI=CALI, QUAC=QUAC, SCALE=SCALE, TIFF=TIFF, NDVI=NDVI, PYRAMID=PYRAMID, VERBOSE=VERBOSE



;=============================== exit ==============================
.FULL_RESET_SESSION
PRINTF, -1, '**************************'
PRINTF, -1, '******** EXIT IDL ********'
PRINTF, -1, '**************************'
EXIT

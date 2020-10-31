;+
; Function to return a sd-structure of a tgz file
;
; :Arguments:
;   tgzfn       : input tgz filename
;   dem         : input dem filename
;   shp         : input shapefile filename
;   dir         : directory of output
;   fcalibration: flag of radiance calibration
;   fquac1      : flag of QUAC
;   fquacdivide : flag of divide 10000 on the result of QUAC
;   ftiff       : flag of convert envi format to tiff
;   fndvi       : flag of calculate NDVI
;   fpyramid    : flag of build pyramid
;   fverbose    : flag of print steps
;-
function sdStructDefine, tgzfn        = tgzfnIn     , $
                         dem          = demIn       , $
                         shp          = shpIn       , $
                         dir          = outDir      , $
                         fcalibration = FCALIBRATION, $
                         fquac1       = FQUAC       , $
                         fquacdivide  = FQUACDIVIDE , $
                         ftiff        = FTIFF       , $
                         fndvi        = FNDVI       , $
                         fpyramid     = FPYRAMID    , $
                         fverbose     = FVERBOSE
  compile_opt idl2, hidden
  common sdblock, e
  
  ;useful information from the filename of tgz file
  information = STRTOK(FILE_BASENAME(tgzfnIn), '_', /EXTRACT)
  satellite   = information[0]
  sensor      = information[1]
  year        = STRMID(information[4], 0, 4)
  
  ;L1 images directory to store decompress files
  L1imagesdir = FILEPATH(FILE_BASENAME(tgzfnIn, '.tar.gz') + '_SnowyDove', $
                         ROOT_DIR=FILE_DIRNAME(tgzfnIn))
  ;output filename
  outputfn    = FILEPATH(sdPoint2Underscore(STRJOIN(information[0:4], '_')), ROOT_DIR=outDir)
  
  ;processor name
  if STRPOS(sensor, 'PMS') ne -1 then processorname = 'sdProcessor_PMS'     $
  else if satellite eq 'GF1'     then processorname = 'sdProcessor_GF1_WFV' $
  else if satellite eq 'GF6'     then processorname = 'sdProcessor_GF6_WFV'
  
  ;shapefile test
  if ISA(shpIn) then if FILE_TEST(shpIn) then strshp = shpIn else strshp = 0B else strshp = 0B
  
  ;get temp filenames
  tempfiles = STRARR(20)
  for i = 0, 19 do tempfiles[i] = e.GetTemporaryFilename('')
  
  ;get wavelength
  @sd_wavelength
  ;get radiance calibration coefs
  @sd_radcalcoeff_main
  
  ;return structure
  RETURN, {tgzfn           : tgzfnIn          , $
           L1imagesdir     : L1imagesdir      , $
           outputfn        : outputfn         , $
           callpro         : processorname    , $
           cali_gain       : gain             , $
           cali_offset     : offset           , $
           wavelength      : wavelength       , $
           demfn           : demIn            , $
           sshp            : strshp           , $
           flag_calibration: ISA(FCALIBRATION), $
           flag_quac       : ISA(FQUAC)       , $
           flag_quacdivide : ISA(FQUACDIVIDE) , $
           flag_tiff       : ISA(FTIFF)       , $
           flag_ndvi       : ISA(FNDVI)       , $
           flag_pyramid    : ISA(FPYRAMID)    , $
           flag_verbose    : ISA(FVERBOSE)    , $
           tempfiles       : tempfiles          $
          }
end
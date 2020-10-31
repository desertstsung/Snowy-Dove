;+
; Procedure to process PMS data
;-
pro sdProcessor_PMS
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  ;log
  ;and decompress tgz filesdPreLog
  ;and get pan and ms file
  sdPreLog
  sdDecompress
  sdGetPANMS, pan, ms
  
  ;gf6 need to reload spatial reference
  ;in order to do RPC Orthorectification
  if (isGF6 = STRPOS(FILE_BASENAME(sdstruct.tgzfn), 'GF6') ne -1) then begin
    sdRPCRedefine, pan
    sdRPCRedefine, ms
  endif
  
  ;RPC-based warp(orthorectify)
  fns = sdValidTempFilename(/WRITABLE, /TWO)
  sdRPCWarp, pan, fns[0]
  sdRPCWarp, ms , fns[1]
  
  ;subset using shapefile if provide
  if sdstruct.sshp then begin
    fns = sdValidTempFilename(/IO, /TWO)
    sdSubsetByShp, fns[0], fns[2]
    sdSubsetByShp, fns[1], fns[3]
  endif
  
  ;radiance calibration
  if sdstruct.flag_calibration then begin
    fns = sdValidTempFilename(/IO, /TWO)
    sdRadianceCalibration, fns[0], fns[2]
    sdRadianceCalibration, fns[1], fns[3]
  endif
  
  ;pan sharpen
  if sdstruct.flag_quac or sdstruct.flag_quacdivide then begin
    fns = sdValidTempFilename(/IO, /TWO)
    sdPanSharpen, fns[0], fns[1], fns[2]
  endif else begin
    fns = sdValidTempFilename(/READABLE, /TWO)
    sdPanSharpen, fns[0], fns[1], sdstruct.outputfn
  endelse
  
  ;common process same in both PMS and WFV
  sdCommonProcess
end

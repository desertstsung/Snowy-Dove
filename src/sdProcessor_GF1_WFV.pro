;+
; Procedure to process GF1-WFV data
;-
pro sdProcessor_GF1_WFV
  compile_opt idl2, hidden
  common sdblock, e, sdstruct

  ;log and decompress tgz file
  sdPreLog
  sdDecompress
  
  ;RPC-based warp(orthorectify)
  ms = FILE_SEARCH(sdstruct.L1imagesdir, '*.tiff')
  if sdstruct.sshp || sdstruct.flag_calibration || sdstruct.flag_quac || sdstruct.flag_quacdivide then begin
    sdRPCWarp, ms, sdValidTempFilename(/WRITABLE)
  endif else begin
    sdRPCWarp, ms, sdstruct.outputfn
  endelse
  
  ;subset using shapefile if provide
  if sdstruct.sshp then begin
    if sdstruct.flag_calibration or sdstruct.flag_quac or sdstruct.flag_quacdivide then begin
      fns = sdValidTempFilename(/IO)
      sdSubsetByShp, fns[0], fns[1]
    endif else begin
      sdSubsetByShp, (fn = sdValidTempFilename(/READABLE)), sdstruct.outputfn
      if ~FILE_TEST(sdstruct.outputfn) then FILE_MOVE, fn, sdstruct.outputfn
    endelse
  endif
  
  ;radiance calibration
  if sdstruct.flag_calibration then begin
    if sdstruct.flag_quac or sdstruct.flag_quacdivide then begin
      fns = sdValidTempFilename(/IO)
      sdRadianceCalibration, fns[0], fns[1]
    endif else begin
      sdRadianceCalibration, sdValidTempFilename(/READABLE), sdstruct.outputfn
    endelse
  endif
  
  ;common process same in both PMS and WFV
  sdCommonProcess
end
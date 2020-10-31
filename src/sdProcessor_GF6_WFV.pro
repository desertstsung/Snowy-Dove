;+
; Procedure to process GF6-WFV data
;-
pro sdProcessor_GF6_WFV
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  ;log and decompress tgz file
  sdPreLog
  sdDecompress
  
  scenes      = FILE_SEARCH(sdstruct.L1imagesdir, '*.tiff')
  orthoscenes = !NULL
  foreach scene, scenes do begin
    ;gf6 need to reload spatial reference
    ;in order to do RPC Orthorectification
    sdRPCRedefine, scene

    ;RPC-based warp(orthorectify)
    sdRPCWarp, scene, (fn = sdValidTempFilename(/WRITABLE))
    orthoscenes = [orthoscenes, fn]
  endforeach
  
  ;mosaic gf6-wfv
  if sdstruct.sshp || sdstruct.flag_calibration || sdstruct.flag_quac || sdstruct.flag_quacdivide then begin
    sdMosaicGF6, orthoscenes, (mfn = sdValidTempFilename(/WRITABLE))
  endif else begin
    sdMosaicGF6, orthoscenes, sdstruct.outputfn
  endelse
  
  ;subset using shapefile if provide
  if sdstruct.sshp then begin
    if sdstruct.flag_calibration or sdstruct.flag_quac or sdstruct.flag_quacdivide then begin
      sdSubsetByShp, mfn, sdValidTempFilename(/WRITABLE)
    endif else begin
      sdSubsetByShp, mfn, sdstruct.outputfn
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
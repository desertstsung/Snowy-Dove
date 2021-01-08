;+
; Procedure that can process both PMS and WFV
;-
pro sdCommonProcess
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  ;QUAC
  if sdstruct.flag_quac then begin
    if sdstruct.flag_quacdivide then begin
      fns = sdValidTempFilename(/IO)
      sdQUAC, fns[0], fns[1]
    endif else begin
      sdQUAC, sdValidTempFilename(/READABLE), sdstruct.outputfn
    endelse
  endif

  ;divide 10000 on the result of QUAC
  if sdstruct.flag_quacdivide then begin
    sdQUACDivide, sdValidTempFilename(/READABLE), sdstruct.outputfn
  endif

  ;QUAC produce raster with '.HDR' header
  ;but in this progress
  ;raster is with '.hdr' header by default
  ;thus, rename the header, only in linux
  if FILE_TEST((h = sdstruct.outputfn+'.HDR')) then FILE_MOVE, h, sdstruct.outputfn+'.hdr', /ALLOW_SAME

  ;NDVI
  if sdstruct.flag_ndvi then begin
    sdNDVIGenerate, sdstruct.outputfn
  endif

  ;convert to tiff
  if sdstruct.flag_tiff then begin
    sdConvertToGeoTIFF, sdstruct.outputfn
  endif else if ~sdstruct.flag_quac then begin
    sdAddMetadata, sdstruct.outputfn, $
      'wavelength = {' + STRJOIN(STRING(sdstruct.wavelength, FORMAT='(I3)'), ',') + '}'
    sdAddMetadata, sdstruct.outputfn, 'wavelength units = Nanometers'
  endif

  ;create pyramid and del temp files
  if sdstruct.flag_pyramid then sdPyramidCreate
  sdDelTempFiles

  sdLog, 'end processing ', sdstruct.tgzfn, /HEAD
end
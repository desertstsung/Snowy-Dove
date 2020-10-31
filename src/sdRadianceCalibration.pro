;+
; Procedure to perform radiance calibration
;
; :Arguments:
;   fileIn : input  filename
;   fileOut: output filename
;-
pro sdRadianceCalibration, fileIn, fileOut
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux
  sdLog, 'radiance calibration [I]: ', fileIn
  
  sdReadHeader, fileIn, NB=nb
  if nb ne N_ELEMENTS(sdstruct.cali_gain) then begin
    if nb eq 1 then begin
      ;pan input
      gain = sdstruct.cali_gain[0]
      offs = sdstruct.cali_offset[0]
    endif else begin
      ;ms input
      gain = sdstruct.cali_gain[1:-1]
      offs = sdstruct.cali_offset[1:-1]
    endelse
  endif else begin
    ;wfv input
    gain = sdstruct.cali_gain
    offs = sdstruct.cali_offset
  endelse
  
  ;use executable sd_radcal(.exe) to apply radiance calibration
  script = FILEPATH('sd_radcal' + (islinux ? '' : '.exe'), ROOT_DIR=FILE_DIRNAME(FILE_DIRNAME(ROUTINE_FILEPATH())), SUBDIRECTORY='binary') $
           + ' '                                                                                                                           $
           + fileIn                                                                                                                        $
           + ' '                                                                                                                           $
           + fileOut                                                                                                                       $
           + ' '                                                                                                                           $
           + STRJOIN(STRING(gain, FORMAT='(F6.4)'), ' ')                                                                                   $
           + ' '                                                                                                                           $
           + STRJOIN(STRING(offs, FORMAT='(F6.4)'), ' ')
  SPAWN, script
  
  sdLog, 'radiance calibration [O]: ', fileOut
end
;+
; Procedure to divide 10000 on the result of QUAC
;
; :Arguments:
;   fileIn : input  filename
;   fileOut: output filename
;-
pro sdQUACDivide, fileIn, fileOut
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux
  
  sdLog, 'QUAC scale to original factor [I]: ', fileIn

  ;use executable sd_radcal(.exe) to divide
  sdReadHeader, fileIn, NB=nb
  SPAWN, FILEPATH('sd_radcal' + (islinux ? '' : '.exe'), ROOT_DIR=FILE_DIRNAME(FILE_DIRNAME(ROUTINE_FILEPATH())), SUBDIRECTORY='binary') $
         + ' '                                                                                                                           $
         + fileIn                                                                                                                        $
         + ' '                                                                                                                           $
         + fileOut                                                                                                                       $
         + ' '                                                                                                                           $
         + STRJOIN(STRING(FLTARR(nb) + 0.0001E, FORMAT='(F6.4)'), ' ')                                                                   $
         + ' '                                                                                                                           $
         + STRJOIN(STRING(FLTARR(nb), FORMAT='(F6.4)'), ' ')

  sdLog, 'QUAC scale to original factor [O]: ', fileOut
end
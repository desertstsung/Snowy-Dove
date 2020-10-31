;+
; Procedure to write header file
;
; :Arguments:
;   fileIn: input filename
;   sarray: input string array
;-
pro sdWriteHeader, fileIn, sarray
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun
  
  OPENW   , lun, fileIn
  PRINTF  , lun, STRJOIN(sarray, STRING(10B))
  FREE_LUN, lun
end
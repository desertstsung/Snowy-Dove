;+
; Procedure to add metadata to a raster file
;
; :Arguments:
;   fileIn: input raster filename
;   strIn : input metadata string to be written to the header file
;-
pro sdAddMetadata, fileIn, strIn
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun
  
  OPENW   , lun, fileIn+'.hdr', /APPEND
  PRINTF  , lun, strIn
  FREE_LUN, lun
end
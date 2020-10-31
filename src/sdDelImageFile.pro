;+
; Procedure to delete raster file and ralate file
;
; :Arguments:
;   fileIn: input raster filename
;-
pro sdDelImageFile, fileIn
  compile_opt idl2, hidden
  
  FILE_DELETE, fileIn             , /ALLOW_NONEXISTENT, /QUIET; raster file
  FILE_DELETE, fileIn + '.hdr'    , /ALLOW_NONEXISTENT, /QUIET; header file
  FILE_DELETE, fileIn + '.HDR'    , /ALLOW_NONEXISTENT, /QUIET; header file
  FILE_DELETE, fileIn + '.enp'    , /ALLOW_NONEXISTENT, /QUIET; pyramid file
  FILE_DELETE, fileIn + '.aux.xml', /ALLOW_NONEXISTENT, /QUIET; xml file produced by gdal
end
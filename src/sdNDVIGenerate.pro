;+
; Procedure to generate NDVI raster
;
; :Arguments:
;   fileIn: input filename to calculate NDVI
;-
pro sdNDVIGenerate, fileIn
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux
  
  ;use executable sd_ndvi(.exe) to perform NDVI generate
  sdLog, 'perform NDVI [I]: ', fileIn
  SPAWN, FILEPATH('sd_ndvi' + (islinux ? '' : '.exe'), ROOT_DIR=FILE_DIRNAME(FILE_DIRNAME(ROUTINE_FILEPATH())), SUBDIRECTORY='binary') $
         + ' '                                                                                                                         $
         + fileIn                                                                                                                      $
         + ' '                                                                                                                         $
         + fileIn + '_NDVI'
  sdLog, 'perform NDVI [O]: ', fileIn + '_NDVI'
end
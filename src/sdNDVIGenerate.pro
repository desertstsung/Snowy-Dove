;+
; Procedure to generate NDVI raster
;
; :Arguments:
;   fileIn: input filename to calculate NDVI
;-
pro sdNDVIGenerate, fileIn
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux
  
  sdLog, 'perform NDVI [I]: ', fileIn
  
  ;use executable sd_ndvi(.exe) to perform NDVI generate
  exefn  = '"' + $
           FILEPATH('sd_ndvi' + (islinux ? '' : '.exe'), $
                    ROOT_DIR=FILE_DIRNAME(FILE_DIRNAME(ROUTINE_FILEPATH())), $
                    SUBDIRECTORY='binary') + $
           '"'
  par1   = '"' + fileIn + '"'
  par2   = '"' + fileIn + '_NDVI' + '"'
  strCLI = STRJOIN([exefn, par1, par2], ' ')
  if islinux then SPAWN, strCLI else SPAWN, strCLI, /HIDE
  sdLog, 'perform NDVI [O]: ', fileIn + '_NDVI'
end
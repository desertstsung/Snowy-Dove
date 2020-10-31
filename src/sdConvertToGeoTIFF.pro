;+
; Procedure to convert ENVI format raster to (Big)GeoTIFF format
;
; :Arguments:
;   fileIn: input ENVI format raster filename
;-
pro sdConvertToGeoTIFF, fileIn
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux
  sdLog, 'ENVI2TIFF [I]: ', fileIn
  
  ;use executable sd_nv2tiff(.exe) to perform file format convert
  SPAWN, FILEPATH('sd_nv2tiff' + (islinux ? '' : '.exe'), $
                  ROOT_DIR=FILE_DIRNAME(FILE_DIRNAME(ROUTINE_FILEPATH())), $
                  SUBDIRECTORY='binary') $
         + ' ' + fileIn
  
  ;add wavelength to header in order to load true color or CIR easily
  sdReadHeader  , fileIn, NS=ns, NL=nl, NB=nb, DT=dt, INTER=inter
  sdDelImageFile, fileIn
  swvl = STRJOIN(STRING(sdstruct.wavelength, FORMAT='(I3)'), ',')
  sdWriteHeader, fileIn+'_TIFF.hdr', ['ENVI'                                  , $
                                      'samples = ' + STRTRIM(STRING(ns), 2)   , $
                                      'lines   = ' + STRTRIM(STRING(nl), 2)   , $
                                      'bands   = ' + STRTRIM(STRING(nb), 2)   , $
                                      'data type  = ' + STRTRIM(STRING(dt), 2), $
                                      'interleave = ' + inter                 , $
                                      'file type  = TIFF'                     , $
                                      'wavelength = {' + swvl + '}'           , $
                                      'wavelength units = Nanometers']
  sdLog, 'ENVI2TIFF [O]: ', fileIn+'_TIFF.tiff'
end
;+
; Procedure to perform QUAC
;
; :Arguments:
;   fileIn : input  filename
;   fileOut: output filename
;-
pro sdQUAC, fileIn, fileOut
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  sdLog, 'QUAC [I]: ', fileIn
  
  ;add wavelength in order to perform QUAC
  sdAddMetadata, fileIn, $
    'wavelength = {' + STRJOIN(STRING(sdstruct.wavelength, FORMAT='(I3)'), ',') + '}'
  sdAddMetadata, fileIn, 'wavelength units = Nanometers'
  
  raster                 = e.OpenRaster(fileIn)
  Task                   = ENVITASK('QUAC')
  Task.INPUT_RASTER      = raster
  Task.OUTPUT_RASTER_URI = fileOut
  Task.Execute
  Task.OUTPUT_RASTER.Close
  raster.Close
  sdLog, 'QUAC [O]: ', fileOut
end
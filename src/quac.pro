;+
; procedure to apply quick atmospheric correction
;
; :Arguments:
;   i_fn: input filename
;-
pro quac, i_fn
  compile_opt idl2, hidden
  log, 'QUAC [I]: ', i_fn

  ;get target filename
  o_fn = (!obj.files)[0]

  ;envitask to apply QUAC
  inRaster = !e.OpenRaster(i_fn)
  addMeta, inRaster, 'wavelength', !obj.wvl
  addMeta, inRaster, 'wavelength units', 'Nanometers'
  Task = ENVITask('QUAC')
  Task.INPUT_RASTER = inRaster
  Task.OUTPUT_RASTER_URI = o_fn
  Task.Execute
  Task.OUTPUT_RASTER.Close
  inRaster.Close
  log, 'QUAC [O]: ', o_fn
end
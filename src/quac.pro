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
  if (!obj.flag)[2] eq '1' then begin
    !obj.appendFile
    o_fn = !obj.getLastFile()
  endif else o_fn = (!obj.files)[0]

  ;add wavelength info
  raster = !e.OpenRaster(i_fn)
  addMeta, raster, 'Wavelength', !obj.wvl
  addMeta, raster, 'wavelength units', 'Nanometers'
  raster.Close

  ;envitask to apply QUAC
  inRaster = !e.OpenRaster(i_fn)
  Task = ENVITask('QUAC')
  Task.INPUT_RASTER = inRaster
  Task.OUTPUT_RASTER_URI = o_fn
  Task.Execute
  Task.OUTPUT_RASTER.Close
  inRaster.Close
  log, 'QUAC [O]: ', o_fn

  ;reduce the QUAC outcome to original scale range from 0-1
  if (!obj.flag)[2] eq '1' then begin
    i_fn = !obj.getLastFile()
    o_fn = (!obj.files)[0]
    log, 'QUAC divide 10k [I]: ', i_fn

    orgRaster = !e.OpenRaster(i_fn)
    outRaster = ENVIRaster(URI = o_fn, $
      (orgRaster.GetData()) / 10000.0, $
      INHERITS_FROM = orgRaster, DATA_TYPE = 4)
    outRaster.Save
    outRaster.Close
    orgRaster.Close
    log, 'QUAC divide 10k [O]: ', o_fn
  endif
end

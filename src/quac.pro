pro quac, i_fn
  compile_opt idl2, hidden
  log, 'quac initialize'
  log, 'quac in: ' + FILE_BASENAME(i_fn)

  if (!obj.flag)[2] eq '1' then begin
    !obj.appendFile
    o_fn = !obj.getLastFile()
  endif else o_fn = (!obj.files)[0]

  raster = !e.OpenRaster(i_fn)
  addMeta, raster, 'Wavelength', !obj.wvl
  addMeta, raster, 'wavelength units', 'Nanometers'
  raster.Close
  log, 'quac addWavelength done'

  inRaster = !e.OpenRaster(i_fn)
  Task = ENVITask('QUAC')
  log, 'quac task ready'
  Task.INPUT_RASTER = inRaster
  Task.OUTPUT_RASTER_URI = o_fn
  Task.Execute
  Task.OUTPUT_RASTER.Close
  inRaster.Close
  log, 'quac done'
  log, 'quac out: ' + FILE_BASENAME(o_fn)

  if (!obj.flag)[2] eq '1' then begin
    i_fn = !obj.getLastFile()
    o_fn = (!obj.files)[0]

    orgRaster = !e.OpenRaster(i_fn)
    outRaster = ENVIRaster(URI = o_fn, $
      (orgRaster.GetData()) / 10000.0, $
      INHERITS_FROM = orgRaster, DATA_TYPE = 4)
    outRaster.Save
    outRaster.Close
    orgRaster.Close
    log, 'quac divide 10k done'
    log, 'quac divide 10k out: ' + FILE_BASENAME(o_fn)
  endif
end
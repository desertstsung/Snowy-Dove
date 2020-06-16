;+
; procedure to apply quick atmospheric correction
;
; :Arguments:
;   i_fn: input filename
;-
pro quac, i_fn
  compile_opt idl2, hidden
  common blkScl, sclSet
  log, 'QUAC [I]: ', i_fn

  ;get target filename
  if sclSet then begin
    !obj.appendFile
    o_fn = !obj.getLastFile()
  endif else o_fn = (!obj.files)[0]

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

  ; quac = quac / 10000.0
  if sclSet then begin
    log, 'QUAC scale to original factor [I]: ', o_fn

    readHeader, o_fn, nb = nb

    sd_radcal, o_fn, (!obj.files)[0], FLTARR(nb) + 0.0001E, FLTARR(nb)

    log, 'QUAC scale to original factor [O]: ', (!obj.files)[0]
  endif
end

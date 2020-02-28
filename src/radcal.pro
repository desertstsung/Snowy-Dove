;+
; procedure to apply qradiance calibration
;
; :Arguments:
;   i_fn: input filename
;   o_fn: target calibrated filename
;-
pro radCal, i_fn, o_fn
  compile_opt idl2, hidden
  log, 'radiance calibration [I]: ', i_fn

  ;add gain and offset value
  inRaster = !e.OpenRaster(i_fn)
  if inRaster.NBANDS ne N_ELEMENTS(!obj.calGain) then begin
    if inRaster.NBANDS eq 1 then begin
      addMeta, inRaster, 'data gain values', (!obj.calGain)[0]
      addMeta, inRaster, 'data offset values', (!obj.calOffs)[0]
    endif else begin
      addMeta, inRaster, 'data gain values', (!obj.calGain)[1:-1]
      addMeta, inRaster, 'data offset values', (!obj.calOffs)[1:-1]
    endelse
  endif else begin
    addMeta, inRaster, 'data gain values', !obj.calGain
    addMeta, inRaster, 'data offset values', !obj.calOffs
  endelse

  ;envitask to apply calibration
  task = ENVITask('RadiometricCalibration')
  task.Input_Raster = inRaster
  task.Output_Raster_URI = o_fn
  task.Execute
  inRaster.Close
  log, 'radiance calibration [O]: ', o_fn
end
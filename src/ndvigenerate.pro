;+
; procedure to produce an extra NDVI raster
;
; :Arguments:
;   i_fn: filename of original raster to produce NDVI
;   o_fn: filename of target NDVI raster
;-
pro ndviGenerate, i_fn, o_fn
  compile_opt idl2, hidden
  log, 'perform NDVI [I]: ', i_fn

  sd_ndvi, i_fn, o_fn

  log, 'perform NDVI [O]: ', o_fn

  ;create pyramid
  common blk, pymd
  if pymd then begin
    log, 'creating raster pyramid...'
    raster = !e.OpenRaster(o_fn)
    raster.CreatePyramid
    raster.Close
    log, 'create raster pyramid done'
  endif
end

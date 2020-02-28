;+
; procedure to apply orthorectification
;
; :Arguments:
;   i_fn: input filename
;   dem:  filename of DEM
;   o_fn: target orthoretified filename
;-
pro rpcOrtho, i_fn, dem, o_fn
  compile_opt idl2, hidden
  log, 'RPC orthorectification [I]: ', [i_fn, dem]

  ;envitask to apply RPCOrthorectification
  inRaster = !e.OpenRaster(i_fn)
  demRaster = !e.OpenRaster(dem)
  Task = ENVITask('RPCOrthorectification')
  Task.DEM_RASTER = demRaster
  Task.INPUT_RASTER = inRaster
  Task.OUTPUT_RASTER_URI = o_fn
  Task.Execute
  Task.OUTPUT_RASTER.Close
  inRaster.Close
  demRaster.Close
  log, 'RPC orthorectification [O]: ', o_fn
end
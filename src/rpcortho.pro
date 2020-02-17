pro rpcOrtho, i_fn, dem, o_fn
  compile_opt idl2, hidden
  log, 'rpcOrtho initialize'
  log, 'rpcOrtho in: ' + FILE_BASENAME(i_fn)
  log, 'rpcOrtho dem: ' + FILE_BASENAME(dem)

  inRaster = !e.OpenRaster(i_fn)
  demRaster = !e.OpenRaster(dem)
  Task = ENVITask('RPCOrthorectification')
  log, 'rpcOrtho task ready'
  Task.DEM_RASTER = demRaster
  Task.INPUT_RASTER = inRaster
  Task.OUTPUT_RASTER_URI = o_fn
  Task.Execute
  Task.OUTPUT_RASTER.Close
  inRaster.Close
  demRaster.Close
  log, 'rpcOrtho done'
  log, 'rpcOrtho out: ' + FILE_BASENAME(o_fn)
end
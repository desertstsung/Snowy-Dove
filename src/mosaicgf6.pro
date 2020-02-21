pro mosaicGF6, imgs, o_fn
  compile_opt idl2, hidden
  log, 'mosaicGF6 initialize'
  log, 'mosaicGF6 in: ' + STRJOIN(FILE_BASENAME(imgs), ' ')

  scenes = !NULL
  foreach img, imgs do begin
    scene = !e.OpenRaster(img)
    addMeta, scene, 'data ignore value', 0
    scenes = [scenes, scene]
  endforeach

  raster = ENVIMosaicRaster(scenes)
  log, 'mosaicGF6 raster got'
  raster.Export, o_fn, 'ENVI'

  foreach element, scenes do begin
    element.Close
  endforeach
  log, 'mosaicGF6 done'
  log, 'mosaicGF6 out: ' + FILE_BASENAME(o_fn)
end
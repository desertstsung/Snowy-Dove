;+
; procedure to mosaic scenes for gf6-wfv
;
; :Arguments:
;   imgs: string array to mosaic into one raster
;   o_fn: target raster filename
;-
pro mosaicGF6, imgs, o_fn
  compile_opt idl2, hidden

  ;open the images to mosaic
  scenes = !NULL
  fn = !NULL
  if (!obj.flag)[0] ne '0' then shp = !e.OpenVector((!obj.flag)[0])
  foreach img, imgs do begin
    scene = !e.OpenRaster(img)
    if shp ne !NULL then begin
      roi = ENVIROI()
      roi.AddVectorRecords, shp, 0
      n_inRaster = roi.PixelCount(scene)
      roi.Close
    endif else n_inRaster = 1
    if n_inRaster gt 0 then begin
      addMeta, scene, 'data ignore value', 0
      scenes = [scenes, scene]
      fn = [fn, img]
    endif else begin
      scene.Close
    endelse
  endforeach
  if N_ELEMENTS(fn) eq 0 then begin
    log, 'shapefile does not match the input raster'
    RETURN
  endif
  
  log, 'mosaic GF6 [I]: ', fn

  if N_ELEMENTS(fn) eq 1 then begin
    o_fn = fn[0]
  endif else begin
    raster = ENVIMosaicRaster(scenes)
    raster.Export, o_fn, 'ENVI'
  endelse
  
  ;close them
  foreach element, scenes do begin
    element.Close
  endforeach
  log, 'mosaic GF6 [O]: ', o_fn
end
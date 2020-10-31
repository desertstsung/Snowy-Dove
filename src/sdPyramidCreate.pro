;+
; Procedure to create pyramid
;-
pro sdPyramidCreate
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  sdLog, 'creating raster pyramid...'
  
  ;output raster
  if FILE_TEST((fn = sdstruct.outputfn)) then begin
    raster = e.OpenRaster(fn)
    raster.CreatePyramid
    raster.Close
  endif
  
  ;output NDVI raster
  if FILE_TEST((fn = sdstruct.outputfn+'_NDVI')) then begin
    raster = e.OpenRaster(fn)
    raster.CreatePyramid
    raster.Close
  endif
  
  ;output raster in tiff format
  if FILE_TEST((fn = sdstruct.outputfn+'_TIFF.tiff')) then begin
    raster = e.OpenRaster(fn)
    raster.CreatePyramid
    raster.Close
  endif
  
  sdLog, 'create raster pyramid done'
end
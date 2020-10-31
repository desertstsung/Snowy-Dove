;+
; Procedure for mosaic GF6-WFV iamges
;
; :Arguments:
;   filesIn: string array of input GF6-WFV filenames
;   fileOut: string of output filename
;-
pro sdMosaicGF6, filesIn, fileOut
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  ;get ENVIRaster array to mosaic
  ;using shapefile if provide
  scenes = !NULL
  fn     = !NULL
  foreach img, filesIn do begin
    if sdstruct.sshp then begin
      if ISA((subrect = sdShpValid(fileIn)), 'BYTE') then begin
        sdAddMetadata, img, 'data ignore value = 0'
        scene = e.OpenRaster(img)
        scenes = [scenes, scene]
        fn     = [fn, img]
      endif
    endif else begin
      sdAddMetadata, img, 'data ignore value = 0'
      scene = e.OpenRaster(img)
      scenes = [scenes, scene]
      fn     = [fn, img]
    endelse
  endforeach
  
  sdLog, 'mosaic GF6 [I]: ', fn
  
  ;apply mosaic and export
  if N_ELEMENTS(fn) eq 1 then begin
    ;if there is only one raster in the certain shapefile
    ;then the only raster is the output file
    fileOut = fn[0]
  endif else begin
    raster = ENVIMosaicRaster(scenes)
    raster.Export, fileOut, 'ENVI'
    raster.Close
  endelse
  
  ;close ENVIRaster in the array
  foreach element, scenes do begin
    element.Close
  endforeach
  sdLog, 'mosaic GF6 [O]: ', fileOut
end
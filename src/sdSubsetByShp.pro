;+
; Procedure to subset raster
;
; :Arguments:
;   fileIn : input  filename
;   fileOut: output filename
;-
pro sdSubsetByShp, fileIn, fileOut
  compile_opt idl2, hidden
  common sdblock, e
  sdLog, 'subset by shapefile [I]: ', fileIn
  
  if ISA((subrect = sdShpValid(fileIn)), 'BYTE') then begin
    ;if sdShpValid returns a scalar
    ;then the output file is the input
    sdLog, 'subset by shapefile [O]: ', fileIn
  endif else begin
    raster    = e.OpenRaster(fileIn)
    subraster = raster.Subset(SUB_RECT=subrect)
    subRaster.Export, fileOut, 'envi'
    subRaster.Close
    raster.Close
    sdLog, 'subset by shapefile [O]: ', fileOut
  endelse
end
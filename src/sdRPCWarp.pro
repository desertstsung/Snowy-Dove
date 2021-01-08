;+
; Procedure to perform RPC-based warp
;
; :Arguments:
;   fileIn : input  filename
;   fileOut: output filename
;-
pro sdRPCWarp, fileIn, fileOut
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux
  
  ;if current OS have python3 and gdal(python package) environment
  ;then use python script to perform RPC warp
  if py then begin
    sdLog, 'gdal RPC Warp [I]: ', [fileIn, sdstruct.demfn]
    
    par1   = '"' + $
             FILEPATH('pywarp.py', $
                       ROOT_DIR=FILE_DIRNAME(FILE_DIRNAME(ROUTINE_FILEPATH())), $
                       SUBDIRECTORY='external') + $
             '"'
    par2   = '"' + fileIn          + '"'
    par3   = '"' + sdstruct.demfn  + '"'
    par4   = '"' + fileOut         + '"'
    strCLI = STRJOIN([py, par1, par2, par3, par4], ' ')
    if islinux then SPAWN, strCLI, msg, err else SPAWN, strCLI, msg, err, /HIDE

    if msg eq '-1' or err eq '-1' then begin
      ;if throw error, then use ENVITask intead
      sdLog, 'gdal RPC Warp [O]: failed'
      goto , enviWarp
    endif else begin
      sdLog, 'gdal RPC Warp [O]: ', fileOut
    endelse
  endif else begin
    enviWarp: begin
              sdLog, 'RPC orthorectification [I]: ', [fileIn, sdstruct.demfn]
              rasterIn               = e.OpenRaster(fileIn)
              rasterDEM              = e.OpenRaster(sdstruct.demfn)
              Task                   = ENVITask('RPCOrthorectification')
              Task.DEM_RASTER        = rasterDEM
              Task.INPUT_RASTER      = rasterIn
              Task.OUTPUT_RASTER_URI = fileOut
              Task.Execute
              Task.OUTPUT_RASTER.Close
              rasterIn.Close
              rasterDEM.Close
              sdLog, 'RPC orthorectification [O]: ', fileOut
              end
  endelse
end
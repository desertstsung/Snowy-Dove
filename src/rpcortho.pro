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

  common pyblk, pyFlag, py3Flag
  SPAWN, 'python --version', msg, err
  pyFlag = STREGEX(msg, '3.[0-9]') ne -1 or $
    STREGEX(err, '3.[0-9]') ne -1
  if not pyFlag then begin
    SPAWN, 'python3 --version', msg, err
    py3Flag = STREGEX(msg, '3.[0-9]') ne -1 or $
      STREGEX(err, '3.[0-9]') ne -1
  endif else py3Flag = 0

  if pyFlag or py3Flag then begin

    script = pyFlag ? 'python ' : 'python3 '
    script += FILEPATH('pyortho.py', root = FILE_DIRNAME(ROUTINE_FILEPATH())) + ' '
    script += i_fn + ' ' + dem + ' ' + o_fn
    log, 'gdal RPC orthorectification [I]: ', [i_fn, dem]
    SPAWN, script, msg, err

    if msg eq '-1' or err eq '-1' then begin
      log, 'gdal RPC orthorectification [O]: failed'
      goto, ENVIOrtho
    endif else begin
      log, 'gdal RPC orthorectification [O]: ', o_fn
    endelse

  endif else begin

    ENVIOrtho: begin
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

  endelse
end

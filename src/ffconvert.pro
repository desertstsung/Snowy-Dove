;+
; procedure to transform default envi file format
; to chunky (Big)GeoTIFF
;
; :Arguments:
;   i_fn:   string of input filename to be converted
;   o_fn:   string of target filename
;   wvl_fn: string of wavelength information file
;   info:   string array of satellite and sensor
;           example: ['GF6', 'PMS']
;-
pro ffConvert, i_fn, o_fn, wvl_fn, info
  compile_opt idl2, hidden
  log, 'ENVI2TIFF [I]: ', i_fn

  sd_nv2tf, i_fn

  readHeader, i_fn, ns = ns, nl = nl, nb = nb, dt = dt, inter = inter
  ;add wavelength in order to load true color or CIR easily
  wvl = STRJOIN(STRTRIM(STRING(readJSON(wvl_fn, key = info)), 2), ',')
  wrtHeader, o_fn, ['ENVI', 'samples = ' + STRTRIM(STRING(ns), 2), $
    'lines = ' + STRTRIM(STRING(nl), 2), $
    'bands = ' + STRTRIM(STRING(nb), 2), $
    'data type = ' + STRTRIM(STRING(dt), 2), $
    'interleave = ' + inter, $
    'file type = TIFF', $
    'wavelength = {' + wvl + '}', $
    'wavelength units = Nanometers']
  delImg, i_fn
  log, 'ENVI2TIFF [O]: ', o_fn

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

;+
; procedure to transform default envi file format to tiff
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

  if i_fn ne o_fn then begin
    ;convert to tiff
    raster = !e.OpenRaster(i_fn)
    raster.Export, o_fn, 'tiff', inter = 'bip'
    raster.Close
    delImg, i_fn
  endif

  ;add wavelength in order to load true color or CIR easily
  wvl = STRJOIN(STRTRIM(STRING(readJSON(wvl_fn, key = info)), 2), ',')
  fnHDR = FILEPATH(FILE_BASENAME(o_fn, '.tiff') + '.hdr', $
    root = FILE_DIRNAME(o_fn))
  tmp = QUERY_TIFF(o_fn, info)
  OPENW,  lun, fnHDR, /GET_LUN
  PRINTF, lun, 'ENVI'
  PRINTF, lun, 'samples = ' + STRTRIM(STRING(info.DIMENSIONS[0]), 2)
  PRINTF, lun, 'lines = ' + STRTRIM(STRING(info.DIMENSIONS[1]), 2)
  PRINTF, lun, 'bands = ' + STRTRIM(STRING(info.CHANNELS), 2)
  PRINTF, lun, 'data type = ' + STRTRIM(STRING(info.PIXEL_TYPE), 2)
  PRINTF, lun, 'interleave = bip'
  PRINTF, lun, 'file type = TIFF'
  PRINTF, lun, 'wavelength = {' + wvl + '}'
  PRINTF, lun, 'wavelength units = Nanometers'
  FREE_LUN, lun

  ;create pyramid
  common blk, pymd
  if pymd then begin
    raster = !e.OpenRaster(o_fn)
    raster.CreatePyramid
    raster.Close
  endif

  log, 'ENVI2TIFF [O]: ', o_fn
end
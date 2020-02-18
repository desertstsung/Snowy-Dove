;+
; transform default envi file format to tiff
;
; :Rely-on:
;   readjson.pro
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

  raster = !e.OpenRaster(i_fn)
  raster.Export, o_fn, 'tiff', INTER = 'bip'
  raster.Close
  delImg, i_fn

  wvl = STRTRIM(STRING(readJSON(wvl_fn, key = info)), 1)
  rasterTIFF = !e.OpenRaster(o_fn)
  addMeta, rasterTIFF, 'Wavelength', wvl
  addMeta, rasterTIFF, 'wavelength units', 'Nanometers'
  rasterTIFF.Close
end
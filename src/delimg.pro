;+
; procedure to delete auxiliary files of a raster
;
; :Arguments:
;   fn: raster filename
;-
pro delImg, fn
  compile_opt idl2, hidden

  if ~FILE_TEST(fn) then RETURN
  raster = !e.OpenRaster(fn)
  id = ENVIRasterToFID(raster)
  hdr_fn = raster.AUXILIARY_URI
  ENVI_FILE_MNG, id = id, /REMOVE, /DELETE
  raster.Close

  if hdr_fn ne !NULL then begin
    if STRPOS(FILE_BASENAME(hdr_fn), 'hdr') ne -1 then begin
      FILE_DELETE, FILEPATH(FILE_BASENAME(hdr_fn, 'hdr') + 'HDR', $
        root = FILE_DIRNAME(hdr_fn)), /ALLOW_NONEXISTENT
      FILE_DELETE, hdr_fn, /ALLOW_NONEXISTENT
    endif else if STRPOS(FILE_BASENAME(hdr_fn), 'HDR') ne -1 then begin
      FILE_DELETE, FILEPATH(FILE_BASENAME(hdr_fn, 'HDR') + 'hdr', $
        root = FILE_DIRNAME(hdr_fn)), /ALLOW_NONEXISTENT
      FILE_DELETE, hdr_fn, /ALLOW_NONEXISTENT
    endif
  endif
end
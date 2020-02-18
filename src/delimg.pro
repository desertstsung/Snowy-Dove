pro delImg, fn
  compile_opt idl2, hidden

  ENVI_OPEN_FILE, fn, r_fid = id
  raster = ENVIFIDToRaster(id)
  hdr_fn = raster.AUXILIARY_URI
  raster.Close
  ENVI_FILE_MNG, id = id, /REMOVE, /DELETE

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
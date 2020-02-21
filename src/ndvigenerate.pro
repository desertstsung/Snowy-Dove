;+
; procedure to produce an extra DNVI raster
;
; :Arguments:
;   i_fn: filename to produce NDVI
;   o_fn: target raster filename
;-
pro ndviGenerate, i_fn, o_fn
  compile_opt idl2, hidden

  ;generate NDVI
  ENVI_OPEN_FILE, i_fn, r_fid = fid
  ENVI_FILE_QUERY, fid, dims = dims
  ENVI_DOIT, 'NDVI_DOIT', fid = fid, $
    dims = dims, pos = [3,2], /CHECK, $
    out_bname = 'NDVI', out_dt = 4, $
    out_name = o_fn, r_fid = ndid

  ;close files
  ENVI_FILE_MNG, id = fid, /REMOVE
  ENVI_FILE_MNG, id = ndid, /REMOVE
end
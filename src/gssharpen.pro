pro gsSharpen, o_fn = r_fn
  compile_opt idl2, hidden
  log, 'gsSharpen initialize'

  ;get the mss and pan filename
  !obj._getLast2, mss = mss_fn, pan = pan_fn
  log, 'gsSharpen in: ' + FILE_BASENAME(mss_fn) $
    + '  ' + FILE_BASENAME(pan_fn)

  ;get temporary filename
  if (!obj.flag)[1] eq '1' then begin
    !obj.appendFile
    o_fn = !obj.getLastFile()
  endif else o_fn = (!obj.files)[0]

  ;convert interleave from default bsq to bil
  ;to speed up ENVI_GS_SHARPEN_DOIT
  ENVI_OPEN_FILE, mss_fn, r_fid = mssId
  ENVI_FILE_QUERY, mssId, dims = dims, nb = nb
  ENVI_DOIT, 'convert_inplace_doit', fid = mssId, $
    pos = LINDGEN(nb), dims = dims, $
    o_interleave = 1, r_fid = bilId

  ENVI_OPEN_FILE, pan_fn, r_fid = panId

  ENVI_DOIT, 'ENVI_GS_SHARPEN_DOIT', dims = dims, $
    fid = bilId, hires_fid = panId, $
    hires_pos = LINDGEN(1), method = 0, $
    out_name = o_fn, pos = LINDGEN(nb)

  ENVI_FILE_MNG, id = mssId, /REMOVE
  ENVI_FILE_MNG, id = bilId, /REMOVE
  ENVI_FILE_MNG, id = panId, /REMOVE
  r_fn = o_fn
  log, 'gsSharpen done'
  log, 'gsSharpen out: ' + FILE_BASENAME(o_fn)
end
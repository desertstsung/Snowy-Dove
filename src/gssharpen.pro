;+
; procedure to sharpen mss using pan
;
; :Keywords:
;   o_fn: named variable to return the output fn
;-
pro gsSharpen, o_fn = r_fn
  compile_opt idl2, hidden
  common pyblk, pyFlag, py3Flag

  ;get the mss and pan filename
  !obj._getLast2, mss = mss_fn, pan = pan_fn
  log, 'pan sharpen [I]: ', [mss_fn, pan_fn]

  ;get output filename
  if (!obj.flag)[1] eq '1' then begin
    !obj.appendFile
    o_fn = !obj.getLastFile()
  endif else o_fn = (!obj.files)[0]

  if pyFlag or py3Flag then begin
    script = pyFlag ? 'python ' : 'python3 '
    script += FILEPATH('pysharpen.pyc', root = FILE_DIRNAME(ROUTINE_FILEPATH())) + ' '
    script += mss_fn + ' '  + pan_fn + ' ' + o_fn + '.tiff'
    SPAWN, script, msg, err

    if msg eq '-1' or err eq '-1' then begin
      goto, ENVISharpen
    endif else begin
      !obj.addTIFFExtension, o_fn
      r_fn = o_fn + '.tiff'
      o_fn = r_fn
    endelse
  endif else begin

    ENVISharpen: begin
      ;convert interleave from default bsq to bil
      ;to speed up ENVI_GS_SHARPEN_DOIT
      ENVI_OPEN_FILE, mss_fn, r_fid = mssId
      ENVI_FILE_QUERY, mssId, dims = dims, nb = nb, inter = inter
      if inter eq 0 then begin
        ENVI_DOIT, 'CONVERT_INPLACE_DOIT', fid = mssId, $
          pos = LINDGEN(nb), dims = dims, $
          o_interleave = 1, r_fid = bilId
      endif else bilId = mssId

      ENVI_OPEN_FILE, pan_fn, r_fid = panId

      ENVI_DOIT, 'ENVI_GS_SHARPEN_DOIT', dims = dims, $
        fid = bilId, hires_fid = panId, $
        hires_pos = LINDGEN(1), method = 0, $
        out_name = o_fn, pos = LINDGEN(nb)

      ENVI_FILE_MNG, id = mssId, /REMOVE
      ENVI_FILE_MNG, id = bilId, /REMOVE
      ENVI_FILE_MNG, id = panId, /REMOVE
      r_fn = o_fn
    end

  endelse

  log, 'pan sharpen [O]: ', o_fn
end

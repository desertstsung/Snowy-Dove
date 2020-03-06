;+
; procedure to delete raster file and its auxiliary file(s)
;
; :Arguments:
;   fn: raster filename
;-
pro delImg, fn
  compile_opt idl2, hidden

  FILE_DELETE, fn, /ALLOW_NONEXISTENT, /QUIET
  FILE_DELETE, fn + '.hdr', /ALLOW_NONEXISTENT, /QUIET
  FILE_DELETE, fn + '.enp', /ALLOW_NONEXISTENT, /QUIET
end

;+
; procedure to read header information of an ENVI file
;
; :Arguments:
;   fn_bin: string of ENVI standard file path
;
; :Keywords:
;   ns: named variable to return the number of samples
;   nl: named variable to return the number of lines
;   dt: named variable to return data type
;   nb: named variable to return the number of bands
;   inter: named variable to return interleave
;   mapinfo: named variable to return the map information
;   cs: named variable to return the coordinate system string
;   header: named variable to return the string array of the whole header
;   fn_hdr: named variable to return the header filename
;-
pro readHeader, fn_bin, $
  ns = ns, nl = nl, dt = dt, $
  nb = nb, inter = inter, $
  mapinfo = mapinfo, cs = cs, $
  header = header, fn_hdr = fn_hdr
  compile_opt idl2, hidden

  appendHeader = ARG_PRESENT(header)

  basename = FILE_BASENAME(fn_bin, '.dat')
  basenameWithSuffix = FILE_BASENAME(fn_bin)
  _fn_hdr = FILEPATH([basename + '.hdr', $
    basenameWithSuffix + '.hdr', $
    basename + '.HDR', $
    basenameWithSuffix + '.HDR'], $
    root_dir = FILE_DIRNAME(fn_bin))
  fn_hdr = _fn_hdr[(WHERE(FILE_TEST(_fn_hdr) eq 1))[0]]

  OPENR, lun, fn_hdr, /GET_LUN
  tmp = ''
  if appendHeader then header = []
  while not EOF(lun) do begin
    READF, lun, tmp
    if appendHeader then header = [header, tmp]
    case 1 of
      STRPOS(tmp, 'samples') ne -1: $
        ns = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'lines') ne -1: $
        nl = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'data type') ne -1: $
        dt = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'bands') ne -1: $
        nb = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'interleave') ne -1: $
        inter = STRMID(tmp, STRLEN(tmp) - 3, 3)
      STRPOS(tmp, 'map info') ne -1: $
        mapinfo = STRMID(tmp, STREGEX(tmp, '\{'))
      STRPOS(tmp, 'coordinate system string') ne -1: $
        cs = STRMID(tmp, STREGEX(tmp, '\{'))
      else: ;pass
    endcase
  endwhile
  FREE_LUN, lun

end

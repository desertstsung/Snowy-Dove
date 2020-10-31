;+
; Procedure to read information in the header file
;
; :Arguments:
;   fileIn: input filename of a raster
;
; :Keywords:
;   ns   : named variable to recieve the number of samples
;   nl   : named variable to recieve the number of lines
;   nb   : named variable to recieve the number of bands
;   dt   : named variable to recieve the data type
;   inter: named variable to recieve the interleave
;-
pro sdReadHeader, fileIn            , $
                  ns    = nsamples  , $
                  nl    = nlines    , $
                  nb    = nbands    , $
                  dt    = datatype  , $
                  inter = interleave
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun
  
  OPENR, lun, fileIn+'.hdr'
  while ~EOF(lun) do begin
    READF, lun, (tmp = '')
    case 1 of
      STRPOS(tmp, 'samples'   ) ne -1: nsamples   = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'lines'     ) ne -1: nlines     = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'data type' ) ne -1: datatype   = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'bands'     ) ne -1: nbands     = LONG(STREGEX(tmp, '[0-9]+', /EXTRACT))
      STRPOS(tmp, 'interleave') ne -1: interleave = STRMID(tmp, STRLEN(tmp)-3, 3)
      else: ;pass
    endcase
  endwhile
  FREE_LUN, lun
end
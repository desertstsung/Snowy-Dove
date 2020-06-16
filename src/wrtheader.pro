;+
; procedure to write header information to an ENVI file
;
; :Arguments:
;   fn_bin: string of ENVI standard file path
;   header: string array of header information
;-
pro wrtHeader, fn_bin, header
  compile_opt idl2, hidden

  fn_hdr = FILEPATH(FILE_BASENAME(fn_bin, '.dat') + '.hdr', $
    root_dir = FILE_DIRNAME(fn_bin))

  OPENW, lun, fn_hdr, /GET_LUN
  foreach info, header do begin
    PRINTF, lun, info
  endforeach
  FREE_LUN, lun
end

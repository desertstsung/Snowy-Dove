;TODO: may del PRINT
;+
; procedure for logging
;
; i_str:
;   string to be written into certain log file
;-
pro log, i_str, head = HEAD
  compile_opt idl2, hidden

  OPENW, ll, !log_fn, /GET_LUN, /APPEND
  if KEYWORD_SET(HEAD) then $
    WRITEU, ll, timeEx() + '     ' $
  else WRITEU, ll, timeEx() + '        '
  PRINTF, ll, i_str
  FREE_LUN, ll
  PRINT, timeEx() + ' ' + i_str
end
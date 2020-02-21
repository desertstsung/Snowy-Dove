;+
; procedure for logging
;
; :Arguments:
;   i_str: string to be written into the log file
;
; :Keywords:
;   head: shorten blanks
;-
pro log, i_str, head = HEAD
  compile_opt idl2, hidden

  OPENW, ll, !log_fn, /GET_LUN, /APPEND
  if KEYWORD_SET(HEAD) then $
    WRITEU, ll, timeEx() + '     ' $
  else WRITEU, ll, timeEx() + '        '
  PRINTF, ll, i_str
  FREE_LUN, ll
end
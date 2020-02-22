;+
; procedure for logging
;
; :Arguments:
;   i_str: string to be written into the log file
;
; :Keywords:
;   head:  shorten blanks and print information in console
;-
pro log, i_str, head = HEAD
  compile_opt idl2, hidden

  OPENW, ll, !log_fn, /GET_LUN, /APPEND
  if KEYWORD_SET(HEAD) then begin
    WRITEU, ll, timeEx() + '     '
    PRINT, timeEx() + ' ' + i_str
  endif else WRITEU, ll, timeEx() + '        '
  PRINTF, ll, i_str
  FREE_LUN, ll
end
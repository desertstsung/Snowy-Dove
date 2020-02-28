;+
; procedure for logging
;
; :Arguments:
;   i_str: string to be written into the log file
;
; :Keywords:
;   head:  shorten blanks and print information in console
;-
pro log, i_str, IOfn,  head = HEAD
  compile_opt idl2, hidden

  OPENW, ll, !log_fn, /GET_LUN, /APPEND

  if KEYWORD_SET(HEAD) then begin
    WRITEU, ll, timeEx() + '     '
    PRINT, timeEx() + ' ' + i_str + FILE_BASENAME(IOfn, '.tar.gz')
  endif else WRITEU, ll, timeEx() + '        '

  if N_PARAMS() eq 1 then begin
    PRINTF, ll, i_str
  endif else if N_PARAMS() eq 2 then begin
    PRINTF, ll, i_str + STRJOIN(FILE_BASENAME(IOfn), '  ')
  endif

  FREE_LUN, ll
end
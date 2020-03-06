;+
; function to return time string with 'yyyy-MM-dd HH:mm:ss' format
;
; :Keywords:
;   filename: symbol ':' cant be used in filename under unix or win,
;             set this keyword to return 'yyyy-MM-dd_HHmmss' format
;-
function timeEx, filename = FILENAME
  compile_opt idl2, hidden

  asciiTime = STRTOK(SYSTIME(0), /EXTRACT)
  month = 1 + WHERE(STRUPCASE(asciiTime[1]) eq $
    ['JAN','FEB','MAR','APR', 'MAY', 'JUN', 'JUL', 'AUG','SEP','OCT','NOV','DEC'])

  timeStr = ''
  timeStr += asciiTime[4]
  timeStr += '-' + STRING(month, for = '(I02)')
  timeStr += '-' + STRING(asciiTime[2], for = '(I02)')
  if KEYWORD_SET(FILENAME) then begin
    timeStr += '_' + STRJOIN(STRTOK(asciiTime[3], ':', /EXTRACT))
    RETURN, timeStr
  endif else begin
    timeStr += ' ' + asciiTime[3]
    RETURN, timeStr
  endelse
end
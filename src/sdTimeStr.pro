;+
; Function to return time string with 'yyyy-MM-dd HH:mm:ss' format
;
; :Keywords:
;   FILENAME: symbol ':' can't be used in filename
;             set this keyword to return 'yyyy-MM-dd_HHmmss' format
;-
function sdTimeStr, filename = FILENAME
  compile_opt idl2, hidden

  asciiTime = STRTOK(SYSTIME(0), /EXTRACT)
  month     = 1 + WHERE(STRUPCASE(asciiTime[1]) eq $
    ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'])

  timeStr  = ''
  timeStr += asciiTime[4]
  timeStr += '-' + STRING(month       , FORMAT='(I02)')
  timeStr += '-' + STRING(asciiTime[2], FORMAT='(I02)')
  if ISA(FILENAME) then $
    timeStr += '_' + STRJOIN(STRTOK(asciiTime[3], ':', /EXTRACT)) $
  else $
    timeStr += ' ' + asciiTime[3]
  RETURN, timeStr
end
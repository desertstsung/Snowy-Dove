;+
; function to return time string with yyyy-MM-dd-HH-mm-ss format
;-
function timeEx, filename = FILENAME
  compile_opt idl2, hidden

  asciiTime = strTok(SYSTIME(0), /EXTRACT)
  month = 1 + WHERE(STRUPCASE(asciiTime[1]) eq $
    ['JAN','FEB','MAR','APR', 'MAY', 'JUN', 'JUL', 'AUG','SEP','OCT','NOV','DEC'])

  timeStr = ''
  timeStr += asciiTime[4]
  timeStr += '-' + STRING(month, for = '(I02)')
  timeStr += '-' + asciiTime[2]
  if KEYWORD_SET(FILENAME) then begin
    timeStr += '_' + STRJOIN(strTok(asciiTime[3], ':', /EXTRACT))
    RETURN, timeStr
  endif else begin
    timeStr += ' ' + asciiTime[3]
    RETURN, timeStr
  endelse
end
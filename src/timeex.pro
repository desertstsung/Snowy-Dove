;+
; function to return time string with yyyy-MM-dd-HH-mm-ss format
;-
function timeEx, filename = FILENAME
  compile_opt idl2, hidden

  timeAry = bin_date(SYSTIME(0))
  timeStr = ''
  if KEYWORD_SET(FILENAME) then begin
    foreach element, timeAry, id do begin
      if id eq 0 then begin
        timeStr += STRING(element, for = '(I04)')
      endif else begin
        timeStr += '-' + STRING(element, for = '(I02)')
      endelse
    endforeach
  endif else begin
    timeStr += STRING(timeAry[0], for = '(I04)')
    timeStr += '-' + STRING(timeAry[1], for = '(I02)')
    timeStr += '-' + STRING(timeAry[2], for = '(I02)')
    timeStr += ' ' + STRING(timeAry[3], for = '(I02)')
    timeStr += ':' + STRING(timeAry[4], for = '(I02)')
    timeStr += ':' + STRING(timeAry[5], for = '(I02)')
  endelse

  RETURN, timeStr
end
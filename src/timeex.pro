;+
; function to return time string with yyyy-MM-dd-HH-mm-ss format
;-
function timeEx
  compile_opt idl2, hidden

  timeAry = bin_date(SYSTIME(0))
  timeStr = ''
  foreach element, timeAry, id do begin
    if id eq 0 then begin
      timeStr += STRING(element, for = '(I04)')
    endif else begin
      timeStr += '-' + STRING(element, for = '(I02)')
    endelse
  endforeach

  RETURN, timeStr
end
;+
; Function to return valid filename for reading or writing
;
; :Keywords:
;   IO      : keyword to return both readable and writable filename
;   WRITABLE: keyword to return writable filename
;   READABLE: keyword to return both readable filename
;   TWO     : keyword to return 2 * filename
;-
function sdValidTempFilename, io       = IO      , $
                              writable = WRITABLE, $
                              readable = READABLE, $
                              two      = TWO
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  ;readable index
  rid = WHERE(FILE_TEST(sdstruct.tempfiles) eq 1)
  ;writable index
  wid = WHERE(FILE_TEST(sdstruct.tempfiles) eq 0)
  
  if ISA(TWO) then begin
    if ISA(IO) then begin
      RETURN, [sdstruct.tempfiles[rid[-2]], $
               sdstruct.tempfiles[rid[-1]], $
               sdstruct.tempfiles[wid[0 ]], $
               sdstruct.tempfiles[wid[1 ]]]
    endif $
    else if ISA(READABLE) then RETURN, [sdstruct.tempfiles[rid[-2]], $
                                        sdstruct.tempfiles[rid[-1]]] $
    else if ISA(WRITABLE) then RETURN, [sdstruct.tempfiles[wid[0 ]], $
                                        sdstruct.tempfiles[wid[1 ]]]
  endif else begin
    if ISA(IO) then begin
      RETURN, [sdstruct.tempfiles[rid[-1]], $
               sdstruct.tempfiles[wid[0 ]]]
    endif $
    else if ISA(READABLE) then RETURN, sdstruct.tempfiles[rid[-1]] $
    else if ISA(WRITABLE) then RETURN, sdstruct.tempfiles[wid[0 ]]
  endelse
end
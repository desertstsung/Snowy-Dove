;+
; Function to return a string that convert char '.' to '_'
;
; :Arguments:
;   strIn: input string contain char '.'
;-
function sdPoint2Underscore, strIn
  compile_opt idl2, hidden
  
  bstr                                = BYTE(strIn)
  bstr[WHERE(bstr eq (BYTE('.'))[0])] = BYTE('_')

  RETURN, STRING(bstr)
end
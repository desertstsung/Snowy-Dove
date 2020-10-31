;+
; Procedure for logging
;
; :Arguments:
;   strIn: string to be written into the log file
;   IOfn : string in filename format
;
; :Keywords:
;   HEAD: shorten blanks
;-
pro sdLog, strIn, IOfn, head = HEAD
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun

  OPENW, lun, logfn, /APPEND

  ;keyword head means less blanks in front of strIn
  if ISA(HEAD) then $
    WRITEU, lun, sdTimeStr() + '     ' $
  else $
    WRITEU, lun, sdTimeStr() + '        '

  if N_PARAMS() then begin
    ;if only strIn presented
    PRINTF, lun, strIn
    if sdstruct.flag_verbose then PRINTF, -1, sdTimeStr() + ' ' + strIn
  endif else begin
    ;if strIn and IOfn both presented
    strInFile = strIn + STRJOIN(FILE_BASENAME(IOfn, '.tar.gz'), '  ')
    PRINTF, lun, strInFile
    if sdstruct.flag_verbose then PRINTF, -1, sdTimeStr() + ' ' + strInFile
  endelse

  FREE_LUN, lun
end
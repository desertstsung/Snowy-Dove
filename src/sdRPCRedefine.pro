;+
; Procedure to re-define RPC information
;
; :Arguments:
;   fileIn: input filename
;-
pro sdRPCRedefine, fileIn
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun
  
  fnrpb = STRMID(fileIn, 0, STRLEN(fileIn)-4) + 'rpb'
  
  dataInFile = STRARR(90)
  OPENR   , lun, fnrpb
  SKIP_LUN, lun, 6, /LINES
  
  ;offset and scale
  for i = 0, 9 do begin
    READF, lun, (str = '')
    dataInFile[i] = STREGEX(str, '-*[0-9]+.[0-9]+', /EXTRACT)
  endfor
  ;coef
  for j = 10, 70, 20 do begin
    SKIP_LUN, lun, 1, /LINES
    for i = j, j+19 do begin
      READF, lun, (str = '')
      dataInFile[i] = STREGEX(str, '[+-][0-9]+.[0-9]+E[+-][0-9][0-9]', /EXTRACT)
    endfor
  endfor
  
  FREE_LUN, lun
  dataInFile = STRJOIN(dataInFile, ', ')
  
  ;re-define RPC information by adding a header file
  fnhdr = STRMID(fileIn, 0, STRLEN(fileIn)-4) + 'hdr'
  !NULL = QUERY_TIFF(fileIn, info)
  sdWriteHeader, fnhdr, ['ENVI'                                                  , $
                         'samples = '    + STRTRIM(STRING(info.DIMENSIONS[0]), 2), $
                         'lines   = '    + STRTRIM(STRING(info.DIMENSIONS[1]), 2), $
                         'bands   = '    + STRTRIM(STRING(info.CHANNELS)     , 2), $
                         'data type  = ' + STRTRIM(STRING(info.PIXEL_TYPE)   , 2), $
                         'interleave = bip'                                      , $
                         'file type  = TIFF'                                     , $
                         'rpc info   = { ' + dataInFile + ' }']
  
  sdLog, 'RPC redefine done'
end
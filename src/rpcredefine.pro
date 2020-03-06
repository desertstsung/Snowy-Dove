;+
; procedure to redefine RPC information, especially gf6 in ENVI51
;
; :Arguments:
;   fnImg: filename of gf6 image
;-
pro rpcRedefine, fnImg
  compile_opt idl2, hidden

  ;get the rpc infomation text file
  fnRPB = STRMID(fnImg, 0, STRLEN(fnImg)-4) + 'rpb'
  str = '' & data = []

  OPENR, lun_rpb, fnRPB, /GET_LUN

  ;read useful information
  i = 0L & lineIndex = [17, 38, 59, 80]
  while ~EOF(lun_rpb) do begin
    READF, lun_rpb, str
    if i ge 6 and i le 15 then begin
      data = [data, STREGEX(str, '-*[0-9]+.[0-9]+', /EXTRACT)]
    endif else if TOTAL((i ge lineIndex) and (i le (lineIndex + 19))) eq 1 then begin
      data = [data, STREGEX(str, '[+-][0-9]+.[0-9]+E[+-][0-9][0-9]', /EXTRACT)]
    endif
    i++
  endwhile
  data = STRJOIN(data, ', ')
  FREE_LUN, lun_rpb

  ;reload rpc information
  fnHDR = STRMID(fnImg, 0, STRLEN(fnImg)-4) + 'hdr'
  tmp = QUERY_TIFF(fnImg, info)
  OPENW,  lun_hdr, fnHDR, /GET_LUN
  PRINTF, lun_hdr, 'ENVI'
  PRINTF, lun_hdr, 'samples = ' + STRTRIM(STRING(info.DIMENSIONS[0]), 2)
  PRINTF, lun_hdr, 'lines = ' + STRTRIM(STRING(info.DIMENSIONS[1]), 2)
  PRINTF, lun_hdr, 'bands = ' + STRTRIM(STRING(info.CHANNELS), 2)
  PRINTF, lun_hdr, 'data type = ' + STRTRIM(STRING(info.PIXEL_TYPE), 2)
  PRINTF, lun_hdr, 'interleave = bip'
  PRINTF, lun_hdr, 'file type = TIFF'
  PRINTF, lun_hdr, 'rpc info = { ' + data + ' }'
  FREE_LUN, lun_HDR
  
  log, 'RPC redefine done'
end
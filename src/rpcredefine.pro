;+
; procedure for redefine RPC information, especially gf6 in ENVI51
;
; fnImg:
;   string of image filename
;-
pro rpcRedefine, fnImg
  compile_opt idl2, hidden
  log, 'rpcRedefine initialize'

  fnRPB = STRMID(fnImg, 0, STRLEN(fnImg)-4) + 'rpb'
  str = '' & data = []

  OPENR, lun, fnRPB, /GET_LUN

  i = 0L & lineIndex = [17, 38, 59, 80]
  while ~EOF(lun) do begin
    READF, lun, str
    if i ge 6 and i le 15 then begin
      data = [data, DOUBLE(STREGEX(str, '-*[0-9]+.[0-9]+', /EXTRACT))]
    endif else if TOTAL((i ge lineIndex) and (i le (lineIndex + 19))) eq 1 then begin
      data = [data, DOUBLE(STREGEX(str, '[+-][0-9]+.[0-9]+E[+-][0-9][0-9]', /EXTRACT))]
    endif
    i++
  endwhile

  offset = data[0:4] & scale = data[5:9]
  linNum = data[10:29] & linDen = data[30:49]
  samNum = data[50:69] & samDen = data[70:89]

  FREE_LUN, lun
  log, 'rpcRedefine read RPC data finish'

  sr = ENVIRPCRasterSpatialRef($
    RPC_LINE_DEN_COEFF = linDen, RPC_LINE_NUM_COEFF = linNum, $
    RPC_SAMP_DEN_COEFF = samDen, RPC_SAMP_NUM_COEFF = samNum, $
    RPC_OFFSETS = offset, RPC_SCALES = scale)
  raster = !e.OpenRaster(fnImg, SPATIALREF_OVERRIDE = sr)
  raster.WriteMetadata
  raster.Close
  log, 'rpcRedefine done'
end
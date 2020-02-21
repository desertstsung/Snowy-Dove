;+
; procedure to redefine RPC information, especially gf6 in ENVI51
;
; :Arguments:
;   fnImg: filename of gf6 image
;-
pro rpcRedefine, fnImg
  compile_opt idl2, hidden
  log, 'rpcRedefine initialize'

  ;get the rpc infomation text file
  fnRPB = STRMID(fnImg, 0, STRLEN(fnImg)-4) + 'rpb'
  str = '' & data = []

  OPENR, lun, fnRPB, /GET_LUN

  ;read useful information
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

  ;set value to variable
  offset = data[0:4] & scale = data[5:9]
  linNum = data[10:29] & linDen = data[30:49]
  samNum = data[50:69] & samDen = data[70:89]

  FREE_LUN, lun
  log, 'rpcRedefine read RPC data finish'

  ;reload rpc information
  sr = ENVIRPCRasterSpatialRef($
    rpc_line_den_coeff = linDen, rpc_line_num_coeff = linNum, $
    rpc_samp_den_coeff = samDen, rpc_samp_num_coeff = samNum, $
    rpc_offsets = offset, rpc_scales = scale)
  raster = !e.OpenRaster(fnImg, SPATIALREF_OVERRIDE = sr)
  raster.WriteMetadata
  raster.Close
  log, 'rpcRedefine done'
end
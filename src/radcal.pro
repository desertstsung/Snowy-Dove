;+
; procedure to perform radiance calibration
;
; :Arguments:
;   i_fn: input filename
;   o_fn: target calibrated filename
;-
pro radCal, i_fn, o_fn
  compile_opt idl2, hidden
  log, 'radiance calibration [I]: ', i_fn

  readHeader, i_fn, nb = nb

  if nb ne N_ELEMENTS(!obj.calGain) then begin
    if nb eq 1 then begin
      gain = [FLOAT((!obj.calGain)[0])]
      offs = [FLOAT((!obj.calOffs)[0])]
    endif else begin
      gain = FLOAT((!obj.calGain)[1:-1])
      offs = FLOAT((!obj.calOffs)[1:-1])
    endelse
  endif else begin
    gain = FLOAT(!obj.calGain)
    offs = FLOAT(!obj.calOffs)
  endelse

  sd_radcal, i_fn, o_fn, gain, offs

  log, 'radiance calibration [O]: ', o_fn
end

;+
; Procedure for pre-logging
;-
pro sdPreLog
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  sdLog, 'start processing ', sdstruct.tgzfn, /HEAD
  sdLog, 'gain coefficient  : ' + STRJOIN(STRING(sdstruct.cali_gain  , FORMAT='(F6.4)'), ' ')
  sdLog, 'offset coefficient: ' + STRJOIN(STRING(sdstruct.cali_offset, FORMAT='(F6.4)'), ' ')
  sdLog, 'wavelength        : ' + STRJOIN(STRING(sdstruct.wavelength , FORMAT='(I3)'  ), ' ')
  sdLog, 'region for subset : ' + (ISA(sdstruct.sshp, 'STRING') ? sdstruct.sshp : 'None')
  sdLog, 'calibration       ? ' + (sdstruct.flag_calibration    ? 'Yes'         : 'No'  )
  sdLog, 'perform quac      ? ' + (sdstruct.flag_quac           ? 'Yes'         : 'No'  )
  sdLog, 'export tiff       ? ' + (sdstruct.flag_tiff           ? 'Yes'         : 'No'  )
  sdLog, 'calculate ndvi    ? ' + (sdstruct.flag_ndvi           ? 'Yes'         : 'No'  )
  sdLog, 'creating pyramid  ? ' + (sdstruct.flag_pyramid        ? 'Yes'         : 'No'  )
  
end
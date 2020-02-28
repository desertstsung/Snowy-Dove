;+
; procedure to process images from gf6-wfv sensor
;
; :Arguments:
;   dem_fn: filename of DEM
;-
pro WFV6Handler, dem_fn
  compile_opt idl2, hidden

  unzip

  scenes = FILE_SEARCH(!obj.imgDir, '*.tiff')
  scenes_Ortho = !NULL
  foreach scene, scenes do begin
    ;gf6 need to reload spatial reference
    ;in order to do RPC Orthorectification
    rpcRedefine, scene

    !obj.appendFile
    scene_Ortho = !obj.getLastFile()

    ;rpc orthorectify
    rpcOrtho, scene, dem_fn, scene_Ortho
    scenes_Ortho = [scenes_Ortho, scene_Ortho]
  endforeach

  ;mosaic
  if (!obj.flag)[0] eq '0' and $
    (!obj.calGain)[0] eq -1 and $
    (!obj.flag)[1] eq '0' then $
    img_Mosaic = (!obj.files)[0] $
  else begin
    !obj.appendFile
    img_Mosaic = !obj.getLastFile()
  endelse
  mosaicGF6, scenes_Ortho, img_Mosaic

  if (!obj.flag)[0] eq '0' then goto, radCal__

  ;subset
  if (!obj.calGain)[0] eq -1 and $
    (!obj.flag)[1] eq '0' then $
    img_Sub = (!obj.files)[0] $
  else begin
    !obj.appendFile
    img_Sub = !obj.getLastFile()
  endelse
  subsetByShp, img_Mosaic, img_Sub

  ;radiance calibration
  radCal__: begin
    if (!obj.calGain)[0] eq -1 then goto, quac__

    img4Cal = !obj.getLastFile()
    if (!obj.flag)[1] eq '0' then $
      img_Cal = (!obj.files)[0] $
    else begin
      !obj.appendFile
      img_Cal = !obj.getLastFile()
    endelse
    radCal, img4Cal, img_Cal
  end

  ;quick atmospheric correction
  quac__: begin
    if (!obj.flag)[1] eq '1' and (!obj.wvl)[0] ne -1 then begin
      img4QUAC = !obj.getLastFile()
      quac, img4QUAC
    endif
  end

  ;destroy oWFV6
  OBJ_DESTROY, !obj
end
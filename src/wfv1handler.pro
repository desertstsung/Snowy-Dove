pro WFV1Handler, dem_fn
  compile_opt idl2, hidden

  unzip

  img = FILE_SEARCH(!obj.imgDir, '*.tiff')

  if (!obj.flag)[0] eq '0' and $
    (!obj.calGain)[0] eq -1 and $
    (!obj.flag)[1] eq '0' then $
    img_Ortho = (!obj.files)[0] $
  else begin
    !obj.appendFile
    img_Ortho = !obj.getLastFile()
  endelse

  rpcOrtho, img[0], dem_fn, img_Ortho

  if (!obj.flag)[0] eq '0' then goto, radCal__

  if (!obj.calGain)[0] eq -1 and $
    (!obj.flag)[1] eq '0' then $
    img_Sub = (!obj.files)[0] $
  else begin
    !obj.appendFile
    img_Sub = !obj.getLastFile()
  endelse
  subsetByShp, img_Ortho, img_Sub

  radCal__: begin
    if (!obj.calGain)[0] eq -1 then goto, quac__

    img4Cal = !obj.getLastFile()
    if (!obj.flag)[1] eq '0' then begin
      img_Cal = (!obj.files)[0]
    endif else begin
      !obj.appendFile
      img_Cal = !obj.getLastFile()
    endelse
    radCal, img4Cal, img_Cal
  end

  quac__: begin
    if (!obj.flag)[1] eq '1' and (!obj.wvl)[0] ne -1 then begin
      img4QUAC = !obj.getLastFile()
      quac, img4QUAC
    endif
  end

  OBJ_DESTROY, !obj
end
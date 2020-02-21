pro WFV6Handler, dem_fn
  compile_opt idl2, hidden

  unzip

  scenes = FILE_SEARCH(!obj.imgDir, '*.tiff')
  scenes_Ortho = !NULL
  foreach scene, scenes do begin
    rpcRedefine, scene

    !obj.appendFile
    scene_Ortho = !obj.getLastFile()

    rpcOrtho, scene, dem_fn, scene_Ortho
    scenes_Ortho = [scenes_Ortho, scene_Ortho]
  endforeach

  if (!obj.flag)[0] eq '0' then begin
    imgs4Mosaic = scenes_Ortho
    goto, mosaic__
  endif

  scenes_Sub = !NULL
  foreach img, scenes_Ortho do begin
    !obj.appendFile
    img_Sub = !obj.getLastFile()
    subsetByShp, img, img_Sub
    if FILE_TEST(img_Sub) then $
      scenes_Sub = [scenes_Sub, img_Sub] $
    else !obj._setLastFile, ''
  endforeach
  imgs4Mosaic = scenes_Sub

  mosaic__: begin
    if N_ELEMENTS(imgs4Mosaic) le 1 then begin
      if (!obj.calGain)[0] eq -1 and $
        (!obj.flag)[1] eq '0' then begin
        raster = !e.OpenRaster(imgs4Mosaic[0])
        raster.Export, (!obj.files)[0], 'ENVI'
        RETURN
      endif
      goto, radCal__
    endif

    if (!obj.calGain)[0] eq -1 and $
      (!obj.flag)[1] eq '0' then $
      img_Mosaic = (!obj.files)[0] $
    else begin
      !obj.appendFile
      img_Mosaic = !obj.getLastFile()
    endelse
    mosaicGF6, imgs4Mosaic, img_Mosaic
  end

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

  quac__: begin
    if (!obj.flag)[1] eq '1' and (!obj.wvl)[0] ne -1 then begin
      img4QUAC = !obj.getLastFile()
      quac, img4QUAC
    endif
  end

  OBJ_DESTROY, !obj
end
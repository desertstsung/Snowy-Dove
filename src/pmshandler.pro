pro PMSHandler, dem_fn
  compile_opt idl2, hidden

  unzip

  findPMSImg, mss = mssImg, pan = panImg

  isGF6 = STRPOS(FILE_BASENAME(!obj.tgz_fn), 'GF6') ne -1 ? 1 : 0
  if not isGF6 then goto, rpcOrtho__

  ;gf6-pms need to reload spatial reference
  ;in order to do RPC Orthorectification
  rpcRedefine, mssImg & rpcRedefine, panImg

  rpcOrtho__: begin
    !obj.appendFile, /twoTime
    !obj._getLast2, mss = mss_Ortho, pan = pan_Ortho
    rpcOrtho, mssImg, dem_fn, mss_Ortho
    rpcOrtho, panImg, dem_fn, pan_Ortho
  end

  if (!obj.flag)[0] eq '0' then goto, radCal__

  !obj.appendFile, /twoTime
  !obj._getLast2, mss = mss_Sub, pan = pan_Sub
  subsetByShp, mss_Ortho, mss_Sub
  subsetByShp, pan_Ortho, pan_Sub

  radCal__: begin
    if (!obj.calGain)[0] eq -1 then goto, imgFusion__
    !obj._getLast2, mss = mss4Cal, pan = pan4Cal
    !obj.appendFile, /twoTime
    !obj._getLast2, mss = mss_Cal, pan = pan_Cal
    radCal, mss4Cal, mss_Cal
    radCal, pan4Cal, pan_Cal
  end

  imgFusion__: gsSharpen, o_fn = gs_fn

  if (!obj.flag)[1] eq '1' and (!obj.wvl)[0] ne -1 then begin
    quac, gs_fn
  endif

  OBJ_DESTROY, !obj
end
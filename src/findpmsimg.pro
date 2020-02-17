;todo:del print
;+
; procedure to get the proper pan and mss image
; from pms sensors
; but especially gf1B/C/D-pms
;-
pro findPMSImg, mss_image = mssImage, pan_image = panImage
  compile_opt idl2, hidden

  imgs = FILE_SEARCH(!obj.imgDir, '*.tiff')
  case N_ELEMENTS(imgs) of
    2: begin
      mssImage = STRPOS(imgs[0], 'PAN') + 1 ? imgs[1] : imgs[0]
      panImage = STRPOS(imgs[0], 'PAN') + 1 ? imgs[0] : imgs[1]
      shpInRaster, mssImage, (!obj.flag)[0], count = count
      if count eq 0 then begin
        mssImage = -1
        panImage = -1
      endif
    end

    6: begin
      m1 = imgs[WHERE(STRPOS(imgs, 'MUX1') ne -1)]
      m2 = imgs[WHERE(STRPOS(imgs, 'MUX2') ne -1)]
      shpInRaster, m1, (!obj.flag)[0], count = count1
      shpInRaster, m2, (!obj.flag)[0], count = count2
      if count1 && count2 then begin
        mssImage = imgs[WHERE(STRPOS(imgs, 'MUX.') ne -1)]
        panImage = imgs[WHERE(STRPOS(imgs, 'PAN.') ne -1)]
      endif else if count1 ne 0 then begin
        mssImage = imgs[WHERE(STRPOS(imgs, 'MUX1') ne -1)]
        panImage = imgs[WHERE(STRPOS(imgs, 'PAN1') ne -1)]
      endif else if count2 ne 0 then begin
        mssImage = imgs[WHERE(STRPOS(imgs, 'MUX2') ne -1)]
        panImage = imgs[WHERE(STRPOS(imgs, 'PAN2') ne -1)]
      endif else begin
        mssImage = -1
        panImage = -1
      endelse
    end

    else: begin
      mssImage = -1
      panImage = -1
    end
  endcase
end
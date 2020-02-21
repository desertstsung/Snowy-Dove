pro findPMSImg, mss_image = mssImage, pan_image = panImage
  compile_opt idl2, hidden

  imgs = FILE_SEARCH(!obj.imgDir, '*.tiff')
  case N_ELEMENTS(imgs) of
    2: begin
      panImage = imgs[WHERE(STRPOS(imgs, 'PAN') ne -1)]
      mssImage = imgs[WHERE(STRPOS(imgs, panImage) eq -1)]
    end

    6: begin
      panImage = imgs[WHERE(STRPOS(imgs, 'PAN.') ne -1)]
      mssImage = imgs[WHERE(STRPOS(imgs, 'MUX.') ne -1)]
    end

    else: begin
      mssImage = -1
      panImage = -1
    end
  endcase
end
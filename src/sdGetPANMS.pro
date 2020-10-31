;+
; Procedure to get pan and ms file from pms sensor
;
; :Arguments:
;   pan: named variable to recieve pan filename
;   ms : named variable to recieve ms  filename
;-
pro sdGetPANMS, pan, ms
  compile_opt idl2, hidden
  common sdblock, e, sdstruct
  
  imgs = FILE_SEARCH(sdstruct.L1imagesdir, '*.tiff', COUNT=n)
  case n of
    2: begin;gf1/2/6-pms
         pan = imgs[WHERE(STRPOS(imgs, 'PAN') ne -1)]
         ms  = imgs[WHERE(STRPOS(imgs, pan)   eq -1)]
       end
    6: begin;gf1b/c/d-pms
         pan = imgs[WHERE(STRPOS(imgs, 'PAN.') ne -1)]
         ms  = imgs[WHERE(STRPOS(imgs, 'MUX.') ne -1)]
       end
  endcase
end
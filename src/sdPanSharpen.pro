;+
; Procedure for logging
;
; :Arguments:
;   panfileIn: input  filename of pan
;   msfileIn : input  filename of ms
;   fileOut  : output filename of result
;-
pro sdPanSharpen, panfileIn, msfileIn, fileOut
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py
  
  ;if current OS have python3 and gdal(python package) environment
  ;then use python script to perform pan sharpen
  if py then begin
    sdLog, 'gdal pan sharpen [I]: ', [panfileIn, msfileIn]
    script = py                                                                                                           $
             + ' '                                                                                                        $
             + FILEPATH('pysharpen.py', ROOT_DIR=FILE_DIRNAME(FILE_DIRNAME(ROUTINE_FILEPATH())), SUBDIRECTORY='external') $
             + ' '                                                                                                        $
             + panfileIn                                                                                                  $
             + ' '                                                                                                        $
             + msfileIn                                                                                                   $
             + ' '                                                                                                        $
             + fileOut
    SPAWN, script, msg, err
    
    if msg eq '-1' or err eq '-1' then begin
      ;if throw error, then use ENVITask intead
      goto, enviSharpen
      sdLog, 'gdal pan sharpen [O]: failed'
    endif else begin
      sdLog, 'gdal pan sharpen [O]: ', fileOut
    endelse
  endif else begin
    enviSharpen: begin
                 sdLog, 'pan sharpen [I]: ', [panfileIn, msfileIn]
                 
                 ;convert interleave from default bsq to bip
                 ;to speed up ENVI_GS_SHARPEN_DOIT
                 ENVI_OPEN_FILE , msfileIn, R_FID=msid
                 ENVI_FILE_QUERY, msid, DIMS=dims, NB=nb, INTERLEAVE=inter
                 if inter eq 0 then begin
                   ENVI_DOIT, 'CONVERT_INPLACE_DOIT', $
                              FID          = msid   , $
                              DIMS         = dims   , $
                              O_INTERLEAVE = 2      , $
                              R_FID        = bilid  , $
                              POS          = LINDGEN(nb)
                 endif else bilid = msid

                 ENVI_OPEN_FILE, panfileIn, R_FID=panid
                 ENVI_DOIT, 'ENVI_GS_SHARPEN_DOIT', $
                            DIMS      = dims      , $
                            FID       = bilid     , $
                            HIRES_FID = panid     , $
                            HIRES_POS = LINDGEN(1), $
                            METHOD    = 0         , $
                            OUT_NAME  = fileOut   , $
                            POS       = LINDGEN(nb)

                 ENVI_FILE_MNG, ID=msid , /REMOVE
                 ENVI_FILE_MNG, ID=bilid, /REMOVE
                 ENVI_FILE_MNG, ID=panid, /REMOVE
                 sdLog, 'pan sharpen [O]: ', fileOut
                 end
  endelse
end
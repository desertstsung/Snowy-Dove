;+
; procedure to unpack *.tar.gz file
;-
pro unzip
  compile_opt idl2, hidden

  dir = FILE_DIRNAME(!obj.tgz_fn)
  !obj.wrkDir = dir + PATH_SEP() + 'snowyDove'
  base = FILE_BASENAME(!obj.tgz_fn, '.tar.gz')
  !obj.imgDir = FILEPATH(base + '_snyDov', root = dir)

  ;get file size in Mb scale
  OPENR, lun, !obj.tgz_fn, /GET_LUN
  fs = FSTAT(lun) & FREE_LUN, lun
  sz = (fs.size)/1048576

  ;to unpack *.tar.gz under unix os
  ;using tar command in terminal
  ;is faster than using file_untar in idl
  ;but only in big file size
  if !version.OS_FAMILY eq 'unix' and sz gt 500 then begin
    SPAWN, 'mkdir ' + !obj.imgDir + ' && ' + $
      'tar -zxf ' + !obj.tgz_fn +' -C ' + !obj.imgDir, rst, err
    if err ne '' then goto, IDL_untar
  endif else begin
    IDL_untar: FILE_UNTAR, !obj.tgz_fn, !obj.imgDir
  endelse
  log, 'unzip done'
end
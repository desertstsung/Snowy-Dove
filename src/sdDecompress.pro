;+
; procedure to decompress *.tar.gz file
;-
pro sdDecompress
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun

  ;get file size in Mb scale
  OPENR, lun, sdstruct.tgzfn
  fs = FSTAT(lun) & FREE_LUN, lun
  sz = (fs.size)/1048576

  ;to unpack *.tar.gz under unix os
  ;using tar command in terminal
  ;is faster than using file_untar in idl
  ;but only in big file size
  sdLog, 'decompressing...'
  if islinux and sz gt 500 then begin
    SPAWN, 'mkdir ' + sdstruct.L1imagesdir + $
           ' && ' + $
           'tar -zxf ' + sdstruct.tgzfn +' -C ' + sdstruct.L1imagesdir, rst, err
    if err ne '' then goto, IDL_untar
  endif else begin
    IDL_untar: FILE_UNTAR, sdstruct.tgzfn, sdstruct.L1imagesdir
  endelse
  sdLog, 'decompress done'
end
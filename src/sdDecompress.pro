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
    cmd1   = 'mkdir'
    par11  = '"' + sdstruct.L1imagesdir + '"'
    par    = '&&'
    cmd2   = 'tar'
    par21  = '-zxf'
    par22  = '"' + sdstruct.tgzfn + '"'
    par23  = '-C'
    par24  = '"' + sdstruct.L1imagesdir + '"'
    strCLI = STRJOIN([cmd1, par11, par, cmd2, par21, par22, par23, par24], ' ')
    if islinux then SPAWN, strCLI, rst, err else SPAWN, strCLI, rst, err, /HIDE
    if err ne '' then goto, IDL_untar
  endif else begin
    IDL_untar: FILE_UNTAR, sdstruct.tgzfn, sdstruct.L1imagesdir
  endelse
  sdLog, 'decompress done'
end
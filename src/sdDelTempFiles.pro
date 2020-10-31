;+
; Procedure to delete temp files and unzip L1 images directory
;-
pro sdDelTempFiles
  compile_opt idl2, hidden
  common sdblock, e, sdstruct

  ;index of valid temp files, and del them
  id = WHERE(FILE_TEST(sdstruct.tempfiles) eq 1)
  foreach i, id do sdDelImageFile, sdstruct.tempfiles[i]
  sdLog, 'delete temp files'
  
  ;del L1 images directory
  FILE_DELETE, sdstruct.L1imagesdir, /RECURSIVE
  sdLog, 'delete unzip directory'
end
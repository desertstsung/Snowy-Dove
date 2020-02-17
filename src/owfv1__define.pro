;+
; object for individual gf1 wfv sensor
; date 2020/2/16
;-

;oWFV1 define is similar to oPMS
pro oWFV1::appendFile
  compile_opt idl2, hidden

  firstIndex = (WHERE(self.files eq ''))[0]
  if firstIndex lt 5 then $
    self.files[firstIndex] = !e.GetTemporaryFilename('')
end

function oWFV1::getLastFile
  compile_opt idl2, hidden

  RETURN, self.files[(WHERE(self.files ne ''))[-1]]
end

pro oWFV1::setProperty, tgz_fn = tgz_fn, $
  wrkDir = wrkDir, imgDir = imgDir, $
  calGain = calGain, calOffs = calOffs, $
  wvl = wvl, flag = flag, files = files
  compile_opt idl2, hidden

  if ISA(tgz_fn) then self.tgz_fn = tgz_fn
  if ISA(wrkDir) then self.wrkDir = wrkDir
  if ISA(imgDir) then self.imgDir = imgDir
  if ISA(calGain) then self.calGain = calGain
  if ISA(calOffs) then self.calOffs = calOffs
  if ISA(wvl) then self.wvl = wvl
  if ISA(flag) then self.flag = flag
  if ISA(files) then self.files = files
end

pro oWFV1::getProperty, tgz_fn = tgz_fn, $
  wrkDir = wrkDir, imgDir = imgDir, $
  calGain = calGain, calOffs = calOffs, $
  wvl = wvl, flag = flag, files = files
  compile_opt idl2, hidden

  if ISA(self) then begin
    if ARG_PRESENT(tgz_fn) then tgz_fn = self.tgz_fn
    if ARG_PRESENT(wrkDir) then wrkDir = self.wrkDir
    if ARG_PRESENT(imgDir) then imgDir = self.imgDir
    if ARG_PRESENT(calGain) then calGain = self.calGain
    if ARG_PRESENT(calOffs) then calOffs = self.calOffs
    if ARG_PRESENT(wvl) then wvl = self.wvl
    if ARG_PRESENT(flag) then flag = self.flag
    if ARG_PRESENT(files) then files = self.files
  endif
end

pro oWFV1::cleanup
  compile_opt idl2, hidden

  lastIndex = (WHERE(self.files ne ''))[-1]
  
  for i = 1L, lastIndex do begin
    ENVI_OPEN_FILE, self.files[i], r_fid = fid
    ENVI_FILE_MNG, id = fid, /REMOVE, /DELETE
  endfor
  log, 'delete temp files'
  
  FILE_DELETE, self.imgDir, /RECURSIVE
  log, 'delete original image directory'
  self->IDL_Object::Cleanup
end

function oWFV1::init, tgz_fn, info, flag, o_fn
  compile_opt idl2, hidden

  self.tgz_fn = tgz_fn

  d = FILE_DIRNAME(ROUTINE_FILEPATH())
  calGain = readJSON(FILEPATH('snyDov_cal.json', root = d), key = [info, 'gain'])
  if calGain[0] eq -1 then self.calGain[*] = -1 else self.calGain = calGain
  calOffs= readJSON(FILEPATH('snyDov_cal.json', root = d), key = [info, 'offset'])
  if calOffs[0] eq -1 then self.calOffs[*] = -1 else self.calOffs = calOffs
  wvl = readJSON(FILEPATH('snyDov_wvl.json', root = d), key = info[0:1])
  if wvl[0] eq -1 then self.wvl[*] = -1 else self.wvl = wvl

  self.flag = flag
  self.files[0] = o_fn
  
  log, 'start processing ' + FILE_BASENAME(tgz_fn, '.tar.gz'), /HEAD
  log, 'gain coefficient: ' + STRJOIN(STRING(calGain, for='(F6.4)'), ' ')
  log, 'offset coefficient: ' + STRJOIN(STRING(calOffs, for='(F6.4)'), ' ')
  log, 'wavelength: ' + STRJOIN(STRING(wvl, for='(I3)'), ' ')
  if flag[0] ne '0' then log, '  region for subset: ' + flag[0]
  log, 'quac flag: ' + STRJOIN(flag[1:2])

  RETURN, 1B
end

pro oWFV1__define
  compile_opt idl2

  structure = { oWFV1, inherits IDL_Object, $
    tgz_fn: '', wrkDir: '', imgDir: '', $
    calGain: MAKE_ARRAY(4, /DOUBLE), $
    calOffs: MAKE_ARRAY(4, /DOUBLE), $
    wvl: MAKE_ARRAY(4, /L64), $
    flag: MAKE_ARRAY(3, /STRING), $
    files: MAKE_ARRAY(5, /STRING)}
end
;+
; object for individual gf1/2/6 pms sensor
; date 2020/2/11
;-

;get temporary filename
pro oPMS::appendFile, twoTime = TWOTIME
  compile_opt idl2, hidden

  firstIndex = (WHERE(self.files eq ''))[0]

  if firstIndex lt N_ELEMENTS(self.files) then begin
    ;GetTemporaryFilename use null extension
    ;to avoid conflict between *.dat.hdr and *.hdr
    self.files[firstIndex] = !e.GetTemporaryFilename('')
  endif

  ;use /TWOTIME to get temporary filename for mss and pan
  if ISA(twoTime) and firstIndex lt N_ELEMENTS(self.files)-1 then begin
    self.files[firstIndex + 1] = !e.GetTemporaryFilename('')
  endif
end

;get the latest filename
function oPMS::getLastFile
  compile_opt idl2, hidden

  RETURN, self.files[(WHERE(self.files ne ''))[-1]]
end

;for pms sensor, it's necessary to have this
;to get the mss and pan filename
pro oPMS::_getLast2, mssFn = mss_fn, panFn = pan_fn
  compile_opt idl2, hidden

  mss_fn = self.files[(WHERE(self.files ne ''))[-1] - 1]
  pan_fn = self.getLastFile()
end

;use oPMS.property = value
;to set value to certain property
pro oPMS::setProperty, tgz_fn = tgz_fn, $
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

;use value = oPMS.property
;to get the value of certain property
pro oPMS::getProperty, tgz_fn = tgz_fn, $
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

;destroy oPMS
pro oPMS::cleanup
  compile_opt idl2, hidden

  lastIndex = (WHERE(self.files ne ''))[-1]

  ;delete temp files
  for i = 1L, lastIndex do delImg, self.files[i]
  log, 'delete temp files'

  ;delete unpack image directory
  FILE_DELETE, self.imgDir, /RECURSIVE
  log, 'delete original image directory'
  self->IDL_Object::Cleanup
end

;+
; example arguments to initialize oPMS
;   tgz_fn: '/home/ds/GF6_PMS_E111.6_N32.8_20190318_L1A1119857678.tar.gz'
;   info:   ['GF6', 'PMS', '2019']
;   flag:   ['/home/ds/shapefile.shp', '1', '0']
;   o_fn:   '/home/ds/snowyDove/GF6_PMS_E111.6_N32.8_20190318.dat'
;-
function oPMS::init, tgz_fn, info, flag, o_fn
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
  if flag[0] ne '0' then log, 'region for subset: ' + flag[0]
  log, 'quac flag: ' + STRJOIN(flag[1:2])

  RETURN, 1B
end

pro oPMS__define
  compile_opt idl2

  structure = { oPMS, inherits IDL_Object, $
    tgz_fn: '', wrkDir: '', imgDir: '', $
    calGain: MAKE_ARRAY(5, /DOUBLE), $
    calOffs: MAKE_ARRAY(5, /DOUBLE), $
    wvl: MAKE_ARRAY(4, /L64), $
    flag: MAKE_ARRAY(3, /STRING), $
    files: MAKE_ARRAY(9, /STRING)}
end
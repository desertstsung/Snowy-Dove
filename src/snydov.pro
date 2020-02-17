;+
; :Description:
;    Main procedure of project Snowy Dove
;    Aimed at pre-process imageries
;    Taken by GaoFen(GF)1, GF2 and GF6
;    Output files has similar name with the original ones
;
; :Requires:
;    IDL8.3/ENVI5.1 or later
;
; :Rely-on:
;    timeex.pro, dov4pms.pro, dov1wfv.pro, dov6wfv.pro
;    op__define.pro, o1w__define.pro, o6w__define.pro
;    ffconvert.pro
;
; :Usage:
;    snyDov, string [, dem = string] [, region = string] [, /qac] [, /scale] [, /tiff] [, /ndvi]
;    or simply
;    snyDov, string [, d = string] [, r = string] [, /q] [, /s] [, /t] [, /n]
;
; :Arguments:
;    i_dir:  string of directory path which include original gz files to process
;
; :Params:
;    dem_fn: string of DEM filename to orthorectify imagery, using GMTED2010.jp2 for default
;    region: string shapefile or ROI filename to subset the imagery
;
; :Keywords:
;    qac:   apply quick atmospheric correction
;    scale: reduce the QUAC outcome to original scale range from 0-1
;    tiff:  convert the default ENVI format to tiff format
;    ndvi:  get an extra NDVI
;
; :Examples:
;    snyDov, '/home/jtsung/Downloads/testData4SnowyDove'
;      --apply orthorectification and calibration to WFV sensors
;      --apply orthorectification, calibration and GS sharpen to PMS sensors
;    snyDov, 'C:\usr\data', d = 'C:\usr\data\mydem.tif', r = 'C:\usr\shp\sc.shp'
;      --apply orthorectification(using mydem), subset and calibration to WFV sensors
;      --apply orthorectification(using mydem), subset, calibration and GS sharpen to PMS sensors
;    snyDov, '/data', /q, /s
;      --apply orthorectification, calibration, QUAC and divide 10k to WFV sensors
;      --apply orthorectification, calibration, GS sharpen, QUAC and divide 10k to PMS sensors
;
; :History:
;    //v18.12.06 - v19.05.22: original version of project jiaotang//
;    v0.1.0: first version, date 2020/2/6
;
; :Author:
;    deserts Tsung (desertstsung@qq.com)
;    Chengdu University of Information Technology
;-
pro snyDov, i_dir, dem_fn = demFn, region = shpFn, $
  qac = qac, scale = scale, tiff = tiff, ndvi = ndvi
  compile_opt idl2, hidden

  ON_ERROR, 2
  c = tic('snyDov')

  ;-----input directory check-----;
  if FILE_TEST(i_dir, /DIRECTORY) then begin
    files = FILE_SEARCH(i_dir, '*.tar.gz')
    if ~files[0] then begin
      MESSAGE, 'no tgz file found in ' + i_dir, /INFORMATIONAL, /RESET
    endif
  endif else begin
    MESSAGE, i_dir + ' is not a directory', /INFORMATIONAL, /RESET
  endelse

  ;-----keywords setting check-----;
  if KEYWORD_SET(scale) && ~KEYWORD_SET(qac) then begin
    MESSAGE, 'scale without QUAC is NOT available', /INFORMATIONAL, /RESET
  endif

  ;-----calibration coefficient and wavelength file check-----;
  currentProDir = FILE_DIRNAME(ROUTINE_FILEPATH())
  cal_fn = FILEPATH('snyDov_cal.json', root = currentProDir)
  wvl_fn = FILEPATH('snyDov_wvl.json', root = currentProDir)
  if ~FILE_TEST(cal_fn) then $
    MESSAGE, 'file for calibration not found', /INFORMATIONAL, /RESET
  if ~FILE_TEST(wvl_fn) then $
    MESSAGE, 'file for wavelength-set not found', /INFORMATIONAL, /RESET

  ;-----filename of log-----;
  o_dir = i_dir + (STRMID(i_dir, STRLEN(i_dir)-1, 1) eq PATH_SEP() ? $
    '' : PATH_SEP()) + 'snowyDove'
  if FILE_TEST(o_dir, /DIRECTORY) then begin
    FILE_DELETE, o_dir, /RECURSIVE
  endif else begin
    FILE_MKDIR, o_dir
  endelse
  DEFSYSV, '!log_fn', FILEPATH('snyDov_' + timeEx() + '.log', root = o_dir), 1

  DLM_LOAD, 'XML', 'SHAPEFILE', 'JPEG2000', 'JPEG', 'PNG', $
    'TIFF', 'GDAL', 'MAP_PE', 'NATIVE'
  DEFSYSV, '!e', ENVI(/HEADLESS), 1
  if ~KEYWORD_SET(demFn) then begin
    demFn = FILEPATH('GMTED2010.jp2', root = !e.root_dir, sub = 'data')
  endif

  PRINT, '----------  snowy dove is flying'
  PRINT, '----------  log file: ' + !log_fn

  ;-----main procedure-----;
  foreach gz_fn, files do begin

    info = (strSplit(FILE_BASENAME(gz_fn), '_', /EXTRACT))[0:4]
    o_fn = FILEPATH(STRJOIN(info, '_'), root = o_dir)

    flag = [(KEYWORD_SET(shpFn) ? shpFn : '0'), $
      (KEYWORD_SET(qac) ? '1' : '0'), (KEYWORD_SET(scale) ? '1' : '0')]

    if STRCMP(info[1], 'PMS', 3) then begin
      DEFSYSV, '!obj', oPMS(gz_fn, [info[0], info[1], $
        STRMID(info[4], 0, 4)], flag, o_fn)
      PMSHandler, demFn
    endif else if STRCMP(info[1], 'WFV', 3) then begin

      case info[0] of
        'GF1': begin
          DEFSYSV, '!obj', oWFV1(gz_fn, [info[0], info[1], $
            STRMID(info[4], 0, 4)], flag, o_fn)
          WFV1Handler, demFn
        end
        'GF6': begin;TODO
          DEFSYSV, '!obj', oWFV6(gz_fn, [info[0], info[1], $
            STRMID(info[4], 0, 4)], flag, o_fn)
          WFV6Handler, demFn
        end
        else: MESSAGE, 'not supported', /INFORMATIONAL, /CONTINUE
      endcase

    endif else begin
      MESSAGE, 'not supported', /INFORMATIONAL, /CONTINUE
    endelse

    if KEYWORD_SET(ndvi) then begin
      fnNDVI = FILEPATH(FILE_BASENAME(o_fn) + '_NDVI', $
        root = FILE_DIRNAME(o_fn))
      ndviGenerate, o_fn, fnNDVI
      log, 'output NDVI file: ' + fnNDVI
    endif

    if KEYWORD_SET(tiff) then begin
      fnTIFF = FILEPATH(FILE_BASENAME(o_fn) + '_TIFF.tiff', $
        root = FILE_DIRNAME(o_fn))
      ffConvert, o_fn, fnTIFF, wvl_fn, info[0:1]
      log, 'output tiff file: ' + fnTIFF
    end

    log, 'end processing ' + FILE_BASENAME(gz_fn, '.tar.gz'), /HEAD
  endforeach

  (!e).close
  toc, c
  PRINT, '----------  thanks for using'
end
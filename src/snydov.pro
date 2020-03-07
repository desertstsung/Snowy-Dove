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
; :Usage:
;    snyDov, i_dir [, dem = string] [, region = string] [, /QAC] [, /TIFF] [, /NDVI] [, /PYRAMID] [, /CONSOLEPRINT]
;    or simply
;    snydov, i_dir [, d = string] [, r = string] [, /q] [, /t] [, /n] [, /p] [, /c]
;
; :Arguments:
;    i_dir:  string of directory path which include original tar.gz files to process
;
; :Params:
;    dem_fn: string of DEM filename to orthorectify imagery, using GMTED2010.jp2 for default
;    region: string of shapefile to subset the imagery
;
; :Keywords:
;    qac:     perform quick atmospheric correction
;    scale:   reduce the QUAC outcome to original scale range from 0-1
;    tiff:    convert the default ENVI format to tiff format
;    ndvi:    get an extra NDVI raster in ENVI format
;    pyramid: create pyramid of result raster
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
;    v0.1-alpha: first version, date 2020/2/21
;    v0.2-alpha: bug-fix of del image, date 2020/2/22
;    v0.3-alpha: bug-fix of getdate from bip format ENVIRaster, date 2020/2/25
;    v0.4-alpha: adjustion of log
;                adjustion of mosaic and subset of gf6
;                add wavelength if qac is not set
;                use '_' instead of '.' in lon/lat in output fn
;                date 2020/2/28
;    v1.0: update the method of rpc redefine
;          update the method of adding hdr to a tiff file
;          add pyramid keyword
;          remove file 'make' and add file 'run'
;          adjustion of del image
;          del scale keyword
;          date 2020/3/7
;
; :Author:
;    deserts Tsung (desertstsung@qq.com)
;    Chengdu University of Information Technology
;-
pro snyDov, i_dir, dem = demFn, region = shpFn, $
  qac = QAC, tiff = TIFF, ndvi = NDVI, $
  pyramid = PYRAMID, consoleprint = CONSOLEPRINT
  compile_opt idl2, hidden
  ON_ERROR, 2

  common blk, pymd, cslprt
  pymd = KEYWORD_SET(pyramid) ? 1B : 0B
  cslprt = KEYWORD_SET(CONSOLEPRINT) ? 1B : 0B

  ;-----input directory check-----;
  if FILE_TEST(i_dir, /DIRECTORY) then begin
    files = FILE_SEARCH(i_dir, '*.tar.gz')
    if ~files[0] then begin
      MESSAGE, 'no tgz file found in ' + i_dir, /INFORMATIONAL, /RESET
      RETURN
    endif
  endif else begin
    MESSAGE, i_dir + ' is not a directory', /INFORMATIONAL, /RESET
    RETURN
  endelse

  ;-----calibration coefficient and wavelength file check-----;
  currentProDir = FILE_DIRNAME(ROUTINE_FILEPATH())
  cal_fn = FILEPATH('snyDov_cal.json', root = currentProDir)
  wvl_fn = FILEPATH('snyDov_wvl.json', root = currentProDir)
  if ~FILE_TEST(cal_fn) then begin
    MESSAGE, 'file for calibration not found', /INFORMATIONAL, /RESET
    RETURN
  endif
  if ~FILE_TEST(wvl_fn) then begin
    MESSAGE, 'file for wavelength-set not found', /INFORMATIONAL, /RESET
    RETURN
  endif

  ;-----filename of log-----;
  o_dir = i_dir + (STRMID(i_dir, STRLEN(i_dir)-1, 1) eq PATH_SEP() ? $
    '' : PATH_SEP()) + 'snowyDove'
  if FILE_TEST(o_dir, /DIRECTORY) then begin
    FILE_DELETE, o_dir, /RECURSIVE
  endif else begin
    FILE_MKDIR, o_dir
  endelse
  DEFSYSV, '!log_fn', FILEPATH(timeEx(/FILENAME) + '.log', root = o_dir), 1

  DLM_LOAD, 'XML', 'SHAPEFILE', 'JPEG2000', 'JPEG', 'PNG', $
    'TIFF', 'GDAL', 'MAP_PE', 'NATIVE', 'JPIP'
  DEFSYSV, '!e', ENVI(/HEADLESS), 1
  if ~KEYWORD_SET(demFn) then begin
    demFn = FILEPATH('GMTED2010.jp2', root = !e.root_dir, sub = 'data')
  endif

  PRINT, timeEx() + ' snowy dove is flying'
  PRINT, timeEx() + ' log file: ' + !log_fn

  ;-----main procedure-----;
  foreach gz_fn, files do begin

    info = (STRTOK(FILE_BASENAME(gz_fn), '_', /EXTRACT))[0:4]
    o_fn = FILEPATH(STRJOIN([info[0:1], STRTOK(info[2], '.', /EXTRACT), $
      STRTOK(info[3], '.', /EXTRACT), info[4]], '_') + '_snyDov', root = o_dir)

    flag = [(KEYWORD_SET(shpFn) ? shpFn : '0'), $
      (KEYWORD_SET(qac) ? '1' : '0')]

    ;PMS Handler, for gf1-pms, gf1b/c/d-pms, gf2-pms, gf6-pms
    if STRCMP(info[1], 'PMS', 3) then begin
      DEFSYSV, '!obj', oPMS(gz_fn, [info[0], info[1], $
        STRMID(info[4], 0, 4)], flag, o_fn)
      PMSHandler, demFn
      ;WFV Handler, for gf1-wfv and gf6-wfv
    endif else if STRCMP(info[1], 'WFV', 3) then begin

      case info[0] of
        'GF1': begin
          DEFSYSV, '!obj', oWFV1(gz_fn, [info[0], info[1], $
            STRMID(info[4], 0, 4)], flag, o_fn)
          WFV1Handler, demFn
        end
        'GF6': begin
          DEFSYSV, '!obj', oWFV6(gz_fn, [info[0], info[1], $
            STRMID(info[4], 0, 4)], flag, o_fn)
          WFV6Handler, demFn
        end
        else: MESSAGE, 'not supported', /INFORMATIONAL, /CONTINUE
      endcase

    endif else begin
      MESSAGE, 'not supported', /INFORMATIONAL, /CONTINUE
    endelse

    ;NDVI generate
    if KEYWORD_SET(ndvi) then begin
      fnNDVI = FILEPATH(FILE_BASENAME(o_fn) + '_NDVI', $
        root = FILE_DIRNAME(o_fn))
      ndviGenerate, o_fn, fnNDVI
    endif

    ;convert ENVI format to GeoTIFF
    if KEYWORD_SET(tiff) then begin
      fnTIFF = FILEPATH(FILE_BASENAME(o_fn) + '_TIFF.tiff', $
        root = FILE_DIRNAME(o_fn))
      ffConvert, o_fn, fnTIFF, wvl_fn, info[0:1]
    end

    log, 'end processing ', gz_fn, /HEAD
  endforeach

  (!e).close
  PRINT, timeEx() + ' thanks for using'
end

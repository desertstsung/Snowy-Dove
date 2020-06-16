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
;    snyDov, i_dir
;      [, dem = string] [, region = string]
;      [, /{QAC | SCALE}] [, /TIFF] [, /NDVI] [, /PYRAMID] [, /CONSOLEPRINT]
;    ;or simply
;    snydov, i_dir
;      [, d = string] [, r = string]
;      [, /{q | s}] [, /t] [, /n] [, /p] [, /c]
;
; :Arguments:
;    i_dir: string of directory path which include original tar.gz files to process
;
; :Params:
;    dem:    string of DEM filename to orthorectify imagery, using GMTED2010.jp2 for default
;    region: string of shapefile to subset the imagery
;
; :Keywords:
;    qac:          perform quick atmospheric correction
;    scale:        reduce the quac outcome to original scale range from 0-1
;                  IF SCALE KEYWORD IS SET, THEN QAC KEYWORD IS SET BY DEFAULT IF NOT PRESENT
;    tiff:         convert the default envi format to tiff format
;    ndvi:         get an extra ndvi raster in envi format
;    pyramid:      create pyramid of result raster
;    consoleprint: print progress in console
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
;    v0.3-alpha: bug-fix of getdata from bip format ENVIRaster, date 2020/2/25
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
;    v1.1-alpha: add python script to perform rpc warp and pan sharpen
;                date 2020/3/18
;    v1.2-alpha: use py<step>.py instead of py<step>.pyc
;                date 2020/3/20
;    v1.3-alpha: update the method of radiance calibration
;                  --add file readheader.pro and wrtheader.pro
;                the syntax of run.src get more shell flavor
;                  --rename run to run.src
;                adjust the format of python output to ENVI standard
;                  --remove addTIFFExtension method of object defination
;                add __extra keyword to handle error when using run.src
;                add version string
;                rename gssharpen.pro to pansharpen.pro
;                re-add a more efficient scale keyword
;                add dynamically loadable module 'snowydove', written in C
;                  --add extra procedure:
;                      sd_nv2tf: export envi file format to TIFF
;                      sd_radcal: perform linear change to envi file format
;                      sd_ndvi: get an ndvi result from envi file format
;                      sd_showpic: print a snowy dove in console
;                date 2020/6/16
;                NOTICE: v1.3-alpha is for linux only
;
; :Author:
;    deserts Tsung (desertstsung@qq.com)
;    Chengdu University of Information Technology
;-
pro snyDov, i_dir, dem = demFn, region = shpFn, $
  qac = QAC, scale = SCALE, tiff = TIFF, ndvi = NDVI, $
  pyramid = PYRAMID, consoleprint = CONSOLEPRINT, $
  __extra = status ;flag to handle error in $run.src$ script;
  compile_opt idl2, hidden

  ;-----current version of snowy dove-----;
  __version__ = '1.3-alpha'

  ;-----common block of pyramid, consoleprint and tiff keyword-----;
  common blk, pymd, cslprt, nv2tiff
  pymd = KEYWORD_SET(PYRAMID) ? 1B : 0B
  cslprt = KEYWORD_SET(CONSOLEPRINT) ? 1B : 0B
  nv2tiff = KEYWORD_SET(TIFF) ? 1B : 0B
  
  ;-----common block of scale keyword-----;
  common blkScl, sclSet
  sclSet = KEYWORD_SET(SCALE)
  if sclSet then QAC = 1

  ;-----input directory check-----;
  if FILE_TEST(i_dir, /DIRECTORY) then begin
    files = FILE_SEARCH(FILEPATH(root = i_dir, '*.tar.gz'))
    if ~files[0] then begin
      MESSAGE, '*******************no tgz file found in ' + i_dir, /INFORMATIONAL, /RESET
      RETURN
    endif
  endif else begin
    MESSAGE, '*******************' + i_dir + ' is not a directory', /INFORMATIONAL, /RESET
    RETURN
  endelse

  ;-----calibration coefficient and wavelength file check-----;
  currentProDir = FILE_DIRNAME(ROUTINE_FILEPATH())
  cal_fn = FILEPATH('snyDov_cal.json', root = currentProDir)
  wvl_fn = FILEPATH('snyDov_wvl.json', root = currentProDir)
  if ~FILE_TEST(cal_fn) then begin
    MESSAGE, '******************* file for calibration not found', /INFORMATIONAL, /RESET
    RETURN
  endif
  if ~FILE_TEST(wvl_fn) then begin
    MESSAGE, '******************* file for wavelength-set not found', /INFORMATIONAL, /RESET
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

  DLM_REGISTER, FILEPATH('snowydove.dlm', root = currentProDir)
  DLM_LOAD, 'XML', 'SHAPEFILE', 'JPEG2000', 'JPEG', 'PNG', $
    'TIFF', 'GDAL', 'MAP_PE', 'NATIVE', 'JPIP', 'SNOWYDOVE'
  DEFSYSV, '!e', ENVI(/HEADLESS), 1
  if ~KEYWORD_SET(demFn) then begin
    demFn = FILEPATH('GMTED2010.jp2', root = !e.root_dir, sub = 'data')
  endif

  sd_ShowPic
  PRINT, timeEx() + ' current version of snowy dove: ' + __version__
  PRINT, timeEx() + ' contact: desertstsung@qq.com'
  PRINT, timeEx() + ' ------------------------'
  PRINT, timeEx() + ' snowy dove is flying'
  PRINT, timeEx() + ' log file: ' + !log_fn

  ;-----main procedure-----;
  status = 1B
  foreach gz_fn, files do begin

    info = (STRTOK(FILE_BASENAME(gz_fn), '_', /EXTRACT))[0:4]
    o_fn = FILEPATH(STRJOIN([info[0:1], STRTOK(info[2], '.', /EXTRACT), $
      STRTOK(info[3], '.', /EXTRACT), info[4]], '_') + '_snyDov', root = o_dir)

    flag = [(KEYWORD_SET(shpFn) ? shpFn : '0'), $
      (KEYWORD_SET(QAC) ? '1' : '0')]

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

    o_fn = FILE_TEST(o_fn) ? o_fn : o_fn + '.tiff'

    ;NDVI generate
    if KEYWORD_SET(NDVI) then begin
      fnNDVI = FILEPATH(FILE_BASENAME(o_fn) + '_NDVI', $
        root = FILE_DIRNAME(o_fn))
      ndviGenerate, o_fn, fnNDVI
    endif

    ;convert ENVI format to GeoTIFF
    if KEYWORD_SET(TIFF) then begin
      if STRMID(o_fn, 4, /REVERSE_OFFSET) ne '.tiff' then begin
        fnTIFF = FILEPATH(FILE_BASENAME(o_fn) + '_TIFF.tiff', $
          root = FILE_DIRNAME(o_fn))
      endif else begin
        fnTIFF = o_fn
      endelse
      ffConvert, o_fn, fnTIFF, wvl_fn, info[0:1]
    end

    log, 'end processing ', gz_fn, /HEAD
  endforeach
  status = 0B

  (!e).close
  PRINT, timeEx() + ' thanks for using'
end

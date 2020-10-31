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
;    sdMain, tgzdirIn
;            [, DEM=demfn] [, REGION=shpfn]
;            [, /CALI] [, /{QUAC | SCALE}] [, /TIFF] [, /NDVI] [, /PYRAMID] [, /VERBOSE]
;    ;or simply
;    sdMain, tgzdirIn
;            [, d=demfn] [, r=shpfn]
;            [, /c] [, /{q | s}] [, /t] [, /n] [, /p] [, /v]
;
; :Arguments:
;    tgzdirIn: string of directory path which include original tar.gz files to process
;
; :Params:
;    DEM   : string of DEM filename to orthorectify imagery, using GMTED2010.jp2 for default
;    REGION: string of shapefile to subset the imagery
;
; :Keywords:
;    CALI   : apply radiance calibration
;    QUAC   : perform quick atmospheric correction
;    SCALE  : reduce the quac outcome to original scale range from 0-1
;             IF SCALE KEYWORD IS SET, THEN QUAC KEYWORD IS SET BY DEFAULT IF NOT PRESENT
;    TIFF   : convert the default envi format to tiff format
;    NDVI   : get an extra ndvi raster in envi format
;    PYRAMID: create pyramid of result raster
;    VERBOSE: print progress in console
;
; :Examples:
;    sdMain, '/home/jtsung/Downloads/testData4SnowyDove', /s
;    sdMain, 'C:\usr\data', d = 'C:\usr\data\mydem.tif', r = 'C:\usr\shp\sc.shp'
;    sdMain, '/data', /v
;
; :History:
;    //v18.12.06 - v19.05.22: original version of project jiaotang//
;    v0.1-alpha: first version, date 2020/2/21
;    
;    v0.2-alpha: bug-fix of del image, date 2020/2/22
;    
;    v0.3-alpha: bug-fix of getdata from bip format ENVIRaster, date 2020/2/25
;    
;    v0.4-alpha: adjustion of log
;                adjustion of mosaic and subset of gf6
;                add wavelength if qac is not set
;                use '_' instead of '.' in lon/lat in output fn
;                date 2020/2/28
;    
;    v1.0      : update the method of rpc redefine
;                update the method of adding hdr to a tiff file
;                add pyramid keyword
;                remove file 'make' and add file 'run'
;                adjustion of del image
;                del scale keyword
;                date 2020/3/7
;    
;    v1.1-alpha: add python script to perform rpc warp and pan sharpen
;                date 2020/3/18
;    
;    v1.2-alpha: use py<step>.py instead of py<step>.pyc
;                date 2020/3/20
;    
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
;    v2.0      : *.pro filename change
;                process change
;                directory structure change
;                  Snowy-Dove
;                  |--binary
;                  |  |--sd_ndvi
;                  |  |--sd_ndvi.exe
;                  |  |--sd_nv2tiff
;                  |  |--sd_nv2tiff.exe
;                  |  |--sd_radcal
;                  |  |--sd_radcal.exe
;                  |--external
;                  |  |--pysharpen.py
;                  |  |--pywarp.py
;                  |  |--sd_ndvi.linux.c
;                  |  |--sd_ndvi.win.c
;                  |  |--sd_nv2tiff.linux.c
;                  |  |--sd_nv2tiff.win.c
;                  |  |--sd_radcal.c
;                  |--src
;                  |  |--sdAddMetadata.pro
;                  |  |--sdCommonProcess.pro
;                  |  |--sdConvertToGeoTIFF.pro
;                  |  |--sdDecompress.pro
;                  |  |--sdDelImageFile.pro
;                  |  |--sdDelTempFiles.pro
;                  |  |--sdGetPANMS.pro sdLog.pro
;                  |  |--sdLonLatRangeIntersect.pro
;                  |  |--sdMain.pro
;                  |  |--sdMosaicGF6.pro
;                  |  |--sdNDVIGenerate.pro
;                  |  |--sdPanSharpen.pro
;                  |  |--sdPoint2Underscore.pro
;                  |  |--sdPreLog.pro
;                  |  |--sdProcessor_GF1_WFV.pro
;                  |  |--sdProcessor_GF6_WFV.pro
;                  |  |--sdProcessor_PMS.pro
;                  |  |--sdPyramidCreate.pro
;                  |  |--sdQUAC.pro
;                  |  |--sdQUACDivide.pro
;                  |  |--sdRPCRedefine.pro
;                  |  |--sdRPCWarp.pro
;                  |  |--sdRadianceCalibration.pro
;                  |  |--sdReadHeader.pro
;                  |  |--sdShpValid.pro
;                  |  |--sdStructDefine.pro
;                  |  |--sdSubsetByShp.pro
;                  |  |--sdTimeStr.pro
;                  |  |--sdValidTempFilename.pro
;                  |  |--sdWriteHeader.pro
;                  |  |--sd_radcalcoeff_2013.pro
;                  |  |--sd_radcalcoeff_2014.pro
;                  |  |--sd_radcalcoeff_2015.pro
;                  |  |--sd_radcalcoeff_2016.pro
;                  |  |--sd_radcalcoeff_2017.pro
;                  |  |--sd_radcalcoeff_2018.pro
;                  |  |--sd_radcalcoeff_2019.pro
;                  |  |--sd_radcalcoeff_2020.pro
;                  |  |--sd_radcalcoeff_main.pro
;                  |__|--sd_wavelength.pro
;                add radiance calibration keyword
;                change dynamically loadable module to executable file(../binary/*)
;                bug-fix of python flag
;                date 2020/10/31
;
; :Number_of_Lines:
;    TOTAL  : 1826(IDL) + 132(Python) + 2160(C) = 4118
;    BLANK  :   31(IDL) +  19(Python) +  209(C) =  259( 6.29%)
;    COMMENT:  404(IDL) +  10(Python) +   64(C) =  478(11.61%)
;
; :Author:
;    deserts Tsung (desertstsung@qq.com)
;    CUIT # Chengdu University of Information Technology
;    HPU  # Henan Polytechnic University
;-
pro sdMain, tgzdirIn         , $
            dem     = demfn  , $
            region  = shpfn  , $
            cali    = CALI   , $
            quac    = QUAC   , $
            scale   = SCALE  , $
            tiff    = TIFF   , $
            ndvi    = NDVI   , $
            pyramid = PYRAMID, $
            verbose = VERBOSE
  compile_opt  idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun

  ;================= current version of snowy dove =================
  __version__ = '2.0'

  ;===================== input directory check =====================
  if ~ISA(tgzdirIn) then tgzdirIn = DIALOG_PICKFILE(/DIRECTORY)
  if FILE_TEST(tgzdirIn, /DIRECTORY) then begin
    tgzfiles = FILE_SEARCH(FILEPATH(ROOT_DIR=tgzdirIn, '*.tar.gz'))
    if ~tgzfiles[0] then begin
      PRINTF, -1, '************************** NO TGZ FILE FOUND IN ' + tgzdirIn
      RETURN
    endif
  endif else begin
    PRINTF, -1, '************************** ' + tgzdirIn + ' IS NOT A DIRECTORY'
    RETURN
  endelse
  
  ;================= quac is set when scale is set =================
  if ISA(SCALE) then QUAC = 1B

  ;======================== filename of log ========================
  outputdirectory = FILEPATH('Sonwy-Dove-Output', ROOT_DIR=tgzdirIn)
  if FILE_TEST(outputdirectory, /DIRECTORY) then FILE_DELETE, outputdirectory, /RECURSIVE
  FILE_MKDIR , outputdirectory
  logfn = FILEPATH(sdTimeStr(/FILENAME) + '.log', ROOT_DIR=outputdirectory)

  ;============================ load DLM ===========================
  DLM_LOAD, 'XML' , 'SHAPEFILE', 'JPEG2000', 'JPEG'  , 'PNG', $
            'TIFF', 'GDAL'     , 'MAP_PE'  , 'NATIVE', 'JPIP'
  
  ;====================== get ENVI environment =====================
  if ~(e = ENVI(/CURRENT)) then e = ENVI(/HEADLESS)
  
  ;======================== check input dem ========================
  defaultdem = FILEPATH('GMTED2010.jp2', ROOT_DIR=e.ROOT_DIR, SUBDIRECTORY='data')
  if ISA(demfn) then begin
    if ~FILE_TEST(demfn) then demfn = defaultdem
  endif else demfn = defaultdem
  
  ;================== python3 check, not required ==================
  SPAWN, 'python --version', msg, err
  py = 2B
  if   STREGEX(msg, '3.*') ne -1 or STREGEX(err, '3.*') ne -1 then py = 'python'
  if py eq 2B then begin
    SPAWN, 'python3 --version', msg, err
    if STREGEX(msg, '3.*') ne -1 or STREGEX(err, '3.*') ne -1 then py = 'python3'
  endif
  
  ;================== current OS is linux based ? ==================
  islinux = !version.OS eq 'linux'
  
  ;======== get valid logical unit number for recyclable use =======
  GET_LUN, lun

  ;=================== print program information ===================
  PRINTF, -1, sdTimeStr() + ' CURRENT VERSION OF SNOWY DOVE: ' + __version__
  PRINTF, -1, sdTimeStr() + ' CONTACT: DESERTSTSUNG@QQ.COM'
  PRINTF, -1, sdTimeStr() + ' ========================'
  PRINTF, -1, sdTimeStr() + ' SNOWY DOVE IS FLYING'
  PRINTF, -1, sdTimeStr() + ' LOG FILE: ' + logfn

  ;========================= main procedure ========================
  foreach tgzfile, tgzfiles do begin
    sdstruct = sdStructDefine(TGZFN        = tgzfile        , $
                              DEM          = demfn          , $
                              SHP          = shpfn          , $
                              DIR          = outputdirectory, $
                              FCALIBRATION = CALI           , $
                              FQUAC1       = QUAC           , $
                              FQUACDIVIDE  = SCALE          , $
                              FTIFF        = TIFF           , $
                              FNDVI        = NDVI           , $
                              FPYRAMID     = PYRAMID        , $
                              FVERBOSE     = VERBOSE)
    CALL_PROCEDURE,  sdstruct.callpro
  endforeach

  ;========================= end of program ========================
  e.Close
  PRINTF, -1, sdTimeStr() + ' THANKS FOR USING'
end

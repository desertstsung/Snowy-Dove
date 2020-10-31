# Snowy Dove
an IDL program aimed at auto-pre-processing imageries taken by GaoFen(GF)1, GF2 and GF6, in batch mode, and without GUI.
# Usage
## using IDL script via terminal
```shell
$ git clone https://github.com/desertstsung/Snowy-Dove.git $yourdir
$ cd $yourdir
$ idl ./sdRunMain.sh -args i_dir -d dem_fn -r shapefile -cpstnpv
```
## using source code in IDL (workbench)
```shell
$ git clone https://github.com/desertstsung/Snowy-Dove.git $yourdir
$ idl # recommended, or idlde
CD, $yourdir/src
.COMPILE sdMain             , sdStructDefine
.COMPILE sdProcessor_PMS    , sdProcessor_GF1_WFV  , sdProcessor_GF6_WFV
.COMPILE sdDecompress       , sdRPCRedefine        , sdRPCWarp
.COMPILE sdSubsetByShp      , sdRadianceCalibration, sdPanSharpen
.COMPILE sdQUAC             , sdQUACDivide         , sdNDVIGenerate
.COMPILE sdConvertToGeoTIFF , sdPyramidCreate      , sdDelTempFiles
.COMPILE sdAddMetadata      , sdDelImageFile       , sdDelTempFiles
.COMPILE sdGetPANMS         , sdLog                , sdLonLatRangeIntersect
.COMPILE sdMosaicGF6        , sdPoint2Underscore   , sdPreLog
.COMPILE sdReadHeader       , sdShpValid           , sdTimeStr
.COMPILE sdValidTempFilename, sdWriteHeader        , sdCommonProcess
RESOLVE_ALL, /CONTINUE_ON_ERROR, SKIP_ROUTINES='envi'
sdMain, tgzdirIn [, DEM=demfn] [, REGION=shpfn] [, /CALI] [, /{QUAC | SCALE}] [, /TIFF] [, /NDVI] [, /PYRAMID] [, /VERBOSE]
; or simply typing:
sdMain, tgzdirIn [, d=demfn] [, r=shpfn] [, /c] [, /{q | s}] [, /t] [, /n] [, /p] [, /v]
```
- ``tgzdirIn``         : directory where *.tar.gz files are
- ``DEM(optional)``    : fn of DEM used to orthoretcify images
- ``REGION(optional)`` : fn of shapefile to subset images
- ``CALI(optional)``   : keyword to apply radiance calibration
- ``QUAC(optional)``   : keyword to apply QUAC
- ``SCALE(optional)``  : keyword to multiply 0.0001 to QUAC result
- ``TIFF(optional)``   : keyword to convert default ENVI format to TIFF format
- ``NDVI(optional)``   : keyword to get an extra NDVI result
- ``PYRAMID(optional)``: keyword to build ``.enp`` file for outcome
- ``VERBOSE(optional)``: keyword to print step in IDL console or terminal
# Notice
- IDL8.3/ENVI5.1 or later is required
- make sure you have the license for FLAASH if keyword QUAC or SCALE is set
# TODO
- its difficult to find the shapefile is whether inside a certain RPC-based(not orthorectified in another way to say) raster, so its **time-cost** to orthorectify each tiff file and then determine its location between the shapefile

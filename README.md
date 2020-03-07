# Snowy Dove
an IDL program aimed at auto-pre-processing imageries taken by GaoFen(GF)1, GF2 and GF6, in batch mode.
# Usage
## using source code via terminal
```shell
$ git clone https://github.com/desertstsung/Snowy-Dove.git
$ cd ./Snowy-Dove/src
$ idl ./run -args i_dir dem=dem_fn region=shapefile /QAC /TIFF /NDVI /PYRAMID /CONSOLEPRINT
$ # or simply typing:
$ idl ./run -args i_dir d=dem_fn r=shapefile /q /t /n /p /c
```
## using saved binary file in IDL (workbench)
```shell
$ wget https://github.com/desertstsung/Snowy-Dove/releases/download/v1.0/v1.0.zip
$ unzip ./v1_0.zip
$ cd ./v1_0
$ idl # recommended, or idlde
IDL> .compile snydov
IDL> snydov, i_dir, dem = dem_fn, region = shapefile, /QAC, /TIFF, /NDVI, /PYRAMID, /CONSOLEPRINT
IDL> ; or simply typing:
IDL> snydov, i_dir, d = dem_fn, r = shapefile, /q, /t, /n, /p, /c
```
- ``i_dir``:                  directory where *.tar.gz files are
- ``dem(optional)``:          fn of DEM used to orthoretcify images
- ``region(optional)``:       fn of shapefile to subset images
- ``QAC(optional)``:          keyword to apply QUAC
- ``TIFF(optional)``:         keyword to convert default ENVI format to TIFF format
- ``NDVI(optional)``:         keyword to get an extra NDVI result
- ``CONSOLEPRINT(optional)``: keyword to print step in IDL console or terminal
# Notice
- IDL8.3/ENVI5.1 or later is required
- the json file must be in the dir where snyDov.sav is
- export to tiff format may encounter warning, it doesnot matter
- make sure you have the license for FLAASH if keyword QAC is set
- if you run this in terminal, use ``d=dem_fn`` instead of ``d = dem_fn``, since each params are divided from space
# TODO
- its difficult to find the shapefile is whether inside a certain RPC-based(not orthorectified in another way to say) raster, so its **time-cost** to orthorectify each tiff file and then determine its location between the shapefile
- there is a way to process without ENVI interface in some steps(radiance calibration, subset, interleave convert, convert ENVI binary file to GeoTIFF, NDVI generate), and worked well in normal size images, but large file like GF6_PMS may encocunter **memory limitation**(at least in my developing environment), which will shut IDL down.
- im trying to find a new way to add keyword 'scale' back.

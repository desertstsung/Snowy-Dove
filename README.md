# Snowy Dove
an IDL program aimed at auto-pre-processing imageries taken by GaoFen(GF)1, GF2 and GF6, in batch mode, and without GUI.
# Usage
## using source code via terminal
```shell
$ git clone https://github.com/desertstsung/Snowy-Dove.git
$ cd ./Snowy-Dove/src
$ idl ./run.src -args i_dir -d dem_fn -r shapefile -q -t -n -p -c
```
## using saved binary file in IDL (workbench)
```shell
$ wget https://github.com/desertstsung/Snowy-Dove/releases/download/v1.3-alpha/v1_3-alpha.zip
$ unzip ./v1_3-alpha.zip
$ cd ./v1_3-alpha
$ idl # recommended, or idlde
IDL> snydov, i_dir, dem = dem_fn, region = shapefile, /{QAC | SCALE}, /TIFF, /NDVI, /PYRAMID, /CONSOLEPRINT
IDL> ; or simply typing:
IDL> snydov, i_dir, d = dem_fn, r = shapefile, /{q | s}, /t, /n, /p, /c
```
- ``i_dir``:                  directory where *.tar.gz files are
- ``dem(optional)``:          fn of DEM used to orthoretcify images
- ``region(optional)``:       fn of shapefile to subset images
- ``QAC(optional)``:          keyword to apply QUAC
- ``SCALE(optional)``:        keyword to multiply 0.0001 to QUAC result
- ``TIFF(optional)``:         keyword to convert default ENVI format to TIFF format
- ``NDVI(optional)``:         keyword to get an extra NDVI result
- ``PYRAMID(optional)``:      keyword to build ``.enp`` file for outcome
- ``CONSOLEPRINT(optional)``: keyword to print step in IDL console or terminal
# Notice
- IDL8.3/ENVI5.1 or later is required
- the json file must be in the dir where snyDov.sav is
- export to tiff format may encounter warning, it doesnot matter
- make sure you have the license for FLAASH if keyword QAC is set
- if you run this in terminal, use ``d=dem_fn`` instead of ``d = dem_fn``, since each params are divided from space
# TODO
- its difficult to find the shapefile is whether inside a certain RPC-based(not orthorectified in another way to say) raster, so its **time-cost** to orthorectify each tiff file and then determine its location between the shapefile
- v1.3-alpha only works in linux since the C library only compiled in linux, older version support windows

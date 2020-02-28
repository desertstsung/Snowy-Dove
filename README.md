# Snowy Dove
an IDL program aimed at auto-pre-processing imageries taken by GaoFen(GF)1, GF2 and GF6, in batch mode.
# Build
```shell
$ git clone https://github.com/desertstsung/Snowy-Dove.git
$ cd ./Snowy-Dove/src
$ idl ./make -arg yourdir/snydov.sav
$ cp ./*.json yourdir
```
# Usage
```
$ idl
IDL> cd, 'yourdir'
IDL> snyDov, i_dir, dem = string, region = sting, /QAC, /SCALE, /TIFF, /NDVI
```
- ``i_dir``:            string directory where *.tar.gz files are
- ``dem(optional)``:    string fn of DEM used to orthoretcify images
- ``region(optional)``: string fn of shapefile to subset images
- ``QAC(optional)``:    keyword to apply QUAC
- ``SCALE(optional)``:  keyword to divide 10k based on the outcome of QUAC
- ``TIFF(optional)``:   keyword to convert default ENVI format to TIFF format
- ``NDVI(optional)``:   keyword to get an extra NDVI result
# Notice
- IDL8.3/ENVI5.1 or later is required
- the json file must be in the dir where snyDov.sav is
- export to tiff format may encounter warning, it doesnot matter
- make sure you have the license for FLAASH if keyword QAC is set
# TODO
its difficult to find the shapefile is whether inside a certain RPC-based(not orthorectified in another way to say) raster, so its **time-cost** to orthorectify each tiff file and then determine its location between the shapefile

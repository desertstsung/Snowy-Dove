# Snowy Dove
an IDL program aimed at auto-pre-processing imageries taken by GaoFen(GF)1, GF2 and GF6, in batch mode.
# Build
```shell
$ git clone https://github.com/desertstsung/Snowy-Dove.git
$ cd ./Snowy-Dove/src
$ /usr/local/exelis/idl/bin/idl ./make -arg yourdir/snydov.sav
$ cp ./*.json yourdir
```
# Usage
```
$ idl
IDL> cd, 'dir where snydov.sav is'
IDL> snyDov, 'dir where *.tar.gz files are', dem = 'dem fn', region = 'shapefile fn', /QAC, /SCALE, /TIFF, /NDVI
```
# Notice
- IDL8.3/ENVI5.1 or later is required
- the json file must be in the dir where snyDov.sav is
- export to tiff format may encounter warning, it doesnot matter
- make sure you have the license for FLAASH if keyword QAC is set
# TODO
its difficult to find the shapefile is whether inside a certain RPC-based(not orthorectified in another way to say) raster, so its **time-cost** to orthorectify each tiff file and then determine its location between the shapefile

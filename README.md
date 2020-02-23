# Snowy Dove
an IDL program aimed at auto-pre-processing imageries taken by GaoFen(GF)1, GF2 and GF6, in batch mode.
# Testing it now

# Usage
```
$ idl
IDL> cd, 'dir where snyDov.sav is'
IDL> snyDov, 'dir where *.tar.gz files are', dem = 'dem fn', region = 'shapefile fn', /QAC, /SCALE, /TIFF, /NDVI
```
# Notice
- the json file must be in the dir where snyDov.sav is
- export to tiff format may encounter warning, it doesnot matter
- make sure you have the license for FLAASH if keyword quac is set
# TODO
its difficult to find the shapefile is whether inside a certain RPC-based(not orthorectified in another way to say) raster, so its **time-cost** to orthorectify each tiff file and then determine its location between the shapefile

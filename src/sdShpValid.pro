;+
; Function to return if the shapefile is in the raster
;   if true , then return the sub-rectangle range array
;   if false, then return the scalar byte 1
;
; :Arguments:
;   fileIn : input raster filename
;-
function sdShpValid, fileIn
  compile_opt idl2, hidden
  common sdblock, e, sdstruct, logfn, py, islinux, lun
  
  ;get raster rectangle
  raster = e.OpenRaster(fileIn)
  sr     = raster.SpatialRef
  ns     = raster.nSamples
  nl     = raster.nLines
  sr.ConvertFileToMap  , [0, ns-1], [0, nl-1], mapx, mapy
  sr.ConvertMapToLonLat, mapx, mapy, rasterlon, rasterlat
  rasterlonmin = MIN(rasterlon, MAX=rasterlonmax)
  rasterlatmin = MIN(rasterlat, MAX=rasterlatmax)
  
  ;get bounding box of shapefile
  OPENR    , lun, sdstruct.sshp
  POINT_LUN, lun, 36
  READU    , lun, (box = DBLARR(4))
  FREE_LUN , lun

  ;get reference of shapefile
  ;by reading the first character
  ;71 represents G, equals GEOG
  ;80 represents P, equals PROJ
  prjfn = FILEPATH(FILE_BASENAME(sdstruct.sshp, 'shp')+'prj', ROOT_DIR=FILE_DIRNAME(sdstruct.sshp))
  OPENR   , lun, prjfn
  READU   , lun, (b = 0B)
  FREE_LUN, lun
  
  if b eq 80 then begin
    ;if PROJ, then convert map to lon/lat
    shape = e.OpenVector(sdstruct.sshp)
    scs   = shape.Coord_Sys
    scs.ConvertMapToLonLat, [box[0], box[2]], [box[1], box[3]], lon, lat
    recordlonmin = lon[0]
    recordlonmax = lon[1]
    recordlatmin = lat[0]
    recordlatmax = lat[1]
    shape.Close
  endif else if b eq 71 then begin
    recordlonmin = box[0]
    recordlonmax = box[2]
    recordlatmin = box[1]
    recordlatmax = box[3]
  endif
  
  if sdLonLatRangeIntersect(lon1min = rasterlonmin, $
                            lon1max = rasterlonmax, $
                            lat1min = rasterlatmin, $
                            lat1max = rasterlatmax, $
                            lon2min = recordlonmin, $
                            lon2max = recordlonmax, $
                            lat2min = recordlatmin, $
                            lat2max = recordlatmax) $
  then begin
    ;if raster rectangle interact with the shapefile rectangle
    ;then return the sub-rectangle range array
    sr.ConvertLonLatToMap, [recordlonmin, recordlonmax], [recordlatmin, recordlatmax], mapx, mapy
    sr.ConvertMapToFile, mapx, mapy, filex, filey
    raster.Close
    x1 = FLOOR(MIN(filex)) > 0
    y1 = CEIL(MIN(filey))  > 0
    x2 = FLOOR(MAX(filex)) < (ns-1)
    y2 = CEIL(MAX(filey))  < (nl-1)
    RETURN, [x1, y1, x2, y2]
  ;else return the scalar byte 1
  endif else RETURN, 1B
end

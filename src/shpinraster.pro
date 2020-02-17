;todo: del print
pro shpInRaster, i_img, i_shp, count = count
  compile_opt idl2, hidden

  if i_shp eq '0' then begin
    count = 1
    RETURN
  endif

  raster = !e.OpenRaster(i_img)
  shp = !e.OpenVector(i_shp)

  oShp = IDLffShape(i_shp)
  entity = oShp.GetEntity(0, /ATTRIBUTES)
  verts = *(entity.VERTICES)

  shp_cs = shp.Coord_Sys
  shp_cs_str = shp_cs.Coord_Sys_Str
  raster_sr = raster.SpatialRef
  if STRCMP(shp_cs_str, 'GEOGCS', 6) then begin
    lon = verts[0, *]
    lat = verts[1, *]
  endif else if STRCMP(shp_cs_str, 'PROJCS', 6) then begin
    shp_cs.ConvertMapToLonLat, verts[0, *], $
      verts[1, *], lon, lat
  endif

  newROI = ENVIROI(NAME = 'shp2ROI')
  newROI.AddGeometry, [lon, lat], /POLYGON
  count = newROI.PixelCount(raster)

  newROI.Close
  OBJ_DESTROY, oShp
  raster.Close
  shp.Close
end
;+
; procedure to add/update metadata to a raster
;
; :Arguments:
;   iRaster: input ENVIRaster object
;   tag:     string name of metadata
;   val:     value of certain tag
;-
pro addMeta, iRaster, tag, val
  compile_opt idl2, hidden

  meta = iRaster.METADATA
  tags = meta.TAGS
  if TOTAL(tags eq STRUPCASE(tag)) eq 1 then $
    meta.UpdateItem, STRLOWCASE(tag), val $
  else meta.AddItem, STRLOWCASE(tag), val
  iRaster.WriteMetadata
end
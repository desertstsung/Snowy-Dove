;+
; procedure to add/update a tag in a raster's metadata
;
; :Arguments:
;   raster: ENVIRaster object to change metadata
;   tag:    tag name string
;   val:    value of the certain tag
;-
pro addMeta, raster, tag, val
  compile_opt idl2, hidden

  upper = STRUPCASE(tag)
  lower = STRLOWCASE(tag)

  if TOTAL(raster.Metadata.Tags eq upper) then $
    raster.Metadata.UpdateItem, lower, val $
  else raster.Metadata.AddItem, lower, val

  raster.WriteMetadata
end

;+
; Function to return boolean result of if two rectangle intersect
; 
; :Keywords:
;   lon1min: the minimum lon of the first  rectangle
;   lon1max: the maximum lon of the first  rectangle
;   lat1min: the minimum lat of the first  rectangle
;   lat1max: the maximum lat of the first  rectangle
;   lon1min: the minimum lon of the second rectangle
;   lon1max: the maximum lon of the second rectangle
;   lat1min: the minimum lat of the second rectangle
;   lat1max: the maximum lat of the second rectangle
;-
function sdLonLatRangeIntersect, lon1min = lon1minIn, $
                                 lon1max = lon1maxIn, $
                                 lat1min = lat1minIn, $
                                 lat1max = lat1maxIn, $
                                 lon2min = lon2minIn, $
                                 lon2max = lon2maxIn, $
                                 lat2min = lat2minIn, $
                                 lat2max = lat2maxIn
  compile_opt idl2, hidden
  
  lonlimit = ((lon2minIn gt lon1minIn) and (lon2minIn lt lon1maxIn)) $
                                        or                           $
             ((lon2maxIn gt lon1minIn) and (lon2maxIn lt lon1maxIn))
  
  latlimit = ((lat2minIn gt lat1minIn) and (lat2minIn lt lat1maxIn)) $
                                        or                           $
             ((lat2maxIn gt lat1minIn) and (lat2maxIn lt lat1maxIn))
  
  RETURN, (lonlimit and latlimit)
end
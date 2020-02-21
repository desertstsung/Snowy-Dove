;+
; function to read JSON format text file
; returns -1 when given key is not correct
;
; :Arguments:
;   i_fn: string of input JSON filename
;
; :Params:
;   key: string array of information to extract
;
; :Examples:
;    g = readJSON('snyDov_cal.json', key = ['GF1C', 'PMS', '2019', 'gain'])
;    w = readJSON('snyDov_wvl.json', key = ['GF6', 'PMS'])
;-
function readJSON, i_fn, key = key
  compile_opt idl2, hidden

  fullJSON = JSON_PARSE(i_fn,  /TOARRAY)

  case N_ELEMENTS(key) of
    2: r = (fullJSON[key[0]])[key[1]]
    4: begin

      t = (fullJSON[key[0]])[key[1]]
      if t.HasKey(key[2]) then $
        r = (((fullJSON[key[0]])[key[1]])[key[2]])[key[3]] $
      else RETURN, -1

    end
    else: RETURN, -1
  endcase

  RETURN, r
end
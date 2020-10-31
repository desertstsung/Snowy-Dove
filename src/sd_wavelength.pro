; +
;   Wavelength for each band in a sensor
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': wavelength = [483, 551, 657, 824]
              'WFV2': wavelength = [487, 556, 657, 821]
              'WFV3': wavelength = [485, 563, 665, 822]
              'WFV4': wavelength = [484, 556, 665, 829]
              'PMS1': wavelength = [495, 554, 665, 824]
              'PMS2': wavelength = [494, 554, 665, 823]
            endcase
          end
  'GF1B': wavelength = [494, 554, 665, 824]
  'GF1C': wavelength = [494, 554, 665, 824]
  'GF1D': wavelength = [494, 554, 665, 824]
  'GF2': begin
           case sensor of
             'PMS1': wavelength = [492, 555, 665, 822]
             'PMS2': wavelength = [492, 555, 665, 822]
           endcase
         end
  'GF6': begin
           case sensor of
             'WFV': wavelength = [478, 544, 660, 806, 621, 744, 442, 596]
             'PMS': wavelength = [496, 566, 646, 806]
           endcase
         end
endcase
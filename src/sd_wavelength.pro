; +
;   Centre wavelength for each band in a sensor, using integral method
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': wavelength = [483, 554, 657, 824]
              'WFV2': wavelength = [488, 558, 657, 821]
              'WFV3': wavelength = [486, 564, 665, 822]
              'WFV4': wavelength = [484, 559, 665, 828]
              'PMS1': wavelength = [495, 554, 665, 823]
              'PMS2': wavelength = [494, 554, 665, 823]
            endcase
          end
  'GF1B': wavelength = [495, 554, 665, 823]
  'GF1C': wavelength = [496, 560, 667, 830]
  'GF1D': wavelength = [494, 556, 661, 825]
  'GF2': begin
           case sensor of
             'PMS1': wavelength = [492, 555, 665, 821]
             'PMS2': wavelength = [492, 555, 665, 821]
           endcase
         end
  'GF6': begin
           case sensor of
             'WFV': wavelength = [488, 558, 659, 826, 701, 749, 432, 609]
             'PMS': wavelength = [491, 565, 659, 820]
           endcase
         end
endcase

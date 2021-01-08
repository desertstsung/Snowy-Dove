; +
;   Centre wavelength for each band in a sensor, using max response value method
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': wavelength = [485, 555, 675, 789]
              'WFV2': wavelength = [506, 557, 676, 774]
              'WFV3': wavelength = [484, 560, 665, 800]
              'WFV4': wavelength = [485, 560, 696, 797]
              'PMS1': wavelength = [502, 576, 680, 810]
              'PMS2': wavelength = [501, 579, 680, 810]
            endcase
          end
  'GF1B': wavelength = [502, 576, 680, 810]
  'GF1C': wavelength = [515, 585, 685, 850]
  'GF1D': wavelength = [510, 580, 680, 855]
  'GF2': begin
           case sensor of
             'PMS1': wavelength = [514, 546, 656, 822]
             'PMS2': wavelength = [514, 546, 656, 822]
           endcase
         end
  'GF6': begin
           case sensor of
             'WFV': wavelength = [478, 528, 660, 806, 710, 744, 442, 596]
             'PMS': wavelength = [496, 566, 646, 806]
           endcase
         end
endcase

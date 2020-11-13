; +
;   Radiance calibration coefficients for each sensor in 2020
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': begin
                        gain   = [0.19319, 0.16041, 0.12796, 0.13405]
                        offset = [0.00000, 0.00000, 0.00000, 0.00000]
                      end
              'WFV2': begin
                        gain   = [0.2057, 0.1648, 0.1260, 0.1187]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV3': begin
                        gain   = [0.2106, 0.1825, 0.1346, 0.1187]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV4': begin
                        gain   = [0.2522, 0.2029, 0.1528, 0.1031]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS1': begin; copy of 2019
                        gain   = [0.1381, 0.1490, 0.1328, 0.1311, 0.1217]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin; copy of 2019
                        gain   = [0.1381, 0.1490, 0.1328, 0.1311, 0.1217]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF1B': begin
            gain   = [0.0687, 0.0757, 0.0618, 0.0545, 0.0572]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF1C': begin
            gain   = [0.0709, 0.0758, 0.0657, 0.0543, 0.0564]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF1D': begin
            gain   = [0.0715, 0.0738, 0.0656, 0.0590, 0.0585]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF2':  begin
            case sensor of
              'PMS1': begin
                        gain   = [0.1817, 0.1378, 0.1778, 0.1700, 0.1858]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.2025, 0.1752, 0.1919, 0.1804, 0.1968]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF6':  begin
            case sensor of
              'WFV': begin
                       gain   = [0.0675, 0.0552, 0.0513, 0.0314, 0.0519, 0.0454, 0.0718, 0.0596]
                       offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                     end
              'PMS': begin
                       gain   = [0.0537, 0.0820, 0.0645, 0.0489, 0.0286]
                       offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                     end
            endcase
          end
endcase

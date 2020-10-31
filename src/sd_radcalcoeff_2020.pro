; +
;   Radiance calibration coefficients for each sensor in 2020 (copy of 2019)
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': begin
                        gain   = [0.2144, 0.1647, 0.1228, 0.1213]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV2': begin
                        gain   = [0.2368, 0.1745, 0.1254, 0.1163]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV3': begin
                        gain   = [0.2139, 0.1797, 0.1344, 0.1337]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV4': begin
                        gain   = [0.2442, 0.1945, 0.1547, 0.1037]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS1': begin
                        gain   = [0.1381, 0.1490, 0.1328, 0.1311, 0.1217]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1381, 0.1490, 0.1328, 0.1311, 0.1217]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF1B': begin
            gain   = [0.0399, 0.0292, 0.0362, 0.0400, 0.0354]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF1C': begin
            gain   = [0.0417, 0.0290, 0.0382, 0.0421, 0.0364]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF1D': begin
            gain   = [0.0431, 0.0284, 0.0373, 0.0435, 0.0371]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF2':  begin
            case sensor of
              'PMS1': begin
                        gain   = [0.1855, 0.1453, 0.1826, 0.1727, 0.1908]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1980, 0.1750, 0.1902, 0.1770, 0.1968]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF6':  begin
            case sensor of
              'WFV': begin
                       gain   = [0.0705, 0.0567, 0.0516, 0.0322, 0.0532, 0.0453, 0.0786, 0.0585]
                       offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                     end
              'PMS': begin
                       gain   = [0.0534, 0.0847, 0.0653, 0.0491, 0.0289]
                       offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                     end
            endcase
          end
endcase
; +
;   Radiance calibration coefficients for each sensor in 2018
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': begin
                        gain   = [0.1824, 0.1546, 0.1270, 0.1344]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV2': begin
                        gain   = [0.1851, 0.1538, 0.1231, 0.1314]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV3': begin
                        gain   = [0.1894, 0.1728, 0.1343, 0.1373]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV4': begin
                        gain   = [0.1866, 0.1599, 0.1307, 0.1251]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS1': begin
                        gain   = [0.1428, 0.1530, 0.1356, 0.1366, 0.1272]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1490, 0.1523, 0.1382, 0.1403, 0.1334]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF1B': begin
            gain   = [0.0399, 0.0333, 0.0414, 0.0474, 0.0435]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF1C': begin
            gain   = [0.0401, 0.0301, 0.0392, 0.0436, 0.0379]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF1D': begin
            gain   = [0.0421, 0.0296, 0.0388, 0.0444, 0.0390]
            offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
          end
  'GF2':  begin
            case sensor of
              'PMS1': begin
                        gain   = [0.1725, 0.1356, 0.1736, 0.1644, 0.1788]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.2136, 0.1859, 0.2072, 0.1934, 0.2180]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF6':  begin
            case sensor of
              'WFV': begin
                       gain   = [0.0667, 0.0517, 0.0485, 0.0298, 0.0530, 0.0450, 0.0814, 0.0559]
                       offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                     end
              'PMS': begin
                       gain   = [0.0505, 0.0825, 0.0663, 0.0513, 0.0298]
                       offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                     end
            endcase
          end
endcase

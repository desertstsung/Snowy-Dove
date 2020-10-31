; +
;   Radiance calibration coefficients for each sensor in 2016
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': begin
                        gain   = [0.1843, 0.1477, 0.1220, 0.1365]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV2': begin
                        gain   = [0.1929, 0.1540, 0.1349, 0.1359]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV3': begin
                        gain   = [0.1753, 0.1565, 0.1480, 0.1322]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV4': begin
                        gain   = [0.1973, 0.1714, 0.1500, 0.1572]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS1': begin
                        gain   = [0.1982, 0.2320, 0.1870, 0.1795, 0.1960]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1979, 0.2240, 0.1851, 0.1793, 0.1863]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF2':  begin
            case sensor of
              'PMS1': begin
                        gain   = [0.1501, 0.1322, 0.1550, 0.1477, 0.1613]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1863, 0.1762, 0.1856, 0.1754, 0.1980]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
endcase

; +
;   Radiance calibration coefficients for each sensor in 2015
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': begin
                        gain   = [0.1816, 0.1560, 0.1412, 0.1368]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV2': begin
                        gain   = [0.1684, 0.1527, 0.1373, 0.1263]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV3': begin
                        gain   = [0.1770, 0.1589, 0.1385, 0.1344]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV4': begin
                        gain   = [0.1886, 0.1645, 0.1467, 0.1378]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS1': begin
                        gain   = [0.1956, 0.2110, 0.1802, 0.1806, 0.1870]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.2018, 0.2242, 0.1887, 0.1882, 0.1963]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF2':  begin
            case sensor of
              'PMS1': begin
                        gain   = [0.1538, 0.1457, 0.1604, 0.1550, 0.1731]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1538, 0.1761, 0.1843, 0.1677, 0.1830]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
endcase

; +
;   Radiance calibration coefficients for each sensor in 2017
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': begin
                        gain   = [0.2165, 0.1685, 0.1354, 0.1507]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV2': begin
                        gain   = [0.2097, 0.1630, 0.1339, 0.1521]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV3': begin
                        gain   = [0.1870, 0.1619, 0.1295, 0.1383]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV4': begin
                        gain   = [0.1770, 0.1521, 0.1322, 0.1349]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS1': begin
                        gain   = [0.1228, 0.1424, 0.1177, 0.1194, 0.1135]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1365, 0.1460, 0.1248, 0.1274, 0.1255]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF2':  begin
            case sensor of
              'PMS1': begin
                        gain   = [0.1503, 0.1193, 0.1530, 0.1424, 0.1569]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.1679, 0.1434, 0.1595, 0.1511, 0.1685]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
endcase

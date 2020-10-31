; +
;   Radiance calibration coefficients for each sensor in 2014
;   Organized by satellite -> sensor
; -
case satellite of
  'GF1' : begin
            case sensor of
              'WFV1': begin
                        gain   = [0.2004, 0.1648, 0.1243, 0.1563]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV2': begin
                        gain   = [0.1733, 0.1383, 0.1122, 0.1391]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV3': begin
                        gain   = [0.1391, 0.1514, 0.1257, 0.1462]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'WFV4': begin
                        gain   = [0.1713, 0.1600, 0.1497, 0.1435]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS1': begin
                        gain   = [0.1963, 0.2247, 0.1892, 0.1889, 0.1939]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
              'PMS2': begin
                        gain   = [0.2147, 0.2419, 0.2047, 0.2009, 0.2058]
                        offset = [0.0000, 0.0000, 0.0000, 0.0000, 0.0000]
                      end
            endcase
          end
  'GF2':  begin
            case sensor of
              'PMS1': begin
                        gain   = [ 0.1630,  0.1585,  0.1883,  0.1740,  0.1897]  
                        offset = [-0.6077, -0.8765, -0.9742, -0.7652, -0.7233]
                      end
              'PMS2': begin
                        gain   = [0.1823,  0.1748,  0.1817,  0.1741,  0.1975]
                        offset = [0.1654, -0.5930, -0.2717, -0.2879, -0.2773]
                      end
            endcase
          end
endcase

; +
;   Radiance calibration coefficients for each sensor in 2013
;   Organized by sensor, since only GF1 valid in 2013
; -
case sensor of
  'WFV1': begin
            gain   = [5.8510, 7.1530, 8.3680, 7.4740]
            offset = [0.0039, 0.0047, 0.0047, 0.0274]
          end
  'WFV2': begin
            gain   = [6.0140, 6.8230, 9.4510, 8.9960]
            offset = [0.0125, 0.0193, 0.0429, 0.0011]
          end
  'WFV3': begin
            gain   = [5.8200, 6.2390, 7.0100, 7.7110]
            offset = [0.0071, 0.0334, 0.0226, 0.0117]
          end
  'WFV4': begin
            gain   = [5.3500, 6.2350, 6.9920, 7.4620]
            offset = [0.0369, 0.0235, 0.0217, 0.0050]
          end
  'PMS1': begin
            gain   = [  0.1886, 0.2082, 0.1672, 0.1748,  0.1883]
            offset = [-13.1270, 4.6186, 4.8768, 4.8924, -9.4771]
          end
  'PMS2': begin
            gain   = [ 0.1878, 0.2072, 0.1776,  0.1770,  0.1909]
            offset = [-7.9731, 7.5348, 3.9395, -1.7445, -7.2053]
          end
endcase

; +
;   Radiance calibration coefficients
;   Organized by year
; -
case year of
  '2021': begin
            @sd_radcalcoeff_2021
          end
  '2020': begin
            @sd_radcalcoeff_2020
          end
  '2019': begin
            @sd_radcalcoeff_2019
          end
  '2018': begin
            @sd_radcalcoeff_2018
          end
  '2017': begin
            @sd_radcalcoeff_2017
          end
  '2016': begin
            @sd_radcalcoeff_2016
          end
  '2015': begin
            @sd_radcalcoeff_2015
          end
  '2014': begin
            @sd_radcalcoeff_2014
          end
  '2013': begin
            @sd_radcalcoeff_2013
          end
  else  : begin
            @sd_radcalcoeff_2021
          end
endcase

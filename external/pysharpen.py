# ==================================================== #
# Snowy Dove external python source code               #
#   --Pan sharpening model                             #
# Last modified in 27/10/2020                          #
# ==================================================== #



import sys
from osgeo import gdal, osr
from gdalconst import *

def pysharpen(null, pan, ms, ofn):
    # get num of bands
    ds = gdal.Open(ms, GA_ReadOnly)
    nb = ds.RasterCount
    ds = None

    # add pan to vrt string
    vrt = """<VRTDataset subClass="VRTPansharpenedDataset">
  <PansharpeningOptions>
    <PanchroBand>
      <SourceFilename relativeToVRT="0">%s</SourceFilename>
      <SourceBand>1</SourceBand>
    </PanchroBand>\n""" % pan
    
    # add each msi to vrt string
    for i in range(nb):
        vrt += """    <SpectralBand dstBand="%s">
      <SourceFilename relativeToVRT="0">%s</SourceFilename>
      <SourceBand>%s</SourceBand>
    </SpectralBand>\n""" % (i+1, ms, i+1)
    
    # end of vrt string
    vrt += """  </PansharpeningOptions>
</VRTDataset>\n"""
    
    # open vrt and export
    vrtds = gdal.Open(vrt)
    ods = gdal.GetDriverByName('ENVI').CreateCopy(ofn, vrtds)
    vrtds = ods = None

    print(1)
    return 1

if __name__ == '__main__':
    sys.exit(pysharpen(*sys.argv))

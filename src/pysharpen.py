import sys
from osgeo import gdal, osr
from gdalconst import *

def pysharpen(null, mss, pan, ofn):
    ds = gdal.Open(mss, GA_ReadOnly)
    nb = ds.RasterCount
    ds = None
    vrt = """<VRTDataset subClass="VRTPansharpenedDataset">
  <PansharpeningOptions>
    <PanchroBand>
      <SourceFilename relativeToVRT="0">%s</SourceFilename>
      <SourceBand>1</SourceBand>
    </PanchroBand>\n""" % pan
    for i in range(nb):
        vrt += """    <SpectralBand dstBand="%s">
      <SourceFilename relativeToVRT="0">%s</SourceFilename>
      <SourceBand>%s</SourceBand>
    </SpectralBand>\n""" % (i+1, mss, i+1)
    vrt += """  </PansharpeningOptions>
</VRTDataset>\n"""
    vrtds = gdal.Open(vrt)
    ods = gdal.GetDriverByName('GTiff').CreateCopy(ofn, vrtds)
    vrtds = ods = None

    print(1)
    return 1

def main():
    return pysharpen(*sys.argv)

if __name__ == '__main__':
    sys.exit(pysharpen(*sys.argv))

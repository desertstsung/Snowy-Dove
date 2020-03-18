import sys, os

try:
    from osgeo import gdal, osr
except ImportError:
    print(-1)
    sys.exit(-1)
try:
    from gdalconst import *
except ImportError:
    print(-1)
    sys.exit(-1)

def pyortho(null, fn, demfn, ofn):
    basename = os.path.basename(fn)
    ds = gdal.Open(fn, GA_ReadOnly)
    isNorth = 1 if basename.split('_')[3][0] == 'N' else 0
    zone = str(int(float(basename.split('_')[2][1:])/6) + 31)
    zone = int('326' + zone) if isNorth else int('327' + zone)

    if basename.startswith('GF1_PMS'):
        if basename.find('PAN') != -1:
            res = 2
        elif basename.find('MSS') != -1:
            res = 8
    elif basename.startswith('GF2_PMS'):
        if basename.find('PAN') != -1:
            res = 1
        elif basename.find('MSS') != -1:
            res = 4
    elif basename.startswith(('GF1B_PMS', 'GF1C_PMS', 'GF1D_PMS', 'GF6_PMS')):
        if basename.find('PAN') != -1:
            res = 2
        elif basename.find('MUX') != -1:
            res = 8
    elif basename.startswith(('GF1_WFV', 'GF6_WFV')):
        res = 16

    dstSRS = osr.SpatialReference()
    dstSRS.ImportFromEPSG(zone)
    ods = gdal.Warp(ofn, ds, format = 'GTiff', xRes = res, yRes = res, dstSRS = dstSRS, rpc = True, transformerOptions = demfn)
    ds = ods = None

    print(1)
    return 1

def main():
    return pyortho(*sys.argv)

if __name__ == '__main__':
    sys.exit(pyortho(*sys.argv))

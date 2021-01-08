# ==================================================== #
# Snowy Dove external python source code               #
#   --warp model                                       #
# Last modified in 16/Dec/2020                         #
# ==================================================== #



import sys, os
try:
    from osgeo     import gdal, osr
    from gdalconst import *
except ImportError:
    print(-1)
    sys.exit(-1)

def GetRes(file):
    sat = ''
    xres = yres = -1
    while True:
        try:
            line = file.readline()
        except:
            return -1, -1
        sat = line[line.find('>')+1 : line.find('</')] if line.find('SatelliteID') != -1 and sat == '' else sat
        if sat in ('GF1B', 'GF1C', 'GF1D'):
            xres = float(line[line.find('>')+1 : line.find('</')]) if line.find('</ImageGSDLine>') != -1 else xres
            yres = float(line[line.find('>')+1 : line.find('</')]) if line.find('</ImageGSDSample>') != -1 else yres
        else:
            xres = yres = float(line[line.find('>')+1 : line.find('</')]) if line.find('</ImageGSD>') != -1 else xres
        if (xres != -1 and yres != -1) or line.find('</ProductMetaData>') != -1: return xres, yres

def pywarp(null, fn, demfn, ofn):
    # open image
    basename = os.path.basename(fn)
    ds = gdal.Open(fn, GA_ReadOnly)

    # get UTM zone
    isNorth = 1 if basename.split('_')[3][0] == 'N' else 0
    zone = str(int(float(basename.split('_')[2][1:])/6) + 31)
    zone = int('326' + zone) if isNorth else int('327' + zone)

    # get resolution of certain sensor
    try:
        with open(fn[0 : len(fn)-4] + 'xml') as file:
            xres, yres = GetRes(file)
        if xres == -1 or yres == -1:
            if basename.startswith('GF1_PMS'):
                if basename.find('PAN') != -1:
                    xres = yres = 2.0
                elif basename.find('MSS') != -1:
                    xres = yres = 8.0
            elif basename.startswith('GF2_PMS'):
                if basename.find('PAN') != -1:
                    xres = yres = 1.0
                elif basename.find('MSS') != -1:
                    xres = yres = 4.0
            elif basename.startswith(('GF1B_PMS', 'GF1C_PMS', 'GF1D_PMS', 'GF6_PMS')):
                if basename.find('PAN') != -1:
                    xres = yres = 2.0
                elif basename.find('MUX') != -1:
                    xres = yres = 8.0
            elif basename.startswith('GF1_WFV'):
                xres = yres = 16.0
    except OSError:
        xres = yres = 16.0

    # set zone
    dstSRS = osr.SpatialReference()
    dstSRS.ImportFromEPSG(zone)

    # perform RPC warp
    ods = gdal.Warp(ofn, ds, format = 'ENVI', xRes = xres, yRes = yres, dstSRS = dstSRS, rpc = True, transformerOptions = demfn)
    ds = ods = None

    print(1)
    return 1

if __name__ == '__main__':
    sys.exit(pywarp(*sys.argv))

/*
 *	Snowy Dove external C source code
 *    --File format convert model for windows platform
 *  Corresponding to ../binary/sd_nv2tiff.exe
 *  Last modified in 14/10/2020
 */



#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#pragma  pack (2)



//TIFF data type
typedef unsigned short     _short;    //2-byte, 16-bits
typedef unsigned int       _long ;    //4-byte, 32-bits
typedef unsigned long long _long8;    //8-byte, 64-bits



//structure definition of image file header
typedef struct {
    _short endian;
    _short version;
    _long  offsetOfIFD;
} IFH;
typedef struct {
    _short endian;
    _short version;
    _short sizeOfOffest;
    _short constant;
    _long8 offsetOfIFD;
} BigIFH;

//structure definition of each entry in image file directory
typedef struct {
    _short tagCode;
    _short dataType;
    _long  count;
    _long  data_or_offset;
} Entry;
typedef struct {
    _short tagCode;
    _short dataType;
    _long8 count;
    _long8 data_or_offset;
} BigEntry;

//structure definition of image file directory
typedef struct {
    _short countOfEntry;
    Entry  newSubFileType;
    Entry  imageWidth;
    Entry  imageLength;
    Entry  bitsPerSample;
    Entry  compression;
    Entry  photoInterp;
    Entry  stripOffsets;
    Entry  orientation;
    Entry  samplesPerPixel;
    Entry  rowsPerStrip;
    Entry  stripBytes;
    Entry  planarConfig;
    Entry  extraSamples;
    Entry  sampleFormat;
    Entry  modelPixelScale;
    Entry  modelTiepoint;
    Entry  geoKeyDirectory;
    _long  endOfIFD;
} IFD;
typedef struct {
    _long8   countOfEntry;
    BigEntry newSubFileType;
    BigEntry imageWidth;
    BigEntry imageLength;
    BigEntry bitsPerSample;
    BigEntry compression;
    BigEntry photoInterp;
    BigEntry stripOffsets;
    BigEntry orientation;
    BigEntry samplesPerPixel;
    BigEntry rowsPerStrip;
    BigEntry stripBytes;
    BigEntry planarConfig;
    BigEntry extraSamples;
    BigEntry sampleFormat;
    BigEntry modelPixelScale;
    BigEntry modelTiepoint;
    BigEntry geoKeyDirectory;
    _long8   endOfIFD;
} BigIFD;

//structure definition of geo-information
typedef struct {
    double pixelScale[3];
    double tiepoint[6];
    _short key[24];
} geoTag;



//data type length
#define SHORT_LEN   sizeof(_short)
#define LONG_LEN    sizeof(_long)
#define LONG8_LEN   sizeof(_long8)
#define FLOAT_LEN   sizeof(float)
#define DOUBLE_LEN  sizeof(double)
#define IFH_LEN     sizeof(IFH)
#define BIG_IFH_LEN sizeof(BigIFH)
#define IFD_LEN     sizeof(IFD)
#define BIG_IFD_LEN sizeof(BigIFD)



//some size
#define BUFF_SIZE       4e9
#define STRING_MAX_SIZE 512



//function to get useful geo-information
//from map-info attribute in ENVI header file
geoTag GetGeotagFromMapInfo(char str[]){
    geoTag geotag;
    char   *tmpstr;
    double tmpdbl;
    _short utmzone;

    tmpstr = strtok(str, ",");
    tmpstr = strtok(NULL, ",");
    tmpstr = strtok(NULL, ",");

    //tiepoint
	geotag.tiepoint[0] = 0;
	geotag.tiepoint[1] = 0;
	geotag.tiepoint[2] = 0;
    tmpstr = strtok(NULL, ",");
    sscanf(tmpstr, "%lf", &tmpdbl);
    geotag.tiepoint[3] = tmpdbl;
    tmpstr = strtok(NULL, ",");
    sscanf(tmpstr, "%lf", &tmpdbl);
    geotag.tiepoint[4] = tmpdbl;
	geotag.tiepoint[5] = 0;

    //pixel scale
    tmpstr = strtok(NULL, ",");
    sscanf(tmpstr, "%lf", &tmpdbl);
    geotag.pixelScale[0] = tmpdbl;
    tmpstr = strtok(NULL, ",");
    sscanf(tmpstr, "%lf", &tmpdbl);
    geotag.pixelScale[1] = tmpdbl;

    //UTM zone
    tmpstr = strtok(NULL, ",");
    sscanf(tmpstr, "%hu", &utmzone);
    tmpstr = strtok(NULL, ",");
    if (strstr(tmpstr, "N") != NULL || strstr(tmpstr, "n") != NULL) { utmzone += 32600; }
    else { utmzone += 32700; }

    //intialize geokey
    geotag.key[0]  = 1;
    geotag.key[1]  = 1;
    geotag.key[2]  = 2;
    geotag.key[3]  = 6;
    geotag.key[4]  = 1024;
    geotag.key[5]  = 0;
    geotag.key[6]  = 1;
    geotag.key[7]  = 1;
    geotag.key[8]  = 1025;
    geotag.key[9]  = 0;
    geotag.key[10] = 1;
    geotag.key[11] = 1;
    geotag.key[12] = 2054;
    geotag.key[13] = 0;
    geotag.key[14] = 1;
    geotag.key[15] = 9102;
    geotag.key[16] = 3072;
    geotag.key[17] = 0;
    geotag.key[18] = 1;
    geotag.key[19] = utmzone;
    geotag.key[20] = 3076;
    geotag.key[21] = 0;
    geotag.key[22] = 1;
    geotag.key[23] = 9001;

    return geotag;
}



//function to get ns, nl, nb and data type
//from certain attribute in ENVI header file
_long GetNumFromStr(char str[]){
    _long number;
    sscanf(str, "%*[^0123456789]%d", &number);
    return number;
}



//main program to export ENVI image to GeoTIFF
void main(int argc, char *argv[]){
    //ENVI image header filename
    char fn_hdr[STRING_MAX_SIZE]; fn_hdr[0] = '\0';
    strcat(fn_hdr, argv[1]);
    strcat(fn_hdr, ".hdr");
    
    //get info from ENVI header file
    FILE *pnvhf = fopen(fn_hdr, "r");
    char tmpstr[STRING_MAX_SIZE];
    _long ns, nl, nb, dt;
    char *inter[3];
    geoTag geotag;
    while (1) {
        fgets(tmpstr, STRING_MAX_SIZE, pnvhf);
        if (feof(pnvhf)) break;
        if (strstr(tmpstr, "samples") != NULL){
            ns = GetNumFromStr(tmpstr);
        } else if (strstr(tmpstr, "lines") != NULL){
            nl = GetNumFromStr(tmpstr);
        } else if (strstr(tmpstr, "bands") != NULL){
            nb = GetNumFromStr(tmpstr);
        } else if (strstr(tmpstr, "data type") != NULL){
            dt = GetNumFromStr(tmpstr);
        } else if (strstr(tmpstr, "interleave") != NULL){
            if (strstr(tmpstr, "bsq") != NULL) {inter[0] = "bsq";}
        } else if (strstr(tmpstr, "map info") != NULL){
            geotag = GetGeotagFromMapInfo(tmpstr);
        }
    }
    fclose(pnvhf);
    
    //filename of TIFF file
    char fn_TIFF[STRING_MAX_SIZE]; fn_TIFF[0] = '\0';
    strcat(fn_TIFF, argv[1]);
    strcat(fn_TIFF, "_TIFF.tiff");
    
    //open ENVI image file and write to TIFF file
    FILE *pTFf = fopen(fn_TIFF, "wb");
    FILE *pnvf = fopen(argv[1], "rb");

    //file size in Gb scale
    _long8 filesizeinbyte = (_long8) ns * nl * nb * (dt == 4 ? FLOAT_LEN : SHORT_LEN);
    _long8 filesizeingb   = (_long8) filesizeinbyte / 1024 / 1024 / 1024;

    //write TIFF file
    if (filesizeingb < 4) {
        
        //TIFF size less than 4G
        
        IFH *ifh;
        ifh              = (IFH *) malloc(IFH_LEN);
        ifh->endian      = 18761;    //little endian
        ifh->version     = 42;
        ifh->offsetOfIFD = 0;
        fwrite(ifh, IFH_LEN, 1, pTFf);

        IFD *ifd;
        ifd               = (IFD *) malloc(IFD_LEN);
        ifd->countOfEntry = 17;
        ifd->endOfIFD     = 0;

        Entry entrytmp;
        fpos_t pos;

        //NewSubfileType
        entrytmp.tagCode        = 254;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = 0;
        ifd->newSubFileType     = entrytmp;

        //ImageWidth
        entrytmp.tagCode        = 256;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = ns;
        ifd->imageWidth         = entrytmp;

        //ImageLength
        entrytmp.tagCode        = 257;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = nl;
        ifd->imageLength        = entrytmp;

        //BitsPerSample
        fgetpos(pTFf, &pos);
        _short *arrayBPS;
        arrayBPS = (_short *) malloc(SHORT_LEN * nb);
        for (_short i = 0; i < nb; i++) {
            arrayBPS[i] = (_short) (dt == 4 ? 32 : 16);
        }
        fwrite(arrayBPS, SHORT_LEN * nb, 1, pTFf);
        free(arrayBPS);
        entrytmp.tagCode        = 258;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = nb;
        entrytmp.data_or_offset = (_long) pos.__value;    //windows uses pos directly, linux uses pos.__value instead
        ifd->bitsPerSample      = entrytmp;

        //Compression
        entrytmp.tagCode        = 259;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = 1;
        ifd->compression        = entrytmp;

        //PhotometricInterpretation
        entrytmp.tagCode = 262;
        entrytmp.dataType = 3;    //short
        entrytmp.count = 1;
        entrytmp.data_or_offset = 2;
        ifd->photoInterp = entrytmp;

        //StripOffsets
        if (*inter == "bsq") {
            fpos_t pos1;
            _long *arraySO;
            arraySO = (_long *) malloc(LONG_LEN * nb);
            fgetpos(pTFf, &pos);
            entrytmp.tagCode        = 273;
            entrytmp.dataType       = 4;    //long
            entrytmp.count          = nb;
            entrytmp.data_or_offset = (_long) pos.__value;
            ifd->stripOffsets       = entrytmp;
            fwrite(arraySO, LONG_LEN * nb, 1, pTFf);
            fgetpos(pTFf, &pos1);
            fsetpos(pTFf, &pos);
            for (_short i = 0; i < nb; i++) {
                arraySO[i] = (_long) pos1.__value + (_long) i * ns * nl * (dt == 4 ? FLOAT_LEN : SHORT_LEN);
            }
            fwrite(arraySO, LONG_LEN * nb, 1, pTFf);
            free(arraySO);
            void *data;
            if (dt == 12 || dt == 2) {
                data = (void *) malloc(ns * nl * nb * SHORT_LEN);
                fread(data, SHORT_LEN, ns * nl * nb, pnvf);
                fwrite(data, SHORT_LEN, ns * nl * nb, pTFf);
                free(data);
            } else if (dt == 4) {
                data = (void *) malloc(ns * nl * nb * FLOAT_LEN);
                fread(data, FLOAT_LEN, ns * nl * nb, pnvf);
                fwrite(data, FLOAT_LEN, ns * nl * nb, pTFf);
                free(data);
            }
        } else {
            fgetpos(pTFf, &pos);
            entrytmp.tagCode        = 273;
            entrytmp.dataType       = 4;    //long
            entrytmp.count          = 1;
            entrytmp.data_or_offset = (_long) pos.__value;
            ifd->stripOffsets       = entrytmp;
            void *data;
            if (dt == 12 || dt == 2) {
                data = (void *) malloc(ns * nl * nb * SHORT_LEN);
                fread(data, SHORT_LEN, ns * nl * nb, pnvf);
                fwrite(data, SHORT_LEN, ns * nl * nb, pTFf);
                free(data);
            } else if (dt == 4) {
                data = (void *) malloc(ns * nl * nb * FLOAT_LEN);
                fread(data, FLOAT_LEN, ns * nl * nb, pnvf);
                fwrite(data, FLOAT_LEN, ns * nl * nb, pTFf);
                free(data);
            }
        }
        fclose(pnvf);

        //Orientation
        entrytmp.tagCode        = 274;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = 1;
        ifd->orientation        = entrytmp;

        //SamplesPerPixel
        entrytmp.tagCode        = 277;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = nb;
        ifd->samplesPerPixel    = entrytmp;

        //RowsPerStrip
        entrytmp.tagCode        = 278;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = nl;
        ifd->rowsPerStrip       = entrytmp;

        //StripByteCounts
        if (*inter == "bsq") {
            _long *arraySBC;
            arraySBC = (_long *) malloc(LONG_LEN * nb);
            fgetpos(pTFf, &pos);
            entrytmp.tagCode        = 279;
            entrytmp.dataType       = 4;    //long
            entrytmp.count          = nb;
            entrytmp.data_or_offset = (_long) pos.__value;
            ifd->stripBytes         = entrytmp;
            for (_short i = 0; i < nb; i++) {
                arraySBC[i] = (_long) ns * nl * (dt == 4 ? FLOAT_LEN : SHORT_LEN);
            }
            fwrite(arraySBC, LONG_LEN * nb, 1, pTFf);
            free(arraySBC);
        } else {
            entrytmp.tagCode        = 279;
            entrytmp.dataType       = 4;    //long
            entrytmp.count          = 1;
            entrytmp.data_or_offset = (_long) nb * ns * nl * (dt == 4 ? FLOAT_LEN : SHORT_LEN);
            ifd->stripBytes         = entrytmp;
        }

        //PlanarConfiguration
        entrytmp.tagCode        = 284;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = (*inter == "bsq" ? 2 : 1);
        ifd->planarConfig       = entrytmp;

        //ExtraSamples
        entrytmp.tagCode  = 338;
        entrytmp.dataType = 3;    //short
        if (nb > 3 && nb <= 5) {
            entrytmp.count = nb-3;
            entrytmp.data_or_offset = 0;
        } else {
            fgetpos(pTFf, &pos);
            _short *arrayES;
            arrayES = (_short *) malloc(SHORT_LEN * (nb-3));
            for (_short i = 0; i < nb-3; i++) { arrayES[i] = (_short) 0; }
            fwrite(arrayES, SHORT_LEN * (nb-3), 1, pTFf);
            free(arrayES);
            entrytmp.count          = nb-3;
            entrytmp.data_or_offset = (_long) pos.__value;
        }
        ifd->extraSamples = entrytmp;

        //SampleFormat
        entrytmp.tagCode  = 339;
        entrytmp.dataType = 3;    //short
        if (*inter == "bsq") {
            fgetpos(pTFf, &pos);
            _short *arraySF;
            arraySF = (_short *) malloc(SHORT_LEN * nb);
            if (dt == 2) {
                for (_short i = 0; i < nb; i++) {
                    arraySF[i] = (_short) 2;
                }
            } else if (dt == 4) {
                for (_short i = 0; i < nb; i++) {
                    arraySF[i] = (_short) 3;
                }
            } else if (dt == 12) {
                for (_short i = 0; i < nb; i++) {
                    arraySF[i] = (_short) 1;
                }
            }
            fwrite(arraySF, SHORT_LEN * nb, 1, pTFf);
            free(arraySF);
            entrytmp.count          = nb;
            entrytmp.data_or_offset = (_long) pos.__value;
            ifd->sampleFormat       = entrytmp;
        } else {
            entrytmp.count = 1;
            if (dt == 2) { entrytmp.data_or_offset = 2; }
            else if (dt == 4) { entrytmp.data_or_offset = 3; }
            else if (dt == 12) { entrytmp.data_or_offset = 1; }
            ifd->sampleFormat = entrytmp;
        }

        //ModelPixelScale
        fgetpos(pTFf, &pos);
        double *geoinfo1;
        geoinfo1 = (double *) malloc(DOUBLE_LEN * 3);
        for (_short i = 0; i < 3; i++) {
            geoinfo1[i] = geotag.pixelScale[i];
        }
        fwrite(geoinfo1, DOUBLE_LEN * 3, 1, pTFf);
        free(geoinfo1);
        entrytmp.tagCode        = 33550;
        entrytmp.dataType       = 12;    //double
        entrytmp.count          = 3;
        entrytmp.data_or_offset = (_long) pos.__value;
        ifd->modelPixelScale    = entrytmp;

        //ModelTiepoint
        fgetpos(pTFf, &pos);
        double *geoinfo2;
        geoinfo2 = (double *) malloc(DOUBLE_LEN * 6);
        for (_short i = 0; i < 6; i++) {
            geoinfo2[i] = geotag.tiepoint[i];
        }
        fwrite(geoinfo2, DOUBLE_LEN * 6, 1, pTFf);
        free(geoinfo2);
        entrytmp.tagCode        = 33922;
        entrytmp.dataType       = 12;    //double
        entrytmp.count          = 6;
        entrytmp.data_or_offset = (_long) pos.__value;
        ifd->modelTiepoint      = entrytmp;

        //GeoKeyDirectory
        fgetpos(pTFf, &pos);
        _short *geoinfo3;
        geoinfo3 = (_short *) malloc(SHORT_LEN * 24);
        for (_short i = 0; i < 24; i++) {
            geoinfo3[i] = geotag.key[i];
        }
        fwrite(geoinfo3, SHORT_LEN * 24, 1, pTFf);
        free(geoinfo3);
        entrytmp.tagCode        = 34735;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 24;
        entrytmp.data_or_offset = (_long) pos.__value;
        ifd->geoKeyDirectory    = entrytmp;

        fgetpos(pTFf, &pos);
        fwrite(ifd, IFD_LEN, 1, pTFf);
        fseek(pTFf, 0, SEEK_SET);
        ifh->offsetOfIFD = (_long) pos.__value;
        fwrite(ifh, IFH_LEN, 1, pTFf);

        free(ifh);
        free(ifd);
    } else {
        
        //TIFF size bigger than 4G
        
        BigIFH *ifh;
        ifh               = (BigIFH *) malloc(BIG_IFH_LEN);
        ifh->endian       = 18761;
        ifh->version      = 43;
        ifh->sizeOfOffest = 8;
        ifh->constant     = 0;
        ifh->offsetOfIFD  = 0;
        fwrite(ifh, BIG_IFH_LEN, 1, pTFf);

        BigIFD *ifd;
        ifd               = (BigIFD *) malloc(BIG_IFD_LEN);
        ifd->countOfEntry = 17;
        ifd->endOfIFD     = 0;

        BigEntry entrytmp;
        fpos_t pos;

        //NewSubfileType
        entrytmp.tagCode        = 254;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = 0;
        ifd->newSubFileType     = entrytmp;

        //ImageWidth
        entrytmp.tagCode        = 256;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = ns;
        ifd->imageWidth         = entrytmp;

        //ImageLength
        entrytmp.tagCode        = 257;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = nl;
        ifd->imageLength        = entrytmp;

        //BitsPerSample
        entrytmp.tagCode  = 258;
        entrytmp.dataType = 3;    //short
        entrytmp.count    = nb;
        if (nb > 4) {    //entry stores data's offset
            fgetpos(pTFf, &pos);
            _short *arrayBPS;
            arrayBPS = (_short *) malloc(SHORT_LEN * nb);
            for (_short i = 0; i < nb; i++) {
                arrayBPS[i] = (_short) (dt == 4 ? 32 : 16);
            }
            fwrite(arrayBPS, SHORT_LEN * nb, 1, pTFf);
            free(arrayBPS);
            entrytmp.data_or_offset = (_long8) pos.__value;    //windows uses pos directly, linux uses pos.__value instead
        } else {    //entry stores data
            //stands for (_short) [x, x, x, x], x = dt == 4 ? 32 : 16
            entrytmp.data_or_offset = (dt == 4 ? (_long8) 9007336695791648 : (_long8) 4503668347895824);
        }
        ifd->bitsPerSample = entrytmp;

        //Compression
        entrytmp.tagCode        = 259;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = 1;
        ifd->compression        = entrytmp;

        //PhotometricInterpretation
        entrytmp.tagCode        = 262;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = 2;
        ifd->photoInterp        = entrytmp;

        //StripOffsets
        if (*inter == "bsq") {
            fpos_t pos1;
            _long8 *arraySO;
            arraySO = (_long8 *) malloc(LONG8_LEN * nb);
            fgetpos(pTFf, &pos);
            entrytmp.tagCode        = 273;
            entrytmp.dataType       = 16;    //long8
            entrytmp.count          = nb;
            entrytmp.data_or_offset = (_long8) pos.__value;
            ifd->stripOffsets       = entrytmp;
            fwrite(arraySO, LONG8_LEN * nb, 1, pTFf);
            fgetpos(pTFf, &pos1);
            fsetpos(pTFf, &pos);
            for (_short i = 0; i < nb; i++) {
                arraySO[i] = (_long8) pos1.__value + (_long8) i * ns * nl * (dt == 4 ? FLOAT_LEN : SHORT_LEN);
            }
            fwrite(arraySO, LONG8_LEN * nb, 1, pTFf);
            free(arraySO);
            void *data;
            data = (void *) malloc(BUFF_SIZE);
            _long8 ntimes = (_long8) (dt == 4 ? FLOAT_LEN : SHORT_LEN) * ns * nl * nb / BUFF_SIZE;
            for (_long8 i = 0; i < ntimes+1; i++) {
                if (i < ntimes) {
                    fread(data, BUFF_SIZE, 1, pnvf);
                    fwrite(data, BUFF_SIZE, 1, pTFf);
                } else {
                    _long8 lastdance = (_long8) (dt == 4 ? FLOAT_LEN : SHORT_LEN) * ns * nl * nb - i * BUFF_SIZE;
                    data = (void *) realloc(data, lastdance);
                    fread(data, lastdance, 1, pnvf);
                    fwrite(data, lastdance, 1, pTFf);
                }
            }
            free(data);
        } else {
            fgetpos(pTFf, &pos);
            entrytmp.tagCode        = 273;
            entrytmp.dataType       = 16;    //long8
            entrytmp.count          = 1;
            entrytmp.data_or_offset = (_long8) pos.__value;
            ifd->stripOffsets       = entrytmp;
            void *data;
            data = (void *) malloc(BUFF_SIZE);
            _long8 ntimes = (_long8) (dt == 4 ? FLOAT_LEN : SHORT_LEN) * ns * nl * nb / BUFF_SIZE;
            for (_long8 i = 0; i < ntimes+1; i++) {
                if (i < ntimes) {
                    fread(data, BUFF_SIZE, 1, pnvf);
                    fwrite(data, BUFF_SIZE, 1, pTFf);
                } else {
                    _long8 lastdance = (_long8) (dt == 4 ? FLOAT_LEN : SHORT_LEN) * ns * nl * nb - i * BUFF_SIZE;
                    data = (void *) realloc(data, lastdance);
                    fread(data, lastdance, 1, pnvf);
                    fwrite(data, lastdance, 1, pTFf);
                }
            }
            free(data);
        }
        fclose(pnvf);

        //Orientation
        entrytmp.tagCode        = 274;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = 1;
        ifd->orientation        = entrytmp;

        //SamplesPerPixel
        entrytmp.tagCode        = 277;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = nb;
        ifd->samplesPerPixel    = entrytmp;

        //RowsPerStrip
        entrytmp.tagCode        = 278;
        entrytmp.dataType       = 4;    //long
        entrytmp.count          = 1;
        entrytmp.data_or_offset = nl;
        ifd->rowsPerStrip       = entrytmp;

        //StripByteCounts
        if (*inter == "bsq") {
            _long8 *arraySBC;
            arraySBC = (_long8 *) malloc(LONG8_LEN * nb);
            fgetpos(pTFf, &pos);
            entrytmp.tagCode = 279;
            entrytmp.dataType = 16;    //long8
            entrytmp.count = nb;
            entrytmp.data_or_offset = (_long8) pos.__value;
            ifd->stripBytes = entrytmp;
            for (_short i = 0; i < nb; i++) {
                arraySBC[i] = (_long8) ns * nl * (dt == 4 ? FLOAT_LEN : SHORT_LEN);
            }
            fwrite(arraySBC, LONG8_LEN * nb, 1, pTFf);
            free(arraySBC);
        } else {
            entrytmp.tagCode        = 279;
            entrytmp.dataType       = 16;    //long8
            entrytmp.count          = 1;
            entrytmp.data_or_offset = (_long8) nb * ns * nl * (dt == 4 ? FLOAT_LEN : SHORT_LEN);
            ifd->stripBytes         = entrytmp;
        }

        //PlanarConfiguration
        entrytmp.tagCode        = 284;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 1;
        entrytmp.data_or_offset = (*inter == "bsq" ? 2 : 1);
        ifd->planarConfig       = entrytmp;

        //ExtraSamples
        entrytmp.tagCode  = 338;
        entrytmp.dataType = 3;    //short
        if (nb > 3 && nb <= 5) {
            entrytmp.count          = nb-3;
            entrytmp.data_or_offset = 0;
        } else {
            fgetpos(pTFf, &pos);
            _short *arrayES;
            arrayES = (_short *) malloc(SHORT_LEN * (nb-3));
            for (_short i = 0; i < nb-3; i++) { arrayES[i] = (_short) 0; }
            fwrite(arrayES, SHORT_LEN * (nb-3), 1, pTFf);
            free(arrayES);
            entrytmp.count          = nb-3;
            entrytmp.data_or_offset = (_long8) pos.__value;
        }
        ifd->extraSamples = entrytmp;

        //SampleFormat
        entrytmp.tagCode  = 339;
        entrytmp.dataType = 3;    //short
        if (*inter == "bsq") {
            entrytmp.count = nb;
            if (nb > 4) {    //entry stores data's offset
                fgetpos(pTFf, &pos);
                _short *arraySF;
                arraySF = (_short *) malloc(SHORT_LEN * nb);
                if (dt == 2) {
                    for (_short i = 0; i < nb; i++) {
                        arraySF[i] = (_short) 2;
                    }
                } else if (dt == 4) {
                    for (_short i = 0; i < nb; i++) {
                        arraySF[i] = (_short) 3;
                    }
                } else if (dt == 12) {
                    for (_short i = 0; i < nb; i++) {
                        arraySF[i] = (_short) 1;
                    }
                }
                fwrite(arraySF, SHORT_LEN * nb, 1, pTFf);
                free(arraySF);
                entrytmp.data_or_offset = (_long8) pos.__value;
            } else {    //entry stores data
                if (dt == 2) {
                    entrytmp.data_or_offset = (_long8) 562958543486978;    //stands for (_short) [2, 2, 2, 2]
                } else if (dt == 4) {
                    entrytmp.data_or_offset = (_long8) 844437815230467;    //stands for (_short) [3, 3, 3, 3]
                } else if (dt == 12) {
                    entrytmp.data_or_offset = (_long8) 281479271743489;    //stands for (_short) [1, 1, 1, 1]
                }
            }
            ifd->sampleFormat = entrytmp;
        } else {
            entrytmp.count = 1;
            if (dt == 2) { entrytmp.data_or_offset = 2; }
            else if (dt == 4) { entrytmp.data_or_offset = 3; }
            else if (dt == 12) { entrytmp.data_or_offset = 1; }
            ifd->sampleFormat = entrytmp;
        }

        //ModelPixelScale
        fgetpos(pTFf, &pos);
        double *geoinfo1;
        geoinfo1 = (double *) malloc(DOUBLE_LEN * 3);
        for (_short i = 0; i < 3; i++) {
            geoinfo1[i] = geotag.pixelScale[i];
        }
        fwrite(geoinfo1, DOUBLE_LEN * 3, 1, pTFf);
        free(geoinfo1);
        entrytmp.tagCode        = 33550;
        entrytmp.dataType       = 12;    //double
        entrytmp.count          = 3;
        entrytmp.data_or_offset = (_long8) pos.__value;
        ifd->modelPixelScale    = entrytmp;

        //ModelTiepoint
        fgetpos(pTFf, &pos);
        double *geoinfo2;
        geoinfo2 = (double *) malloc(DOUBLE_LEN * 6);
        for (_short i = 0; i < 6; i++) {
            geoinfo2[i] = geotag.tiepoint[i];
        }
        fwrite(geoinfo2, DOUBLE_LEN * 6, 1, pTFf);
        free(geoinfo2);
        entrytmp.tagCode        = 33922;
        entrytmp.dataType       = 12;    //double
        entrytmp.count          = 6;
        entrytmp.data_or_offset = (_long8) pos.__value;
        ifd->modelTiepoint      = entrytmp;

        //GeoKeyDirectory
        fgetpos(pTFf, &pos);
        _short *geoinfo3;
        geoinfo3 = (_short *) malloc(SHORT_LEN * 24);
        for (_short i = 0; i < 24; i++) {
            geoinfo3[i] = geotag.key[i];
        }
        fwrite(geoinfo3, SHORT_LEN * 24, 1, pTFf);
        free(geoinfo3);
        entrytmp.tagCode        = 34735;
        entrytmp.dataType       = 3;    //short
        entrytmp.count          = 24;
        entrytmp.data_or_offset = (_long8) pos.__value;
        ifd->geoKeyDirectory    = entrytmp;

        fgetpos(pTFf, &pos);
        fwrite(ifd, BIG_IFD_LEN, 1, pTFf);
        fseek(pTFf, 0, SEEK_SET);
        ifh->offsetOfIFD = (_long8) pos.__value;
        fwrite(ifh, BIG_IFH_LEN, 1, pTFf);

        free(ifh);    free(ifd);
    }

    //close file
    fclose(pTFf);
}


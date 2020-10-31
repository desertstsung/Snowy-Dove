/*
 *	Snowy Dove external C source code
 *    --Radiance calibration model
 *  Corresponding to ../binary/sd_readcal  ../binary/sd_readcal.exe
 *  Last modified in 14/10/2020
 */



#include <stdio.h>
#include <stdlib.h>
#include <string.h>



typedef unsigned short     _short;    //2-byte, 16-bits
typedef unsigned int       _long ;    //4-byte, 32-bits
typedef unsigned long long _long8;    //8-byte, 64-bits



#define SHORT_LEN       sizeof(_short)
#define FLOAT_LEN       sizeof(float)
#define STRING_MAX_SIZE 512



//function to get ns, nl, nb and data type
//from certain attribute in ENVI header file
_long GetNumFromStr(char str[]){
    _long number;
    sscanf(str, "%*[^0123456789]%d", &number);
    return number;
}



//main procedure to perform radiance calibration
//or multi 0.0001 on the result of QUAC
void main(int argc, char *argv[]){
    char fn_hdr[STRING_MAX_SIZE]; fn_hdr[0] = '\0';
    strcat(fn_hdr, argv[1]);
    strcat(fn_hdr, ".hdr");
    char ofn_hdr[STRING_MAX_SIZE]; ofn_hdr[0] = '\0';
    strcat(ofn_hdr, argv[2]);
    strcat(ofn_hdr, ".hdr");

    //get info from ENVI header file
    FILE *pnvhf  = fopen(fn_hdr, "r");
    FILE *ponvhf = fopen(ofn_hdr, "w");
    char tmpstr[STRING_MAX_SIZE];
    _long ns, nl, nb, dt;
    char *inter[3];
    while (1) {
        fgets(tmpstr, STRING_MAX_SIZE, pnvhf);
        if (feof(pnvhf)) break;
        if (strstr(tmpstr, "data type") != NULL) {
            fputs("data type = 4\n", ponvhf);
        } else if (strstr(tmpstr, "reflectance scale factor") != NULL) {
        } else fputs(tmpstr, ponvhf);
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
        }
    }
    float gain[nb];
    for (_short i = 3; i < 3+nb; i++) {
        sscanf(argv[i], "%f", &gain[i-3]);
    }
    float offset[nb];
    for (_short i = 3+nb; i < 3+nb*2; i++) {
        sscanf(argv[i], "%f", &offset[i-3-nb]);
    }
    if (gain[0] != 0.0001) {
        fputs("data units = W m^-2 sr^-1 µm^-\n",      ponvhf);
        fputs("calibration scale factor = 1.000000\n", ponvhf);
    }
    fclose(pnvhf);    fclose(ponvhf);

    //calibation of bsq envi format
    FILE *pnvf = fopen(argv[1], "rb");
    FILE *pof  = fopen(argv[2], "wb");
    
    if (nb == 1) {
        if (dt == 2) {
            short *arr; arr = (short *) malloc((_long8) SHORT_LEN * ns);
            float *cal; cal = (float *) malloc((_long8) FLOAT_LEN * ns);
            for (_long8 i = 0; i < nl; i++) {
                fread(arr, (_long8) SHORT_LEN * ns, 1, pnvf);
                for (_long8 j = 0; j < (_long8) ns; j++) {
                    cal[j] = (float) arr[j] * gain[0] + offset[0];
                }
                fwrite(cal, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(arr);    free(cal);
        } else if (dt == 12) {
            _short *arr; arr = (_short *) malloc((_long8) SHORT_LEN * ns);
            float  *cal; cal = (float *)  malloc((_long8) FLOAT_LEN * ns);
            for (_long8 i = 0; i < nl; i++) {
                fread(arr, (_long8) SHORT_LEN * ns, 1, pnvf);
                for (_long8 j = 0; j < (_long8) ns; j++) {
                    cal[j] = (float) arr[j] * gain[0] + offset[0];
                }
                fwrite(cal, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(arr);    free(cal);
        }
    } else {
        if (dt == 2) {
            short *arr; arr = (short *) malloc((_long8) SHORT_LEN * ns * nl);
            float *cal; cal = (float *) malloc((_long8) FLOAT_LEN * ns * nl);
            for (short i = 0; i < nb; i++) {
                fread(arr, (_long8) SHORT_LEN * ns * nl, 1, pnvf);
                for (_long8 j = 0; j < (_long8) ns * nl; j++) {
                    cal[j] = (float) arr[j] * gain[i] + offset[i];
                }
                fwrite(cal, (_long8) FLOAT_LEN * ns * nl, 1, pof);
            }
            free(arr);    free(cal);
        } else if (dt == 12) {
            _short *arr; arr = (_short *) malloc((_long8) SHORT_LEN * ns * nl);
            float  *cal; cal = (float *)  malloc((_long8) FLOAT_LEN * ns * nl);
            for (short i = 0; i < nb; i++) {
                fread(arr, (_long8) SHORT_LEN * ns * nl, 1, pnvf);
                for (_long8 j = 0; j < (_long8) ns * nl; j++) {
                    cal[j] = (float) arr[j] * gain[i] + offset[i];
                }
                fwrite(cal, (_long8) FLOAT_LEN * ns * nl, 1, pof);
            }
            free(arr);    free(cal);
        }
    }
    
    fclose(pnvf);    fclose(pof);
}

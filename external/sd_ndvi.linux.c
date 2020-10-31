/*
 *	Snowy Dove external C source code
 *    --NDVI calculating model for linux-based platform
 *  Corresponding to ../binary/sd_ndvi
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



//main procedure to get an extra NDVI image
void main(int argc, char *argv[]){
    char fn_hdr[STRING_MAX_SIZE]; fn_hdr[0] = '\0';
    strcat(fn_hdr, argv[1]);
    strcat(fn_hdr, ".hdr");
    char ofn_hdr[STRING_MAX_SIZE]; ofn_hdr[0] = '\0';
    strcat(ofn_hdr, argv[2]);
    strcat(ofn_hdr, ".hdr");

    //get info from ENVI header file
    FILE *pnvhf  = fopen(fn_hdr,  "r");
    FILE *ponvhf = fopen(ofn_hdr, "w");
    char tmpstr[STRING_MAX_SIZE];
    _long ns, nl, nb, dt;
    char *inter[3];
    fputs("ENVI\n",                      ponvhf);
    fputs("file type = ENVI Standard\n", ponvhf);
    while (1) {
        fgets(tmpstr, STRING_MAX_SIZE, pnvhf);
        if (feof(pnvhf)) break;
        if (strstr(tmpstr, "samples") != NULL){
            ns = GetNumFromStr(tmpstr);
            fputs(tmpstr, ponvhf);
        } else if (strstr(tmpstr, "lines") != NULL){
            nl = GetNumFromStr(tmpstr);
            fputs(tmpstr, ponvhf);
        } else if (strstr(tmpstr, "bands") != NULL){
            nb = GetNumFromStr(tmpstr);
            fputs("bands = 1\n", ponvhf);
        } else if (strstr(tmpstr, "data type") != NULL){
            dt = GetNumFromStr(tmpstr);
            fputs("data type = 4\n", ponvhf);
        } else if (strstr(tmpstr, "interleave") != NULL){
            if (strstr(tmpstr, "bsq") != NULL) {inter[0] = "bsq";}
            fputs("interleave = bsq\n", ponvhf);
        } else if (strstr(tmpstr, "map info") != NULL){
            fputs(tmpstr, ponvhf);
        } else if (strstr(tmpstr, "coordinate system string") != NULL){
            fputs(tmpstr, ponvhf);
        }
    }
    fputs("band names = {NDVI}\n", ponvhf);
    fclose(pnvhf);    fclose(ponvhf);
    
    FILE *pnvf = fopen(argv[1], "rb");
    FILE *pof  = fopen(argv[2], "wb");
    
    if (*inter == "bsq") {
        fpos_t pos;
        if (dt == 2) {
            short *red; red = (short *) malloc((_long8) SHORT_LEN * ns);
            short *nir; nir = (short *) malloc((_long8) SHORT_LEN * ns);
            float  *nd; nd  = (float *) malloc((_long8) FLOAT_LEN * ns);
            for(_long i = 0; i < nl; i++) {
                pos.__pos = (_long8) ns * (i + 2 * nl) * SHORT_LEN;
                fsetpos(pnvf, &pos);
                fread(red, (_long8) SHORT_LEN * ns, 1, pnvf);
                pos.__pos = (_long8) ns * (i + 3 * nl) * SHORT_LEN;
                fsetpos(pnvf, &pos);
                fread(nir, (_long8) SHORT_LEN * ns, 1, pnvf);
                for (_long j = 0; j < ns; j++) {
                    nd[j] = ((float) nir[j] - red[j]) / ((float) nir[j] + red[j]);
                }
                fwrite(nd, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(red);    free(nir);    free(nd);
        } else if (dt == 12) {
            _short *red; red = (_short *) malloc((_long8) SHORT_LEN * ns);
            _short *nir; nir = (_short *) malloc((_long8) SHORT_LEN * ns);
            float   *nd; nd  = (float *)  malloc((_long8) FLOAT_LEN * ns);
            for(_long i = 0; i < nl; i++) {
                pos.__pos = (_long8) ns * (i + 2 * nl) * SHORT_LEN;
                fsetpos(pnvf, &pos);
                fread(red, (_long8) SHORT_LEN * ns, 1, pnvf);
                pos.__pos = (_long8) ns * (i + 3 * nl) * SHORT_LEN;
                fsetpos(pnvf, &pos);
                fread(nir, (_long8) SHORT_LEN * ns, 1, pnvf);
                for (_long j = 0; j < ns; j++) {
                    nd[j] = ((float) nir[j] - red[j]) / ((float) nir[j] + red[j]);
                }
                fwrite(nd, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(red);    free(nir);    free(nd);
        } else if (dt == 4) {
            float *red; red = (float *) malloc((_long8) FLOAT_LEN * ns);
            float *nir; nir = (float *) malloc((_long8) FLOAT_LEN * ns);
            float  *nd; nd  = (float *) malloc((_long8) FLOAT_LEN * ns);
            for(_long i = 0; i < nl; i++) {
                pos.__pos = (_long8) ns * (i + 2 * nl) * FLOAT_LEN;
                fsetpos(pnvf, &pos);
                fread(red, (_long8) FLOAT_LEN * ns, 1, pnvf);
                pos.__pos = (_long8) ns * (i + 3 * nl) * FLOAT_LEN;
                fsetpos(pnvf, &pos);
                fread(nir, (_long8) FLOAT_LEN * ns, 1, pnvf);
                for (_long j = 0; j < ns; j++) {
                    nd[j] = (nir[j] - red[j]) / (nir[j] + red[j]);
                }
                fwrite(nd, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(red);    free(nir);    free(nd);
        }
    } else {     /* bip */
        if (dt == 2) {
            short *line; line = (short *) malloc((_long8) SHORT_LEN * ns * nb);
            float   *nd; nd   = (float *) malloc((_long8) FLOAT_LEN * ns);
            for(_long i = 0; i < nl; i++) {
                fread(line, (_long8) SHORT_LEN * ns * nb, 1, pnvf);
                for (_long j = 0; j < ns; j++) {
                    nd[j] = (float) (line[nb*j+3] - line[nb*j+2]) / (line[nb*j+3] + line[nb*j+2]);
                }
                fwrite(nd, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(nd);    free(line);
        } else if (dt == 12) {
            _short *line; line = (_short *) malloc((_long8) SHORT_LEN * ns * nb);
            float    *nd; nd   = (float *)  malloc((_long8) FLOAT_LEN * ns);
            for(_long i = 0; i < nl; i++) {
                fread(line, (_long8) SHORT_LEN * ns * nb, 1, pnvf);
                for (_long j = 0; j < ns; j++) {
                    nd[j] = ((float) line[nb*j+3] - line[nb*j+2]) / ((float) line[nb*j+3] + line[nb*j+2]);
                }
                fwrite(nd, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(nd);    free(line);
        } else if (dt == 4) {
            float *line; line = (float *) malloc((_long8) FLOAT_LEN * ns * nb);
            float   *nd; nd   = (float *) malloc((_long8) FLOAT_LEN * ns);
            for(_long i = 0; i < nl; i++) {
                fread(line, (_long8) FLOAT_LEN * ns * nb, 1, pnvf);
                for (_long j = 0; j < ns; j++) {
                    nd[j] = (line[nb*j+3] - line[nb*j+2]) / (line[nb*j+3] + line[nb*j+2]);
                }
                fwrite(nd, (_long8) FLOAT_LEN * ns, 1, pof);
            }
            free(nd);    free(line);
        }
    }
    
    fclose(pnvf);    fclose(pof);
}


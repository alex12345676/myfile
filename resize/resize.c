// Copies a BMP file

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "bmp.h"

int strtoint(char*);

int main(int argc, char *argv[])
{
    // ensure proper usage
    if (argc != 4)
    {
        fprintf(stderr, "Usage: ./resize size infile outfile\n");
        return 1;
    }
    int n = strtoint(argv[1]);
    if( (n <= 0) && (n > 100))
    {
        fprintf(stderr, "Usage: ./resize size infile outfile\nsize integer > 0 < 100\n");
        return 2;
    }
    // remember filenames

    char *infile = argv[2];
    char *outfile = argv[3];

    // open input file
    FILE *inptr = fopen(infile, "r");
    if (inptr == NULL)
    {
        fprintf(stderr, "Could not open %s.\n", infile);
        return 2;
    }

    // open output file
    FILE *outptr = fopen(outfile, "w");
    if (outptr == NULL)
    {
        fclose(inptr);
        fprintf(stderr, "Could not create %s.\n", outfile);
        return 3;
    }

    // read infile's BITMAPFILEHEADER
    BITMAPFILEHEADER bf,bf2;
    fread(&bf, sizeof(BITMAPFILEHEADER), 1, inptr);

    // read infile's BITMAPINFOHEADER
    BITMAPINFOHEADER bi,bi2;
    fread(&bi, sizeof(BITMAPINFOHEADER), 1, inptr);

    // ensure infile is (likely) a 24-bit uncompressed BMP 4.0
    if (bf.bfType != 0x4d42 || bf.bfOffBits != 54 || bi.biSize != 40 ||
        bi.biBitCount != 24 || bi.biCompression != 0)
    {
        fclose(outptr);
        fclose(inptr);
        fprintf(stderr, "Unsupported file format.\n");
        return 4;
    }
    bi2.biWidth = bi.biWidth * n;
    bi2.biHeight =n * bi.biHeight;
    int padding2 = (4 - (bi2.biWidth * sizeof(RGBTRIPLE)) % 4) % 4;
    bi2.biSizeImage = (bi2.biWidth*sizeof(RGBTRIPLE) + padding2) * abs(bi2.biHeight);
    bf2.bfSize = 54 + bi2.biSizeImage;
    bf2.bfType = bf.bfType;
    bf2.bfReserved1 = bf.bfReserved1;
    bf2.bfReserved2 = bf.bfReserved2;
    bf2.bfOffBits = bf.bfOffBits;
    bi2.biSize = bi.biSize;
     bi2.biPlanes = bi.biPlanes;
    bi2.biBitCount = bi.biBitCount;
    bi2.biCompression = bi.biCompression;
    bi2.biXPelsPerMeter = bi.biXPelsPerMeter;
    bi2.biYPelsPerMeter = bi.biYPelsPerMeter;
    bi2.biClrUsed = bi.biClrUsed;
    bi2.biClrImportant = bi.biClrImportant;
    // write outfile's BITMAPFILEHEADER
    fwrite(&bf2, sizeof(BITMAPFILEHEADER), 1, outptr);

    // write outfile's BITMAPINFOHEADER
    fwrite(&bi2, sizeof(BITMAPINFOHEADER), 1, outptr);

    // determine padding for scanlines
    int padding = (4 - (bi.biWidth * sizeof(RGBTRIPLE)) % 4) % 4;

    // iterate over infile's scanlines
    for (int i = 0, biHeight = abs(bi2.biHeight), l = n; i < biHeight; i++)
    {
        // iterate over pixels in scanline
        for (int j = 0; j < bi.biWidth; j++)
        {
            // temporary storage
            RGBTRIPLE triple;

            // read RGB triple from infile
            fread(&triple, sizeof(RGBTRIPLE), 1, inptr);
            for( int k = 0; k < n; k++)
            {

            // write RGB triple to outfile
            fwrite(&triple, sizeof(RGBTRIPLE), 1, outptr);
            }
        }
        if( --l > 0 )
        {
            fseek(inptr, 0 - bi.biWidth*sizeof(RGBTRIPLE), SEEK_CUR );

            for (int k = 0; k < padding2; k++)
             {
                fputc(0x00, outptr);
            }
        }
        else
        {// skip over padding, if any
            fseek(inptr, padding, SEEK_CUR);
            l = n;

        // then add it back (to demonstrate how)
            for (int k = 0; k < padding2; k++)
            {
                fputc(0x00, outptr);
            }
        }
    }

    // close infile
    fclose(inptr);

    // close outfile
    fclose(outptr);

    // success
    return 0;
}

int strtoint(char *str)
{
    int rez = 0;
    for ( int i = 0, n = strlen( str ); i < n; i++ )
    {
        rez *=10;
        if( isdigit(str[i]))
        {
            //n *=10;
            rez += str[i] - '0';
        }
        else
        return 0;
    }
    return rez;
}
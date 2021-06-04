#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void flipdiagbmp1(void *bitmap, int width);

int main(int argc, const char *argv[])
{
    if (argc != 2)
    {
        printf("Bad amount of arguments\n");
        return 0;
    }
    FILE *file_pointer;
    file_pointer = fopen(argv[1], "rb");
    if (file_pointer == NULL)
    {
        printf("Invalid file name\n");
        return 0;
    }
    unsigned short header, bpp;
    fread(&header, 2, 1, file_pointer);
    if (header != 0x4D42) // doesn't start with 'BM\'
    {
        printf("Not a BMP file\n");
        return 0;
    }
    fseek(file_pointer, 28, SEEK_SET);
    fread(&bpp, 2, 1, file_pointer);
    if (bpp != 1)
    {
        printf("Bad file format - it is not bpp1\n");
        return 0;
    }
    int width, height;
    fseek(file_pointer, 18, SEEK_SET);
    fread(&width, 4, 1, file_pointer);
    fread(&height, 4, 1, file_pointer);
    if (width != height)
    {
        printf("Bad bitmap format - it is not a square\n");
        return 0;
    }
    unsigned int size, offset;
    fseek(file_pointer, 2, SEEK_SET);
    fread(&size, 4, 1, file_pointer);
    fseek(file_pointer, 10, SEEK_SET);
    fread(&offset, 4, 1, file_pointer);
    void *whole_file = malloc(size);
    void *bitmap = whole_file + offset;
    fseek(file_pointer, 0, SEEK_SET);
    fread(whole_file, 1, size, file_pointer);
    fclose(file_pointer);
    flipdiagbmp1(bitmap, width);
    printf("Image has been filpped\n");
    file_pointer = fopen(argv[1], "wb");
    if (file_pointer == NULL)
    {
        printf("Unable to open the file in write mode\n");
        free(whole_file);
        return 0;
    }
    fwrite(whole_file, 1, size, file_pointer);
    fclose(file_pointer);
    free(whole_file);
    return 0;
}
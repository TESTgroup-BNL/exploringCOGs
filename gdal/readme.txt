# simple example conversions of tiff to COGs

# create overviews
gdaladdo -r average [input.tif] 2 4 8 16

gdal_translate [input.tif] [output.tif] -of COG

gdal_translate [input.tif] [output.tif] -co COMPRESS=LZW -co TILED=YES

gdal_translate [input.tif] [output.tif] -co TILED=YES -co COMPRESS=DEFLATE

gdal_translate [input.tif] [output.tif] -co TILED=YES -co COPY_SRC_OVERVIEWS=YES -co COMPRESS=DEFLATE

# note: the DEFLATE option may not be compatible with some spatial libraries


gdal_translate [input.tif] [output.tif] -co COMPRESS=LZW -co TILED=YES -co COPY_SRC_OVERVIEWS=YES 



# if you want to be able to pull in one band at a time or have a lot of bands you can use

gdal_translate [input.tif] [output.tif] -co COMPRESS=LZW -co TILED=YES -co INTERLEAVE=BAND


# additional information
https://geoexamples.com/other/2019/02/08/cog-tutorial.html/

https://medium.com/@saxenasanket135/cog-overview-and-how-to-create-and-validate-a-cloud-optimised-geotiff-b39e671ff013


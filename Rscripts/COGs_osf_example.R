####################################################################################################
#   BNL UAS COGS example
#
#   https://medium.com/planet-stories/a-handy-introduction-to-cloud-optimized-geotiffs-1f2c9e716ec3
#   https://frodriguezsanchez.net/post/accessing-data-from-large-online-rasters-with-cloud-optimized-geotiff-gdal-and-terra-r-package/
#   https://www.maths.lancs.ac.uk/~rowlings/Teaching/UseR2012/cheatsheet.html
#
#   OSF dataset source: https://osf.io/x6uq4/
#
#
#  	--- Last updated:  05.21.2021 BY Shawn P. Serbin <sserbin@bnl.gov>
####################################################################################################


#--------------------------------------------------------------------------------------------------#
# Close all devices and delete all variables.
rm(list=ls(all=TRUE))   # clear workspace
graphics.off()          # close any open graphics
closeAllConnections()   # close any open connections to files
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
#### Load R libraries
list.of.packages <- c("rgdal","raster", "terra", "sp", "here","RColorBrewer")
# check for dependencies and install if needed
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, dependencies=c("Depends", "Imports",
                                                                       "LinkingTo"))
# Load libraries
invisible(lapply(list.of.packages, library, character.only = TRUE))
`%notin%` <- Negate(`%in%`)
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
### output location
output_dir <- file.path(here::here("R_Output"))
if (! file.exists(output_dir)) dir.create(output_dir,recursive=TRUE)
outdir <- file.path(path.expand(output_dir))
setwd(outdir) # set working directory
getwd()  # check wd
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# setup

# RGB
# by appending /vsicurl/ we create a virtual raster
rgb_cog.url <- "/vsicurl/https://osf.io/erv4m/download"
rgb_raster_name <- "NGEEArctic_UAS_Kougarok_20180725_Flight6_RGB_cog.tif"

# DEM
# by appending /vsicurl/ we create a virtual raster
dem_cog.url <- "/vsicurl/https://osf.io/6bmku/download"
dem_raster_name <- "NGEEArctic_UAS_Kougarok_20180725_Flight6_DEM_cog.tif"

# CHM
# by appending /vsicurl/ we create a virtual raster
chm_cog.url <- "/vsicurl/https://osf.io/2mepa/download"
chm_raster_name <- "NGEEArctic_UAS_Kougarok_20180725_Flight6_CHM_cog_deflate.tif"

# TIR
tir_cog.url <- "/vsicurl/https://osf.io/kpydz/download"
tir_raster_name <- "NGEEArctic_UAS_Kougarok_20180725_Flight6_TIR_cog.tif"

# grab some example locations
example_kg_points <- rgdal::readOGR(file.path(here(),"shapefiles"),
                             "kg_example_points")
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# view raster info / plot raster

# RGB
rgb_ras <- rast(rgb_cog.url)
RGB(rgb_ras) <- c(1,2,3)
rgb_ras

#png(file.path(outdir,gsub(".tif",".png",rgb_raster_name)), height=2500, 
#    width=3500, res=340)
pdf(file.path(outdir,gsub(".tif",".pdf",rgb_raster_name)), height=9, width=11)
#terra::plot(rgb_ras)
raster::plotRGB(rgb_ras, r=1, g=2, b=3, stretch="lin")
box(lwd=2.2)
dev.off()

# DEM
dem_ras <- rast(dem_cog.url)
names(dem_ras) <- "DEM_meters"
dem_ras

#png(file.path(outdir,gsub(".tif",".png",dem_raster_name)), height=2500,width=3300, res=340)
pdf(file.path(outdir,gsub(".tif",".pdf",dem_raster_name)), height=9, width=11)
terra::plot(dem_ras, legend=TRUE, axes=TRUE, smooth=FALSE,range=c(70,101),
            col=topo.colors(35), plg=list(x="topright",cex=1,title="DEM (m)"),
            pax=list(sides=c(1,2), cex.axis=1.2),
            mar=c(2,2,3,4)) # b, l, t, r
box(lwd=2.2)
dev.off()

# CHM
chm_ras <- rast(chm_cog.url)
names(chm_ras) <- "CHM_meters"
chm_ras

#png(file.path(outdir,gsub(".tif",".png",chm_raster_name)), height=2500,width=3500, res=340)
pdf(file.path(outdir,gsub(".tif",".pdf",chm_raster_name)), height=9, width=11)
terra::plot(chm_ras, legend=TRUE, axes=TRUE, smooth=FALSE,range=c(0,315),
            col=topo.colors(35), plg=list(x="topright",cex=1,title="CHM (m) x 100"),
            pax=list(sides=c(1,2), cex.axis=1.2),
            mar=c(2,2,3,5.5)) # b, l, t, r
box(lwd=2.2)
dev.off()

# TIR
tir_ras <- rast(tir_cog.url)
names(tir_ras) <- "Tsurf_degCx10"
tir_ras

#png(file.path(outdir,gsub(".tif",".png",tir_raster_name)), height=2500,width=3500, res=340)
pdf(file.path(outdir,gsub(".tif",".pdf",tir_raster_name)), height=9, width=11)
terra::plot(tir_ras, legend=TRUE, axes=TRUE, smooth=TRUE,range=c(170,300),
            col=rev(brewer.pal(11,"RdYlBu")), 
            plg=list(x="topright",cex=1,title="Tsurf (deg C) x 10"),
            pax=list(sides=c(1,2), cex.axis=1.2),
            mar=c(2,2,3,5.5)) # b, l, t, r
box(lwd=2.2)
dev.off()
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# extract data
#png(file.path(outdir,paste0(gsub(".tif","",rgb_raster_name),"_points.png")),
#    height=2500, width=3500, res=340)
pdf(file.path(outdir,paste0(gsub(".tif","",rgb_raster_name),"_points.pdf")), height=9, width=11)
raster::plotRGB(rgb_ras, r=1, g=2, b=3, stretch="lin")
box(lwd=2.2)
points(example_kg_points, pch=20, col="blue", cex=2)
dev.off()


# extract data
dem.data <- terra::extract(dem_ras, terra::vect(example_kg_points))

chm.data <- terra::extract(chm_ras, terra::vect(example_kg_points))
chm.data[,2] <- chm.data[,2]*0.01

tir.data <- terra::extract(tir_ras, terra::vect(example_kg_points))
tir.data[,2] <- tir.data[,2]*0.1
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# plot point data
hist(dem.data[,2],freq=T, xlab="DEM (meters)",main="")

hist(chm.data[,2],freq=T, xlab="CHM (meters)",main="")

hist(tir.data[,2],freq=T, xlab="Tsurf (degC)",main="")

#png(file.path(outdir,"CHM_vs_TIR.png"), height=2500, width=3000, res=340)
pdf(file.path(outdir,"CHM_vs_TIR.pdf"), height=9, width=11)
par(mar=c(5,5,1,1)) #b, l, t, r
plot(chm.data[,2],tir.data[,2], ylab="Tsurf (deg C)", xlab="CHM (meters)",
     cex.axis=1.4,cex.lab=1.8, pch=21, bg="grey50", cex=2)
box(lwd=2.2)
dev.off()
#--------------------------------------------------------------------------------------------------#


#--------------------------------------------------------------------------------------------------#
# EOF
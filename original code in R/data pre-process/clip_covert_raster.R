library(raster)
library(rgdal)
library(maptools)
library(dismo)
library(rgeos)

# This file is used for extracting maps to the study area
# And convert 'TIFF' files into 'SHL' raster format

setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_srad")

# set paths for datasets in different directory
path_1 <- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_prec/'
path_2 <- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_srad/'
path_3 <- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_tavg/'
path_4 <- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_vapr/'
path_5 <- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_wind/'

# Clip GeoTiff files
# read Pantanal border
crop_extent <- readOGR("/Users/zihuige/ACSE/ACSE-9/Project/Borders/border.shp")
# location to store coverted files
path <- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/SHL'


###################### process precipitation data
# read file names in the directory
list <- list.files()
data <- data.frame()

for(i in list){
  data <- raster(paste0(path_1, i))
  data_crop <- crop(data, crop_extent)
  data_crop <- mask(data_crop, crop_extent)
  data_crop <-  rasterToPolygons(data_crop)
  name <- paste0("SHL_",i)
  writeOGR(data_crop, dsn=path, layer=name, driver="ESRI Shapefile", overwrite_layer=F)
}

###################### process solar radiation data
setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_srad")

list <- list.files()
data <- data.frame()

for(i in list){
  data <- raster(paste0(path_2, i))
  data_crop <- crop(data, crop_extent)
  data_crop <- mask(data_crop, crop_extent)
  data_crop <-  rasterToPolygons(data_crop)
  name <- paste0("SHL_",i)
  writeOGR(data_crop, dsn=path, layer=name, driver="ESRI Shapefile", overwrite_layer=F)
}
######################


###################### process temperature data
setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_tavg")

list <- list.files()
data <- data.frame()

for(i in list){
  data <- raster(paste0(path_3, i))
  data_crop <- crop(data, crop_extent)
  data_crop <- mask(data_crop, crop_extent)
  data_crop <-  rasterToPolygons(data_crop)
  name <- paste0("SHL_",i)
  writeOGR(data_crop, dsn=path, layer=name, driver="ESRI Shapefile", overwrite_layer=F)
}
######################


###################### process vapour pressure data
setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_vapr")

list <- list.files()
data <- data.frame()

for(i in list){
  data <- raster(paste0(path_4, i))
  data_crop <- crop(data, crop_extent)
  data_crop <- mask(data_crop, crop_extent)
  data_crop <-  rasterToPolygons(data_crop)
  name <- paste0("SHL_",i)
  writeOGR(data_crop, dsn=path, layer=name, driver="ESRI Shapefile", overwrite_layer=F)
}
######################


###################### process wind data
setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/wc2.1_30s_wind")

list <- list.files()
data <- data.frame()

for(i in list){
  data <- raster(paste0(path_5, i))
  data_crop <- crop(data, crop_extent)
  data_crop <- mask(data_crop, crop_extent)
  data_crop <-  rasterToPolygons(data_crop)
  name <- paste0("SHL_",i)
  writeOGR(data_crop, dsn=path, layer=name, driver="ESRI Shapefile", overwrite_layer=F)
}

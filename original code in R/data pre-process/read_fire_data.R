library(dplyr)
library(tidyverse)

# This file is used to obtain information and pre-process data
# The training set file will be made at the end of this code
# We need to obtain data from 'SHL' files and combine row elements if they are
# from the same id number

################################
setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/CSV")
# Path to find files
path0 <- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/CSV/'
# Path to save processed data
path1<- '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/ComCSV/'

# Calculate average precipitation value and drop off for duplicate grid cells
list <- list.files()

# Preprocess CSV file converted from SHL
# Delete unnecessary rows and drop off duplicate rows by 'id' order
preprocess_datasets <- function(path0){
  df <- data.frame()
  
  for(i in list){
    df <- read.csv(paste0(path0, i))
    df <- subset(df, select = -c(geometry))
    df <- df %>%
      group_by(id) %>%
      summarise_all(mean)
    df <- df[ , c("id", "w2_1_30")]
    df <- df[order(df$id), ]
    write.csv(df, paste(path0, i, sep = "" ), row.names = FALSE)
  }
}


###############
# This is the function to access variable information from different CSV files into
# one CSV file for each variable
###############

# Need to comment current code corresponding to different file of variables
preprocess_datasets(path0)

# process
process_datasets <- function(file_name){
  data <- data.frame()
  
  # calculate average values in dry season
  
  # Precipitation
  data1 <- data_frame(read.csv(paste0(path0, list[1])))
  data2 <- data_frame(read.csv(paste0(path0, list[2])))
  data3 <- data_frame(read.csv(paste0(path0, list[3])))
  data4 <- data_frame(read.csv(paste0(path0, list[4])))
  data5 <- data_frame(read.csv(paste0(path0, list[5])))
  data6 <- data_frame(read.csv(paste0(path0, list[6])))
  #
  # Solar Radiation
  # data1 <- data_frame(read.csv(paste0(path0, list[7])))
  # data2 <- data_frame(read.csv(paste0(path0, list[8])))
  # data3 <- data_frame(read.csv(paste0(path0, list[9])))
  # data4 <- data_frame(read.csv(paste0(path0, list[10])))
  # data5 <- data_frame(read.csv(paste0(path0, list[11])))
  # data6 <- data_frame(read.csv(paste0(path0, list[12])))

  # Average Temperature
  # data1 <- data_frame(read.csv(paste0(path0, list[13])))
  # data2 <- data_frame(read.csv(paste0(path0, list[14])))
  # data3 <- data_frame(read.csv(paste0(path0, list[15])))
  # data4 <- data_frame(read.csv(paste0(path0, list[16])))
  # data5 <- data_frame(read.csv(paste0(path0, list[17])))
  # data6 <- data_frame(read.csv(paste0(path0, list[18])))

  # Water vapour pressure
  # data1 <- data_frame(read.csv(paste0(path0, list[19])))
  # data2 <- data_frame(read.csv(paste0(path0, list[20])))
  # data3 <- data_frame(read.csv(paste0(path0, list[21])))
  # data4 <- data_frame(read.csv(paste0(path0, list[22])))
  # data5 <- data_frame(read.csv(paste0(path0, list[23])))
  # data6 <- data_frame(read.csv(paste0(path0, list[24])))

  # Wind
  # data1 <- data_frame(read.csv(paste0(path0, list[25])))
  # data2 <- data_frame(read.csv(paste0(path0, list[26])))
  # data3 <- data_frame(read.csv(paste0(path0, list[27])))
  # data4 <- data_frame(read.csv(paste0(path0, list[28])))
  # data5 <- data_frame(read.csv(paste0(path0, list[29])))
  # data6 <- data_frame(read.csv(paste0(path0, list[30])))

  data <- list(data1,data2,data3,data4,data5,data6) %>% reduce(inner_join, by ="id")
  data <- data.frame(id=data[,1], Means=rowMeans(data[,-1]))
  write.csv(data, paste(path1, file = file_name), row.names = FALSE)
  return (data)
}

# Calculate average values of data frames from April to September
prec_data <- process_datasets('prec_data.csv')
# srad_data <- process_datasets('srad_data.csv')
# tavg_data <- process_datasets('tavg_data.csv')
# vapr_data <- process_datasets('vapr_data.csv')
# wind_data <- process_datasets('wind_data.csv')

## This is the funtion to merge variable CSV files into same CSV file with their id numbers
# Finally merge a variety of bioclimatc datasets into a same csv file before we train the model
merge_datasets <- function(path1){
  data <- data.frame()
  
  ## process fire information
  # Drop data column and calculate average values by duplicate grid cells
  df_fire <- read.csv('/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/PAN_FIRE_M-C61.csv')
  # df_fire <- subset(df_fire, select = -c(BRIGHTNESS,BRIGHT_T31,ACQ_DATE) )
  df_fire <- df_fire %>%
    group_by(id) %>%
    summarise_all(mean)
  df_fire <- df_fire[ , c("id", "FRP")]
  df_fire <- df_fire[order(df_fire$id), ]
  name_list <- list('id','prec','srad','tavg','vapr','wind','FRP')
  data <- list(prec_data,srad_data,tavg_data,vapr_data,wind_data,df_fire) %>% reduce(inner_join, by ="id")
  write.csv(data, paste(path1, file = 'training.csv'), row.names=name_list )
  # write.csv(df_fire, paste('/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/', file = 'PAN_FIRE_M-C61.csv'), row.names = FALSE)
}

merge_datasets(path1)

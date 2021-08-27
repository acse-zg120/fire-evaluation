ACSE 9 Independent Research Project - Zihui Ge
==========

Description 
--------
This repository contains scripts in R language to process geo-files, analyse trends between fire dynamics and climate variables, and implement automatic learning algorithms. Local regression, second-order regression, and Mann-Kendall Trend test are applied to analyse the trend of fire occurrences and precipitation in the Pantanal biome in South America. Two multi-class classification methods, decision tree and random forest algorithms in machine learning is applied to predict and classify fires into five categories: category 1 (<100MW), category 2 (100-500MW), category 3 (500-1000MW), category 4 (1000-1500MW) and category 5 (≥1500MW). Fire information in Pantanal is collected using Moderate Resolution Imaging Spectroradiometer (MODIS) MCD14ML from 2000 to 2018. 


<img alt="Study Area" src="results/Study Area.png" width="50%">



Dependencies
------------
The majority of code files were written in R. Only one python file is used to convert files from SHL to CSV.  
There are two versions for stastical analyses and automatic learnings. Users can eeasily download `.ipynb` files from `acse2020-acse9-finalreport-acse-zg120/code in ipynb/` repository, and download corresponding datasets from `acse2020-acse9-finalreport-acse-zg120/dataset/`

R version:  
In Colab: version 4.1.1 (2021-08-10)  
In RStudio: Version 1.4.1717

Packages
------------
Package       |Version
--------------|---------------
corrplot      |0.90
dismo         |1.3-3
dplyr         |1.0.7 
ggplot2       |3.3.5
Kendall       |2.2 
maptools      |1.1-1 
pROC          |1.17.0.1  
randomForest  |4.6-14
raster        |3.4-13 
rattle        |5.4.0 
rgdal         |1.5-23
rgoes         |0.5-5 
ROCR          |1.0-11
rpart         |4.1-15  
rpart.plot    |3.1.0 
zoo           |1.8-9 



Description of files
--------------------

Data Preprocessing:

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------
`clip_convert_raster.R`           |Clip original TIFF files with Pantanal boder and convert to raster files (SHL format).
`process_csv.py`                  |Convert raster files to CSV files.
`read_fire_data.R`                |Obtain information from raster files, combine climate data during dry season (April-Sep) in to individual CSV files for each variable, read fire information, and merge all CSV files into one CSV file for training purpose.

Mann-Kendll Trend Test file: 

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------ 
`MK_TEST.R`                       |Aplly Mann-Kendall Trend Test to fire occurences and precipitation, build local and second order regression models, and plot AUC curves for every category (ROC).


Classification file:

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------
`Classification_ML.R`             |Apply decision tree and random forest algorithms to train data set, validate models using test set, and calculate accuracy for five fire categories.                      


Results:

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------
Study Area.png                    |Geolocation of the study area (Pantanal in South America)
MK test.png                       |MK test results for fire occurrences and precipitatio information.
Regression Plot.png               |Graphs for local regression and second order regression between fire occurrences and precipitation information.
Correlation plot.png              |Correlated relationship for input variables 
Variance Inflation Factor.png     |Variance Inflation Factor for climate variables
Mean Decrease Accuracy.png        |Mean Decrease Accuracy result to analyse the importance of variables
validation proces.png             |Result for validation process
Confusion matrix.png              |Confusion matrics for validation results
ROC.png                           |AUC curve (ROC) plot for each fire category


## Contact
Ge, Zeena - zihui.ge20@imperial.ac.uk
## Reference
ReadMe template from: https://github.com/sidneycadot/oeis.git

ACSE 9 Independent Research Project 
==========

Description 
--------
This repository contains scripts in R language to process geo-files, analyse trends between fire dynamics and climate variables, and implement automatic learning algorithms. Local regression, second-order regression, and Mann-Kendall Trend test are applied to analyse the trend of fire occurrences and precipitation in the Pantanal biome in South America. Two multi-class classification methods, decision tree and random forest algorithms in machine learning is applied to predict and classify fires into five categories: category 1 (<100MW), category 2 (100-500MW), category 3 (500-1000MW), category 4 (1000-1500MW) and category 5 (≥1500MW). Fire information in Pantanal was collected using Moderate Resolution Imaging Spectroradiometer (MODIS) MCD14ML from 2000 to 2018. 

Dependencies
------------
The majority of code files were written in R expect `process_csv.py` file. 

Description of files
--------------------

Data Preprocessing:

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------
`clip_convert_raster.R`           |Clip original TIFF files with Pantanal boder and convert into raster files (SHL format).
`process_csv.py`                  |Convert raster files into CSV files.
`read_fire_data.R`                |Obtain information from raster files, combine climate data during dry season (April-Sep) in to individual CSV files for each variable, read fire information, and merge all CSV into one CSV for training purpose.

Mann-Kendll Trend Test file: 

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------ 
`MK_TEST.R`                       |Aplly Mann-Kendall Trend Test to fire occurences and precipitation, build local and second order regression models, and plot AUC curve (ROC).


Classification file:

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------
`Classification ML.R`             |Apply decision tree and random forest algorithms to train data set, and calculate accuracy for five fire categories.                      


Results:

filename                          |  description
----------------------------------|------------------------------------------------------------------------------------
PantanalMap.pdf                   |Map of the study area (Pantanal in South America)
MK test.png                       |MK test results for fire occurrences and precipitatio information.
Regression Plot.png               |Graphs for local regression and second order regression between fire occurrences and precipitatio information.
Correlation plot.png              |Correlated relationship for input variables 
Variance Inflation Factor.png     |Variance Inflation Factor for climate variables
Mean Decrease Accuracy.png        |Mean Decrease Accuracy result for analyse the importance of variables
validation proces.png             |Result for validation process
Confusion matrix.png              |Confusion matrics for validation results
ROC.png                           |AUC curve (ROC) plot for each fire category

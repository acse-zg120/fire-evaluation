import pandas as pd
import numpy as np
import os
import csv
import geopandas as gpd

# process precipition for MK test purpose
def write_into_file():
    filename = open('/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/prec.csv', 'r')
    file = csv.DictReader(filename)
    years = []
    prec = []

    for col in file:
        years.append(col['year'])
        prec.append(col['prec'])
    
    for i in range(len(years)):
        num_a = years[i]
        num_a = num_a [33:-4]
        num_a = str(num_a)
        years [i] = num_a

    for i in range (len(prec)):
        num_b = prec[i]
        num_b = num_b[1:-1]
        num_b = float(num_b)
        prec [i] = num_b

    print (years, prec)
    file = pd.DataFrame({'Year':years,'Prec':prec})
    file.to_csv('/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/prec_1.csv', index = None, encoding = 'utf8')

    
# this function is for training purpose in machine learning
def convert_shp_to_csv():
    ## Identifying files
    data_dir = '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/INTERS'
    files = os.listdir(data_dir)
    shp_files = [file for file in files if '.shp' in file]

    ## Reading in shps and saving as CSVs
    new_data_dir = '/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/CSV'
    for shp_file in shp_files:
        gdf = gpd.read_file(f'{data_dir}/{shp_file}')
        gdf.to_csv(f'{new_data_dir}/{shp_file[:-4]}.csv')
    
if __name__ == "__main__":
    write_into_file()


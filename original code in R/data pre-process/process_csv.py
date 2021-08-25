import pandas as pd
import numpy as np
import os
import csv
import geopandas as gpd

mean_value = []
years = []

def main():
    filename = os.listdir(r'/Users/zihuige/ACSE/ACSE-9/Project/Zonal Statistics Layers')
    
    for i in range(len(filename)):
        try:
            df = pd.read_csv('/Users/zihuige/ACSE/ACSE-9/Project/Zonal Statistics Layers/' + filename[i])
            # df = df.drop(df[(df['PREC'] == 0)].index)
            prec = df['_mean'].values
            # avr = np.sum(prec)/len(prec)
            mean_value.append(prec)
            years.append(filename[i])
            
        except Exception as e:
            pass
        continue

    file = pd.DataFrame({'Year':years,'Prec':mean_value})
    file.to_csv('/Users/zihuige/ACSE/ACSE-9/Project/zonal_statistics_1.csv', index = None, encoding = 'utf8')


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


def cal_avr():
    for i in range (5):
        df = pd.read_csv('/Users/zihuige/ACSE/ACSE-9/Project/Training test/csv_file/',i)
    #df = df.drop(columns=['BRIGHTNESS','ACQ_DATE','ACQ_TIME','BRIGHT_T31'])
        df = df.groupby('id')['w2_1_10'].mean()
    print (df)
    
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


import pandas as pd
import glob
import os

# List all CSV files in the directory
season_number = 4
year = 2021
# colony_name = 'Albany'

csv_files = glob.glob(rf"C:\Users\HP Pavilion\Desktop\All Delhi\New York Data\Season {season_number}\{year}\*.csv")

# Create an empty list to store dataframes
dfs = []

# Read each CSV file into a dataframe and add it to the list
for file in csv_files:
    df = pd.read_csv(file)
    dfs.append(df)

# Concatenate all dataframes into a single dataframe
combined_df = pd.concat(dfs, ignore_index=True)

# Create a new directory to save the files
output_directory = rf'C:\Users\HP Pavilion\Desktop\All Delhi\New York Data\Season_Wise_Data\Season_{season_number}\{year}'
os.makedirs(output_directory, exist_ok=True)

# Specify the full filename including the extension
filename = os.path.join(output_directory, f'PM_2.5_1_Hour_New_York_Season_{season_number}_{year}.csv')

# Save the combined dataframe to a new CSV file
combined_df.to_csv(filename, index=False)
print(f"Saved {year}")

import pandas as pd

year = 2019
season_number = 1
# Load the CSV file

data_file = rf'PM_2.5_1_Hour_New_York_Season_{season_number}_{year}.csv'
df = pd.read_csv(data_file)

# Check if columns exist and have the right names
required_columns = ['Date GMT', 'Time GMT', 'Sample Measurement']
if not all(col in df.columns for col in required_columns):
    raise ValueError(f"One or more of the required columns {required_columns} are missing.")

# Group by 'Date GMT' and 'Time GMT', then calculate the mean of 'Sample Measurement'
df_grouped = df.groupby(['Date GMT', 'Time GMT'], as_index=False)['Sample Measurement'].mean()

# Save the result to a new CSV file
output_file = f'averaged_sample_measurements_for_New_York_Season_{season_number}_{year}.csv'
df_grouped.to_csv(output_file, index=False)

print(f"Averaged data for Season-{season_number} {year}")


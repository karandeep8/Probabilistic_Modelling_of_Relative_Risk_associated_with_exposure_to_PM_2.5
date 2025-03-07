import pandas as pd

year = 2018

# Load the CSV file
df = pd.read_csv(f'new_york_data_{year}.csv')

# Get the unique values of 'County Name'
unique_counties = df['County Name'].unique()

# Loop through each unique county and save its data to a separate CSV file
for county in unique_counties:
    # Filter the data for the current county
    county_data = df[df['County Name'] == county]

    # Define the output file name
    output_file = f'new_york_data_{year}_{county}.csv'

    # Save the filtered data to a new CSV file
    county_data.to_csv(output_file, index=False)

    print(f'Data for {county} has been saved to {output_file}')


import pandas as pd


years = [2018]

for year in years:
    county_name = 'Steuben'
    # Load the CSV file
    df = pd.read_csv(f'new_york_data_{year}_{county_name}.csv')

    # Select only the desired columns
    columns_to_keep = ['Date GMT', 'Time GMT', 'Sample Measurement', 'State Name', 'County Name']
    filtered_df = df[columns_to_keep]

    # Save the filtered data to a new CSV file (or overwrite the existing one)
    filtered_df.to_csv(f'new_york_data_{year}_{county_name}_filtered.csv', index=False)

    print(f"Done for {county_name}-{year}.")


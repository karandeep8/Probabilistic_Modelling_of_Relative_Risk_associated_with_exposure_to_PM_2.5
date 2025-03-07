import pandas as pd
country = 'New_York'
year = 2021

# Load the CSV file
input_file = fr'risk_data_{country}_{year}_risk_beta_0.0562_PM_2.5.csv'
output_file = fr'daily_average_{country}_{year}.csv'

# Read the CSV file
data = pd.read_csv(input_file)

# Convert 'Date GMT' to a datetime object for easier grouping
data['Date GMT'] = pd.to_datetime(data['Date GMT'], format='%d-%m-%Y')

# Calculate the daily average for 'Sample Measurement'
daily_avg = data.groupby('Date GMT')['Sample Measurement'].mean().reset_index()

# Rename the columns for clarity
daily_avg.columns = ['Date', 'Daily Average Measurement']

# Save the results to a new CSV file
daily_avg.to_csv(output_file, index=False)

print(f"Daily averages saved to {output_file}")

import pandas as pd

country = 'New_York'
year = 2021

# Load the CSV file
input_file = fr'risk_data_{country}_{year}_risk_beta_0.0562_PM_2.5.csv'
output_file = fr'weekly_average_{country}_{year}.csv'

# Read the CSV file
data = pd.read_csv(input_file)

# Convert 'Date GMT' to a datetime object for easier grouping
data['Date GMT'] = pd.to_datetime(data['Date GMT'], format='%d-%m-%Y')

# Add a new column for week numbers (ISO week date system)
data['Week'] = data['Date GMT'].dt.isocalendar().week

# Calculate the weekly average for 'Sample Measurement'
weekly_avg = data.groupby('Week')['Sample Measurement'].mean().reset_index()

# Rename the columns for clarity
weekly_avg.columns = ['Week', 'Weekly Average Measurement']

# Save the results to a new CSV file
weekly_avg.to_csv(output_file, index=False)

print(f"Weekly averages saved to {output_file}")

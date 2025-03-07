import pandas as pd
import numpy as np

# Input parameters
country = 'New_York'
years = [2019, 2020, 2021]
beta_values = [0.0562, 0.1551, 0.2541]

for year in years:
    for beta_value in beta_values:
        # Load the data
        data = pd.read_csv(f'daily_risk_data_{country}_{year}_risk_beta_{beta_value}_PM_2.5.csv')
        samples = data['Risk_Data_Average']

        # Calculate mean and variance
        std_value = np.std(samples)

        mean_value = np.mean(samples)
        variance_value = np.var(samples)

        coefficient_of_variation_value = std_value / mean_value

        # Print the results
        print(f"Mean: {mean_value}")
        print(f"Variance: {variance_value}")
        print(f"CV: {coefficient_of_variation_value}")

        # Save the results to a CSV file
        results = pd.DataFrame({
            'Statistic': ['Mean', 'Variance', 'Coefficient of Variation'],
            'Value': [mean_value, variance_value, coefficient_of_variation_value]
        })

        results.to_csv(f'risk_statistics_{country}_{year}_beta_{beta_value}.csv', index=False)
        print(f"Results saved to risk_statistics_{country}_{year}_beta_{beta_value}.csv")

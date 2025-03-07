# import pandas as pd
# from relative_risk import relative_risk_upper, relative_risk_average, relative_risk_lower
#
#
# country = 'New_York'
# year = 2021
# threshold_value_country_wise = 35
#
# # Extracting these columns from data_pm_2_5 DataFrame
# selected_columns = ['Date', 'Daily Average Measurement']
#
# data_pm_2_5_selected = pd.read_csv(f'daily_average_{country}_{year}.csv')[selected_columns]
#
# risk_upper_data_list = []
# risk_average_data_list = []
# risk_lower_data_list = []
#
# for i in data_pm_2_5_selected['Daily Average Measurement']:
#     risk_data = relative_risk_upper(i, threshold_value_country_wise, 0.2541)
#     risk_upper_data_list.append(risk_data)
#
# for i in data_pm_2_5_selected['Daily Average Measurement']:
#     risk_data = relative_risk_average(i, threshold_value_country_wise, 0.15515)
#     risk_average_data_list.append(risk_data)
#
# for i in data_pm_2_5_selected['Daily Average Measurement']:
#     risk_data = relative_risk_lower(i, threshold_value_country_wise, 0.0562)
#     risk_lower_data_list.append(risk_data)
#
# result_df = pd.DataFrame({
#     'Date': data_pm_2_5_selected['Date'],
#     'Sample Measurement': data_pm_2_5_selected['Daily Average Measurement'],
#     'Risk_Data_Upper': risk_upper_data_list,
#     'Risk_Data_Average': risk_average_data_list,
#     'Risk_Data_Lower': risk_lower_data_list
# })
#
# # Save the result DataFrame to a CSV file
# result_df.to_csv(f'daily_risk_data_{country}_{year}_PM_2.5.csv', index=False)
# print(f"{country} {year} Saved Successfully")


"""Version-2"""
import pandas as pd
from relative_risk import relative_risk_upper, relative_risk_average, relative_risk_lower

country = 'New_York'
year = 2021

threshold_value_country_wise = 35
beta_values = [.0562, .1551, .2541]

selected_columns = ['Date', 'Daily Average Measurement']

data_pm_2_5_selected = pd.read_csv(f'daily_average_{country}_{year}.csv')[selected_columns]

for beta_value in beta_values:

    risk_average_data_list = []

    for i in data_pm_2_5_selected['Daily Average Measurement']:
        risk_data = relative_risk_average(i, threshold_value_country_wise, beta_value)
        risk_average_data_list.append(risk_data)

    result_df = pd.DataFrame({
        'Date': data_pm_2_5_selected['Date'],
        'Sample Measurement': data_pm_2_5_selected['Daily Average Measurement'],
        'Risk_Data_Average': risk_average_data_list,
    })

    # Save the result DataFrame to a CSV file
    result_df.to_csv(f'daily_risk_data_{country}_{year}_risk_beta_{beta_value}_PM_2.5.csv', index=False)
    print(f"{country} {year} Saved Successfully")

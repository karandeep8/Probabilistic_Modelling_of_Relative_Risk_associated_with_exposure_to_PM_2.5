"""For Seasons"""
# import pandas as pd
# import numpy as np
# from scipy.stats import entropy
#
# # Input parameters
# country = "New_York"
# years = [2019, 2020, 2021]
# beta_values = [0.0562, 0.1551, 0.2541]
# season_numbers = [1, 2, 3, 4]
#
# # Loop through each combination of year and beta value
# for year in years:
#     for beta in beta_values:
#         results = []
#
#         for season in season_numbers:
#             # Set num_bins based on season number
#             num_bins = 6 if season == 1 else 7
#
#             print(f"{year}-{beta}-{season}-{num_bins}")
#             # Construct the filename
#             filename = f"daily_risk_data_{country}_{year}_risk_beta_{beta:.4f}_PM_2.5_Season_{season}.csv"
#
#             # Read data and extract column
#             data = pd.read_csv(filename)
#             temperature_data = data["Risk_Data_Average"].dropna()
#
#             # Compute histogram (get counts)
#             counts, _ = np.histogram(temperature_data, bins=num_bins)
#
#             # Normalize counts to get probabilities
#             probabilities = counts / counts.sum()  # Ensure sum(probabilities) = 1
#
#             # Compute Shannon entropy
#             ent = entropy(probabilities, base=2)
#
#             # Compute maximum entropy for the given number of bins
#             entropy_max = np.log2(num_bins)
#
#             # Normalize entropy
#             normalized_entropy = ent / entropy_max
#
#             # Print and store results
#             print(f"Year: {year}, Beta: {beta:.4f}, Season: {season}, Entropy: {ent:.6f}, Normalized Entropy: {normalized_entropy:.6f}")
#             results.append([year, beta, season, ent, normalized_entropy])
#
#         # Save all seasons' entropy values in one file
#         output_filename = f"entropy_results_{country}_{year}_beta_{beta:.4f}.csv"
#         pd.DataFrame(results, columns=["Year", "Beta", "Season", "Entropy", "Normalized_Entropy"]).to_csv(output_filename, index=False)
#         print(f"Entropy results saved to {output_filename}")

"""For Daily"""
# import pandas as pd
# import numpy as np
# from scipy.stats import entropy
#
# # Input parameters
# country = "New_York"
# years = [2019, 2020, 2021]
# beta_values = [0.0562, 0.1551, 0.2541]
#
# # Loop through each year
# for year in years:
#     results = []  # Initialize results list for the entire year
#
#     # Set num_bins based on the year
#     if year == 2019:
#         num_bins = 15
#     elif year == 2020:
#         num_bins = 17
#     elif year == 2021:
#         num_bins = 14
#
#     # Loop through beta values
#     for beta in beta_values:
#         # Construct the filename
#         filename = f"daily_risk_data_{country}_{year}_risk_beta_{beta:.4f}_PM_2.5.csv"
#         print(f"Processing file: {filename} (Year: {year}, Beta: {beta:.4f}, Bins: {num_bins})")
#
#         # Read data and extract column
#         try:
#             data = pd.read_csv(filename)
#             temperature_data = data["Risk_Data_Average"].dropna()
#
#             # Compute histogram (get counts)
#             counts, _ = np.histogram(temperature_data, bins=num_bins)
#
#             # Normalize counts to get probabilities
#             probabilities = counts / counts.sum()  # Ensure sum(probabilities) = 1
#
#             # Compute Shannon entropy
#             ent = entropy(probabilities, base=2)
#
#             # Compute maximum entropy for the given number of bins
#             entropy_max = np.log2(num_bins)
#
#             # Normalize entropy
#             normalized_entropy = ent / entropy_max
#
#             # Print and store results
#             print(f"Year: {year}, Beta: {beta:.4f}, Entropy: {ent:.6f}, Normalized Entropy: {normalized_entropy:.6f}")
#             results.append([year, beta, ent, normalized_entropy])
#
#         except FileNotFoundError:
#             print(f"Warning: File {filename} not found. Skipping.")
#         except Exception as e:
#             print(f"Error processing file {filename}: {e}")
#
#     # Save results for the entire year in one CSV file
#     output_filename = f"daily_risk_entropy_results_{country}_{year}.csv"
#     pd.DataFrame(results, columns=["Year", "Beta", "Entropy", "Normalized_Entropy"]).to_csv(output_filename, index=False)
#     print(f"Entropy results saved to {output_filename}")


"""For Graph"""
# Version-1 Season Wise
# import pandas as pd
# import matplotlib.pyplot as plt
#
# # Input parameters
# country = "New_York"
# years = [2019, 2020, 2021]
# beta_value = 0.2541
# seasons = [1, 2, 3, 4]  # All four seasons
# colors = ['b', 'g', 'r', 'purple']  # Colors for different seasons
#
# # Initialize plot
# plt.figure(figsize=(18, 10))
#
# # Loop through seasons
# for i, season in enumerate(seasons):
#     normalized_entropies = []  # Store entropy for each year
#
#     # Loop through years
#     for year in years:
#         # Construct filename
#         filename = f"entropy_results_{country}_{year}_beta_{beta_value:.4f}.csv"
#
#         # Read data
#         data = pd.read_csv(filename)
#
#         # Filter data for the given season
#         season_data = data[data["Season"] == season]
#
#         # Extract normalized entropy
#         if not season_data.empty:
#             normalized_entropy = season_data["Normalized_Entropy"].values[0]
#             print(year, normalized_entropy)
#             normalized_entropies.append(normalized_entropy)
#         else:
#             normalized_entropies.append(None)  # Handle missing data
#
#     # Plot for this season
#     plt.plot(years, normalized_entropies, marker='o', linestyle='-', linewidth=3, color=colors[i], label=f'Season {season}')
#
# # Labels and title
# plt.xticks(fontsize=15, fontweight='bold')
# plt.yticks(fontsize=15, fontweight='bold')
# plt.xticks(years)  # Ensure all years are shown on x-axis
# plt.xlabel("Year", fontsize=20, fontweight='bold')
# plt.ylabel("Entropy", fontsize=20, fontweight='bold')
# plt.title(f"Normalized Entropy of RR Across Seasons for Country {country} (Beta = {beta_value:.4f})", fontsize=20, fontweight='bold')
# plt.grid(False)
# plt.legend(fontsize=15, loc='best')
# plt.tight_layout()
# output_filename = f'Normalized_Entropy_seasons_country_{country}_(Beta = {beta_value:.4f}).png'
# plt.savefig(output_filename, dpi=600)
# plt.show()

# Version-2 Daily
# import pandas as pd
# import matplotlib.pyplot as plt
#
# # Input parameters
# country = "New_York"
# years = [2019, 2020, 2021]
# colors = ['b', 'g', 'r']  # Colors for different years
#
# # Initialize plot
# plt.figure(figsize=(18, 10))
#
# # Loop through years
# for i, year in enumerate(years):
#     # Construct filename
#     filename = f"daily_risk_entropy_results_{country}_{year}.csv"
#
#     # Read data
#     data = pd.read_csv(filename)
#
#     # Extract beta values and corresponding normalized entropy
#     beta_values = data["Beta"]
#     normalized_entropy = data["Normalized_Entropy"]
#     print(f'{normalized_entropy}')
#
#     # Plot normalized entropy vs beta for the given year
#     plt.plot(beta_values, normalized_entropy, marker='o', linestyle='-', linewidth=3, color=colors[i], label=f'Year {year}')
#
# # Labels and title
# plt.xticks(fontsize=15, fontweight='bold')
# plt.yticks(fontsize=15, fontweight='bold')
# plt.xlabel("Beta Values", fontsize=20, fontweight='bold')
# plt.ylabel("Normalized Entropy", fontsize=20, fontweight='bold')
# plt.title(f"Normalized Entropy of RR for {country}", fontsize=20, fontweight='bold')
# plt.xticks(beta_values, fontsize=12)
# plt.yticks(fontsize=12)
# plt.legend(fontsize=15, loc='best')
# plt.grid(False)
#
# # Save plot
# output_filename = f'Normalized_Entropy_Beta_{country}_{year}.png'
# plt.savefig(output_filename, dpi=600)
# plt.show()

% Input parameters
year = 2021;
country = "Delhi";

% Dynamically construct the filename
filename = sprintf('daily_average_PM_10_%s_%d.csv', country, year);

% Read data from the constructed filename
data = readtable(filename, 'VariableNamingRule', 'preserve');

% Extract the 'Daily Average Measurement' column
temperature_data = data.('Daily Average Measurement');

% Calculate lognormal parameters
log_params = lognfit(temperature_data); % [mu, sigma] in log scale
log_mu = log_params(1);
log_sigma = log_params(2);

% Display fitted parameters for the lognormal distribution
fprintf('Fitted Lognormal Parameters:\n');
fprintf('Mean (mu): %.2f\n', log_mu);
fprintf('Std Dev (sigma): %.2f\n', log_sigma);

% Create ECDF of the temperature data
[f_empirical, x_empirical] = ecdf(temperature_data);

% Generate x values for the fitted lognormal CDF
X = linspace(min(temperature_data), max(temperature_data), 1000);
fitted_cdf = logncdf(X, log_mu, log_sigma);

% Create a figure
figure;

% Create a figure
ideal_width = 1920;
ideal_height = 1080;
figure_handle = figure('Position', [100, 100, ideal_width, ideal_height]);

% Plot ECDF of the data
plot(x_empirical, f_empirical, 'b', 'LineWidth', 3, 'DisplayName', 'Empirical CDF');
hold on;

% Plot the fitted lognormal CDF
plot(X, fitted_cdf, 'r--', 'LineWidth', 3, 'DisplayName', 'Lognormal CDF');

% Add labels, legend, and title
xlabel('y', 'FontSize', 25, 'FontWeight', 'bold');
ylabel('Cumulative Probability', 'FontSize', 25, 'FontWeight', 'bold');
title(sprintf('ECDF and CDF Comparison of PM 10 (%s, %d)', country, year), ...
    'FontSize', 22, 'FontWeight', 'bold');

% Add legend
lgd=legend({'PM 10 ECDF', 'Lognormal CDF'}, ...
    'FontSize', 22, 'FontWeight', 'bold');
lgd.Location = "east";
lgd.Orientation = "horizontal";
lgd.IconColumnWidth = 5;
grid on;

% Customize tick properties
ax = gca;
ax.FontSize = 16; % Increase font size for ticks
ax.FontWeight = 'bold'; % Make tick labels bold

% Improve plot appearance
grid on;
hold off;

% Save the plot as an image file with high resolution
output_filename = sprintf('ECDF_vs_Fitted_Lognormal_CDF_of_PM 10_%s_%d.png', country, year);
print(figure_handle, output_filename, '-dpng', '-r600');

% Display a message indicating where the plot was saved
fprintf('Plot saved to: %s\n', fullfile(pwd, output_filename));

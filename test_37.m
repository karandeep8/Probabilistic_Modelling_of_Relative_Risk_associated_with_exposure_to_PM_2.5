% Input parameters
country = "Delhi";

year = 2021;
beta = 0.2541;

a = 2.84218479;
min_value_parameter = 0.35184200673;

mean_value = 4.48;
std_value = 0.77;

% Dynamically construct the filename
filename = sprintf('daily_risk_data_%s_%d_risk_beta_%.4f_PM_2.5.csv', country, year, beta);

% Read data
try
    data = readtable(filename, 'VariableNamingRule', 'preserve');
catch ME
    fprintf('Error reading file: %s\n', ME.message);
    return; % Exit if file reading fails
end

% Extract the 'Risk_Data_Average' column
if ismember('Risk_Data_Average', data.Properties.VariableNames)
    temperature_data = data.('Risk_Data_Average');
else
    fprintf('Error: Column "Risk_Data_Average" not found in the file.\n');
    return;
end

% Preprocess temperature_data to remove NaN/Inf
temperature_data = temperature_data(~isnan(temperature_data) & ~isinf(temperature_data));

% Calculate empirical CDF of temperature data
[empirical_cdf, sorted_temperature_data] = ecdf(temperature_data);

% Create a figure
ideal_width = 1920;
ideal_height = 1080;
figure_handle = figure('Position', [100, 100, ideal_width, ideal_height]);

% Plot ECDF
plot(sorted_temperature_data, empirical_cdf, 'Color', [0, 0, 1, 0.5], 'LineWidth', 3); % ECDF (lighter blue line)

% Add labels and formatting
graph_title = sprintf('ECDF of RR (%s, %d, β = %.4f)', country, year, beta);
title(graph_title, 'FontSize', 22, 'FontWeight', 'bold');
xlabel('y', 'FontSize', 25, 'FontWeight', 'bold');
ylabel('Cumulative Probability', 'FontSize', 25, 'FontWeight', 'bold');
lgd = legend({'RR ECDF'}, ...
    'FontSize', 22, 'FontWeight', 'bold');
lgd.Location = "east";
lgd.Orientation = "horizontal";
lgd.IconColumnWidth = 5;
grid on;

% Set axis limits (adjust as needed)
xlim([min(sorted_temperature_data) max(sorted_temperature_data)]);
ylim([0 1.1]); % CDFs range from 0 to 1

% Customize tick properties
ax = gca;
ax.FontSize = 16; % Increase font size for ticks
ax.FontWeight = 'bold'; % Make tick labels bold

% Save the image
image_filename = regexprep(graph_title, '[^\w\s]', '');
image_filename = strrep(image_filename, ' ', '_');
image_filename = strcat('ECDF_', image_filename, '.png');

print(figure_handle, image_filename, '-dpng', '-r300');

% Display a message indicating where the image was saved
fprintf('Plot saved to: %s\n', fullfile(pwd, image_filename));

% RR PDF function (not used in this version, but kept for completeness)
function final_value = rr_pdf(a, beta, y, mean_value, std_value)
    first_part = a / beta;
    second_part = (a * y)^((1 - beta) / beta) / (std_value * sqrt(2 * pi));
    third_part = 1 / (((a * y)^(1 / beta)) - 1);
    log_term = log(((a * y)^(1 / beta)) - 1);
    fourth_part = exp(-((log_term - mean_value)^2) / (2 * std_value^2));
    final_value = first_part * second_part * third_part * fourth_part;
end
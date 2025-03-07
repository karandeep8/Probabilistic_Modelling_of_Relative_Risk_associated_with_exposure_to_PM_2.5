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

% Define X as a range for plotting
X = linspace(min_value_parameter, max(temperature_data), 10000);

% Compute rr_pdf values
try
    rr_pdf_values = arrayfun(@(y) rr_pdf(a, beta, y, mean_value, std_value), X);
catch ME
    fprintf('Error in computing rr_pdf: %s\n', ME.message);
    return;
end

% Ensure X values are within valid domain for rr_pdf
valid_idx = rr_pdf_values > 0 & ~isinf(rr_pdf_values) & ~isnan(rr_pdf_values);
X = X(valid_idx);
rr_pdf_values = rr_pdf_values(valid_idx);

% Compute the CDF from the PDF (kept for calculations)
rr_cdf_values = cumtrapz(X, rr_pdf_values); % Cumulative integral
rr_cdf_values = rr_cdf_values / max(rr_cdf_values); % Normalize

% Calculate ECDF from the actual data
[ecdf_values, ecdf_x] = ecdf(temperature_data);

% Calculate c0, c1, and c2
c0 = 1; % Define c0
c1 = mean(temperature_data) + std(temperature_data);
c2 = mean(temperature_data) + 2 * std(temperature_data);

% Find P(Y <= c0), P(Y <= c1), and P(Y <= c2) using the theoretical CDF (unchanged)
P_Y_le_c0 = interp1(X, rr_cdf_values, c0, 'linear', 'extrap');
P_Y_le_c1 = interp1(X, rr_cdf_values, c1, 'linear', 'extrap');
P_Y_le_c2 = interp1(X, rr_cdf_values, c2, 'linear', 'extrap');

% Display the results
fprintf('P(Y <= c0) where c0 = 1: %.4f\n', P_Y_le_c0);
fprintf('P(Y <= c1) where c1 = E[Y] + sigma: %.4f\n', P_Y_le_c1);
fprintf('P(Y <= c2) where c2 = E[Y] + 2*sigma: %.4f\n', P_Y_le_c2);

% Create a figure
ideal_width = 1920;
ideal_height = 1080;
figure_handle = figure('Position', [100, 100, ideal_width, ideal_height]);

% Plot ECDF instead of CDF
plot(ecdf_x, ecdf_values, '--g', 'LineWidth', 3); % ECDF (dashed green line)
hold on;

% Highlight c0, c1, and c2 on the plot
line([c0, c0], [0, P_Y_le_c0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 2.5); % Vertical line at c0
line([min(ecdf_x), c0], [P_Y_le_c0, P_Y_le_c0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 2.5); % Horizontal line at P(Y <= c0)
scatter(c0, P_Y_le_c0, 100, 'black', 'filled'); % Mark the point (c0, P(Y <= c0))

line([c1, c1], [0, P_Y_le_c1], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 2.5); % Vertical line at c1
line([min(ecdf_x), c1], [P_Y_le_c1, P_Y_le_c1], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 2.5); % Horizontal line at P(Y <= c1)
scatter(c1, P_Y_le_c1, 100, 'red', 'filled'); % Mark the point (c1, P(Y <= c1))

line([c2, c2], [0, P_Y_le_c2], 'Color', 'blue', 'LineStyle', '--', 'LineWidth', 2.5); % Vertical line at c2
line([min(ecdf_x), c2], [P_Y_le_c2, P_Y_le_c2], 'Color', 'blue', 'LineStyle', '--', 'LineWidth', 2.5); % Horizontal line at P(Y <= c2)
scatter(c2, P_Y_le_c2, 100, 'blue', 'filled'); % Mark the point (c2, P(Y <= c2))

% Modify text annotations to avoid overlapping with x-axis ticks:
text(c0, -0.15, sprintf('c0 = %.2f', c0), ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
text(min(ecdf_x) + 0.1*(max(ecdf_x)-min(ecdf_x)), P_Y_le_c0, sprintf('P(Y \\leq c0) = %.4f', P_Y_le_c0), ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'black', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

text(c1, -0.15, sprintf('c1 = %.2f', c1), ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'red', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
text(min(ecdf_x) + 0.1*(max(ecdf_x)-min(ecdf_x)), P_Y_le_c1, sprintf('P(Y \\leq c1) = %.4f', P_Y_le_c1), ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'red', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

text(c2, -0.15, sprintf('c2 = %.2f', c2), ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'blue', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
text(min(ecdf_x) + 0.1*(max(ecdf_x)-min(ecdf_x)), P_Y_le_c2, sprintf('P(Y \\leq c2) = %.4f', P_Y_le_c2), ...
    'FontSize', 14, 'FontWeight', 'bold', 'Color', 'blue', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

% Add labels and formatting
graph_title = sprintf('ECDF of RR (%s, %d, \\beta = %.4f)', country, year, beta);
title(graph_title, 'FontSize', 22, 'FontWeight', 'bold');
xlabel('y', 'FontSize', 25, 'FontWeight', 'bold');
ylabel('Cumulative Probability', 'FontSize', 25, 'FontWeight', 'bold');
lgd = legend({'RR ECDF'}, ...
    'FontSize', 18, 'FontWeight', 'bold');
lgd.Location = "east";
lgd.Orientation = "horizontal";
lgd.IconColumnWidth = 5;
grid on;

% Set axis limits (adjust as needed)
xlim([min(ecdf_x) max(ecdf_x)]);
ylim([0 1.1]); % ECDFs range from 0 to 1

% Customize tick properties
ax = gca;
ax.FontSize = 16; % Increase font size for ticks
ax.FontWeight = 'bold'; % Make tick labels bold

% Save the image
image_filename = regexprep(graph_title, '[^\w\s]', '');
image_filename = strrep(image_filename, ' ', '_');
image_filename = strcat('ECDF_', image_filename, '.png');

print(figure_handle, image_filename, '-dpng', '-r300');

fprintf('Plot saved to: %s\n', fullfile(pwd, image_filename));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RR PDF function
function final_value = rr_pdf(a, beta, y, mean_value, std_value)
    first_part = a / beta;
    second_part = (a * y)^((1 - beta) / beta) / (std_value * sqrt(2 * pi));
    third_part = 1 / (((a * y)^(1 / beta)) - 1);
    log_term = log(((a * y)^(1 / beta)) - 1);
    fourth_part = exp(-((log_term - mean_value)^2) / (2 * std_value^2));
    final_value = first_part * second_part * third_part * fourth_part;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RR CDF function (kept for reference but not used in plotting)
function cdf_val = rr_cdf(x, a, beta, mean_value, std_value)
    % Compute the CDF for each value in x
    cdf_val = arrayfun(@(val) integral(@(y) rr_pdf(a, beta, y, mean_value, std_value), ...
                                       min(x), val, 'ArrayValued', true), x);
end
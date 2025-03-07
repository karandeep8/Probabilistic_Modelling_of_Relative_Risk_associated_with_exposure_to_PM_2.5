% Input parameters
country = "New_York";

year = 2021;

num_bins = 14;

beta = 0.2541;
a = 2.48574438;
min_value_parameter = 0.40229398005;

% Define additional parameters for rr_pdf

mean_value = 1.95;
std_value = 0.47;

% Dynamically construct the filename
filename = sprintf('daily_risk_data_%s_%d_risk_beta_%.4f_PM_2.5.csv', country, year, beta);

% Read data
data = readtable(filename, 'VariableNamingRule', 'preserve');

% Extract the 'Risk_Data_Average' column
temperature_data = data.('Risk_Data_Average');


% Create the histogram and get observed frequencies
[counts, edges] = histcounts(temperature_data, num_bins, 'Normalization', 'pdf');

% Define bin centers for expected frequency calculations
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;

% Compute expected frequencies using RR PDF
expected_rr = arrayfun(@(y) rr_pdf(a, beta, y, mean_value, std_value), bin_centers);

% Scale expected frequencies to match histogram
expected_rr_scaled = expected_rr * sum(diff(edges)) * sum(counts);

% Perform Chi-Square Goodness-of-Fit Test for RR PDF
[h_rr, p_rr, stats_rr] = chi2gof(bin_centers, ...
    'CDF', @(x) rr_cdf(x, a, beta, mean_value, std_value), ...
    'Edges', edges, 'Frequency', counts);

% Display results
disp('Chi-Square Test Results for RR PDF:');
disp(['Hypothesis Rejected: ', num2str(h_rr)]); % h_rr=0 means fit is good, h_rr=1 means rejected
disp(['p-value: ', num2str(p_rr)]);
disp(['Chi-Square Statistic: ', num2str(stats_rr.chi2stat)]);

% Define X as a range for plotting
X = linspace(min_value_parameter, max(temperature_data) + 0.5, 10000);

% Compute rr_pdf values
rr_pdf_values = arrayfun(@(y) rr_pdf(a, beta, y, mean_value, std_value), X);

% Calculate the area under the curve (numerical integration)
area_under_curve = trapz(X, rr_pdf_values);

% Display the area under the curve
fprintf('Area under the curve (Relative Risk PDF): %.4f\n', area_under_curve);

% Create a figure with ideal resolution (1920x1080 pixels)
ideal_width = 1920;
ideal_height = 1080;
figure_handle = figure('Position', [100, 100, ideal_width, ideal_height]); % Position is [left, bottom, width, height]

% Plot histogram and PDFs
histogram(temperature_data, num_bins, 'Normalization', 'pdf', ...
    'FaceAlpha', 0.6, 'EdgeColor', 'b');
hold on;

% Overlay the rr_pdf
plot(X, rr_pdf_values, 'g', 'LineWidth', 3);

% Add labels and formatting
graph_title = sprintf('Relative Risk(RR) Data Distribution (%s, %d, β = %.4f)', ...
    country, year, beta);
title(graph_title, 'FontSize', 22, 'FontWeight', 'bold');
xlabel('y', 'FontSize', 25, 'FontWeight', 'bold'); % Label for the x-axis
ylabel('f_Y(y)', 'FontSize', 25, 'FontWeight', 'bold');  % Label for the y-axis

% Add legend
lgd = legend({'RR Data Histogram', 'RR PDF'}, ...
    'FontSize', 22, 'FontWeight', 'bold');
lgd.Location = "east";
lgd.Orientation = "horizontal";
lgd.IconColumnWidth = 5;
grid on;

% Set axis limits
xlim([min_value_parameter max(temperature_data)*1.1]);
ylim([0 max(rr_pdf_values)*1.1]);

% Display the p-value on the graph
p_text = sprintf('p-value: %.4f', p_rr); % Format the p-value text
x_pos = min_value_parameter + (max(temperature_data) - min_value_parameter) * 0.05; % Adjust X position for the text
y_pos = max(rr_pdf_values) * 0.9; % Adjust Y position for the text
text(x_pos, y_pos, p_text, 'FontSize', 22, 'Color', 'red', 'FontWeight', 'bold');

% Customize tick properties
ax = gca;
ax.FontSize = 16; % Increase font size for ticks
ax.FontWeight = 'bold'; % Make tick labels bold

% Save the image automatically with the graph title as the filename
% Replace spaces and special characters in the title with underscores for the filename
image_filename = regexprep(graph_title, '[^\w\s]', ''); % Remove special characters
image_filename = strrep(image_filename, ' ', '_'); % Replace spaces with underscores
image_filename = strcat('Histogram_', image_filename, '.png'); % Add prefix and file extension

% Save the figure
% saveas(figure_handle, image_filename);
print(figure_handle, image_filename, '-dpng', '-r300');

% Display a message indicating where the image was saved
fprintf('Plot saved to: %s\n', fullfile(pwd, image_filename));

% RR PDF function (unchanged)
function final_value = rr_pdf(a, beta, y, mean_value, std_value)
    first_part = a / beta;
    second_part = (a * y)^((1 - beta) / beta) / (std_value * sqrt(2 * pi));
    third_part = 1 / (((a * y)^(1 / beta)) - 1);
    log_term = log(((a * y)^(1 / beta)) - 1);
    fourth_part = exp(-((log_term - mean_value)^2) / (2 * std_value^2));
    final_value = first_part * second_part * third_part * fourth_part;
end

% RR CDF function
function cdf_val = rr_cdf(x, a, beta, mean_value, std_value)
    % Compute the CDF for each value in x
    cdf_val = arrayfun(@(val) integral(@(y) rr_pdf(a, beta, y, mean_value, std_value), ...
                                       min(x), val, 'ArrayValued', true), x);
end



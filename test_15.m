% Input parameters
year = 2021;
country = "Delhi";
num_bins = 15;
x_annotation = 500; % x-coordinate at the peak of the PDF
y_annotation = 0.0025 * 1.2; % Position slightly above the peak

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

% Create the histogram and get observed frequencies
[counts, edges] = histcounts(temperature_data, num_bins);

% Calculate bin centers
bin_centers = (edges(1:end-1) + edges(2:end)) / 2;

% Perform Chi-Square Goodness-of-Fit Test
[h, p, stats] = chi2gof(bin_centers, ...
    'CDF', @(x) logncdf(x, log_mu, log_sigma), ...
    'Edges', edges, ...
    'Frequency', counts);

% Display results
disp('Chi-Square Test Results:');
disp(['Hypothesis Rejected: ', num2str(h)]); % h=0 means fit is good, h=1 means rejected
disp(['p-value: ', num2str(p)]);
disp(['Chi-Square Statistic: ', num2str(stats.chi2stat)]);

% Create a figure
ideal_width = 1920;
ideal_height = 1080;
figure_handle = figure('Position', [100, 100, ideal_width, ideal_height]);

histogram(temperature_data, num_bins, 'Normalization', 'pdf', ...
    'FaceAlpha', 0.7, 'EdgeColor', 'b');
hold on;

% Overlay the lognormal PDF curve
X = linspace(0, max(temperature_data) + 5, 10000);
lognormal_pdf = lognpdf(X, log_mu, log_sigma);
xlim([0, max(temperature_data) * 1.1]);
plot(X, lognormal_pdf, 'r', 'LineWidth', 3);

% Add labels, title, and legend with increased size and bold font
xlabel('y', 'FontSize', 25, 'FontWeight', 'bold');
ylabel('f_Y(y)', 'FontSize', 25, 'FontWeight', 'bold');
graph_title = sprintf('Histogram of PM 10 Measurement (%s, %d)', country, year);
title(graph_title, 'FontSize', 22, 'FontWeight', 'bold');
lgd = legend('PM 10 Measurement Histogram', 'Lognormal PDF', ...
    'FontSize', 22, 'FontWeight', 'bold');
lgd.Location = "east";
lgd.Orientation = "horizontal";
lgd.IconColumnWidth = 5;

% Annotate the p-value, log_mu, and log_sigma on the plot using LaTeX for mu and sigma
annotation_text = sprintf('$p$-value: %.4f\n$\\hat{\\mu}=%.2f$\n$\\hat{\\sigma}=%.2f$', p, log_mu, log_sigma);
[~, max_pdf_index] = max(lognormal_pdf); % Get index of max PDF value
text(x_annotation, y_annotation, annotation_text, ...
    'FontSize', 30, 'FontWeight', 'bold', ...
    'Color', [0.6 0 0], ...          % Darker red color (RGB)
    'BackgroundColor', 'yellow', ...
    'EdgeColor', 'black', ...
    'Interpreter', 'latex');

% Customize tick properties
ax = gca;
ax.FontSize = 16; % Increase font size for ticks
ax.FontWeight = 'bold'; % Make tick labels bold

% Improve plot appearance
grid on;
hold off;

% Save the plot as an image file with high resolution
image_filename = regexprep(graph_title, '[^\w\s]', ''); % Remove special characters
image_filename = strrep(image_filename, ' ', '_'); % Replace spaces with underscores
image_filename = strcat('Daily_Histogram_', image_filename, '.png'); % Add prefix and file extension

print(figure_handle, image_filename, '-dpng', '-r600'); % Save at 300 dpi

fprintf('Plot saved to: %s\n', fullfile(pwd, image_filename));








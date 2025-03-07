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

% Define X as a range for computation
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

% Compute the CDF from the PDF
rr_cdf_values = cumtrapz(X, rr_pdf_values); % Cumulative integral
rr_cdf_values = rr_cdf_values / max(rr_cdf_values); % Normalize

% Define c0, c1, and c2 with new values
c0 = 1;  % Modified value
c1 = 1.12;    % Modified value
c2 = 1.20;  % Modified value

% Find P(Y <= c0), P(Y <= c1), and P(Y <= c2) using the theoretical CDF
P_Y_le_c0 = interp1(X, rr_cdf_values, c0, 'linear', 'extrap');
P_Y_le_c1 = interp1(X, rr_cdf_values, c1, 'linear', 'extrap');
P_Y_le_c2 = interp1(X, rr_cdf_values, c2, 'linear', 'extrap');

% Display the results
fprintf('P(Y <= c0) where c0 = %.1f: %.4f\n', c0, P_Y_le_c0);
fprintf('P(Y <= c1) where c1 = %.1f: %.4f\n', c1, P_Y_le_c1);
fprintf('P(Y <= c2) where c2 = %.1f: %.4f\n', c2, P_Y_le_c2);

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
def relative_risk_upper(x, threshold_value, coefficient_value_upper_limit):
    first_part = x + 1
    second_part = threshold_value + 1
    third_part = float(first_part / second_part)
    fourth_part = float(third_part ** coefficient_value_upper_limit)
    return fourth_part


def relative_risk_average(x, threshold_value, coefficient_value_average_limit):
    first_part = x + 1
    second_part = threshold_value + 1
    third_part = float(first_part / second_part)
    fourth_part = float(third_part ** coefficient_value_average_limit)
    return fourth_part


def relative_risk_lower(x, threshold_value, coefficient_value_lower_limit):
    first_part = x + 1
    second_part = threshold_value + 1
    third_part = float(first_part / second_part)
    fourth_part = float(third_part ** coefficient_value_lower_limit)
    return fourth_part

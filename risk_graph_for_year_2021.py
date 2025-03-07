import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Use Matplotlib's built-in math renderer (no LaTeX required)
# Explicitly ensure math text uses the same font properties
plt.rc('mathtext', fontset='stix')  # Use a font that supports bold and size changes
plt.rc('font', family='STIXGeneral', weight='bold', size=15)  # Set default font properties

country = 'Delhi'
year = 2021
beta = 0.0562
data = pd.read_csv(f'daily_risk_data_{country}_{year}_risk_beta_{beta}_PM_2.5.csv')['Risk_Data_Average']

plt.hist(data, bins=15, color='skyblue', edgecolor='black', density=True)
plt.xticks(fontsize=15, fontweight='bold')
plt.yticks(fontsize=15, fontweight='bold')
# Use raw string with $ for beta symbol and keep it compatible with Matplotlib's renderer
plt.title(r'Histogram of RR for Delhi ({0}), $\beta$={1}'.format(year, beta), fontsize=20, fontweight='bold')
plt.xlabel('y', fontsize=20, fontweight='bold')
# Use raw string with $ for f_y(Y) with subscript y
plt.ylabel(r'$f_{y}(Y)$', fontsize=20, fontweight='bold')
plot_filename = f"Risk_Histogram_{country}_{year}_beta_{beta}.png"
plt.tight_layout()
plt.gcf().set_size_inches(18, 10)
plt.savefig(plot_filename)
plt.show()
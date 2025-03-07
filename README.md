# Probabilistic Modelling of Relative Risk Associated with Exposure to PM₂.₅

## Overview
This repository contains the **codebase** for **probabilistic modelling of relative risk** associated with **exposure to PM₂.₅**. The study utilizes **air quality data** from both **New York (EPA)** and **Delhi (CPCB)** to assess **health risks** by applying **statistical analysis, entropy measures, and risk modelling**.

The repository is structured systematically, with each file performing a **specific function** related to data preprocessing, statistical analysis, and risk estimation.

---

## Data Sources
- **New York:** PM₂.₅ FRM/FEM Mass (88101) data from [EPA Air Data](https://aqs.epa.gov/aqsweb/airdata/download_files.html).
- **Delhi:** Air quality data from **CPCB** accessible via the **Advanced Search** feature at [CPCB Air Quality Data Portal](https://airquality.cpcb.gov.in/ccr/#/caaqm-dashboard-all/caaqm-landing).

---

## Repository Structure and File Descriptions

The project is divided into the following main components:

### 1️⃣ Data Preprocessing
These scripts **clean, aggregate, and organize the raw air quality data** from both New York and Delhi.
- **`cleaning_new_york_data.py`** → Cleans raw New York air quality data.
- **`averaging_the_value.py`** & **`averaging_values_code.py`** → Compute **average PM₂.₅ concentrations** from datasets.
- **`combining.py`** → Merges multiple datasets into a structured format.

---

### 2️⃣ Statistical Analysis
These scripts **compute statistical measures** such as **mean, variance, and entropy** for PM₂.₅ exposure.
- **`mean_and_variance.py`** → Calculates **mean and variance** of PM₂.₅ concentrations.
- **`entropy_calculation.py`** → Computes **entropy-based measures** to assess pollution uncertainty.

---

### 3️⃣ Risk Assessment and Modelling
These scripts estimate the **relative risk** associated with **PM₂.₅ exposure** using **probabilistic models**.
- **`relative_risk.py`** → Develops the **probabilistic risk model** for PM₂.₅ exposure.
- **`risk_data.py`** → Processes and **organizes risk-related data** for further analysis.
- **`risk_graph_for_year_2021.py`** → Generates **risk assessment visualizations** for 2021.

---

### 4️⃣ MATLAB Files
These **MATLAB scripts** validate statistical models and **risk assessment calculations**.
- **`test_15.m` to `test_41.m`** → Perform **different test scenarios** for validating data analysis models.

---

### 5️⃣ Miscellaneous
- **`.gitignore`** → Specifies files and directories to be ignored by Git.
- **`pyvenv.cfg`** → Configuration file for the virtual environment.

---

## How It Works
1. **Preprocessing:** The data is first **cleaned, formatted, and averaged** using Python scripts.
2. **Statistical Analysis:** The **mean, variance, and entropy measures** are computed.
3. **Risk Estimation:** The **relative risk model** is applied to quantify **health risks**.
4. **Visualization:** Graphs and **statistical outputs** are generated for analysis.
5. **Validation:** MATLAB scripts verify the **accuracy of risk modelling approaches**.

---

## Contributing
Contributions are welcome! Please create a pull request or open an issue for discussion.

---

## License
This repository follows an **open-source license**.

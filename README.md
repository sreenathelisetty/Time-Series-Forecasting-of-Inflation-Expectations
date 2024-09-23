# Time Series Forecasting of Inflation Expectations

## Overview
This project focuses on the analysis and forecasting of inflation expectation rates using advanced time series analysis techniques in R. The primary goal is to uncover historical trends in inflation expectations and generate reliable forecasts for future periods. By leveraging statistical methods, this project aims to provide insights that can inform economic policy and financial decision-making.

## Technologies Used
- **Programming Language**: R
- **Key Libraries**: 
  - **Data Manipulation and Visualization**: 
    - `readr`: For reading and importing CSV data.
    - `dplyr`: For data manipulation and transformation.
    - `ggplot2`: For creating insightful visualizations of time series data.
  - **Time Series Analysis**: 
    - `tsibble`: For handling tidy temporal data.
    - `fable`: For forecasting using state-of-the-art models.
    - `feasts`: For features and diagnostics of time series data.
    - `forecast`: For applying forecasting methods, particularly ARIMA.
  - **Statistical Tests and Date Handling**: 
    - `tseries`: For conducting statistical tests such as unit root tests.
    - `lubridate`: For easy manipulation and formatting of date objects.

## Data Source
The dataset used in this project is sourced from the Federal Reserve Economic Data (FRED). It contains historical inflation expectation rates, which are crucial for understanding economic conditions and for making informed predictions.

## Key Steps in the Analysis
1. **Loading Required Libraries**: Essential libraries are loaded to facilitate efficient data handling, visualization, and forecasting processes.
  
2. **Data Loading and Preprocessing**: 
   - The dataset is imported from a CSV file.
   - The date column is reformatted to ensure proper date handling.
   - New variables are created, including the logarithm of inflation rates and seasonal differences, to prepare the data for stationarity tests.

3. **Initial Data Exploration**: 
   - Display the first few observations to understand the structure and content of the dataset.
   - Generate a time series plot to visualize historical trends in inflation expectations.

4. **Data Transformation**: 
   - Multiple transformations are performed to stabilize variance and ensure stationarity, which is critical for time series analysis.

5. **Unit Root Tests**: 
   - Conduct KPSS tests on the transformed series to check for stationarity, helping determine the appropriate modeling strategy.

6. **ACF and PACF Analysis**: 
   - Generate Autocorrelation Function (ACF) and Partial Autocorrelation Function (PACF) plots to identify suitable AR (AutoRegressive) and MA (Moving Average) components for ARIMA modeling.

7. **Model Fitting**: 
   - Fit several ARIMA models to the data, selecting the best model based on Akaike Information Criterion corrected (AICc) and Bayesian Information Criterion (BIC).

8. **Model Diagnostics**: 
   - Perform residual diagnostics to ensure that the residuals of the fitted model do not exhibit autocorrelation, which would indicate a poor model fit.

9. **Forecasting**: 
   - Utilize the selected ARIMA model to forecast inflation expectations for the next 36 months.
   - Apply bootstrap techniques to generate additional forecasts, enhancing the robustness of the predictions.

10. **Visualization of Forecasts**: 
    - Plot the direct forecasts alongside the averaged bootstrapped forecasts to visually compare the results and assess the reliability of the predictions.

11. **Final Output**: 
    - Create a tsibble (tidy temporal data frame) to neatly present the forecasted values alongside their corresponding dates, facilitating easy interpretation.

## Results
The analysis culminates in a comprehensive summary of findings, including insights derived from the forecasts and potential implications for understanding inflation trends. The results highlight critical periods of change and provide guidance for economic stakeholders.

## Installation and Usage
To run this project locally, ensure you have R installed along with the required libraries. Clone the repository and follow these steps:
1. Install the necessary packages using `install.packages()`.
2. Load the project files in your R environment.
3. Execute the analysis scripts in sequence.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Conclusion
This project showcases a comprehensive approach to time series analysis and forecasting, contributing valuable insights into inflation expectations. The findings can serve as a reference for economists, policymakers, and financial analysts in understanding and predicting economic conditions.

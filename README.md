Time Series Forecasting of Inflation Expectations

Overview

This project analyzes and forecasts inflation expectation rates using time series analysis techniques in R. The aim is to understand trends in inflation expectations and provide forecasts for future periods.

Technologies Used

Programming Language: R
Libraries:
readr, dplyr, ggplot2 for data manipulation and visualization
tsibble, fable, feasts, forecast for time series analysis
tseries, lubridate for statistical tests and date handling
Data Source

The dataset is sourced from FRED and contains historical inflation expectation rates.

Key Steps in the Analysis

Loading Required Libraries: Necessary libraries for data handling, visualization, and forecasting.
Data Loading and Preprocessing: Read the dataset from a CSV file and reformat the date column. Create new variables, including the logarithm of inflation rates and seasonal differences to prepare for stationarity tests.
Initial Data Exploration: Display the first few observations and generate a time series plot to visualize trends.
Data Transformation: Perform transformations to stabilize variance and ensure stationarity.
Unit Root Tests: Conduct KPSS tests to check for stationarity of transformed series.
ACF and PACF Analysis: Generate ACF and PACF plots to identify AR and MA components for ARIMA modeling.
Model Fitting: Fit various ARIMA models and select the best model based on AICc and BIC criteria.
Model Diagnostics: Perform residual diagnostics to check for autocorrelation in residuals.
Forecasting: Use the best ARIMA model to forecast inflation expectations for the next 36 months and apply bootstrap techniques for additional forecasts.
Visualization of Forecasts: Plot direct forecasts alongside averaged bootstrapped forecasts for comparison.
Final Output: Create a tsibble to present forecasted values and corresponding dates.
Results

Summary of findings, including insights from forecasts and implications for understanding inflation trends.

Installation and Usage

Instructions on how to run the project locally, including any necessary dependencies.

License

Include licensing information (e.g., MIT License).

Conclusion

This project showcases a comprehensive approach to time series analysis and forecasting, contributing valuable insights into inflation expectations.

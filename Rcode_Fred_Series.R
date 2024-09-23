# Loading required libraries

library(readr)
library(tidyr)
library(ggplot2)
library(dplyr)
library(tsibble)
library(fable)
library(feasts)
library(forecast)
library(tseries)
library(lubridate)

# Loading and pre processing the data set
data1 <- read_csv("/Users/sreenathelisetty/Desktop/Forecasting Final exam/T5YIFRM.csv")

data1 <- data1 %>%
  rename(Value = T5YIFRM)

data1 <- data1 %>%
  mutate(
    Date = as.Date(DATE, format = "%Y-%m-%d"),
    FormattedDate = format(Date, "%Y %b")
  ) %>%
  select(-DATE) %>%
  rename(DATE = FormattedDate) %>%
  mutate(DATE = yearmonth(DATE))

data <- data1 %>%
  select(DATE, Value) %>%
  as_tsibble(index = DATE)

####### Question 1 #############

# Displaying the first 10 observations
head(data,10)

####### Question 2 #############

# Plotting the time series data
ggplot(data, aes(x = DATE, y = Value)) +
  geom_line() +
  labs(title = "Time Series Plot", y = "Inflation Expectation Rate (%)") +
  theme_minimal()

####### Question 3 #############

# Summarizing, and preparing the data
transformed_data <- data %>%
  transmute(
    Month = DATE,
    `Level of the series` = Value,
    `Log of the series` = log(Value),
    `Seasonal difference of the log` = difference(`Log of the series`, 12),  # Assuming monthly data
    `Double difference of the log` = difference(`Seasonal difference of the log`, 1)
  )

# Pivoting data to long format for plotting
data_long <- transformed_data %>%
  pivot_longer(
    cols = c(`Level of the series`, `Log of the series`, `Seasonal difference of the log`, `Double difference of the log`),
    names_to = "Type",
    values_to = "Value"
  ) %>%
  mutate(
    Type = factor(Type, levels = c(
      "Level of the series",
      "Log of the series",
      "Seasonal difference of the log",
      "Double difference of the log"
    ))
  )

# Plotting according to required criteria
ggplot(data_long, aes(x = Month, y = Value, color = Type)) +
  geom_line() +
  facet_grid(vars(Type), scales = "free_y") +
  labs(title = "Time Series Analysis with Multiple Transformations",
       x = "Date",
       y = "Value",
       color = "Transformation") +
  theme_minimal()

data %>%
  transmute(
    `Sales ($million)` = Value,
    `Log sales` = log(Value),
    `Annual change in log sales` = difference(log(Value), 12),
    `Doubly differenced log sales` = difference(difference(log(Value), 12), 1)
  ) %>%
  pivot_longer(-DATE, names_to="Type", values_to="Sales") %>%
  mutate(
    Type = factor(Type, levels = c(
      "Sales ($million)",
      "Log sales",
      "Annual change in log sales",
      "Doubly differenced log sales"))
  ) %>%
  ggplot(aes(x = DATE, y = Sales)) +
  geom_line() +
  facet_grid(vars(Type), scales = "free_y") +
  labs(title = "FRED Time series transformations", y = NULL)

####### Question 4 #############

#  Unit root test for Log series

log_series_tests <- transformed_data %>%
  features(`Log of the series`, unitroot_kpss)
log_series_tests

# Unit root test for Seasonal difference series
seasonal_diff_tests <- transformed_data %>%
  features(`Seasonal difference of the log`, unitroot_kpss)
seasonal_diff_tests

# Unit root test for Double difference series
double_diff_tests <- transformed_data %>%
  features(`Double difference of the log`, unitroot_kpss)
double_diff_tests

####### Question 5 #############

# ACF and PACF for log of the seasonal difference
Acf(transformed_data$`Seasonal difference of the log`, main="ACF of Seasonal Difference")
Pacf(transformed_data$`Seasonal difference of the log`, main="PACF of Seasonal Difference")

####### Question 6 #############

# ACF and PACF for log of the double difference
Acf(transformed_data$`Double difference of the log`, main="ACF of Double Difference")
Pacf(transformed_data$`Double difference of the log`, main="PACF of Double Difference")

####### Question 8 #############
# Fitting the selected models
model_fit <- data %>%
  model(
    arima110110 = ARIMA(Value ~ pdq(1, 1, 0) + PDQ(1, 1, 0)),
    arima011011 = ARIMA(Value ~ pdq(0, 1, 1) + PDQ(0, 1, 1)),
    stepwise = ARIMA(Value),
    search = ARIMA(Value, stepwise=FALSE),
    auto = ARIMA(Value, stepwise = FALSE, approx = FALSE)
  )
model_fit %>% pivot_longer(everything(), names_to = "Model name",
                           values_to = "Orders")
#Information criteria
glance(model_fit) %>% 
  arrange(AICc) %>% 
  select(.model, AICc, BIC)

####### Question 10 #############

# Output of best model based on AICc and BIC

model_fit %>%
  select(stepwise) %>%
  report()

####### Question 11 ############

model_fit %>%
  select(stepwise) %>%
  gg_tsresiduals()

####### Question 12 ###########

##Correlation test of the residuals for the best model
augment(model_fit) %>% features(.innov, ljung_box, lag=24, dof=4)

####### Question 13 ###########

###forecasting the data
forecast_data <- model_fit %>%
  select(stepwise) %>%
  forecast(h = 36)

forecast_plot <- forecast_data %>%
  autoplot(data) +
  labs(title = "Forecast for Next 3 Years Using Stepwise model",
       x = "Date",
       y = "Forecasted Value") +
  theme_minimal()
forecast_plot

####### Question 14 ###########
forecast_data 

####### Question 15 ###########

# Load necessary libraries
library(forecast)
library(tseries)

# Assuming data$log_GASREGM is your log transformed time series data
# First, convert it to a ts object if not already
time_series <- ts(data$Value, frequency = 12)  # assuming monthly data with annual frequency of 12

# Bootstrap the time series using the 'tsbootstrap' function from the 'tseries' package
bootstrap_samples <- tsbootstrap(time_series, n.sim = 1000, block.size = 24, type = "block")

bootstrap_samples
bootstrap_samples <- as.matrix(bootstrap_samples)
# Define a function to fit ARIMA model and forecast
fit_and_forecast <- function(sample) {
  fit <- Arima(sample, order=c(1,1,1), seasonal=c(1,1,1))  # Change these orders to your best model configuration
  forecast(fit, h = 12)  # You can adjust the horizon h as per your requirement
}

# Apply the fit_and_forecast function to each bootstrap sample
forecasts <- apply(bootstrap_samples, 2, fit_and_forecast)
print(length(forecasts))
print(class(forecasts))
print(lapply(forecasts, class))
# To visualize, let's plot all forecasts (overlaying them might be messy with 1000 lines, so consider summary measures or subsets)
plot(forecast:::autoplot.forecast(forecasts[[1]]), main = "Bootstrapped ARIMA Forecasts")





fit_and_forecast <- function(sample) {
  ts_sample <- ts(sample, frequency = 12)  # Ensure it's a ts object, adjust frequency as necessary
  fit <- Arima(ts_sample, order=c(1,1,1), seasonal=c(1,1,1))  # Use your best model settings
  forecast(fit, h = 12)  # Forecast for 12 periods
}

# Apply the fit_and_forecast function to each column (time series) in the bootstrap samples
forecasts <- apply(bootstrap_samples, 2, fit_and_forecast)





# Assuming 'best_model' is already fitted to your entire dataset
direct_forecast <- forecast(best_model, h = 36)

# Aggregate the bootstrapped forecasts
# Assuming each forecast in 'forecasts' is of length 36 months
mean_forecasts <- matrix(nrow = 36, ncol = length(forecasts))
for (i in 1:length(forecasts)) {
  mean_forecasts[, i] <- forecasts[[i]]$mean
}
average_forecast <- rowMeans(mean_forecasts, na.rm = TRUE)  # Calculate mean across each time point

# Create the plot
plot(direct_forecast, main = "Direct vs. Bootstrapped Forecasts", ylab = "Forecast", xlab = "Time", col = "blue")
lines(average_forecast, col = "red", lty = 2, type = 'l')  # Add the averaged bootstrapped forecast
legend("topright", legend = c("Direct Forecast", "Averaged Bootstrapped Forecast"), col = c("blue", "red"), lty = 1:2, cex = 0.8)







library(tsibble)

# Assuming 'average_forecast' holds your averaged bootstrapped forecasts
# and assuming your original time series has a monthly frequency and starts at a known date

# Create a sequence of future dates for the forecast
start_date <- as.Date("2003-01-01")  # Adjust this start date to match your time series end date + 1 month
forecast_dates <- seq.Date(start_date, by = "month", length.out = 36)

# Create a tsibble
forecast_tsibble <- tsibble(
  Date = forecast_dates,
  Forecast = average_forecast,
  .rows = 36
)

# Print the tsibble
print(forecast_tsibble)


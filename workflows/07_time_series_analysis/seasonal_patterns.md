# Vibe Workflow: Time Series Analysis: Seasonal Patterns

**Goal:** Uncover temporal patterns in ecological datasets to reveal cycles, shifts, and trends.

**Vibe:** Temporal analysis to understand time-based ecological responses and dynamics.

**Core Packages:** `tidyverse`, `lubridate`, `forecast`, `bcp`, `mgcv`

---

## 🪴 1. Project Setup & Vibe Check

Time series analysis in ecology reveals the rhythms of life - from daily activity patterns to seasonal migrations to climate-driven long-term trends. We'll explore multiple approaches: classical decomposition to separate trend/seasonal/residual components, change point analysis to detect regime shifts, and smooth trend fitting to model nonlinear temporal patterns. Each method illuminates different aspects of temporal ecological patterns.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Load the following libraries: tidyverse, lubridate, forecast, bcp, mgcv, viridis, here.
> - Set a random seed to 123.
> - Create output directories for figures and tables in workflows/07_time_series_analysis/3_output if they do not exist, using here().

---

## 🧹 2. Data Wrangling: The Tidy Up

We prepare time series data with proper temporal structure, ensuring dates are correctly formatted and missing time points are identified. We create multiple time series representing different ecological processes: species abundance, phenological stages, and environmental drivers. This demonstrates common patterns in ecological monitoring data.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Load the demo time series dataset from data/raw/demo_time_series.csv.
> - Parse dates, extract month, season, day of year, and convert phenology stages to numeric codes.
> - Create an extended synthetic dataset with monthly data from 2020-2023, including temperature, species abundance, and spring onset day, with seasonal and trend components.
> - Print data overviews and check for missing time points in the original dataset.

---

## 🔬 3. The Analysis: Asking Our Questions

Time series analysis reveals multiple temporal patterns: seasonal cycles, long-term trends, and abrupt changes. We apply classical decomposition to separate these components, use change point analysis to detect regime shifts, and fit smooth trends to capture nonlinear temporal dynamics. Each approach answers different ecological questions about temporal patterns.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - For a selected species and site, extract the abundance time series, create a ts object, and perform classical decomposition (trend, seasonal, residual). Summarize the decomposition results.
> - Use Bayesian change point analysis (bcp) to detect changes in mean temperature in the extended dataset. Summarize and count likely and major change points.
> - Summarize seasonal patterns by species and month, including mean and standard deviation of abundance and phenology, and calculate standard errors.
> - Analyze phenological timing for key stages (bud_break, full_leaf, senescence, growth_initiation, flowering) by species, summarizing mean and earliest day of year.

---

## 📊 4. Visualization: Seeing the Story

Time series visualization requires showing temporal patterns at multiple scales: raw data, seasonal cycles, long-term trends, and change points. We create a comprehensive set of plots that reveal the temporal story hidden in ecological data, from daily rhythms to multi-year trends.

### **Visualization To-Do List**

- [ ] **Time Series Decomposition Plots**
  - [ ] Create stacked plots showing observed, trend, seasonal, and residual components
  - [ ] Use consistent time axis across all panels
  - [ ] Apply appropriate scaling for each component
  - [ ] Include informative panel labels
  - [ ] Use steelblue color for consistency

- [ ] **Seasonal Pattern Visualization**
  - [ ] Plot monthly abundance patterns by species
  - [ ] Add error bars for uncertainty
  - [ ] Use viridis color palette for species
  - [ ] Format month labels clearly
  - [ ] Include trend lines connecting points

- [ ] **Change Point Analysis Plots**
  - [ ] Show original time series with change point probabilities
  - [ ] Use dual y-axes for different scales
  - [ ] Highlight major change points with markers
  - [ ] Apply contrasting colors for different data types
  - [ ] Include probability threshold indicators

- [ ] **Phenological Timing Plots**
  - [ ] Create timeline plots showing event timing
  - [ ] Use horizontal error bars for date ranges
  - [ ] Color by species or event type
  - [ ] Format day-of-year axis with month labels
  - [ ] Sort events by timing for clarity

- [ ] **Smooth Trend Visualization**
  - [ ] Plot GAM predictions with confidence bands
  - [ ] Facet by species or habitat
  - [ ] Use consistent color schemes
  - [ ] Format date axes appropriately
  - [ ] Include model uncertainty

- [ ] **Long-term Trend Analysis**
  - [ ] Create multi-panel plots for different variables
  - [ ] Add regression lines with confidence intervals
  - [ ] Use consistent styling across panels
  - [ ] Include trend statistics in captions
  - [ ] Apply appropriate axis transformations

- [ ] **Figure Styling Standards**
  - [ ] Use colorblind-friendly palettes throughout
  - [ ] Apply consistent font sizes (title 14, subtitle 12)
  - [ ] Format date axes with appropriate breaks
  - [ ] Position legends optimally
  - [ ] Include informative captions
  - [ ] Save with descriptive filenames
  - [ ] Use 300 DPI resolution for publication quality

```r
# Plot 1: Time series decomposition
decomp_plot <- decomp_data %>%
  select(date, observed, trend, seasonal, residual) %>%
  pivot_longer(-date, names_to = "component", values_to = "value") %>%
  mutate(
    component = factor(component, 
                      levels = c("observed", "trend", "seasonal", "residual"),
                      labels = c("Observed", "Trend", "Seasonal", "Residual"))
  ) %>%
  ggplot(aes(x = date, y = value)) +
  geom_line(color = "steelblue", size = 1) +
  facet_wrap(~ component, scales = "free_y", ncol = 1) +
  labs(
    title = "Time Series Decomposition: Quercus alba Abundance",
    subtitle = "Additive decomposition into trend, seasonal, and residual components",
    x = "Date",
    y = "Abundance / Component Value",
    caption = "Classical decomposition reveals underlying temporal patterns"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold")
  )

print(decomp_plot)

# Plot 2: Seasonal patterns by species
seasonal_plot <- seasonal_patterns %>%
  ggplot(aes(x = month_numeric, y = mean_abundance, color = species)) +
  geom_line(size = 1.2, alpha = 0.8) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = mean_abundance - se_abundance,
                    ymax = mean_abundance + se_abundance),
                width = 0.2, alpha = 0.7) +
  scale_color_viridis_d(option = "plasma", name = "Species") +
  scale_x_continuous(breaks = 1:12, 
                     labels = month.abb) +
  labs(
    title = "Seasonal Abundance Patterns",
    subtitle = "Mean abundance by month with standard error bars",
    x = "Month",
    y = "Mean Abundance",
    caption = "Different species show distinct seasonal activity patterns"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    legend.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(seasonal_plot)

# Plot 3: Change point detection
change_point_plot <- change_points %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = temperature), color = "steelblue", size = 1) +
  geom_line(aes(y = change_prob * max(temperature)), 
            color = "red", alpha = 0.7, size = 1) +
  geom_point(data = filter(change_points, major_change),
             aes(y = temperature), color = "red", size = 3) +
  scale_y_continuous(
    name = "Temperature (°C)",
    sec.axis = sec_axis(~ . / max(change_points$temperature), 
                       name = "Change Point Probability")
  ) +
  labs(
    title = "Change Point Detection in Temperature Time Series",
    subtitle = "Red line shows probability of regime change; red points indicate major changes",
    x = "Date",
    caption = "Bayesian change point analysis identifies abrupt shifts in mean temperature"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title.y.right = element_text(color = "red"),
    axis.text.y.right = element_text(color = "red")
  )

print(change_point_plot)

# Plot 4: Phenological timing
phenology_plot <- phenology_timing %>%
  ggplot(aes(x = mean_day, y = reorder(paste(species, phenology_stage), mean_day))) +
  geom_segment(aes(xend = mean_day, y = reorder(paste(species, phenology_stage), mean_day), 
                   yend = reorder(paste(species, phenology_stage), mean_day)), 
               x = 0, alpha = 0.3) +
  geom_point(aes(color = species), size = 4) +
  geom_errorbar(aes(xmin = earliest_day, xmax = latest_day, color = species),
                width = 0.3, alpha = 0.7) +
  scale_color_viridis_d(option = "viridis", name = "Species") +
  scale_x_continuous(breaks = c(1, 60, 121, 182, 244, 305, 365),
                     labels = c("Jan", "Mar", "May", "Jul", "Sep", "Nov", "Dec")) +
  labs(
    title = "Phenological Event Timing",
    subtitle = "Mean timing with range of observed dates",
    x = "Day of Year",
    y = "Species and Phenological Stage",
    caption = "Error bars show earliest to latest observed dates for each event"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(size = 9)
  )

print(phenology_plot)

# Plot 5: GAM smooth trends
gam_plot <- prediction_data %>%
  filter(species %in% c("Quercus_alba", "Carex_pensylvanica")) %>%
  mutate(
    date_approx = as.Date(paste("2023", day_of_year), format = "%Y %j")
  ) %>%
  ggplot(aes(x = date_approx, y = predicted_abundance, color = habitat)) +
  geom_line(size = 1.2) +
  facet_wrap(~ species, scales = "free_y") +
  scale_color_viridis_d(option = "plasma", name = "Habitat") +
  scale_x_date(date_labels = "%b", date_breaks = "2 months") +
  labs(
    title = "Smooth Abundance Trends from GAM Models",
    subtitle = "Predicted seasonal patterns by habitat and species",
    x = "Month",
    y = "Predicted Abundance",
    caption = "Smooth splines reveal nonlinear seasonal patterns"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold", style = "italic"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(gam_plot)

# Plot 6: Long-term trends
trend_plot <- extended_data %>%
  select(date, temperature_c, species_abundance, spring_onset_day) %>%
  pivot_longer(-date, names_to = "variable", values_to = "value") %>%
  mutate(
    variable = case_when(
      variable == "temperature_c" ~ "Temperature (°C)",
      variable == "species_abundance" ~ "Species Abundance", 
      variable == "spring_onset_day" ~ "Spring Onset (Day of Year)"
    )
  ) %>%
  ggplot(aes(x = date, y = value)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "red", alpha = 0.3) +
  facet_wrap(~ variable, scales = "free_y", ncol = 1) +
  labs(
    title = "Long-term Environmental and Biological Trends",
    subtitle = "Linear trends fitted to 4-year time series",
    x = "Date",
    y = "Value",
    caption = "Red lines show linear trends with 95% confidence intervals"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold")
  )

print(trend_plot)

# Save all plots
ggsave(here("workflows", "07_time_series_analysis", "3_output", "figures", "time_series_decomposition.png"),
       decomp_plot, width = 10, height = 12, dpi = 300)

ggsave(here("workflows", "07_time_series_analysis", "3_output", "figures", "seasonal_patterns.png"),
       seasonal_plot, width = 10, height = 6, dpi = 300)

ggsave(here("workflows", "07_time_series_analysis", "3_output", "figures", "change_point_analysis.png"),
       change_point_plot, width = 12, height = 6, dpi = 300)

ggsave(here("workflows", "07_time_series_analysis", "3_output", "figures", "phenology_timing.png"),
       phenology_plot, width = 10, height = 8, dpi = 300)

ggsave(here("workflows", "07_time_series_analysis", "3_output", "figures", "gam_smooth_trends.png"),
       gam_plot, width = 12, height = 6, dpi = 300)

ggsave(here("workflows", "07_time_series_analysis", "3_output", "figures", "long_term_trends.png"),
       trend_plot, width = 10, height = 10, dpi = 300)

# Combined comprehensive figure
comprehensive_ts <- (decomp_plot + seasonal_plot) / 
                   (change_point_plot + phenology_plot) +
  plot_annotation(
    title = "Comprehensive Time Series Analysis of Ecological Data",
    subtitle = "Decomposition, seasonality, change points, and phenological patterns",
    caption = "Vibe Coding for Ecology • Temporal Pattern Analysis"
  )

ggsave(here("workflows", "07_time_series_analysis", "3_output", "figures", "comprehensive_time_series.png"),
       comprehensive_ts, width = 16, height = 12, dpi = 300)
```

---

## 🌐 5. Autocorrelation Checks

Autocorrelation checks will help reveal the dependence between observations at different time lags in our time series.

```r
# Autocorrelation and Partial Autocorrelation
print("Autocorrelation for Quercus_alba")
acf(quercus_timeseries)
pacf(quercus_timeseries)
```

---

## 🧊 6. ARIMA/State-Space Models

In this section, we will fit ARIMA models to provide forecasts based on past values in the time series.

```r
# Fit ARIMA model using auto.arima
arima_model <- auto.arima(quercus_timeseries)
summary(arima_model)

# Forecasting with ARIMA
forecasted_values <- forecast(arima_model, h=12)
plot(forecasted_values)
```

---

## 🔮 7. Forecasting Ecological Trends

Forecasting is crucial for projecting future ecological conditions based on current trends.

```r
# Generate forecast for species abundance
species_forecast <- forecast(arima_model, h=24)
plot(species_forecast)
```

---

## 🌱 8. Best Practices for Irregular Sampling

Irregular sampling can complicate time series analysis. Here are some strategies to manage it:

- **Interpolation**: Use methods like linear or spline interpolation to estimate values at missing timestamps.
- **Aggregation**: Aggregate data to a consistent temporal resolution, like daily or monthly.
- **Handling Missing Data**: Use imputation techniques or integrate missing data analysis in model fitting.

---

## 🧬 9. Reproducibility Check

Time series analysis involves complex temporal modeling and multiple analytical approaches. We save all model objects, decomposition results, and trend analyses to ensure reproducibility. The temporal patterns identified here can inform future sampling design and hypothesis testing.

```r
# Save time series objects and results
saveRDS(decomposition, 
        here("workflows", "07_time_series_analysis", "3_output", "tables", "ts_decomposition.rds"))
saveRDS(temp_bcp, 
        here("workflows", "07_time_series_analysis", "3_output", "tables", "change_point_model.rds"))
saveRDS(gam_model, 
        here("workflows", "07_time_series_analysis", "3_output", "tables", "gam_seasonal_model.rds"))

# Save processed datasets
write_csv(decomp_data, 
          here("workflows", "07_time_series_analysis", "3_output", "tables", "decomposition_components.csv"))
write_csv(seasonal_patterns, 
          here("workflows", "07_time_series_analysis", "3_output", "tables", "seasonal_pattern_summary.csv"))
write_csv(phenology_timing, 
          here("workflows", "07_time_series_analysis", "3_output", "tables", "phenological_timing.csv"))
write_csv(trend_analysis, 
          here("workflows", "07_time_series_analysis", "3_output", "tables", "long_term_trends.csv"))

# Save change point results
write_csv(change_points, 
          here("workflows", "07_time_series_analysis", "3_output", "tables", "change_point_probabilities.csv"))

# Create comprehensive time series analysis report
ts_analysis_report <- list(
  data_structure = list(
    total_observations = nrow(time_series_data),
    date_range = paste(min(time_series_data$date), "to", max(time_series_data$date)),
    species_count = length(unique(time_series_data$species)),
    extended_data_years = length(unique(extended_data$year)),
    missing_timepoints = missing_dates
  ),
  decomposition_results = list(
    seasonal_variance = var(decomp_data$seasonal, na.rm = TRUE),
    trend_variance = var(decomp_data$trend, na.rm = TRUE),
    residual_variance = var(decomp_data$residual, na.rm = TRUE),
    seasonal_strength = var(decomp_data$seasonal, na.rm = TRUE) / var(decomp_data$observed, na.rm = TRUE)
  ),
  change_points = list(
    n_likely_changes = sum(change_points$likely_change),
    n_major_changes = sum(change_points$major_change),
    most_likely_change_date = change_points$date[which.max(change_points$change_prob)]
  ),
  phenology_patterns = list(
    earliest_event = min(phenology_timing$mean_day),
    latest_event = max(phenology_timing$mean_day),
    longest_duration = max(phenology_timing$duration_days),
    species_with_longest_season = phenology_timing$species[which.max(phenology_timing$duration_days)]
  ),
  trend_analysis = list(
    temperature_trend_per_year = trend_analysis$temp_trend[nrow(trend_analysis)],
    abundance_trend_per_year = trend_analysis$abundance_trend[nrow(trend_analysis)],
    phenology_shift_days_per_year = trend_analysis$phenology_trend[nrow(trend_analysis)]
  )
)

saveRDS(ts_analysis_report, 
        here("workflows", "07_time_series_analysis", "3_output", "tables", "time_series_analysis_report.rds"))

# Print comprehensive summary
cat("=== Time Series Analysis Summary ===\n")
cat("Data structure:\n")
cat("  Total observations:", ts_analysis_report$data_structure$total_observations, "\n")
cat("  Date range:", ts_analysis_report$data_structure$date_range, "\n")
cat("  Species analyzed:", ts_analysis_report$data_structure$species_count, "\n")

cat("\nDecomposition results:\n")
cat("  Seasonal strength:", round(ts_analysis_report$decomposition_results$seasonal_strength, 3), "\n")
cat("  Trend variance:", round(ts_analysis_report$decomposition_results$trend_variance, 2), "\n")

cat("\nChange point analysis:\n")
cat("  Likely change points:", ts_analysis_report$change_points$n_likely_changes, "\n")
cat("  Major change points:", ts_analysis_report$change_points$n_major_changes, "\n")

cat("\nPhenological patterns:\n")
cat("  Earliest event (day of year):", round(ts_analysis_report$phenology_patterns$earliest_event), "\n")
cat("  Latest event (day of year):", round(ts_analysis_report$phenology_patterns$latest_event), "\n")
cat("  Longest season duration:", ts_analysis_report$phenology_patterns$longest_duration, "days\n")

cat("\nLong-term trends (per year):\n")
cat("  Temperature change:", round(ts_analysis_report$trend_analysis$temperature_trend_per_year, 2), "°C\n")
cat("  Abundance change:", round(ts_analysis_report$trend_analysis$abundance_trend_per_year, 2), "individuals\n")
cat("  Phenology shift:", round(ts_analysis_report$trend_analysis$phenology_shift_days_per_year, 1), "days\n")

# Record session information for reproducibility
sessionInfo()
```

---

## Summary

This workflow demonstrates comprehensive time series analysis for ecological data:

- **Classical Decomposition**: Separated temporal patterns into trend, seasonal, and residual components
- **Change Point Detection**: Identified regime shifts using Bayesian methods
- **Seasonal Analysis**: Quantified species-specific seasonal patterns
- **Phenological Timing**: Analyzed timing and duration of life cycle events
- **Smooth Trend Modeling**: Used GAMs to model nonlinear seasonal patterns
- **Long-term Trends**: Detected directional changes over multiple years

**Key findings:** Strong seasonal patterns dominate most species, phenological timing varies substantially among species, and long-term trends suggest both climate warming and phenological advancement.

**Next steps:** These methods can be extended with spectral analysis for periodic patterns, state-space models for hidden states, or wavelet analysis for time-frequency decomposition.

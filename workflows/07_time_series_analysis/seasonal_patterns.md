# Vibe Workflow: Seasonal Patterns in Ecological Time Series

**Goal:** Analyze temporal patterns in ecological data to understand seasonal cycles, phenological shifts, and long-term trends using time series analysis techniques.

**Vibe:** Time is the most universal dimension in ecology. Seasonal patterns, phenological timing, and long-term trends tell the story of how life responds to environmental rhythms and changing conditions. Every ecological dataset is a time series waiting to reveal its temporal secrets.

**Core Packages:** `tidyverse`, `lubridate`, `forecast`, `bcp`, `mgcv`

---

## 🪴 1. Project Setup & Vibe Check

Time series analysis in ecology reveals the rhythms of life - from daily activity patterns to seasonal migrations to climate-driven long-term trends. We'll explore multiple approaches: classical decomposition to separate trend/seasonal/residual components, change point analysis to detect regime shifts, and smooth trend fitting to model nonlinear temporal patterns. Each method illuminates different aspects of temporal ecological patterns.

```r
# Load essential libraries for time series analysis
library(tidyverse)  # For data manipulation and visualization
library(lubridate)  # For date/time handling
library(forecast)   # For time series decomposition and forecasting
library(bcp)        # For Bayesian change point analysis
library(mgcv)       # For smooth trend modeling with GAMs
library(viridis)    # For colorblind-friendly palettes
library(here)       # For robust file paths

# Set seed for reproducibility
set.seed(123)

# Create output directories if they don't exist
if (!dir.exists(here("workflows", "07_time_series_analysis", "3_output", "figures"))) {
  dir.create(here("workflows", "07_time_series_analysis", "3_output", "figures"), recursive = TRUE)
}
if (!dir.exists(here("workflows", "07_time_series_analysis", "3_output", "tables"))) {
  dir.create(here("workflows", "07_time_series_analysis", "3_output", "tables"), recursive = TRUE)
}
```

---

## 🧹 2. Data Wrangling: The Tidy Up

We prepare time series data with proper temporal structure, ensuring dates are correctly formatted and missing time points are identified. We create multiple time series representing different ecological processes: species abundance, phenological stages, and environmental drivers. This demonstrates common patterns in ecological monitoring data.

```r
# Load the demo time series dataset
time_series_data <- read_csv(here("data", "raw", "demo_time_series.csv")) %>%
  mutate(
    date = as.Date(date),
    month = month(date, label = TRUE),
    season = case_when(
      month %in% c("Dec", "Jan", "Feb") ~ "Winter",
      month %in% c("Mar", "Apr", "May") ~ "Spring",
      month %in% c("Jun", "Jul", "Aug") ~ "Summer",
      month %in% c("Sep", "Oct", "Nov") ~ "Fall"
    ),
    day_of_year = yday(date),
    phenology_numeric = case_when(
      phenology_stage == "dormant" ~ 0,
      phenology_stage == "bud_break" ~ 1,
      phenology_stage == "growth_initiation" ~ 1,
      phenology_stage == "leaf_emergence" ~ 2,
      phenology_stage == "active_growth" ~ 2,
      phenology_stage == "full_leaf" ~ 3,
      phenology_stage == "flowering" ~ 4,
      phenology_stage == "seed_set" ~ 5,
      phenology_stage == "seed_dispersal" ~ 4,
      phenology_stage == "senescence" ~ 2,
      phenology_stage == "senescence_begin" ~ 2,
      phenology_stage == "dormancy_prep" ~ 1
    )
  )

# Create additional synthetic time series for demonstration
# Multi-year data with trends and noise
extended_data <- tibble(
  date = seq(as.Date("2020-01-15"), as.Date("2023-12-15"), by = "month"),
  year = year(date),
  month = month(date),
  day_of_year = yday(date)
) %>%
  mutate(
    # Seasonal temperature pattern with warming trend
    temperature_c = 15 + 10 * sin(2 * pi * (day_of_year - 80) / 365) + 
                   0.5 * (year - 2020) + rnorm(n(), 0, 2),
    
    # Species abundance with seasonal cycle and population trend
    species_abundance = pmax(0, 
      20 + 15 * sin(2 * pi * (day_of_year - 120) / 365) + 
      -1.5 * (year - 2020) + rnorm(n(), 0, 3)
    ),
    
    # Phenological timing shift (earlier spring events over time)
    spring_onset_day = 80 - 2 * (year - 2020) + rnorm(n(), 0, 5),
    
    season = case_when(
      month %in% c(12, 1, 2) ~ "Winter",
      month %in% c(3, 4, 5) ~ "Spring", 
      month %in% c(6, 7, 8) ~ "Summer",
      month %in% c(9, 10, 11) ~ "Fall"
    )
  )

# Quick exploration of temporal patterns
glimpse(time_series_data)
glimpse(extended_data)

cat("Time series data overview:\n")
cat("Date range:", min(time_series_data$date), "to", max(time_series_data$date), "\n")
cat("Species:", length(unique(time_series_data$species)), "\n")
cat("Sites:", length(unique(time_series_data$site_id)), "\n")
cat("Extended data range:", min(extended_data$date), "to", max(extended_data$date), "\n")

# Check for missing time points
missing_dates <- time_series_data %>%
  complete(date, species, site_id) %>%
  filter(is.na(abundance)) %>%
  nrow()

cat("Missing time points:", missing_dates, "\n")
```

---

## 🔬 3. The Analysis: Asking Our Questions

Time series analysis reveals multiple temporal patterns: seasonal cycles, long-term trends, and abrupt changes. We apply classical decomposition to separate these components, use change point analysis to detect regime shifts, and fit smooth trends to capture nonlinear temporal dynamics. Each approach answers different ecological questions about temporal patterns.

```r
# Analysis 1: Classical time series decomposition
# Focus on one species for detailed decomposition
quercus_ts <- time_series_data %>%
  filter(species == "Quercus_alba", site_id == "Site_01") %>%
  arrange(date) %>%
  pull(abundance)

# Create time series object
quercus_timeseries <- ts(quercus_ts, frequency = 12, start = c(2023, 1))

# Decompose the time series
decomposition <- decompose(quercus_timeseries, type = "additive")

# Extract components
decomp_data <- tibble(
  date = time_series_data %>% 
    filter(species == "Quercus_alba", site_id == "Site_01") %>% 
    arrange(date) %>% 
    pull(date),
  observed = as.numeric(decomposition$x),
  trend = as.numeric(decomposition$trend),
  seasonal = as.numeric(decomposition$seasonal),
  residual = as.numeric(decomposition$random)
) %>%
  filter(!is.na(trend))  # Remove NAs from trend estimation

print("Time series decomposition summary:")
print(summary(decomp_data))

# Analysis 2: Change point detection on extended data
# Detect changes in mean temperature
temp_bcp <- bcp(extended_data$temperature_c, mcmc = 5000, burnin = 1000)

# Extract probability of change points
change_points <- tibble(
  date = extended_data$date,
  temperature = extended_data$temperature_c,
  change_prob = temp_bcp$prob.mean
) %>%
  mutate(
    likely_change = change_prob > 0.5,
    major_change = change_prob > 0.8
  )

cat("Change point analysis results:\n")
cat("Likely change points (>50%):", sum(change_points$likely_change), "\n")
cat("Major change points (>80%):", sum(change_points$major_change), "\n")

# Analysis 3: Seasonal pattern analysis
seasonal_patterns <- time_series_data %>%
  group_by(species, month) %>%
  summarise(
    mean_abundance = mean(abundance, na.rm = TRUE),
    sd_abundance = sd(abundance, na.rm = TRUE),
    mean_phenology = mean(phenology_numeric, na.rm = TRUE),
    n_observations = n(),
    .groups = 'drop'
  ) %>%
  mutate(
    month_numeric = as.numeric(month),
    se_abundance = sd_abundance / sqrt(n_observations)
  )

print("Seasonal patterns by species:")
print(seasonal_patterns)

# Analysis 4: Phenological timing analysis
phenology_timing <- time_series_data %>%
  filter(phenology_stage %in% c("bud_break", "full_leaf", "senescence", "growth_initiation", "flowering")) %>%
  group_by(species, phenology_stage) %>%
  summarise(
    mean_day = mean(day_of_year),
    earliest_day = min(day_of_year),
    latest_day = max(day_of_year),
    duration_days = latest_day - earliest_day,
    .groups = 'drop'
  ) %>%
  arrange(species, mean_day)

print("Phenological timing analysis:")
print(phenology_timing)

# Analysis 5: Smooth trend modeling with GAM
# Model species abundance as smooth function of day of year
gam_model <- gam(abundance ~ s(day_of_year, k = 8) + habitat + species, 
                 data = time_series_data, 
                 family = poisson)

gam_summary <- summary(gam_model)
print("GAM model summary:")
print(gam_summary)

# Generate predictions for smooth visualization
prediction_data <- expand_grid(
  day_of_year = 1:365,
  habitat = unique(time_series_data$habitat),
  species = unique(time_series_data$species)
) %>%
  mutate(
    predicted_abundance = predict(gam_model, newdata = ., type = "response")
  )

# Analysis 6: Long-term trend analysis
trend_analysis <- extended_data %>%
  group_by(year) %>%
  summarise(
    mean_temp = mean(temperature_c),
    mean_abundance = mean(species_abundance),
    spring_onset = mean(spring_onset_day),
    .groups = 'drop'
  ) %>%
  mutate(
    temp_trend = (mean_temp - mean_temp[1]) / (year - year[1]),
    abundance_trend = (mean_abundance - mean_abundance[1]) / (year - year[1]),
    phenology_trend = (spring_onset - spring_onset[1]) / (year - year[1])
  )

print("Long-term trends (per year):")
print(trend_analysis)
```

---

## 📊 4. Visualization: Seeing the Story

Time series visualization requires showing temporal patterns at multiple scales: raw data, seasonal cycles, long-term trends, and change points. We create a comprehensive set of plots that reveal the temporal story hidden in ecological data, from daily rhythms to multi-year trends.

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

## 🧬 5. Reproducibility Check

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

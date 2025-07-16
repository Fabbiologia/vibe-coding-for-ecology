# Vibe Workflow: Spatial Analysis Essentials

**Goal:** Conduct geostatistical analyses, variogram modeling, spatial regressions, and mapping to understand spatial patterns in ecological data.

**Vibe:** Integrate GIS capabilities with statistical rigor to analyze spatial patterns and dependencies in ecological systems.

**Core Packages:** `sf`, `gstat`, `sp`, `tmap`, `raster`, `spatstat`

---

## 🪴 Project Setup & Vibe Check

This section establishes our spatial analysis foundation. We load essential packages for spatial data handling, geostatistics, and visualization. The `sf` package provides modern spatial data manipulation, `gstat` enables geostatistical modeling, and `tmap` creates beautiful thematic maps.

```r
# Load essential libraries for spatial analysis
library(sf)          # Modern spatial data handling
library(gstat)       # Geostatistical modeling
library(sp)          # Spatial objects and methods
library(tmap)        # Thematic mapping
library(raster)      # Raster data operations
library(spatstat)    # Spatial point pattern analysis
library(tidyverse)   # Data manipulation
library(here)        # Robust file paths
library(viridis)     # Color palettes

# Set seed for reproducibility
set.seed(123)

# Create output directories
if (!dir.exists(here("workflows", "08_spatial_analysis", "3_output", "figures"))) {
  dir.create(here("workflows", "08_spatial_analysis", "3_output", "figures"), recursive = TRUE)
}
if (!dir.exists(here("workflows", "08_spatial_analysis", "3_output", "tables"))) {
  dir.create(here("workflows", "08_spatial_analysis", "3_output", "tables"), recursive = TRUE)
}
```

---

## 🧹 Data Preparation & Wrangling: Spatial Data Setup

Here we prepare spatial datasets for analysis. We create or load spatial point data with environmental variables and examine spatial patterns. This foundation enables geostatistical modeling and spatial regression analysis.

```r
# Create simulated spatial ecological data
# Generate random sampling points across a landscape
n_sites <- 50
coords <- data.frame(
  x = runif(n_sites, min = 0, max = 100),
  y = runif(n_sites, min = 0, max = 100)
)

# Create environmental gradients
spatial_data <- coords %>%
  mutate(
    site_id = paste0("Site_", 1:n_sites),
    elevation = 100 + 0.5 * x + 0.3 * y + rnorm(n_sites, 0, 10),
    soil_ph = 6.5 + 0.01 * x - 0.005 * y + rnorm(n_sites, 0, 0.5),
    precipitation = 800 + 2 * y + rnorm(n_sites, 0, 50)
  ) %>%
  # Add spatial autocorrelation to species abundance
  mutate(
    species_abundance = 10 + 0.1 * elevation + 2 * soil_ph + 
      0.01 * precipitation + rnorm(n_sites, 0, 3)
  ) %>%
  # Ensure realistic values
  mutate(
    species_abundance = pmax(0, species_abundance),
    soil_ph = pmax(4, pmin(8, soil_ph))
  )

# Convert to sf object
spatial_sf <- st_as_sf(spatial_data, coords = c("x", "y"), crs = 4326)

# Quick data exploration
glimpse(spatial_data)
cat("Number of sampling sites:", nrow(spatial_data), "\n")
cat("Elevation range:", range(spatial_data$elevation), "\n")
cat("Species abundance range:", range(spatial_data$species_abundance), "\n")
```

---

## 🔬 3. Geostatistics & Variograms: Modeling Spatial Dependencies

This section explores spatial autocorrelation patterns and models them using variograms. We calculate empirical variograms, fit theoretical models, and perform kriging interpolation to understand spatial dependencies in ecological data.

```r
# Convert to spatial points for gstat
coordinates(spatial_data) <- ~ x + y

# Calculate empirical variogram for species abundance
variogram_abundance <- variogram(species_abundance ~ 1, spatial_data)

# Fit theoretical variogram model
variogram_model <- fit.variogram(variogram_abundance, 
                                model = vgm("Sph"))  # Spherical model

# Display variogram parameters
print(variogram_model)

# Calculate variogram with environmental covariates
variogram_residuals <- variogram(species_abundance ~ elevation + soil_ph, 
                               spatial_data)
variogram_model_residuals <- fit.variogram(variogram_residuals, 
                                         model = vgm("Sph"))

# Perform ordinary kriging
kriging_grid <- expand.grid(
  x = seq(0, 100, by = 2),
  y = seq(0, 100, by = 2)
)
coordinates(kriging_grid) <- ~ x + y
gridded(kriging_grid) <- TRUE

# Ordinary kriging
kriging_result <- krige(species_abundance ~ 1, 
                       spatial_data, 
                       kriging_grid, 
                       model = variogram_model)

# Universal kriging with environmental covariates
kriging_universal <- krige(species_abundance ~ elevation + soil_ph, 
                          spatial_data, 
                          kriging_grid, 
                          model = variogram_model_residuals)

# Convert kriging results to dataframe for visualization
kriging_df <- as.data.frame(kriging_result)
kriging_universal_df <- as.data.frame(kriging_universal)
```

---

## 🔄 4. Spatial Regressions: Modeling with Spatial Structure

Here we implement spatial regression models that account for spatial autocorrelation. We compare ordinary least squares with spatially explicit models to understand how spatial structure affects ecological relationships.

```r
# Convert back to regular dataframe for regression
spatial_df <- as.data.frame(spatial_data)

# Ordinary least squares regression (ignoring spatial structure)
ols_model <- lm(species_abundance ~ elevation + soil_ph + precipitation, 
               data = spatial_df)

# Check for spatial autocorrelation in residuals
coords_matrix <- coordinates(spatial_data)
distances <- as.matrix(dist(coords_matrix))
inv_distances <- 1 / distances
diag(inv_distances) <- 0

# Moran's I test for spatial autocorrelation
library(spdep)
# Create spatial weights matrix
coords_sp <- coordinates(spatial_data)
knn_weights <- knn2nb(knearneigh(coords_sp, k = 5))
spatial_weights <- nb2listw(knn_weights, style = "W")

# Test spatial autocorrelation in OLS residuals
moran_test <- moran.test(residuals(ols_model), spatial_weights)
print(moran_test)

# Spatial lag model
spatial_lag <- lagsarlm(species_abundance ~ elevation + soil_ph + precipitation, 
                       data = spatial_df, 
                       listw = spatial_weights)

# Spatial error model
spatial_error <- errorsarlm(species_abundance ~ elevation + soil_ph + precipitation, 
                           data = spatial_df, 
                           listw = spatial_weights)

# Compare model performance
aic_comparison <- data.frame(
  Model = c("OLS", "Spatial Lag", "Spatial Error"),
  AIC = c(AIC(ols_model), AIC(spatial_lag), AIC(spatial_error))
) %>%
  arrange(AIC)

print(aic_comparison)

# Summary of best spatial model
summary(spatial_lag)
```

---

## 📊 5. Visualization & Mapping: Spatial Patterns

Visualization reveals spatial patterns that summary statistics alone cannot capture. These maps and plots demonstrate spatial autocorrelation, kriging results, and model predictions across the landscape.

```r
# Plot 1: Sampling locations with species abundance
sampling_map <- ggplot(spatial_df, aes(x = x, y = y)) +
  geom_point(aes(color = species_abundance, size = species_abundance)) +
  scale_color_viridis_c(name = "Species
Abundance") +
  scale_size_continuous(name = "Species
Abundance", range = c(1, 4)) +
  labs(
    title = "Sampling Locations and Species Abundance",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    legend.position = "right"
  )

print(sampling_map)

# Save the plot
ggsave(
  here("workflows", "08_spatial_analysis", "3_output", "figures", "sampling_locations.png"),
  sampling_map,
  width = 10, height = 6, dpi = 300
)

# Plot 2: Variogram with fitted model
variogram_plot <- ggplot(variogram_abundance, aes(x = dist, y = gamma)) +
  geom_point(size = 2) +
  geom_line(data = variogramLine(variogram_model, maxdist = max(variogram_abundance$dist)),
            aes(x = dist, y = gamma), color = "red", size = 1) +
  labs(
    title = "Empirical Variogram with Fitted Spherical Model",
    x = "Distance",
    y = "Semivariance"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold")
  )

print(variogram_plot)

# Save the plot
ggsave(
  here("workflows", "08_spatial_analysis", "3_output", "figures", "variogram_model.png"),
  variogram_plot,
  width = 8, height = 6, dpi = 300
)

# Plot 3: Kriging interpolation map
kriging_map <- ggplot(kriging_df, aes(x = x, y = y)) +
  geom_raster(aes(fill = var1.pred)) +
  geom_point(data = spatial_df, aes(x = x, y = y), 
             color = "black", size = 1, alpha = 0.7) +
  scale_fill_viridis_c(name = "Predicted
Abundance") +
  labs(
    title = "Kriging Interpolation of Species Abundance",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    legend.position = "right"
  )

print(kriging_map)

# Save the plot
ggsave(
  here("workflows", "08_spatial_analysis", "3_output", "figures", "kriging_interpolation.png"),
  kriging_map,
  width = 10, height = 6, dpi = 300
)

# Plot 4: Model residuals spatial distribution
residuals_df <- spatial_df %>%
  mutate(
    ols_residuals = residuals(ols_model),
    spatial_residuals = residuals(spatial_lag)
  )

residuals_plot <- residuals_df %>%
  select(x, y, ols_residuals, spatial_residuals) %>%
  pivot_longer(cols = c(ols_residuals, spatial_residuals),
               names_to = "model_type",
               values_to = "residual") %>%
  mutate(model_type = case_when(
    model_type == "ols_residuals" ~ "OLS Model",
    model_type == "spatial_residuals" ~ "Spatial Lag Model"
  )) %>%
  ggplot(aes(x = x, y = y, color = residual)) +
  geom_point(size = 2) +
  scale_color_gradient2(name = "Residual", low = "blue", mid = "white", high = "red") +
  facet_wrap(~model_type) +
  labs(
    title = "Model Residuals: OLS vs Spatial Lag",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(size = 12, face = "bold")
  )

print(residuals_plot)

# Save the plot
ggsave(
  here("workflows", "08_spatial_analysis", "3_output", "figures", "model_residuals_comparison.png"),
  residuals_plot,
  width = 12, height = 6, dpi = 300
)
```

---

## 🧬 Reproducibility Check

Document our spatial analysis workflow and save key results for future use. The spatial models and interpolation results provide insights into ecological processes operating across landscapes.

```r
# Save processed spatial data
write_csv(spatial_df, 
          here("workflows", "08_spatial_analysis", "3_output", "tables", "spatial_ecological_data.csv"))

# Save kriging results
write_csv(kriging_df, 
          here("workflows", "08_spatial_analysis", "3_output", "tables", "kriging_predictions.csv"))

# Save model comparison results
write_csv(aic_comparison, 
          here("workflows", "08_spatial_analysis", "3_output", "tables", "model_comparison.csv"))

# Record variogram model parameters
variogram_params <- data.frame(
  parameter = c("nugget", "sill", "range"),
  value = c(variogram_model$psill[1], 
           sum(variogram_model$psill), 
           variogram_model$range[2])
)

write_csv(variogram_params, 
          here("workflows", "08_spatial_analysis", "3_output", "tables", "variogram_parameters.csv"))

cat("\n=== SPATIAL ANALYSIS WORKFLOW COMPLETE ===\n")
cat("Results saved to 3_output/figures/ and 3_output/tables/\n\n")

# Record session information
sessionInfo()
```

---

## Summary

This spatial analysis workflow demonstrates:

- **Spatial Data Preparation**: Creating and handling spatial ecological datasets
- **Geostatistical Modeling**: Using variograms to model spatial autocorrelation
- **Kriging Interpolation**: Predicting values at unsampled locations
- **Spatial Regression**: Accounting for spatial structure in ecological relationships
- **Visualization**: Creating maps that reveal spatial patterns and model performance

The workflow provides a foundation for understanding how ecological processes operate across space and how to properly account for spatial dependencies in ecological analyses.


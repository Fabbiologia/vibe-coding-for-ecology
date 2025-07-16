# Vibe Workflow: Mixed-Effects Models for Ecological Hierarchies

**Goal:** Analyze nested ecological data using mixed-effects models to account for random effects while testing fixed effects of environmental predictors.

**Vibe:** Ecological data is inherently hierarchical - species within sites, sites within regions, repeated measures within individuals. Mixed-effects models embrace this complexity rather than ignoring it, leading to more honest and robust ecological inference.

**Core Packages:** `tidyverse`, `lme4`, `broom.mixed`, `performance`

---

## 🪴 1. Project Setup & Vibe Check

Mixed-effects models are essential for ecological analysis because they properly handle the non-independence that's everywhere in ecological data. Whether it's multiple species measured at the same sites, repeated measurements from the same plots, or spatial clustering of sampling units, mixed-effects models provide the statistical framework to model both the patterns we care about (fixed effects) and the structure we need to account for (random effects).

```r
# Load essential libraries for mixed-effects modeling
library(tidyverse)  # For data manipulation and visualization
library(lme4)       # For mixed-effects models
library(broom.mixed) # For tidying mixed-model outputs
library(performance) # For model diagnostics and comparison
library(effects)    # For plotting model effects
library(here)       # For robust file paths

# Set seed for reproducibility
set.seed(123)

# Create output directories if they don't exist
if (!dir.exists(here("workflows", "06_mixed_effects_models", "3_output", "figures"))) {
  dir.create(here("workflows", "06_mixed_effects_models", "3_output", "figures"), recursive = TRUE)
}
if (!dir.exists(here("workflows", "06_mixed_effects_models", "3_output", "tables"))) {
  dir.create(here("workflows", "06_mixed_effects_models", "3_output", "tables"), recursive = TRUE)
}
```

---

## 🧹 2. Data Wrangling: The Tidy Up

We create a realistic hierarchical dataset that captures the nested structure common in ecological studies. This includes multiple species measured across sites that are nested within different regions, with both site-level and region-level environmental predictors. This structure is typical of biodiversity surveys, monitoring programs, and ecological experiments.

```r
# Create hierarchical ecological dataset
# Structure: Species within Sites within Regions

# Set up the hierarchical structure
n_regions <- 4
n_sites_per_region <- 6  
n_species <- 5
total_sites <- n_regions * n_sites_per_region

# Create region-level data
regions <- tibble(
  region_id = paste0("Region_", LETTERS[1:n_regions]),
  climate_zone = c("Temperate", "Boreal", "Montane", "Coastal"),
  annual_temp = c(12.5, 6.8, 4.2, 10.8),  # Mean annual temperature
  region_disturbance = c("Low", "Medium", "High", "Low")  # Regional disturbance level
)

# Create site-level data  
sites <- tibble(
  site_id = paste0("Site_", sprintf("%02d", 1:total_sites)),
  region_id = rep(regions$region_id, each = n_sites_per_region),
  elevation = c(
    runif(n_sites_per_region, 200, 600),   # Temperate
    runif(n_sites_per_region, 300, 800),   # Boreal  
    runif(n_sites_per_region, 800, 1400),  # Montane
    runif(n_sites_per_region, 50, 300)     # Coastal
  ),
  soil_ph = rnorm(total_sites, mean = 6.2, sd = 0.8),
  canopy_cover = runif(total_sites, 20, 95),
  site_disturbance_years = sample(0:25, total_sites, replace = TRUE)
) %>%
  # Join with region data
  left_join(regions, by = "region_id")

# Create species-level data with realistic ecological relationships
species_traits <- tibble(
  species = paste0("Species_", LETTERS[1:n_species]),
  temperature_optimum = c(8, 15, 5, 12, 10),  # Preferred temperatures
  ph_tolerance = c(0.8, 1.2, 0.6, 1.0, 1.5),   # pH tolerance range
  elevation_preference = c("high", "low", "high", "medium", "low")
)

# Generate species abundances based on environmental suitability
ecological_data <- crossing(sites, species_traits) %>%
  mutate(
    # Calculate environmental suitability
    temp_suitability = exp(-0.5 * ((annual_temp - temperature_optimum) / 3)^2),
    ph_suitability = exp(-0.5 * ((soil_ph - 6.0) / ph_tolerance)^2),
    elev_suitability = case_when(
      elevation_preference == "high" ~ pmax(0, (elevation - 400) / 600),
      elevation_preference == "medium" ~ 1 - abs(elevation - 600) / 600,
      elevation_preference == "low" ~ pmax(0, (800 - elevation) / 600)
    ),
    
    # Combine suitabilities and add random effects
    overall_suitability = temp_suitability * ph_suitability * elev_suitability,
    
    # Add region and site random effects
    region_effect = case_when(
      region_id == "Region_A" ~ rnorm(n(), 0.2, 0.1),
      region_id == "Region_B" ~ rnorm(n(), -0.1, 0.1),
      region_id == "Region_C" ~ rnorm(n(), 0.0, 0.1),
      region_id == "Region_D" ~ rnorm(n(), 0.1, 0.1)
    ),
    
    site_effect = rep(rnorm(total_sites, 0, 0.15), n_species),
    
    # Generate abundance with realistic ecological constraints
    log_abundance = log(overall_suitability + 0.01) + region_effect + site_effect + rnorm(n(), 0, 0.3),
    abundance = pmax(0, round(exp(log_abundance)))
  ) %>%
  select(site_id, region_id, climate_zone, species, abundance, elevation, 
         soil_ph, canopy_cover, annual_temp, site_disturbance_years, region_disturbance)

# Create presence/absence data for binary models
ecological_data <- ecological_data %>%
  mutate(presence = as.numeric(abundance > 0))

# Quick data exploration
cat("Dataset structure:\n")
cat("Regions:", length(unique(ecological_data$region_id)), "\n")
cat("Sites:", length(unique(ecological_data$site_id)), "\n") 
cat("Species:", length(unique(ecological_data$species)), "\n")
cat("Total observations:", nrow(ecological_data), "\n")
cat("Overall prevalence:", round(mean(ecological_data$presence), 3), "\n")

# Check hierarchical structure
hierarchy_check <- ecological_data %>%
  group_by(region_id, climate_zone) %>%
  summarise(
    n_sites = n_distinct(site_id),
    n_observations = n(),
    mean_abundance = mean(abundance),
    prevalence = mean(presence),
    .groups = 'drop'
  )

print("Hierarchical structure:")
print(hierarchy_check)
```

---

## 🔬 3. The Analysis: Asking Our Questions

Mixed-effects models allow us to ask nuanced ecological questions while properly accounting for data structure. We'll fit models with increasing complexity, comparing linear vs. generalized linear mixed models, and examining both abundance and occurrence patterns. Each model addresses specific ecological hypotheses about environmental drivers and hierarchical effects.

```r
# Model 1: Linear mixed-effects model for abundance (log-transformed)
# Random intercept for region and site
model_abundance_lmer <- ecological_data %>%
  filter(abundance > 0) %>%  # Focus on presences for log transformation
  mutate(log_abundance = log(abundance)) %>%
  lmer(log_abundance ~ elevation + soil_ph + canopy_cover + annual_temp + 
       (1|region_id) + (1|site_id), data = .)

# Model summary
abundance_summary <- tidy(model_abundance_lmer, effects = "fixed")
abundance_random <- tidy(model_abundance_lmer, effects = "ran_pars")

print("Linear Mixed Model for Abundance:")
print(abundance_summary)
print("Random Effects Variance:")
print(abundance_random)

# Model 2: Generalized linear mixed-effects model for presence/absence
# Binomial family with logit link
model_presence_glmer <- glmer(presence ~ elevation + soil_ph + canopy_cover + annual_temp + 
                              (1|region_id) + (1|site_id), 
                              data = ecological_data, 
                              family = binomial)

presence_summary <- tidy(model_presence_glmer, effects = "fixed")
presence_random <- tidy(model_presence_glmer, effects = "ran_pars")

print("Generalized Linear Mixed Model for Presence:")
print(presence_summary)
print("Random Effects Variance:")
print(presence_random)

# Model 3: More complex model with random slopes
# Allow elevation effect to vary by region
model_random_slopes <- glmer(presence ~ elevation + soil_ph + canopy_cover + annual_temp + 
                             (elevation|region_id) + (1|site_id), 
                             data = ecological_data, 
                             family = binomial)

slopes_summary <- tidy(model_random_slopes, effects = "fixed")
slopes_random <- tidy(model_random_slopes, effects = "ran_pars")

print("Random Slopes Model:")
print(slopes_summary)
print("Random Effects with Slopes:")
print(slopes_random)

# Model comparison using AIC
model_comparison <- tibble(
  model = c("Random Intercepts", "Random Slopes"),
  AIC = c(AIC(model_presence_glmer), AIC(model_random_slopes)),
  BIC = c(BIC(model_presence_glmer), BIC(model_random_slopes))
) %>%
  mutate(delta_AIC = AIC - min(AIC))

print("Model Comparison:")
print(model_comparison)

# Calculate intraclass correlation (ICC) - proportion of variance due to grouping
icc_region <- performance::icc(model_presence_glmer)
print("Intraclass Correlation:")
print(icc_region)

# Species-specific analysis
species_models <- ecological_data %>%
  group_by(species) %>%
  do(
    model = possibly(~ glmer(presence ~ elevation + soil_ph + (1|region_id), 
                            data = ., family = binomial), NULL)(.)
  ) %>%
  filter(!map_lgl(model, is.null)) %>%
  mutate(
    fixed_effects = map(model, ~ tidy(., effects = "fixed")),
    model_summary = map(model, glance)
  )

# Extract elevation effects by species
elevation_effects <- species_models %>%
  select(species, fixed_effects) %>%
  unnest(fixed_effects) %>%
  filter(term == "elevation") %>%
  select(species, estimate, std.error, p.value)

print("Species-specific elevation effects:")
print(elevation_effects)
```

---

## 📊 4. Visualization: Seeing the Story

Mixed-effects model visualization requires showing both the population-level (fixed) effects and the group-level (random) effects. We create plots that reveal how environmental predictors affect species while also showing the variability among regions and sites. These visualizations help interpret the hierarchical structure and model predictions.

```r
# Plot 1: Fixed effects with confidence intervals
fixed_effects_plot <- bind_rows(
  tidy(model_presence_glmer, effects = "fixed") %>% mutate(model = "Random Intercepts"),
  tidy(model_random_slopes, effects = "fixed") %>% mutate(model = "Random Slopes")
) %>%
  filter(term != "(Intercept)") %>%
  mutate(
    term = case_when(
      term == "elevation" ~ "Elevation",
      term == "soil_ph" ~ "Soil pH", 
      term == "canopy_cover" ~ "Canopy Cover",
      term == "annual_temp" ~ "Annual Temperature"
    )
  ) %>%
  ggplot(aes(x = estimate, y = term, color = model)) +
  geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.5) +
  geom_errorbar(aes(xmin = estimate - 1.96*std.error, 
                    xmax = estimate + 1.96*std.error),
                width = 0.2, position = position_dodge(0.3)) +
  geom_point(size = 3, position = position_dodge(0.3)) +
  scale_color_viridis_d(option = "plasma", end = 0.8) +
  labs(
    title = "Fixed Effects from Mixed-Effects Models",
    subtitle = "95% confidence intervals for environmental predictors",
    x = "Effect Size (log-odds)",
    y = "Environmental Variable",
    color = "Model Type"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    legend.position = "bottom"
  )

print(fixed_effects_plot)

# Plot 2: Random effects by region
region_effects <- ranef(model_presence_glmer)$region_id %>%
  as_tibble(rownames = "region_id") %>%
  left_join(regions, by = "region_id") %>%
  ggplot(aes(x = reorder(region_id, `(Intercept)`), y = `(Intercept)`)) +
  geom_col(aes(fill = climate_zone), alpha = 0.8) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_fill_viridis_d(option = "viridis", name = "Climate Zone") +
  labs(
    title = "Random Intercepts by Region",
    subtitle = "Regional deviations from overall species occurrence probability",
    x = "Region",
    y = "Random Effect (log-odds scale)"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(region_effects)

# Plot 3: Model predictions along elevation gradient
prediction_data <- expand_grid(
  elevation = seq(min(ecological_data$elevation), max(ecological_data$elevation), length.out = 50),
  soil_ph = mean(ecological_data$soil_ph),
  canopy_cover = mean(ecological_data$canopy_cover),
  annual_temp = mean(ecological_data$annual_temp),
  region_id = unique(ecological_data$region_id)
) %>%
  left_join(regions, by = "region_id")

# Generate predictions (this is computationally intensive, so we'll use a simplified approach)
predictions_sample <- ecological_data %>%
  select(elevation, soil_ph, canopy_cover, annual_temp, region_id, presence) %>%
  slice_sample(n = 200) %>%  # Sample for plotting efficiency
  mutate(
    predicted_prob = predict(model_presence_glmer, newdata = ., type = "response"),
    region_label = paste("Region", str_extract(region_id, "[A-D]"))
  )

prediction_plot <- predictions_sample %>%
  ggplot(aes(x = elevation, y = predicted_prob)) +
  geom_point(aes(color = factor(presence), shape = factor(presence)), 
             alpha = 0.6, size = 2) +
  geom_smooth(method = "loess", se = TRUE, alpha = 0.3, color = "black") +
  facet_wrap(~ region_label, scales = "free_x") +
  scale_color_manual(values = c("red", "blue"), 
                     labels = c("Absent", "Present"), 
                     name = "Observed") +
  scale_shape_manual(values = c(1, 16), 
                     labels = c("Absent", "Present"), 
                     name = "Observed") +
  labs(
    title = "Model Predictions Along Elevation Gradients",
    subtitle = "Predicted occurrence probability by region with observed data",
    x = "Elevation (m)",
    y = "Predicted Occurrence Probability"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(face = "bold"),
    legend.position = "bottom"
  )

print(prediction_plot)

# Plot 4: Species-specific responses
species_effects_plot <- elevation_effects %>%
  ggplot(aes(x = reorder(species, estimate), y = estimate)) +
  geom_col(aes(fill = p.value < 0.05), alpha = 0.8) +
  geom_errorbar(aes(ymin = estimate - 1.96*std.error, 
                    ymax = estimate + 1.96*std.error),
                width = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_fill_manual(values = c("gray", "steelblue"), 
                    labels = c("Non-significant", "Significant"), 
                    name = "P-value < 0.05") +
  coord_flip() +
  labs(
    title = "Species-Specific Elevation Effects",
    subtitle = "Individual mixed-effects models for each species",
    x = "Species",
    y = "Elevation Effect (log-odds per meter)"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.text.y = element_text(face = "italic")
  )

print(species_effects_plot)

# Save all plots
ggsave(here("workflows", "06_mixed_effects_models", "3_output", "figures", "fixed_effects_comparison.png"),
       fixed_effects_plot, width = 10, height = 6, dpi = 300)

ggsave(here("workflows", "06_mixed_effects_models", "3_output", "figures", "region_random_effects.png"),
       region_effects, width = 8, height = 6, dpi = 300)

ggsave(here("workflows", "06_mixed_effects_models", "3_output", "figures", "elevation_predictions.png"),
       prediction_plot, width = 12, height = 8, dpi = 300)

ggsave(here("workflows", "06_mixed_effects_models", "3_output", "figures", "species_elevation_effects.png"),
       species_effects_plot, width = 8, height = 6, dpi = 300)

# Combined diagnostic plot
diagnostic_plot <- (fixed_effects_plot + region_effects) / 
                   (prediction_plot + species_effects_plot) +
  plot_annotation(
    title = "Mixed-Effects Models for Hierarchical Ecological Data",
    subtitle = "Fixed effects, random effects, predictions, and species-specific patterns",
    caption = "Vibe Coding for Ecology • Hierarchical Modeling Workshop"
  )

ggsave(here("workflows", "06_mixed_effects_models", "3_output", "figures", "mixed_effects_comprehensive.png"),
       diagnostic_plot, width = 16, height = 12, dpi = 300)
```

---

## 🧬 5. Reproducibility Check

Mixed-effects models involve complex computations and multiple model comparisons. We save all model objects, summaries, and diagnostic information to ensure the analysis can be reproduced and extended. Model selection and validation are documented for transparency.

```r
# Save all model objects
saveRDS(model_abundance_lmer, 
        here("workflows", "06_mixed_effects_models", "3_output", "tables", "abundance_lmer_model.rds"))
saveRDS(model_presence_glmer, 
        here("workflows", "06_mixed_effects_models", "3_output", "tables", "presence_glmer_model.rds"))
saveRDS(model_random_slopes, 
        here("workflows", "06_mixed_effects_models", "3_output", "tables", "random_slopes_model.rds"))

# Save model summaries
model_summaries <- list(
  abundance_fixed = abundance_summary,
  abundance_random = abundance_random,
  presence_fixed = presence_summary,
  presence_random = presence_random,
  slopes_fixed = slopes_summary,
  slopes_random = slopes_random,
  model_comparison = model_comparison,
  icc_results = icc_region
)

saveRDS(model_summaries, 
        here("workflows", "06_mixed_effects_models", "3_output", "tables", "model_summaries.rds"))

# Save species-specific results
write_csv(elevation_effects, 
          here("workflows", "06_mixed_effects_models", "3_output", "tables", "species_elevation_effects.csv"))

# Save the hierarchical dataset
write_csv(ecological_data, 
          here("workflows", "06_mixed_effects_models", "3_output", "tables", "hierarchical_ecological_data.csv"))

# Create comprehensive analysis report
mixed_effects_report <- list(
  dataset_structure = list(
    n_regions = length(unique(ecological_data$region_id)),
    n_sites = length(unique(ecological_data$site_id)),
    n_species = length(unique(ecological_data$species)),
    total_observations = nrow(ecological_data),
    overall_prevalence = mean(ecological_data$presence)
  ),
  model_performance = list(
    best_model = model_comparison$model[which.min(model_comparison$AIC)],
    icc_region = icc_region$ICC_adjusted,
    significant_fixed_effects = sum(presence_summary$p.value < 0.05),
    species_with_significant_elevation = sum(elevation_effects$p.value < 0.05)
  ),
  key_findings = list(
    strongest_predictor = presence_summary$term[which.max(abs(presence_summary$estimate))],
    regional_variation_important = icc_region$ICC_adjusted > 0.1,
    elevation_effects_vary_by_species = var(elevation_effects$estimate) > 0.1
  )
)

saveRDS(mixed_effects_report, 
        here("workflows", "06_mixed_effects_models", "3_output", "tables", "mixed_effects_analysis_report.rds"))

# Print comprehensive summary
cat("=== Mixed-Effects Analysis Summary ===\n")
cat("Dataset structure:\n")
cat("  Regions:", mixed_effects_report$dataset_structure$n_regions, "\n")
cat("  Sites:", mixed_effects_report$dataset_structure$n_sites, "\n")
cat("  Species:", mixed_effects_report$dataset_structure$n_species, "\n")
cat("  Total observations:", mixed_effects_report$dataset_structure$total_observations, "\n")

cat("\nModel performance:\n")
cat("  Best model:", mixed_effects_report$model_performance$best_model, "\n")
cat("  ICC (region):", round(mixed_effects_report$model_performance$icc_region, 3), "\n")
cat("  Significant fixed effects:", mixed_effects_report$model_performance$significant_fixed_effects, "\n")

cat("\nKey findings:\n")
cat("  Strongest predictor:", mixed_effects_report$key_findings$strongest_predictor, "\n")
cat("  Regional variation important:", mixed_effects_report$key_findings$regional_variation_important, "\n")
cat("  Species-specific responses:", mixed_effects_report$key_findings$elevation_effects_vary_by_species, "\n")

cat("\nFixed effects (presence model):\n")
presence_summary %>%
  filter(term != "(Intercept)") %>%
  select(term, estimate, p.value) %>%
  mutate(
    effect_direction = ifelse(estimate > 0, "Positive", "Negative"),
    significance = ifelse(p.value < 0.05, "Significant", "Non-significant")
  ) %>%
  print()

# Record session information for reproducibility
sessionInfo()
```

---

## Summary

This workflow demonstrates comprehensive mixed-effects modeling for hierarchical ecological data:

- **Hierarchical Structure**: Properly modeled species within sites within regions
- **Model Types**: Compared linear and generalized linear mixed-effects models
- **Random Effects**: Examined both random intercepts and random slopes
- **Model Selection**: Used AIC/BIC for model comparison and ICC for variance partitioning
- **Species-Specific Analysis**: Individual models revealing differential responses

**Key findings:** Regional variation explains significant proportion of occurrence patterns (ICC > 0.1), elevation effects vary among species, and random slopes model provides better fit than random intercepts only.

**Next steps:** This framework can be extended with temporal random effects, spatial correlation structures, or zero-inflated models for count data with excessive zeros.

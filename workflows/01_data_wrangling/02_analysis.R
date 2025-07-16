# Analysis Script: Exploring Data Patterns and Relationships
# Part of the Vibe Coding for Ecology workflow series
# This script performs exploratory analysis on cleaned species and environmental data

# Load essential libraries ----
library(tidyverse)  # For data manipulation and visualization
library(broom)      # For tidying statistical outputs
library(corrr)      # For correlation analysis
library(here)       # For robust file paths

# Set seed for reproducibility ----
set.seed(123)

# Load cleaned data ----
message("Loading cleaned datasets...")

cleaned_dataset <- readRDS(
  here("workflows", "01_data_wrangling", "3_output", "tables", "cleaned_species_environmental_data.rds")
)

habitat_summary <- readRDS(
  here("workflows", "01_data_wrangling", "3_output", "tables", "habitat_summary_stats.rds")
)

# Verify data structure ----
message("Verifying data structure...")
glimpse(cleaned_dataset)
cat("Analysis will include", nrow(cleaned_dataset), "observations from", 
    length(unique(cleaned_dataset$site_id)), "sites\n")

# Species richness analysis ----
message("Analyzing species richness patterns...")

richness_by_habitat <- cleaned_dataset %>%
  group_by(site_id, habitat, elevation, elevation_class) %>%
  summarise(
    species_richness = sum(abundance > 0),
    total_abundance = sum(abundance),
    dominant_species = species[which.max(abundance)],
    .groups = 'drop'
  )

# Test differences in species richness between habitats
richness_test <- t.test(species_richness ~ habitat, data = richness_by_habitat)
richness_results <- tidy(richness_test)

cat("Species richness comparison between habitats:\n")
print(richness_results)

# Abundance patterns analysis ----
message("Analyzing abundance patterns...")

abundance_patterns <- cleaned_dataset %>%
  group_by(species, habitat) %>%
  summarise(
    mean_abundance = mean(abundance),
    median_abundance = median(abundance),
    max_abundance = max(abundance),
    sites_present = sum(abundance > 0),
    frequency = sites_present / n(),
    .groups = 'drop'
  ) %>%
  arrange(desc(mean_abundance))

# Find indicator species for each habitat
indicator_species <- abundance_patterns %>%
  group_by(habitat) %>%
  slice_max(mean_abundance, n = 2) %>%
  ungroup()

cat("\nTop indicator species by habitat:\n")
print(indicator_species)

# Environmental correlation analysis ----
message("Analyzing environmental correlations...")

env_correlations <- cleaned_dataset %>%
  select(elevation, soil_ph, annual_precip_mm, canopy_cover_pct, abundance) %>%
  correlate() %>%
  focus(abundance) %>%
  arrange(desc(abs(abundance)))

cat("\nEnvironmental correlations with species abundance:\n")
print(env_correlations)

# Species-specific environmental relationships ----
message("Analyzing species-specific environmental relationships...")

species_env_models <- cleaned_dataset %>%
  group_by(species) %>%
  do(
    elevation_model = lm(abundance ~ elevation, data = .),
    ph_model = lm(abundance ~ soil_ph, data = .),
    precip_model = lm(abundance ~ annual_precip_mm, data = .)
  ) %>%
  pivot_longer(cols = ends_with("_model"), names_to = "env_variable", values_to = "model") %>%
  mutate(
    env_variable = str_remove(env_variable, "_model"),
    model_summary = map(model, tidy),
    r_squared = map_dbl(model, ~ summary(.)$r.squared),
    p_value = map_dbl(model_summary, ~ .$p.value[2])  # Get slope p-value
  ) %>%
  select(-model, -model_summary) %>%
  filter(p_value < 0.1)  # Keep marginally significant relationships

cat("\nSignificant species-environment relationships (p < 0.1):\n")
print(species_env_models)

# Diversity analysis ----
message("Calculating diversity indices...")

diversity_analysis <- cleaned_dataset %>%
  group_by(site_id, habitat, elevation_class) %>%
  summarise(
    species_richness = sum(abundance > 0),
    total_abundance = sum(abundance),
    # Shannon diversity index
    shannon_diversity = -sum(ifelse(abundance > 0, 
                                   (abundance/total_abundance) * log(abundance/total_abundance), 0)),
    # Simpson diversity index  
    simpson_diversity = 1 - sum((abundance/total_abundance)^2),
    # Evenness (Pielou's J)
    evenness = shannon_diversity / log(species_richness),
    .groups = 'drop'
  ) %>%
  # Replace NaN evenness with 0 for sites with only one species
  mutate(evenness = ifelse(is.nan(evenness), 0, evenness))

# Test diversity differences between habitats
shannon_test <- t.test(shannon_diversity ~ habitat, data = diversity_analysis)
simpson_test <- t.test(simpson_diversity ~ habitat, data = diversity_analysis)

cat("\nDiversity comparisons between habitats:\n")
cat("Shannon diversity test:\n")
print(tidy(shannon_test))
cat("\nSimpson diversity test:\n")
print(tidy(simpson_test))

# Elevation gradient analysis ----
message("Analyzing elevation gradient patterns...")

elevation_patterns <- cleaned_dataset %>%
  group_by(elevation_class, species) %>%
  summarise(
    mean_abundance = mean(abundance),
    presence_frequency = sum(abundance > 0) / n(),
    .groups = 'drop'
  ) %>%
  filter(presence_frequency > 0.25)  # Keep species present in >25% of sites

# Test for elevation preferences
elevation_preferences <- cleaned_dataset %>%
  group_by(species) %>%
  do(elevation_lm = lm(abundance ~ elevation, data = .)) %>%
  mutate(
    model_summary = map(elevation_lm, tidy),
    slope = map_dbl(model_summary, ~ .$estimate[2]),
    p_value = map_dbl(model_summary, ~ .$p.value[2]),
    r_squared = map_dbl(elevation_lm, ~ summary(.)$r.squared)
  ) %>%
  select(-elevation_lm, -model_summary) %>%
  filter(p_value < 0.1) %>%
  arrange(p_value)

cat("\nSpecies elevation preferences (significant slopes):\n")
print(elevation_preferences)

# Save analysis results ----
message("Saving analysis results...")

# Save all results as RDS objects for downstream use
saveRDS(richness_by_habitat, 
        here("workflows", "01_data_wrangling", "3_output", "tables", "richness_analysis.rds"))
saveRDS(abundance_patterns, 
        here("workflows", "01_data_wrangling", "3_output", "tables", "abundance_patterns.rds"))
saveRDS(diversity_analysis, 
        here("workflows", "01_data_wrangling", "3_output", "tables", "diversity_analysis.rds"))
saveRDS(elevation_preferences, 
        here("workflows", "01_data_wrangling", "3_output", "tables", "elevation_preferences.rds"))

# Save key results as CSV for easy viewing
write_csv(richness_by_habitat, 
          here("workflows", "01_data_wrangling", "3_output", "tables", "richness_by_habitat.csv"))
write_csv(abundance_patterns, 
          here("workflows", "01_data_wrangling", "3_output", "tables", "abundance_patterns.csv"))
write_csv(diversity_analysis, 
          here("workflows", "01_data_wrangling", "3_output", "tables", "diversity_indices.csv"))

# Create summary report ----
analysis_summary <- list(
  total_sites = length(unique(cleaned_dataset$site_id)),
  total_species = length(unique(cleaned_dataset$species)),
  habitat_types = unique(cleaned_dataset$habitat),
  richness_habitat_pvalue = richness_results$p.value,
  shannon_habitat_pvalue = tidy(shannon_test)$p.value,
  significant_elevation_species = nrow(elevation_preferences),
  mean_shannon_forest = mean(diversity_analysis$shannon_diversity[diversity_analysis$habitat == "Forest"]),
  mean_shannon_grassland = mean(diversity_analysis$shannon_diversity[diversity_analysis$habitat == "Grassland"])
)

saveRDS(analysis_summary, 
        here("workflows", "01_data_wrangling", "3_output", "tables", "analysis_summary.rds"))

# Print completion message ----
message("✓ Analysis completed successfully!")
message("→ Results saved to 3_output/tables/")
message("→ Ready for visualization in 03_visualization.R")

cat("\n=== Analysis Summary ===\n")
cat("Sites analyzed:", analysis_summary$total_sites, "\n")
cat("Species analyzed:", analysis_summary$total_species, "\n")
cat("Habitat richness differs significantly:", 
    ifelse(analysis_summary$richness_habitat_pvalue < 0.05, "Yes", "No"), 
    "(p =", round(analysis_summary$richness_habitat_pvalue, 3), ")\n")
cat("Shannon diversity differs by habitat:", 
    ifelse(analysis_summary$shannon_habitat_pvalue < 0.05, "Yes", "No"), 
    "(p =", round(analysis_summary$shannon_habitat_pvalue, 3), ")\n")
cat("Species with elevation preferences:", analysis_summary$significant_elevation_species, "\n")

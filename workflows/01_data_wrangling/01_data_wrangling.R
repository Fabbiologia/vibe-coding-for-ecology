# Data Wrangling Script: Tidy, Reshape, and Join Operations
# Part of the Vibe Coding for Ecology workflow series
# This script demonstrates core data wrangling patterns for ecological data

# Load essential libraries ----
library(tidyverse)  # For data manipulation and visualization
library(here)       # For robust file paths

# Set seed for reproducibility ----
set.seed(123)

# Create output directories ----
if (!dir.exists(here("workflows", "01_data_wrangling", "3_output", "figures"))) {
  dir.create(here("workflows", "01_data_wrangling", "3_output", "figures"), recursive = TRUE)
}
if (!dir.exists(here("workflows", "01_data_wrangling", "3_output", "tables"))) {
  dir.create(here("workflows", "01_data_wrangling", "3_output", "tables"), recursive = TRUE)
}

# Create simulated species abundance dataset ----
message("Creating simulated species abundance data...")

species_wide <- tibble(
  site_id = paste0("Site_", 1:8),
  habitat = rep(c("Forest", "Grassland"), each = 4),
  elevation = c(1200, 1250, 1300, 1350, 800, 850, 900, 950),
  Quercus_alba = c(15, 12, 8, 5, 0, 0, 2, 1),
  Acer_rubrum = c(8, 10, 12, 10, 3, 5, 7, 6),
  Pinus_strobus = c(20, 18, 15, 12, 1, 0, 3, 2),
  Carex_pensylvanica = c(2, 3, 5, 8, 25, 30, 28, 22)
)

# Reshape wide to long format ----
message("Reshaping data from wide to long format...")

species_long <- species_wide %>%
  pivot_longer(
    cols = c(Quercus_alba, Acer_rubrum, Pinus_strobus, Carex_pensylvanica),
    names_to = "species",
    values_to = "abundance"
  ) %>%
  # Clean up species names by replacing underscores with spaces
  mutate(species = str_replace(species, "_", " "))

# Create environmental data ----
message("Creating environmental data for joining...")

environmental_data <- tibble(
  site_id = paste0("Site_", 1:8),
  soil_ph = c(6.2, 6.5, 6.8, 7.1, 5.8, 5.9, 6.0, 6.1),
  annual_precip_mm = c(1200, 1180, 1150, 1100, 950, 980, 1000, 1020),
  canopy_cover_pct = c(85, 80, 75, 70, 15, 20, 25, 30)
)

# Join datasets ----
message("Joining species and environmental data...")

complete_dataset <- species_long %>%
  left_join(environmental_data, by = "site_id") %>%
  # Calculate summary metrics per site
  group_by(site_id) %>%
  mutate(
    species_richness = sum(abundance > 0),
    total_abundance = sum(abundance)
  ) %>%
  ungroup()

# Clean and filter data ----
message("Applying data cleaning operations...")

cleaned_dataset <- complete_dataset %>%
  # Remove sites with zero total abundance
  filter(total_abundance > 0) %>%
  # Create meaningful categorical variables
  mutate(
    elevation_class = case_when(
      elevation < 1000 ~ "Low",
      elevation >= 1000 & elevation < 1200 ~ "Medium", 
      elevation >= 1200 ~ "High"
    ),
    abundance_class = case_when(
      abundance == 0 ~ "Absent",
      abundance > 0 & abundance <= 5 ~ "Rare",
      abundance > 5 & abundance <= 15 ~ "Common",
      abundance > 15 ~ "Abundant"
    )
  ) %>%
  # Only keep species that occur in at least 2 sites
  group_by(species) %>%
  filter(sum(abundance > 0) >= 2) %>%
  ungroup()

# Save processed data ----
message("Saving cleaned datasets...")

saveRDS(
  cleaned_dataset,
  here("workflows", "01_data_wrangling", "3_output", "tables", "cleaned_species_environmental_data.rds")
)

write_csv(
  cleaned_dataset,
  here("workflows", "01_data_wrangling", "3_output", "tables", "cleaned_species_environmental_data.csv")
)

# Create summary statistics ----
message("Generating summary statistics...")

habitat_summary <- cleaned_dataset %>%
  group_by(site_id, habitat, elevation_class) %>%
  summarise(
    species_richness = sum(abundance > 0),
    total_abundance = sum(abundance),
    shannon_diversity = -sum(ifelse(abundance > 0, 
                                   (abundance/total_abundance) * log(abundance/total_abundance), 0)),
    .groups = 'drop'
  )

species_occurrence <- cleaned_dataset %>%
  group_by(species, habitat) %>%
  summarise(
    sites_present = sum(abundance > 0),
    mean_abundance = mean(abundance[abundance > 0]),
    max_abundance = max(abundance),
    .groups = 'drop'
  ) %>%
  arrange(desc(sites_present))

# Save summary tables ----
saveRDS(habitat_summary, 
        here("workflows", "01_data_wrangling", "3_output", "tables", "habitat_summary_stats.rds"))
write_csv(habitat_summary, 
          here("workflows", "01_data_wrangling", "3_output", "tables", "habitat_summary_stats.csv"))

write_csv(species_occurrence, 
          here("workflows", "01_data_wrangling", "3_output", "tables", "species_occurrence_patterns.csv"))

# Print completion message ----
message("✓ Data wrangling completed successfully!")
message("→ Datasets saved to 3_output/tables/")
message("→ Ready for analysis in 02_analysis.R")

# Print data summary ----
cat("\n=== Data Wrangling Summary ===\n")
cat("Sites processed:", length(unique(cleaned_dataset$site_id)), "\n")
cat("Species retained:", length(unique(cleaned_dataset$species)), "\n")
cat("Total observations:", nrow(cleaned_dataset), "\n")
cat("Habitat types:", length(unique(cleaned_dataset$habitat)), "\n")
cat("Elevation range:", min(cleaned_dataset$elevation), "to", max(cleaned_dataset$elevation), "m\n")

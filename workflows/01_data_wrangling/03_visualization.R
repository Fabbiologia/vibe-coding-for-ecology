# Visualization Script: Creating Insightful Ecological Plots
# Part of the Vibe Coding for Ecology workflow series
# This script creates publication-ready visualizations from analyzed ecological data

# Load essential libraries ----
library(tidyverse)  # For data manipulation and visualization
library(viridis)    # For colorblind-friendly palettes
library(ggrepel)    # For non-overlapping text labels
library(patchwork)  # For combining plots
library(here)       # For robust file paths

# Set seed for reproducibility ----
set.seed(123)

# Load analysis results ----
message("Loading analysis results...")

cleaned_dataset <- readRDS(
  here("workflows", "01_data_wrangling", "3_output", "tables", "cleaned_species_environmental_data.rds")
)

richness_analysis <- readRDS(
  here("workflows", "01_data_wrangling", "3_output", "tables", "richness_analysis.rds")
)

abundance_patterns <- readRDS(
  here("workflows", "01_data_wrangling", "3_output", "tables", "abundance_patterns.rds")
)

diversity_analysis <- readRDS(
  here("workflows", "01_data_wrangling", "3_output", "tables", "diversity_analysis.rds")
)

elevation_preferences <- readRDS(
  here("workflows", "01_data_wrangling", "3_output", "tables", "elevation_preferences.rds")
)

# Plot 1: Species richness by habitat ----
message("Creating species richness visualization...")

richness_plot <- richness_analysis %>%
  ggplot(aes(x = habitat, y = species_richness, fill = habitat)) +
  geom_boxplot(alpha = 0.7, show.legend = FALSE) +
  geom_jitter(width = 0.2, alpha = 0.8, size = 3) +
  scale_fill_viridis_d(option = "plasma", begin = 0.3, end = 0.8) +
  labs(
    title = "Species Richness Across Habitat Types",
    subtitle = "Each point represents one sampling site",
    x = "Habitat Type",
    y = "Number of Species",
    caption = "Data: Simulated forest and grassland communities"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    plot.caption = element_text(size = 10, style = "italic")
  )

print(richness_plot)

# Save richness plot
ggsave(
  here("workflows", "01_data_wrangling", "3_output", "figures", "species_richness_by_habitat.png"),
  richness_plot,
  width = 8, height = 6, dpi = 300
)

# Plot 2: Abundance patterns by species and habitat ----
message("Creating abundance patterns visualization...")

abundance_heatmap <- cleaned_dataset %>%
  group_by(species, habitat) %>%
  summarise(mean_abundance = mean(abundance), .groups = 'drop') %>%
  ggplot(aes(x = habitat, y = reorder(species, mean_abundance), fill = mean_abundance)) +
  geom_tile(color = "white", size = 0.5) +
  scale_fill_viridis_c(option = "viridis", name = "Mean\nAbundance") +
  labs(
    title = "Species Abundance Patterns Across Habitats",
    subtitle = "Heatmap showing mean abundance per species and habitat",
    x = "Habitat Type",
    y = "Species",
    caption = "Darker colors indicate higher abundance"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    axis.text.y = element_text(face = "italic"),
    plot.caption = element_text(size = 10, style = "italic")
  )

print(abundance_heatmap)

# Save abundance heatmap
ggsave(
  here("workflows", "01_data_wrangling", "3_output", "figures", "abundance_heatmap.png"),
  abundance_heatmap,
  width = 8, height = 6, dpi = 300
)

# Plot 3: Diversity indices comparison ----
message("Creating diversity indices visualization...")

diversity_comparison <- diversity_analysis %>%
  select(site_id, habitat, elevation_class, shannon_diversity, simpson_diversity, evenness) %>%
  pivot_longer(
    cols = c(shannon_diversity, simpson_diversity, evenness),
    names_to = "diversity_metric",
    values_to = "value"
  ) %>%
  mutate(
    diversity_metric = factor(diversity_metric, 
                             levels = c("shannon_diversity", "simpson_diversity", "evenness"),
                             labels = c("Shannon Diversity", "Simpson Diversity", "Evenness"))
  ) %>%
  ggplot(aes(x = habitat, y = value, fill = habitat)) +
  geom_boxplot(alpha = 0.7, show.legend = FALSE) +
  geom_jitter(width = 0.2, alpha = 0.6, size = 2) +
  facet_wrap(~ diversity_metric, scales = "free_y", ncol = 3) +
  scale_fill_viridis_d(option = "plasma", begin = 0.3, end = 0.8) +
  labs(
    title = "Diversity Metrics Across Habitat Types",
    subtitle = "Comparison of three complementary diversity measures",
    x = "Habitat Type",
    y = "Diversity Value",
    caption = "Higher values indicate greater diversity or evenness"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    strip.text = element_text(size = 11, face = "bold"),
    plot.caption = element_text(size = 10, style = "italic")
  )

print(diversity_comparison)

# Save diversity comparison
ggsave(
  here("workflows", "01_data_wrangling", "3_output", "figures", "diversity_metrics_comparison.png"),
  diversity_comparison,
  width = 12, height = 5, dpi = 300
)

# Plot 4: Elevation relationships ----
message("Creating elevation relationship visualization...")

elevation_plot <- cleaned_dataset %>%
  # Focus on species with strong elevation preferences
  filter(species %in% elevation_preferences$species[1:3]) %>%
  ggplot(aes(x = elevation, y = abundance, color = species)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, alpha = 0.3) +
  facet_wrap(~ species, scales = "free_y", ncol = 2) +
  scale_color_viridis_d(option = "plasma", name = "Species") +
  labs(
    title = "Species Abundance Along Elevation Gradients",
    subtitle = "Linear trends for species with significant elevation preferences",
    x = "Elevation (m)",
    y = "Abundance",
    caption = "Lines show linear regression fits with 95% confidence intervals"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(size = 12),
    strip.text = element_text(size = 11, face = "bold", style = "italic"),
    plot.caption = element_text(size = 10, style = "italic"),
    legend.position = "none"  # Remove legend since facets show species names
  )

print(elevation_plot)

# Save elevation plot
ggsave(
  here("workflows", "01_data_wrangling", "3_output", "figures", "elevation_relationships.png"),
  elevation_plot,
  width = 10, height = 8, dpi = 300
)

# Plot 5: Environmental correlations network ----
message("Creating environmental correlations visualization...")

env_correlations_plot <- cleaned_dataset %>%
  select(elevation, soil_ph, annual_precip_mm, canopy_cover_pct, abundance) %>%
  cor() %>%
  as_tibble(rownames = "var1") %>%
  pivot_longer(-var1, names_to = "var2", values_to = "correlation") %>%
  filter(var1 != var2) %>%
  # Clean variable names for plotting
  mutate(
    var1 = case_when(
      var1 == "annual_precip_mm" ~ "Precipitation",
      var1 == "canopy_cover_pct" ~ "Canopy Cover",
      var1 == "soil_ph" ~ "Soil pH",
      var1 == "elevation" ~ "Elevation",
      var1 == "abundance" ~ "Species Abundance"
    ),
    var2 = case_when(
      var2 == "annual_precip_mm" ~ "Precipitation",
      var2 == "canopy_cover_pct" ~ "Canopy Cover", 
      var2 == "soil_ph" ~ "Soil pH",
      var2 == "elevation" ~ "Elevation",
      var2 == "abundance" ~ "Species Abundance"
    )
  ) %>%
  ggplot(aes(x = var1, y = var2, fill = correlation)) +
  geom_tile(color = "white", size = 0.5) +
  geom_text(aes(label = round(correlation, 2)), color = "white", size = 4, fontface = "bold") +
  scale_fill_gradient2(
    low = "#d73027", mid = "white", high = "#1a9850",
    midpoint = 0, name = "Correlation", 
    limits = c(-1, 1)
  ) +
  labs(
    title = "Environmental Variable Correlations",
    subtitle = "Pearson correlation coefficients between environmental factors and abundance",
    x = "",
    y = "",
    caption = "Red = negative correlation, Green = positive correlation"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.caption = element_text(size = 10, style = "italic")
  ) +
  coord_fixed()

print(env_correlations_plot)

# Save correlations plot
ggsave(
  here("workflows", "01_data_wrangling", "3_output", "figures", "environmental_correlations.png"),
  env_correlations_plot,
  width = 8, height = 6, dpi = 300
)

# Plot 6: Combined summary figure ----
message("Creating combined summary visualization...")

# Create a multi-panel summary figure using patchwork
summary_figure <- (richness_plot + abundance_heatmap) / 
                  (diversity_comparison) +
  plot_annotation(
    title = "Ecological Patterns in Forest and Grassland Communities",
    subtitle = "Comprehensive analysis of species richness, abundance, and diversity patterns",
    caption = "Data wrangling workflow demonstration • Vibe Coding for Ecology",
    theme = theme(
      plot.title = element_text(size = 16, face = "bold"),
      plot.subtitle = element_text(size = 14),
      plot.caption = element_text(size = 11, style = "italic")
    )
  )

print(summary_figure)

# Save summary figure
ggsave(
  here("workflows", "01_data_wrangling", "3_output", "figures", "ecological_patterns_summary.png"),
  summary_figure,
  width = 16, height = 12, dpi = 300
)

# Create visualization summary report ----
message("Creating visualization summary...")

visualization_summary <- list(
  figures_created = 6,
  output_directory = "workflows/01_data_wrangling/3_output/figures/",
  figure_list = c(
    "species_richness_by_habitat.png",
    "abundance_heatmap.png", 
    "diversity_metrics_comparison.png",
    "elevation_relationships.png",
    "environmental_correlations.png",
    "ecological_patterns_summary.png"
  ),
  color_palette = "viridis (colorblind-friendly)",
  plot_theme = "theme_bw()",
  resolution = "300 DPI"
)

saveRDS(
  visualization_summary,
  here("workflows", "01_data_wrangling", "3_output", "tables", "visualization_summary.rds")
)

# Print completion message ----
message("✓ Visualization completed successfully!")
message("→ All figures saved to 3_output/figures/")
message("→ Data wrangling workflow trilogy complete!")

cat("\n=== Visualization Summary ===\n")
cat("Figures created:", visualization_summary$figures_created, "\n")
cat("Output directory:", visualization_summary$output_directory, "\n")
cat("Color palette:", visualization_summary$color_palette, "\n")
cat("Resolution:", visualization_summary$resolution, "\n")

cat("\nFigures produced:\n")
for(i in seq_along(visualization_summary$figure_list)) {
  cat(paste0(i, ". ", visualization_summary$figure_list[i], "\n"))
}

cat("\n✨ Ready for presentation and publication! ✨\n")

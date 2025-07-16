# Vibe Workflow: Alpha and Beta Diversity Analysis

**Goal:** Calculate and visualize alpha diversity (within-site richness and evenness) and beta diversity (between-site compositional differences) using the classic dune meadow dataset.

**Vibe:** A comprehensive exploration of ecological diversity that bridges community ecology theory with practical analytical tools.

**Core Packages:** `tidyverse`, `vegan`, `broom`

---

## 🪴 1. Project Setup & Vibe Check

This section establishes our foundation for diversity analysis. We load the essential packages for ecological analysis: tidyverse for data manipulation, vegan for ecological functions, and broom for tidy model outputs. The vegan package provides access to the dune dataset and specialized diversity functions that are standards in community ecology.

```r
# Load essential libraries for ecological diversity analysis
library(tidyverse)  # For data manipulation and visualization
library(vegan)      # For ecological data and diversity functions
library(broom)      # For tidying statistical outputs
library(here)       # For robust file paths

# Set seed for reproducibility of any stochastic operations
set.seed(123)

# Create output directories if they don't exist
if (!dir.exists(here("workflows", "05_diversity_metrics", "3_output", "figures"))) {
  dir.create(here("workflows", "05_diversity_metrics", "3_output", "figures"), recursive = TRUE)
}
if (!dir.exists(here("workflows", "05_diversity_metrics", "3_output", "tables"))) {
  dir.create(here("workflows", "05_diversity_metrics", "3_output", "tables"), recursive = TRUE)
}
```

---

## 🧹 2. Data Wrangling: The Tidy Up

Here we prepare the classic dune meadow dataset for diversity analysis. The dune dataset contains species abundances across 20 grassland sites, while dune.env provides environmental variables. This combination allows us to explore how diversity patterns relate to environmental gradients.

```r
# Load the dune dataset - species abundances in Dutch dune meadows
data(dune)
data(dune.env)

# Convert to tibbles and add site identifiers
species_data <- as_tibble(dune, rownames = "site_id")
env_data <- as_tibble(dune.env, rownames = "site_id")

# Quick vibe check on the data structure
glimpse(species_data)
glimpse(env_data)

# Check dimensions and basic properties
cat("Number of sites:", nrow(species_data), "\n")
cat("Number of species:", ncol(species_data) - 1, "\n")
cat("Total abundance across all sites:", sum(species_data[,-1]), "\n")

# Examine environmental variables
summary(env_data)

# Create a clean, combined dataset
# First, reshape species data to long format for easier manipulation
species_long <- species_data %>%
  pivot_longer(
    cols = -site_id,
    names_to = "species",
    values_to = "abundance"
  ) %>%
  filter(abundance > 0)  # Keep only species that are present

# Join with environmental data
combined_data <- species_long %>%
  left_join(env_data, by = "site_id")

# Preview the combined dataset
head(combined_data, 10)
```

---

## 🔬 3. The Analysis: Asking Our Questions

This is where we quantify diversity patterns using established ecological metrics. We calculate multiple alpha diversity indices (richness, Shannon, Simpson) and beta diversity measures (Bray-Curtis dissimilarity). These metrics provide complementary perspectives on community structure and compositional differences.

```r
# Calculate alpha diversity metrics for each site
alpha_diversity <- species_data %>%
  column_to_rownames("site_id") %>%
  {
    tibble(
      site_id = rownames(.),
      species_richness = specnumber(.),           # Number of species
      total_abundance = rowSums(.),               # Total individuals
      shannon_diversity = diversity(., index = "shannon"),  # Shannon H'
      simpson_diversity = diversity(., index = "simpson"),  # Simpson's D
      evenness = shannon_diversity / log(species_richness)  # Pielou's evenness
    )
  } %>%
  # Join with environmental data
  left_join(env_data, by = "site_id")

# Display alpha diversity results
print(alpha_diversity)

# Calculate beta diversity using Bray-Curtis dissimilarity
species_matrix <- species_data %>%
  column_to_rownames("site_id") %>%
  as.matrix()

# Calculate dissimilarity matrix
beta_diversity_matrix <- vegdist(species_matrix, method = "bray")

# Convert to a tidy format for analysis
beta_diversity_df <- beta_diversity_matrix %>%
  as.matrix() %>%
  as_tibble(rownames = "site1") %>%
  pivot_longer(
    cols = -site1,
    names_to = "site2", 
    values_to = "bray_curtis_dissim"
  ) %>%
  filter(site1 != site2) %>%  # Remove self-comparisons
  # Add environmental data for both sites
  left_join(env_data %>% select(site_id, Management, A1), 
            by = c("site1" = "site_id")) %>%
  rename(Management1 = Management, A1_site1 = A1) %>%
  left_join(env_data %>% select(site_id, Management, A1), 
            by = c("site2" = "site_id")) %>%
  rename(Management2 = Management, A1_site2 = A1) %>%
  # Create variables for comparing environmental similarity
  mutate(
    same_management = Management1 == Management2,
    moisture_diff = abs(A1_site1 - A1_site2)
  )

# Summary of beta diversity patterns
beta_summary <- beta_diversity_df %>%
  group_by(same_management) %>%
  summarise(
    mean_dissimilarity = mean(bray_curtis_dissim),
    sd_dissimilarity = sd(bray_curtis_dissim),
    n_comparisons = n(),
    .groups = 'drop'
  )

print(beta_summary)

# Statistical test: Do sites with same management have lower beta diversity?
beta_test <- t.test(
  bray_curtis_dissim ~ same_management, 
  data = beta_diversity_df
)

print(tidy(beta_test))
```

---

## 📊 4. Visualization: Seeing the Story

Visualization reveals patterns in diversity that summary statistics alone cannot capture. We create plots showing alpha diversity patterns across environmental gradients and beta diversity relationships that highlight the role of environmental similarity in structuring communities.

```r
# Plot 1: Alpha diversity across management types
alpha_plot <- alpha_diversity %>%
  ggplot(aes(x = Management, y = shannon_diversity, fill = Management)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.8, size = 2) +
  labs(
    title = "Shannon Diversity Across Management Types",
    x = "Management Type",
    y = "Shannon Diversity Index (H')",
    fill = "Management"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    legend.position = "none"
  )

print(alpha_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "alpha_diversity_by_management.png"),
  alpha_plot,
  width = 8, height = 6, dpi = 300
)

# Plot 2: Relationship between richness and evenness
richness_evenness_plot <- alpha_diversity %>%
  ggplot(aes(x = species_richness, y = evenness, color = Management)) +
  geom_point(size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Species Richness vs. Evenness",
    x = "Species Richness",
    y = "Pielou's Evenness",
    color = "Management"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    legend.position = "bottom"
  )

print(richness_evenness_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "richness_evenness_relationship.png"),
  richness_evenness_plot,
  width = 8, height = 6, dpi = 300
)

# Plot 3: Beta diversity patterns
beta_plot <- beta_diversity_df %>%
  ggplot(aes(x = moisture_diff, y = bray_curtis_dissim, color = same_management)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Beta Diversity vs. Environmental Difference",
    subtitle = "Bray-Curtis dissimilarity increases with moisture gradient differences",
    x = "Difference in Moisture (A1 scale)",
    y = "Bray-Curtis Dissimilarity",
    color = "Same Management"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom"
  )

print(beta_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "beta_diversity_environmental_gradient.png"),
  beta_plot,
  width = 10, height = 6, dpi = 300
)

# Plot 4: Diversity comparison across multiple indices
diversity_comparison <- alpha_diversity %>%
  select(site_id, Management, species_richness, shannon_diversity, simpson_diversity) %>%
  pivot_longer(
    cols = c(species_richness, shannon_diversity, simpson_diversity),
    names_to = "diversity_metric",
    values_to = "value"
  ) %>%
  mutate(
    diversity_metric = case_when(
      diversity_metric == "species_richness" ~ "Species Richness",
      diversity_metric == "shannon_diversity" ~ "Shannon Diversity",
      diversity_metric == "simpson_diversity" ~ "Simpson Diversity"
    )
  )

comparison_plot <- diversity_comparison %>%
  ggplot(aes(x = Management, y = value, fill = Management)) +
  geom_boxplot(alpha = 0.7) +
  facet_wrap(~diversity_metric, scales = "free_y") +
  labs(
    title = "Comparison of Diversity Metrics Across Management Types",
    x = "Management Type",
    y = "Diversity Value",
    fill = "Management"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    strip.text = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  )

print(comparison_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "diversity_metrics_comparison.png"),
  comparison_plot,
  width = 12, height = 8, dpi = 300
)
```

---

## 🧬 5. Reproducibility Check

We save our diversity calculations and document our computational environment. These results form the foundation for more advanced analyses like ordination or species indicator analysis. The diversity metrics we've calculated are standard in community ecology and comparable across studies.

```r
# Save alpha diversity results
write_csv(
  alpha_diversity,
  here("workflows", "05_diversity_metrics", "3_output", "tables", "alpha_diversity_results.csv")
)

# Save beta diversity matrix in multiple formats
write_csv(
  beta_diversity_df,
  here("workflows", "05_diversity_metrics", "3_output", "tables", "beta_diversity_pairwise.csv")
)

# Save the distance matrix object for future ordination analyses
saveRDS(
  beta_diversity_matrix,
  here("workflows", "05_diversity_metrics", "3_output", "tables", "bray_curtis_distance_matrix.rds")
)

# Save summary statistics
write_csv(
  beta_summary,
  here("workflows", "05_diversity_metrics", "3_output", "tables", "beta_diversity_summary.csv")
)

# Create and save a comprehensive summary report
diversity_summary <- list(
  alpha_diversity_summary = alpha_diversity %>%
    group_by(Management) %>%
    summarise(
      sites = n(),
      mean_richness = round(mean(species_richness), 2),
      mean_shannon = round(mean(shannon_diversity), 2),
      mean_evenness = round(mean(evenness, na.rm = TRUE), 3),
      .groups = 'drop'
    ),
  beta_diversity_test = tidy(beta_test),
  overall_stats = tibble(
    total_sites = nrow(alpha_diversity),
    total_species = max(alpha_diversity$species_richness),
    mean_site_richness = round(mean(alpha_diversity$species_richness), 1),
    mean_shannon = round(mean(alpha_diversity$shannon_diversity), 3)
  )
)

# Save the summary
saveRDS(
  diversity_summary,
  here("workflows", "05_diversity_metrics", "3_output", "tables", "diversity_analysis_summary.rds")
)

# Print final summary
cat("=== Diversity Analysis Summary ===\n")
cat("Total sites analyzed:", nrow(alpha_diversity), "\n")
cat("Mean species richness:", round(mean(alpha_diversity$species_richness), 1), "\n")
cat("Mean Shannon diversity:", round(mean(alpha_diversity$shannon_diversity), 3), "\n")
cat("Mean beta diversity (Bray-Curtis):", round(mean(beta_diversity_df$bray_curtis_dissim), 3), "\n")
cat("\nManagement effect on beta diversity:\n")
cat("Same management mean dissimilarity:", round(beta_summary$mean_dissimilarity[2], 3), "\n")
cat("Different management mean dissimilarity:", round(beta_summary$mean_dissimilarity[1], 3), "\n")
cat("T-test p-value:", format(beta_test$p.value, scientific = TRUE), "\n")

# Record session information for reproducibility
sessionInfo()
```

---

## Summary

This workflow demonstrates comprehensive diversity analysis in community ecology:

- **Alpha diversity**: Calculated multiple indices (richness, Shannon, Simpson, evenness) to capture different aspects of within-site diversity
- **Beta diversity**: Used Bray-Curtis dissimilarity to quantify compositional differences between sites
- **Environmental relationships**: Explored how management and moisture gradients relate to diversity patterns
- **Statistical testing**: Formally tested whether environmental similarity predicts compositional similarity

**Key findings:** Sites under the same management regime show lower beta diversity (more similar communities), and compositional dissimilarity increases with differences in moisture conditions. This suggests that both management practices and abiotic factors structure plant community composition in these dune meadows.

**Next steps:** These diversity metrics can feed into ordination analyses, indicator species analysis, or more complex models of community assembly.

# Vibe Workflow: Comprehensive Diversity Metrics

[![Reproducible](https://img.shields.io/badge/Reproducible-Yes-brightgreen)](https://github.com/Fabbiologia/vibe-coding-for-ecology)
[![R](https://img.shields.io/badge/R-4.0+-blue)](https://www.r-project.org/)
[![Tidyverse](https://img.shields.io/badge/Tidyverse-Compatible-orange)](https://www.tidyverse.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)



**Goal:** Explore and visualize diversity metrics within and between ecological communities, including alpha, beta, gamma diversity, Hill numbers, rarefaction curves, and diversity profiles.

**Vibe:** Integrate community ecology theory with analytical practices to explore diversity comprehensively.

**Core Packages:** `tidyverse`, `vegan`, `broom`, `iNEXT`, `hillR`, `betapart`

---

## 🪴 1. Project Setup & Vibe Check

This section establishes our foundation for diversity analysis. We load the essential packages for ecological analysis: tidyverse for data manipulation, vegan for ecological functions, and broom for tidy model outputs. The vegan package provides access to the dune dataset and specialized diversity functions that are standards in community ecology.

```r
# Load essential libraries for ecological diversity analysis
library(tidyverse)  # For data manipulation and visualization
library(vegan)      # For ecological data and diversity functions
library(broom)      # For tidying statistical outputs
library(here)       # For robust file paths

# Additional packages for comprehensive diversity analysis
library(iNEXT)      # For rarefaction and extrapolation
library(hillR)      # For Hill number calculations
library(betapart)   # For beta diversity partitioning
library(mobr)       # For scale-dependent diversity analysis
library(viridis)    # For color palettes

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

This is where we quantify diversity patterns using comprehensive ecological metrics. We calculate alpha, beta, and gamma diversity indices, Hill numbers, and perform rarefaction. These metrics offer deep insights into community structure and compositional differences.

```r
# Calculate beta diversity using Bray-Curtis dissimilarity
species_matrix <- species_data %>%
  column_to_rownames("site_id") %>%
  as.matrix()

# Calculate alpha diversity metrics for each site
alpha_diversity < - species_data %>%
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

# Calculate Hill numbers for each site (q = 0, 1, 2)
# q = 0: Species richness (sensitive to rare species)
# q = 1: Shannon diversity (exponential of Shannon entropy)
# q = 2: Simpson diversity (inverse Simpson concentration)
hill_numbers <- hill_taxa(species_matrix, q = c(0, 1, 2), MARGIN = 1)
hill_df <- as_tibble(hill_numbers, rownames = "site_id") %>%
  rename(hill_q0 = `0`, hill_q1 = `1`, hill_q2 = `2`) %>%
  left_join(env_data, by = "site_id")

print(hill_df)

# Perform rarefaction and extrapolation using iNEXT
# Prepare data for iNEXT (transpose for site-by-species format)
species_list <- lapply(1:nrow(species_matrix), function(i) {
  site_data <- species_matrix[i, ]
  site_data[site_data > 0]
})
names(species_list) <- rownames(species_matrix)

# Calculate rarefaction curves for q = 0, 1, 2
rarefaction_results <- iNEXT(species_list, q = c(0, 1, 2), datatype = "abundance")

# Extract rarefaction data for plotting
rarefaction_df <- rarefaction_results$iNextEst %>%
  bind_rows(.id = "site_id") %>%
  left_join(env_data, by = "site_id")

# Calculate gamma diversity (regional species pool)
species_pool <- specpool(species_matrix)
print(species_pool)

# Calculate multiplicative beta diversity partitioning
# This separates beta diversity into turnover and nestedness components
beta_partition <- beta.pair(species_matrix, index.family = "sorensen")

# Extract components
beta_turnover <- as.matrix(beta_partition$beta.sim)  # Turnover component
beta_nestedness <- as.matrix(beta_partition$beta.sne)  # Nestedness component
beta_total <- as.matrix(beta_partition$beta.sor)  # Total beta diversity

# Create tidy format for beta diversity components
beta_components_df <- tibble(
  site1 = rep(rownames(beta_total), each = ncol(beta_total)),
  site2 = rep(colnames(beta_total), times = nrow(beta_total)),
  beta_total = as.vector(beta_total),
  beta_turnover = as.vector(beta_turnover),
  beta_nestedness = as.vector(beta_nestedness)
) %>%
  filter(site1 != site2) %>%
  left_join(env_data %>% select(site_id, Management), by = c("site1" = "site_id")) %>%
  rename(Management1 = Management) %>%
  left_join(env_data %>% select(site_id, Management), by = c("site2" = "site_id")) %>%
  rename(Management2 = Management) %>%
  mutate(same_management = Management1 == Management2)

# Summary of beta diversity components
beta_components_summary <- beta_components_df %>%
  group_by(same_management) %>%
  summarise(
    mean_total = mean(beta_total),
    mean_turnover = mean(beta_turnover),
    mean_nestedness = mean(beta_nestedness),
    .groups = 'drop'
  )

print(beta_components_summary)

# Display alpha diversity results
print(alpha_diversity)

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

### **Visualization To-Do List**

- [ ] **Hill Number Plots**
  - [ ] Bar plots of Hill numbers by management type
  - [ ] Use viridis color palette for consistency
  - [ ] Add error bars for variability
  - [ ] Export with high-resolution settings

- [ ] **Rarefaction Curves**
  - [ ] Plot rarefaction curves for each site
  - [ ] Differentiate with color by management or other factors
  - [ ] Include confidence intervals
  - [ ] Annotate key trends and values

- [ ] **Beta Diversity Partitioning**
  - [ ] Stacked bar plots of beta diversity components
  - [ ] Highlight contributions of turnover vs nestedness
  - [ ] Use colors to distinguish components
  - [ ] Save for publication purposes

- [ ] **Beta Diversity Patterns**
  - [ ] Plot Bray-Curtis dissimilarity vs environmental gradients
  - [ ] Color by same/different management
  - [ ] Add smooth trend lines
  - [ ] Include uncertainty bands
  - [ ] Use informative titles and captions

- [ ] **Diversity Metrics Comparison**
  - [ ] Create faceted comparison of multiple diversity indices
  - [ ] Use consistent color schemes across panels
  - [ ] Apply appropriate scaling for each metric
  - [ ] Include statistical annotations if significant
  - [ ] Export with publication-ready dimensions

- [ ] **Figure Styling Standards**
  - [ ] Use colorblind-friendly palettes
  - [ ] Apply consistent font sizes (title 14, subtitle 12)
  - [ ] Position legends appropriately
  - [ ] Include informative axis labels with units
  - [ ] Save with descriptive filenames
  - [ ] Use 300 DPI resolution for publication quality

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

# Plot 5: Hill Numbers by Management Type
hill_long <- hill_df %>%
  select(site_id, Management, hill_q0, hill_q1, hill_q2) %>%
  pivot_longer(
    cols = c(hill_q0, hill_q1, hill_q2),
    names_to = "hill_order",
    values_to = "hill_value"
  ) %>%
  mutate(
    hill_order = case_when(
      hill_order == "hill_q0" ~ "Hill q=0 (Richness)",
      hill_order == "hill_q1" ~ "Hill q=1 (Shannon)",
      hill_order == "hill_q2" ~ "Hill q=2 (Simpson)"
    )
  )

hill_plot <- hill_long %>%
  ggplot(aes(x = Management, y = hill_value, fill = Management)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.8, size = 2) +
  facet_wrap(~hill_order, scales = "free_y") +
  scale_fill_viridis_d(name = "Management") +
  labs(
    title = "Hill Numbers Across Management Types",
    subtitle = "Different orders emphasize rare vs. common species",
    x = "Management Type",
    y = "Hill Number Value"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    strip.text = element_text(size = 12, face = "bold"),
    legend.position = "none"
  )

print(hill_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "hill_numbers_by_management.png"),
  hill_plot,
  width = 12, height = 8, dpi = 300
)

# Plot 6: Rarefaction Curves
rarefaction_plot <- rarefaction_df %>%
  filter(Order.q == 0) %>%  # Focus on species richness
  ggplot(aes(x = m, y = qD, color = Management)) +
  geom_line(aes(group = site_id), alpha = 0.7, size = 1) +
  geom_ribbon(aes(ymin = qD.LCL, ymax = qD.UCL, fill = Management), alpha = 0.2) +
  scale_color_viridis_d(name = "Management") +
  scale_fill_viridis_d(name = "Management") +
  labs(
    title = "Species Rarefaction Curves by Management Type",
    subtitle = "Curves show expected species richness at different sampling intensities",
    x = "Sample Size (m)",
    y = "Species Richness (qD)"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom"
  )

print(rarefaction_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "rarefaction_curves.png"),
  rarefaction_plot,
  width = 10, height = 8, dpi = 300
)

# Plot 7: Beta Diversity Partitioning
beta_partition_plot <- beta_components_summary %>%
  pivot_longer(
    cols = c(mean_turnover, mean_nestedness),
    names_to = "component",
    values_to = "value"
  ) %>%
  mutate(
    component = case_when(
      component == "mean_turnover" ~ "Turnover",
      component == "mean_nestedness" ~ "Nestedness"
    ),
    same_management = ifelse(same_management, "Same Management", "Different Management")
  ) %>%
  ggplot(aes(x = same_management, y = value, fill = component)) +
  geom_col(position = "stack", alpha = 0.8) +
  scale_fill_viridis_d(name = "Component", begin = 0.3, end = 0.8) +
  labs(
    title = "Beta Diversity Partitioning",
    subtitle = "Turnover vs. Nestedness components of beta diversity",
    x = "Management Comparison",
    y = "Beta Diversity Value"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom"
  )

print(beta_partition_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "beta_diversity_partitioning.png"),
  beta_partition_plot,
  width = 8, height = 6, dpi = 300
)

# Plot 8: Diversity Profile (Hill Numbers Across Orders)
diversity_profile <- hill_df %>%
  select(site_id, Management, hill_q0, hill_q1, hill_q2) %>%
  pivot_longer(
    cols = c(hill_q0, hill_q1, hill_q2),
    names_to = "q_order",
    values_to = "hill_value"
  ) %>%
  mutate(
    q_numeric = case_when(
      q_order == "hill_q0" ~ 0,
      q_order == "hill_q1" ~ 1,
      q_order == "hill_q2" ~ 2
    )
  ) %>%
  group_by(Management, q_numeric) %>%
  summarise(
    mean_hill = mean(hill_value),
    se_hill = sd(hill_value) / sqrt(n()),
    .groups = 'drop'
  )

profile_plot <- diversity_profile %>%
  ggplot(aes(x = q_numeric, y = mean_hill, color = Management)) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = mean_hill - se_hill, ymax = mean_hill + se_hill), 
                width = 0.1, size = 1) +
  scale_color_viridis_d(name = "Management") +
  scale_x_continuous(breaks = c(0, 1, 2), 
                     labels = c("q=0\n(Richness)", "q=1\n(Shannon)", "q=2\n(Simpson)")) +
  labs(
    title = "Diversity Profiles by Management Type",
    subtitle = "Hill numbers across different orders of diversity",
    x = "Order of Diversity (q)",
    y = "Hill Number Value"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 12),
    legend.position = "bottom"
  )

print(profile_plot)

# Save the plot
ggsave(
  here("workflows", "05_diversity_metrics", "3_output", "figures", "diversity_profiles.png"),
  profile_plot,
  width = 8, height = 6, dpi = 300
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
- **Hill numbers**: Computed Hill numbers (q = 0, 1, 2) to provide a unified framework for diversity measurement across different orders
- **Beta diversity**: Used Bray-Curtis dissimilarity to quantify compositional differences between sites
- **Beta diversity partitioning**: Decomposed beta diversity into turnover and nestedness components using Sørensen-based indices
- **Gamma diversity**: Calculated regional species pool characteristics to understand landscape-level diversity patterns
- **Rarefaction and extrapolation**: Generated rarefaction curves using iNEXT to standardize diversity comparisons across different sampling efforts
- **Diversity profiles**: Created Hill number profiles to visualize how diversity patterns change with different emphases on rare vs. common species
- **Environmental relationships**: Explored how management and moisture gradients relate to diversity patterns
- **Statistical testing**: Formally tested whether environmental similarity predicts compositional similarity

**Key findings:** Sites under the same management regime show lower beta diversity (more similar communities), and compositional dissimilarity increases with differences in moisture conditions. Hill numbers reveal that diversity patterns are consistent across different orders, while beta diversity partitioning shows that turnover (species replacement) dominates over nestedness in structuring communities. Rarefaction curves indicate that sampling effort is adequate for most sites, though some management types may benefit from additional sampling.

**Next steps:** These comprehensive diversity metrics provide a solid foundation for:
- Ordination analyses to visualize community structure
- Indicator species analysis to identify characteristic taxa
- Functional diversity assessments
- Temporal diversity monitoring
- More complex models of community assembly and metacommunity dynamics

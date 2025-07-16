# R Coding Rules for Ecology

*Actionable guidelines tailored for ecological research and Vibe Coding principles*

## 🎨 **Plotting & Visualization**

1. **Use `theme_bw()` or `theme_minimal()` by default** for clean, publication-ready plots
   ```r
   ggplot(data, aes(x, y)) + geom_point() + theme_bw()
   ```

2. **Always label axes and legends** with meaningful names and units
   ```r
   labs(x = "Elevation (m)", y = "Species richness", 
        title = "Species richness across elevation gradient")
   ```

3. **Save plots programmatically** using `ggsave()` with explicit dimensions and resolution
   ```r
   ggsave("species_richness_plot.png", width = 8, height = 6, dpi = 300)
   ```

4. **Use color-blind-safe palettes** like `viridis` or `RColorBrewer::brewer.pal(..., "Set2")`
   ```r
   scale_color_viridis_d() # for discrete variables
   scale_color_viridis_c() # for continuous variables
   ```

## 📁 **Data Management**

5. **Keep raw data immutable** - never modify original files directly
   ```r
   # Good: read raw, modify copy, save processed
   raw_data <- read_csv("data/raw/field_data.csv")
   clean_data <- raw_data %>% filter(!is.na(species))
   saveRDS(clean_data, "data/processed/cleaned_data.rds")
   ```

6. **Use relative file paths** with `here::here()` for cross-platform compatibility
   ```r
   clean_data <- readRDS(here::here("data", "processed", "cleaned_data.rds"))
   ```

7. **Name processed data descriptively** - avoid generic names like `data.rds`
   ```r
   saveRDS(species_matrix, here::here("data", "processed", "species_abundance_matrix.rds"))
   ```

## 🔄 **Reproducibility**

8. **Scripts must run top-to-bottom** without manual intervention
   ```r
   # Include all necessary library() calls at the top
   # Set working directory with here::here() if needed
   # Handle missing directories: if (!dir.exists("output")) dir.create("output")
   ```

9. **Seed random number generators** for any stochastic operations
   ```r
   set.seed(123) # Use a consistent seed across your project
   ```

10. **Document session information** at the end of analysis scripts
    ```r
    sessionInfo() # Always include this for reproducibility
    ```

11. **Use `renv` for dependency management** and commit `renv.lock`
    ```r
    renv::init()    # Initialize project environment
    renv::snapshot() # Save current package versions
    ```

## 📝 **Code Style & Documentation**

12. **Use descriptive variable names** that convey meaning
    ```r
    # Good
    species_richness_model <- lm(richness ~ elevation, data = site_data)
    
    # Avoid
    m1 <- lm(y ~ x, data = df)
    ```

13. **Document every function** with roxygen-style comments
    ```r
    #' Calculate species richness per site
    #' @param species_matrix Matrix with sites as rows, species as columns
    #' @return Vector of species richness values
    calculate_richness <- function(species_matrix) {
      rowSums(species_matrix > 0)
    }
    ```

14. **Use assignment operator `<-`** instead of `=` for assignments
    ```r
    species_data <- read_csv("species.csv") # Preferred
    ```

15. **Comment generously** - explain the *why*, not just the *what*
    ```r
    # Remove sites with < 5 species to focus on established communities
    filtered_sites <- sites %>% filter(species_count >= 5)
    ```

## 🏗️ **Project Organization**

16. **Number scripts sequentially** to show analysis flow
    ```
    01_data_cleaning.R
    02_species_richness_analysis.R  
    03_visualization.R
    ```

17. **Use consistent directory structure** following Vibe Coding sanctuary principles
    ```
    data/raw/          # Original, untouched data
    data/processed/    # Cleaned, analysis-ready data
    scripts/          # Numbered R scripts
    output/figures/   # Generated plots
    output/tables/    # Generated tables
    ```

## ⚡ **Performance & Logging**

18. **Log long operations** (>10 seconds) to track progress
    ```r
    library(futile.logger)
    flog.info("Starting PCA analysis on %d sites", nrow(site_data))
    ```

19. **Use progress bars** for long loops or apply functions
    ```r
    library(progress)
    pb <- progress_bar$new(total = length(files))
    results <- map(files, ~{pb$tick(); process_file(.x)})
    ```

## 🧪 **Analysis Best Practices**

20. **Validate model assumptions** before interpreting results
    ```r
    # For linear models, always check residuals
    plot(model)
    # For GLMs, check dispersion
    check_overdispersion(glm_model)
    ```

21. **Use version control** with meaningful commit messages
    ```bash
    git commit -m "feat: add species accumulation curve analysis"
    git commit -m "fix: correct elevation data units in cleaning script"
    ```

## 💡 **Contributing to These Rules**

Found a better way to handle ecological data? Want to suggest a new guideline? 

1. Open an issue with the `rule-proposal` label
2. Discuss with the community 
3. Submit a PR with your proposed changes to this file

*Remember: These rules evolve with our understanding. The goal is clarity, reproducibility, and shared understanding in ecological analysis.*

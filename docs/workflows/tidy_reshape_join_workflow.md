# Vibe Workflow: Data Wrangling Essentials

[![Reproducible](https://img.shields.io/badge/Reproducible-Yes-brightgreen)](https://github.com/Fabbiologia/vibe-coding-for-ecology)
[![R](https://img.shields.io/badge/R-4.0+-blue)](https://www.r-project.org/)
[![Tidyverse](https://img.shields.io/badge/Tidyverse-Compatible-orange)](https://www.tidyverse.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)



**Goal:** Master the fundamental data wrangling operations that form the backbone of ecological analysis - tidying messy data, reshaping between wide and long formats, and joining multiple datasets.

**Vibe:** A foundation-building workflow that transforms raw ecological data into analysis-ready formats with confidence and clarity.

**Core Packages:** `tidyverse` (dplyr, tidyr, readr)

---

## 🪴 1. Project Setup & Vibe Check

This section establishes our data wrangling sanctuary. We load the tidyverse suite, which provides all the tools we need for modern data manipulation. The `here` package ensures our file paths work consistently across different operating systems and project setups. This foundation feels right because it creates a predictable, reproducible environment for our data work.

### Instructions for AI Agent:

**Task:** Set up the data wrangling environment with all necessary packages and reproducible settings.

**Step-by-step instructions:**
1. Load tidyverse for comprehensive data manipulation (dplyr, tidyr, readr, ggplot2)
2. Load here package for robust relative file paths that work across systems
3. Load any additional packages needed for specific data operations
4. Set random seed to 123 for consistent results across runs
5. Create output directory structure for figures if it doesn't exist
6. Create output directory structure for tables if it doesn't exist
7. Verify workspace is clean and organized for data operations

**Expected output:** A clean R environment with all necessary packages loaded and directory structure established.

---

## 🧹 2. Data Wrangling: The Tidy Up

Here we demonstrate the core data wrangling patterns using built-in ecological datasets. We'll work with three common scenarios: untidy data that needs reshaping, datasets that require joining, and messy data that needs cleaning. These examples mirror real-world ecological data challenges while remaining immediately runnable.

### **Scenario 1: Reshaping Wide to Long (Species Abundance Data)**

### Instructions for AI Agent:

**Task:** Reshape, inspect, and validate a species abundance dataset. 

**Step-by-step instructions:**
1. Generate a simulated species abundance dataset in wide format with site identifiers, habitat categories, elevation data, and species abundance columns.
2. Inspect the wide format data structure using appropriate methods to ensure each species is a separate column and check for any inconsistencies or missing values.
3. Reshape the dataset from wide to long format by converting species columns to rows and creating new 'species' and 'abundance' columns.
4. Apply string cleaning to standardize species names.
5. Validate the transformation by checking the dimensions and ensuring the integrity of data is maintained.

**Expected output:** A tidy long-format species abundance dataset ready for analysis.

### **Scenario 2: Joining Environmental and Species Data**

### Instructions for AI Agent:

**Task:** Join environmental data with species data and calculate derived ecological metrics.

**Step-by-step instructions:**
1. Create complementary environmental dataset with soil pH, precipitation, and canopy cover data for the same sites as species data.
2. Perform left_join() to combine species and environmental data using site identifiers.
3. Verify all species records retain environmental information and check for unmatched sites.
4. Calculate derived ecological metrics including species richness and total abundance per site.
5. Validate the joining operation by checking dimensions and data integrity.

**Expected output:** A combined dataset with species, environmental, and derived ecological metrics.

### **Scenario 3: Cleaning and Filtering Operations**

### Instructions for AI Agent:

**Task:** Clean and validate ecological data with realistic quality issues.

**Step-by-step instructions:**
1. Introduce realistic data quality issues including missing values, inconsistent naming, and impossible values.
2. Implement systematic data cleaning by standardizing species names and handling impossible values.
3. Apply data validation filters to remove records with missing critical information.
4. Document all cleaning operations including counts of missing values and corrections made.
5. Create a summary of data quality before and after cleaning operations.

**Expected output:** A cleaned and validated dataset ready for ecological analysis with documentation of all cleaning steps.
---

## 🔬 3. The Analysis: Asking Our Questions

Now we apply our cleaned data to answer ecological questions. Data wrangling enables analysis - here we calculate summary statistics and explore patterns that would be difficult with messy data. The tidy format makes grouping operations intuitive and the results immediately interpretable.

### Instructions for AI Agent:

**Task:** Analyze cleaned ecological data to answer key ecological questions.

**Step-by-step instructions:**
1. Calculate habitat-based summary statistics including species richness, total abundance, and Shannon diversity index grouped by site, habitat, and elevation class.
2. Analyze species occurrence patterns by counting site presence, calculating mean abundance when present, and determining maximum abundance for each species-habitat combination.
3. Examine environmental correlations by calculating correlations between species abundance and environmental variables (elevation, soil pH, precipitation) using complete observations only.
4. Display all results in organized summary tables with clear variable names.

**Expected output:** Comprehensive ecological summary statistics and correlation analyses ready for interpretation.

---

## 📊 4. Visualization: Seeing the Story

Visualization reveals patterns that summary statistics alone cannot capture. These plots demonstrate how proper data wrangling enables clear, informative graphics. Each visualization answers a specific ecological question about species distributions and environmental relationships.

### Instructions for AI Agent:

**Task:** Create publication-quality visualizations of ecological patterns.

**Step-by-step instructions:**
1. Create species richness visualization using boxplots grouped by elevation class and habitat type, with individual data points and jitter for site-level variation.
2. Generate species abundance patterns plot using column charts with dodged positioning to compare habitats side-by-side.
3. Develop environmental relationship visualizations using scatter plots with species-specific trend lines and faceting by habitat type.
4. Apply consistent theme_bw() styling to all plots with appropriate titles, axis labels, and legend positioning.
5. Save all visualizations as high-resolution PNG files (300 DPI) with appropriate dimensions for publication.

**Expected output:** Three publication-ready ecological visualizations saved to the figures directory.

---

## 🧬 5. Reproducibility Check

Proper data wrangling creates a foundation for reproducible research. Here we save our processed data, document our workflow, and ensure others can replicate our analysis. The tidy data we've created serves as a clean foundation for any subsequent ecological analysis.

### Instructions for AI Agent:

**Task:** Ensure reproducibility by saving processed data and documenting the computational environment.

**Step-by-step instructions:**
1. Save all processed datasets as CSV files to the tables output folder using robust file paths.
2. Export habitat summary statistics, species occurrence patterns, and cleaned ecological data in structured formats.
3. Document the computational environment by recording sessionInfo() to capture R version, package versions, and system information.
4. Include timestamp of analysis completion and random seed used for reproducibility.
5. Create a comprehensive record that enables future replication of the analysis.

**Expected output:** Saved datasets in CSV format and complete documentation of the computational environment for reproducibility.

---

## Summary

This workflow demonstrates the fundamental data wrangling operations that underpin ecological analysis:

- **Reshaping data** from wide to long format using `pivot_longer()`
- **Joining datasets** to combine biological and environmental information
- **Cleaning and filtering** to prepare data for analysis
- **Creating summary statistics** that reveal ecological patterns
- **Visualizing relationships** that emerge from properly structured data

The key insight is that investing time in proper data wrangling pays dividends throughout the analysis pipeline. Clean, tidy data makes subsequent analyses more reliable, interpretable, and reproducible.

**Next steps:** Use this cleaned dataset as input for specialized analyses like diversity metrics, ordination, or species distribution modeling.

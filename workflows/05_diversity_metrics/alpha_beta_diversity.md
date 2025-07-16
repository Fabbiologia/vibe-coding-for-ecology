# Vibe Workflow: Comprehensive Diversity Metrics

**Goal:** Explore and visualize diversity metrics within and between ecological communities, including alpha, beta, gamma diversity, Hill numbers, rarefaction curves, and diversity profiles.

**Vibe:** Integrate community ecology theory with analytical practices to explore diversity comprehensively.

**Core Packages:** `tidyverse`, `vegan`, `broom`, `iNEXT`, `hillR`, `betapart`

---

## 🪴 1. Project Setup & Vibe Check

This section establishes our foundation for diversity analysis. We load the essential packages for ecological analysis: tidyverse for data manipulation, vegan for ecological functions, and broom for tidy model outputs. The vegan package provides access to the dune dataset and specialized diversity functions that are standards in community ecology.

**AI Agent Instructions for Project Setup:**

1. **Load essential R packages for ecological diversity analysis:**
   - Load tidyverse for comprehensive data manipulation and visualization capabilities
   - Load vegan package which provides ecological data and specialized diversity functions
   - Load broom for converting statistical outputs into tidy data frames
   - Load here package for creating robust, reproducible file paths

2. **Load additional specialized diversity packages:**
   - Load iNEXT package for rarefaction and extrapolation analyses
   - Load hillR package for calculating Hill numbers (unified diversity framework)
   - Load betapart package for beta diversity partitioning into turnover and nestedness
   - Load mobr package for scale-dependent diversity analysis
   - Load viridis package for colorblind-friendly color palettes

3. **Set reproducibility parameters:**
   - Set a random seed value of 123 to ensure reproducible results for any stochastic operations

4. **Create directory structure for outputs:**
   - Check if the directory "workflows/05_diversity_metrics/3_output/figures" exists
   - If not, create this directory path recursively to store figure outputs
   - Check if the directory "workflows/05_diversity_metrics/3_output/tables" exists
   - If not, create this directory path recursively to store table outputs
   - Use the here() function to ensure paths work across different operating systems

---

## 🧹 2. Data Wrangling: The Tidy Up

Here we prepare the classic dune meadow dataset for diversity analysis. The dune dataset contains species abundances across 20 grassland sites, while dune.env provides environmental variables. This combination allows us to explore how diversity patterns relate to environmental gradients.

**AI Agent Instructions for Data Wrangling:**

1. **Load the classic ecological datasets:**
   - Load the "dune" dataset which contains species abundances in Dutch dune meadows
   - Load the "dune.env" dataset which contains environmental variables for the same sites
   - These are built-in datasets from the vegan package

2. **Convert data to tidy format:**
   - Convert the dune data to a tibble format, preserving row names as a new column called "site_id"
   - Convert the dune.env data to a tibble format, preserving row names as a new column called "site_id"
   - This ensures site identifiers are preserved as explicit columns rather than row names

3. **Perform initial data exploration:**
   - Use glimpse() to examine the structure of the species data
   - Use glimpse() to examine the structure of the environmental data
   - Print the number of sites (number of rows in species data)
   - Print the number of species (number of columns minus one for the site_id column)
   - Calculate and print the total abundance across all sites (sum of all numeric columns)

4. **Examine environmental variables:**
   - Generate a summary of the environmental data to understand variable types and distributions
   - This helps identify factor levels for management types and ranges for continuous variables

5. **Create a combined long-format dataset:**
   - Reshape the species data from wide to long format:
     - Keep the site_id column as is
     - Transform all other columns into two new columns: "species" (column names) and "abundance" (values)
   - Filter to keep only rows where abundance is greater than 0 (remove absent species)
   - This creates a presence-only dataset in long format

6. **Join species and environmental data:**
   - Perform a left join between the long species data and environmental data using "site_id" as the key
   - This adds environmental variables to each species occurrence record
   - Preview the first 10 rows of the combined dataset to verify the join worked correctly

---

## 🔬 3. The Analysis: Asking Our Questions

This is where we quantify diversity patterns using comprehensive ecological metrics. We calculate alpha, beta, and gamma diversity indices, Hill numbers, and perform rarefaction. These metrics offer deep insights into community structure and compositional differences.

```
Write R code to perform a comprehensive diversity analysis on the dune dataset:  
- Calculate a species matrix (site x species) from the tidy data.  
- For each site, calculate alpha diversity metrics: species richness, total abundance, Shannon diversity, Simpson diversity, and Pielou's evenness. Join these with environmental data.  
- Calculate Hill numbers (q = 0, 1, 2) for each site using hillR, and join with environmental data.  
- Prepare the data for iNEXT and calculate rarefaction curves for q = 0, 1, 2. Extract the results for plotting and join with environmental data.  
- Calculate gamma diversity (regional species pool) using specpool().  
- Partition beta diversity into turnover and nestedness components using betapart.  
- Create a tidy dataframe of beta diversity components, including management type for each site pair and whether they share the same management.  
- Summarize beta diversity components by same/different management.  
- Calculate a Bray-Curtis dissimilarity matrix and convert it to a tidy dataframe, including environmental data for both sites and the difference in moisture (A1).  
- Summarize beta diversity patterns by same/different management and perform a t-test to compare Bray-Curtis dissimilarity between groups.  
- Print all summary tables and test results.
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

```
Write R code to visualize diversity metrics from the previous analysis:  
- Create a boxplot of Shannon diversity by management type, with jittered points, styled for publication, and save as a high-res PNG.  
- Plot the relationship between species richness and evenness, colored by management, with a linear trend line, and save as PNG.  
- Plot Bray-Curtis dissimilarity vs. moisture difference, colored by same/different management, with a smooth trend line and save as PNG.  
- Create a faceted boxplot comparing species richness, Shannon, and Simpson diversity by management, and save as PNG.  
- Create a faceted boxplot of Hill numbers (q=0,1,2) by management, using the viridis color palette, and save as PNG.  
- Plot rarefaction curves (q=0) for each site, colored by management, with confidence intervals, and save as PNG.  
- Create a stacked bar plot of mean turnover and nestedness components of beta diversity by same/different management, using viridis colors, and save as PNG.  
- Plot diversity profiles (Hill numbers across q=0,1,2) by management, with error bars, and save as PNG.  
- For all plots, use colorblind-friendly palettes, consistent font sizes, informative axis labels, and 300 DPI resolution.
```

---

## 🧬 5. Reproducibility Check

We save our diversity calculations and document our computational environment. These results form the foundation for more advanced analyses like ordination or species indicator analysis. The diversity metrics we've calculated are standard in community ecology and comparable across studies.

```
Write R code to save all diversity analysis results for reproducibility:  
- Save the alpha diversity dataframe as a CSV.  
- Save the beta diversity pairwise dataframe as a CSV.  
- Save the Bray-Curtis distance matrix as an RDS file.  
- Save the beta diversity summary as a CSV.  
- Create a summary list containing:  
  - Alpha diversity summary by management  
  - Tidy output of the beta diversity t-test  
  - Overall stats (total sites, total species, mean site richness, mean Shannon)  
- Save the summary list as an RDS file.  
- Print a summary of the analysis, including total sites, mean richness, mean Shannon, mean beta diversity, mean dissimilarity for same/different management, and t-test p-value.  
- Print sessionInfo() for reproducibility.
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

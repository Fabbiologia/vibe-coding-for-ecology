# Vibe Workflow: Data Wrangling Essentials

**Goal:** Master the fundamental data wrangling operations that form the backbone of ecological analysis - tidying messy data, reshaping between wide and long formats, and joining multiple datasets.

**Vibe:** A foundation-building workflow that transforms raw ecological data into analysis-ready formats with confidence and clarity.

**Core Packages:** `tidyverse` (dplyr, tidyr, readr)

---

## 🪴 1. Project Setup & Vibe Check

This section establishes our data wrangling sanctuary. We load the tidyverse suite, which provides all the tools we need for modern data manipulation. The `here` package ensures our file paths work consistently across different operating systems and project setups. This foundation feels right because it creates a predictable, reproducible environment for our data work.

```english
Load essential libraries for data wrangling:
- Load tidyverse for comprehensive data manipulation (dplyr, tidyr, readr, ggplot2)
- Load here for robust relative file paths that work across systems
- Load any additional packages needed for specific data operations

Establish reproducible foundation:
- Set random seed to 123 for consistent results across runs
- Create output directory structure for figures if it doesn't exist
- Create output directory structure for tables if it doesn't exist
- Verify workspace is clean and organized for data operations
```

---

## 🧹 2. Data Wrangling: The Tidy Up

Here we demonstrate the core data wrangling patterns using built-in ecological datasets. We'll work with three common scenarios: untidy data that needs reshaping, datasets that require joining, and messy data that needs cleaning. These examples mirror real-world ecological data challenges while remaining immediately runnable.

### **Scenario 1: Reshaping Wide to Long (Species Abundance Data)**

```english
Create simulated species abundance dataset in wide format:
- Generate site identifiers with consistent naming (Site_1, Site_2, etc.)
- Add habitat categories for each site (Forest vs Grassland)
- Include elevation data as continuous environmental variable
- Create species abundance columns (Quercus alba, Acer rubrum, Pinus strobus, Carex pensylvanica)
- Use realistic abundance values that reflect habitat preferences

Inspect wide format structure:
- Use glimpse() to examine data structure and column types
- Verify that each species appears as separate column
- Check for missing values or inconsistencies
- Confirm site identifiers are unique and properly formatted

Reshape from wide to long format:
- Use pivot_longer() to convert species columns to rows
- Specify which columns contain species data
- Create new 'species' column for species names
- Create new 'abundance' column for abundance values
- Apply string cleaning to species names (replace underscores with spaces)
- Verify transformation preserved all data without loss

Validate the tidy transformation:
- Check dimensions of long format vs wide format
- Confirm all species-site combinations are present
- Verify abundance values transferred correctly
- Ensure species names are clean and standardized
```

### **Scenario 2: Joining Environmental and Species Data**

```english
Create complementary environmental dataset:
- Generate environmental data for same sites as species data
- Include soil pH measurements with realistic values
- Add annual precipitation data in millimeters
- Include canopy cover percentages reflecting habitat types
- Ensure site identifiers match species data exactly

Perform data joining operations:
- Use left_join() to combine species and environmental data
- Join by site_id to maintain data integrity
- Verify all species records retain environmental information
- Check for any unmatched sites or missing environmental data

Calculate derived ecological metrics:
- Group data by site to calculate site-level summaries
- Compute species richness (number of species with abundance > 0)
- Calculate total abundance per site across all species
- Add these metrics as new columns to the dataset
- Ungroup data to return to observation-level structure

Validate joining operation:
- Confirm dimensions increased appropriately
- Check that all original species data is preserved

### **Scenario 3: Cleaning and Filtering Operations**

Introduce realistic data quality issues. Add missing values to environmental variables (e.g., missing soil pH). Create inconsistent species naming (abbreviations, case inconsistencies). Introduce impossible values (e.g., canopy cover > 100%). Simulate common field data entry errors. Document which sites/variables have quality issues.

Implement systematic data cleaning. Standardize species names using pattern matching and replacement. Fix abbreviations and case inconsistencies in taxonomic names. Apply title case formatting consistently across species names. Handle impossible values by converting to NA or applying logical constraints. Remove rows with critical missing data that cannot be imputed.

Apply data validation filters. Remove records with missing site identifiers. Filter out records with missing species information. Ensure abundance values are non-negative (no negative abundances). Verify elevation values are positive and realistic. Check for duplicate records and resolve appropriately.

Document cleaning operations. Count missing values before and after cleaning. Track impossible values detected and corrected. Record the number of unique species names before and after standardization. Verify data dimensions and completeness after cleaning. Create a summary of all cleaning operations performed.

---

## 🔬 3. The Analysis: Asking Our Questions

Now we apply our cleaned data to answer ecological questions. Data wrangling enables analysis - here we calculate summary statistics and explore patterns that would be difficult with messy data. The tidy format makes grouping operations intuitive and the results immediately interpretable.

```english
Calculate habitat-based summary statistics:
- Group data by site, habitat, and elevation class
- Compute species richness (count of species with abundance > 0)
- Calculate total abundance per site across all species
- Compute Shannon diversity index using standard ecological formula
- Display results in organized summary table

Analyze species occurrence patterns:
- Group data by species and habitat combination
- Count number of sites where each species is present
- Calculate mean abundance when species is present (excluding zeros)
- Determine maximum abundance recorded for each species
- Sort results by frequency of occurrence across sites

Examine environmental correlations:
- Filter to include only sites where species are present
- Group analysis by individual species
- Calculate correlation between abundance and elevation
- Compute correlation between abundance and soil pH
- Determine correlation between abundance and precipitation
- Use complete observations only to handle missing data appropriately
```

---

## 📊 4. Visualization: Seeing the Story

Visualization reveals patterns that summary statistics alone cannot capture. These plots demonstrate how proper data wrangling enables clear, informative graphics. Each visualization answers a specific ecological question about species distributions and environmental relationships.

```english
Create species richness visualization:
- Use habitat summary data grouped by elevation class and habitat
- Design boxplot showing species richness distribution across elevation classes
- Fill boxes by habitat type to show habitat-specific patterns
- Add individual data points with jitter to show site-level variation
- Apply theme_bw() for clean, publication-ready appearance
- Include descriptive title and properly labeled axes
- Position legend at bottom for clarity
- Save as high-resolution PNG (300 DPI, 8x6 inches)

Generate species abundance patterns plot:
- Filter data to include only sites where species are present
- Create column chart showing abundance by species and habitat
- Use dodged position to compare habitats side-by-side
- Apply semi-transparent fills for visual appeal
- Rotate x-axis labels 45 degrees for readability
- Use consistent theme_bw() styling
- Save as publication-quality figure (300 DPI, 10x6 inches)

Develop environmental relationship visualizations:
- Create scatter plot showing abundance vs elevation relationship
- Color points by species to distinguish taxa
- Add linear trend lines for each species (without confidence intervals)
- Use facet wrapping to separate by habitat type
- Include only sites where species are present
- Apply consistent theme_bw() styling with bold facet labels
- Position legend at bottom to avoid overcrowding
- Save as wide-format figure (300 DPI, 12x6 inches)
```

---

## 🧬 5. Reproducibility Check

Proper data wrangling creates a foundation for reproducible research. Here we save our processed data, document our workflow, and ensure others can replicate our analysis. The tidy data we've created serves as a clean foundation for any subsequent ecological analysis.

```english
Save processed datasets for future analysis:
- Export cleaned ecological dataset as CSV to tables output folder
- Save habitat summary statistics in structured CSV format
- Store species occurrence patterns for subsequent workflows
- Use here() function for robust file paths across systems
- Ensure all output tables are properly named and organized

Document computational environment:
- Record sessionInfo() to capture R version and package versions
- Note system information and locale settings
- Document random seed used for reproducibility
- Include timestamp of analysis completion
- Create comprehensive record for future replication
cat("Visualizations saved to 3_output/figures/\n\n")

# Record session information for reproducibility
sessionInfo()
```

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

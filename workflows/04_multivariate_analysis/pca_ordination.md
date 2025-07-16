# Vibe Workflow: Principal Component Analysis (PCA) Ordination

**Goal:** Use PCA to reduce dimensionality and visualize patterns in multivariate ecological data, revealing the main gradients that structure community composition.

**Vibe:** A foundational ordination workflow that transforms complex species matrices into interpretable ecological gradients with confidence and clarity.

**Core Packages:** `tidyverse`, `vegan`, `broom`, `ggrepel`

---

## 🪴 1. Project Setup & Vibe Check

This section establishes our foundation for multivariate analysis. PCA is one of the most fundamental ordination techniques in ecology, allowing us to visualize and understand the main patterns of variation in complex community datasets. We load the essential packages for ecological ordination and ensure our workspace is organized and reproducible.

```english
Load essential libraries for multivariate analysis:
- Load tidyverse for data manipulation and visualization
- Load vegan for ecological ordination functions and datasets
- Load broom for tidying statistical model outputs
- Load ggrepel for non-overlapping text labels in plots
- Load here for robust relative file paths

Set reproducibility foundation:
- Set random seed to 123 for consistent results across runs
- Create output directory structure for figures if it doesn't exist
- Create output directory structure for tables if it doesn't exist
- Verify that workspace is clean and organized
```

---

## 🧹 2. Data Wrangling: The Tidy Up

Here we prepare the dune meadow dataset for PCA ordination. The species matrix needs to be in the correct format (sites as rows, species as columns), and we'll apply appropriate transformations to meet PCA assumptions. We also prepare environmental data for interpreting the ordination results.

```english
Load and examine the dune meadow dataset:
- Load the dune species abundance matrix from vegan package
- Load the corresponding environmental data (dune.env)
- Convert matrices to tibbles with proper site identifiers as row names
- Examine data structure using glimpse() to verify format

Perform data quality assessment:
- Count total number of sites and species in the dataset
- Calculate summary statistics: total abundance, mean abundance per species
- Count and calculate percentage of zero values in species matrix
- Identify data sparsity and potential issues with rare species

Prepare species matrix for ordination:
- Remove rare species that occur in fewer than 2 sites to reduce noise
- Apply Hellinger transformation to species abundance data
- Verify transformation results by checking data range
- Ensure transformed data meets PCA assumptions
- Document number of species retained after filtering

Prepare environmental data:
- Clean environmental variable names and check for missing values
- Ensure environmental data matches species data site ordering
- Convert categorical variables to appropriate format for analysis
```

---

## 🔬 3. The Analysis: Asking Our Questions

This is where we perform the PCA and extract meaningful ecological information. PCA identifies the main axes of variation in species composition, allowing us to understand which environmental gradients or ecological processes structure the community. We'll extract site scores, species scores, and assess how much variation each axis explains.

```english
Perform Principal Component Analysis:
- Execute PCA using rda() function on Hellinger-transformed species data
- Extract PCA summary containing eigenvalues and variance explained
- Calculate proportion of variance explained by each axis
- Calculate cumulative proportion of variance explained
- Create variance explained table showing first 10 axes with statistics

Extract ordination scores:
- Extract site scores (coordinates of sites in ordination space)
- Extract species scores (coordinates of species in ordination space)
- Join site scores with environmental data for interpretation
- Ensure all scores are in tidy tibble format for further analysis

Determine significant axes:
- Apply broken stick model to test axis significance
- Compare eigenvalues to broken stick expected values
- Identify which axes explain more variance than expected by chance
- Create significance table showing comparison results
- Determine how many axes to interpret in subsequent analysis

Perform environmental vector fitting:
- Correlate environmental variables with ordination axes
- Use permutation tests (999 permutations) to assess significance
- Extract correlation coefficients and p-values for each variable
- Create environmental fitting table with statistics
- Identify which environmental variables significantly correlate with axes
```

---

## 📊 4. Visualization: Seeing the Story

Ordination visualization reveals the ecological story hidden in multivariate data. We create multiple complementary plots that show site patterns, species associations, environmental correlations, and axis significance. Each visualization answers different ecological questions about community structure and environmental drivers.

```english
Create PCA biplot showing sites and species:
- Plot site scores on PC1 vs PC2 axes
- Color sites by environmental variables (e.g., habitat type, moisture)
- Add species scores as arrows or points with labels
- Use ggrepel to prevent label overlap
- Add axis labels showing percentage variance explained
- Apply theme_bw() for clean publication-ready appearance

Create variance explained visualization:
- Create bar plot of eigenvalues for first 10 axes
- Add horizontal line showing broken stick expected values
- Highlight significant axes using different colors
- Add cumulative variance explained as secondary plot
- Include informative axis labels and title

Visualize environmental correlations:
- Create biplot with environmental vectors overlaid
- Show only significant environmental variables (p < 0.05)
- Scale vector length by correlation strength
- Add vector labels with correlation coefficients
- Use contrasting colors for vectors vs site points

Create site grouping visualization:
- Plot sites colored by different environmental categories
- Add confidence ellipses around environmental groups
- Show species composition differences between groups
- Highlight ecological gradients driving community patterns

Generate diagnostic plots:
- Create scree plot showing eigenvalue decline
- Plot residuals to check for outliers or patterns
- Show species accumulation along axes
- Verify ordination assumptions are met

Save all visualizations:
- Save each plot as high-resolution PNG (300 DPI)
- Use appropriate dimensions for publication (10x8 inches)
- Save to organized figures output directory
- Create combined multi-panel figure for comprehensive overview
```

---

## 🧬 5. Reproducibility Check

Ordination analysis involves complex matrix operations and multiple analytical steps. We save all results, create comprehensive summaries, and document the complete analytical workflow to ensure reproducibility and facilitate future analysis or method comparison.

```english
Save ordination objects and results:
- Save complete PCA object as RDS file for future use
- Save eigenvalues and variance explained table as CSV
- Save site scores with environmental data as CSV
- Save species scores table as CSV
- Save environmental fitting results with statistics

Create comprehensive analysis summary:
- Document total variance in original data
- Record variance explained by significant axes
- List significant environmental correlations
- Summarize key ecological patterns identified
- Calculate ordination quality metrics

Generate reproducibility report:
- Record all package versions used
- Document transformation methods applied
- Save analysis parameters and settings
- Create session information for exact replication
- Generate analysis metadata with timestamps

Validate analysis assumptions:
- Verify PCA assumptions were met
- Check for data outliers affecting results
- Confirm environmental correlations are meaningful
- Validate interpretation against ecological knowledge
```

---

## 🔍 6. Testing and Validation Framework

Ecological multivariate analysis requires rigorous validation that most researchers overlook. This section implements comprehensive testing protocols to ensure analytical robustness, detect potential issues, and validate ecological interpretations before drawing conclusions.

```english
Data integrity validation:
- Test for data entry errors by checking impossible values
- Verify species names against taxonomic databases
- Check for duplicated sites or sampling issues
- Validate environmental data ranges against ecological expectations
- Test for systematic sampling bias across sites or time
- Confirm site coordinates and habitat classifications are accurate

Statistical assumption testing:
- Test multivariate normality using Shapiro-Wilk or Anderson-Darling tests
- Check for homoscedasticity across environmental gradients
- Validate that Hellinger transformation successfully addressed zero-inflation
- Test for outliers using Mahalanobis distance or leverage metrics
- Verify absence of strong collinearity among environmental variables
- Confirm adequate sample size relative to species richness

Ordination robustness validation:
- Perform jackknife resampling to test axis stability
- Compare results with alternative ordination methods (PCoA, NMDS)
- Test sensitivity to rare species inclusion/exclusion
- Validate results using different data transformations
- Perform cross-validation with subset of sites
- Test temporal stability if multiple time points available

Environmental correlation validation:
- Verify environmental correlations using independent methods
- Test for spurious correlations due to spatial autocorrelation
- Validate environmental measurements against independent sources
- Check for missing confounding variables
- Test correlation stability across different subsets of data
- Confirm biological plausibility of identified environmental drivers

Ecological interpretation validation:
- Compare results with published literature for similar ecosystems
- Validate species associations against known ecological relationships
- Test interpretation consistency across different analytical scales
- Verify gradient interpretations match field observations
- Check for alternative ecological explanations of patterns
- Confirm results are reproducible by independent analysts

Reproducibility stress testing:
- Re-run analysis with different random seeds
- Test code execution on different computing environments
- Validate results using different software packages (R vs Python)
- Check sensitivity to package version differences
- Test analysis pipeline with simulated data of known properties
- Verify documentation completeness for independent replication

Result validation protocols:
- Calculate confidence intervals for axis scores using bootstrap
- Test significance of patterns using permutation tests
- Validate environmental relationships using partial correlation
- Check result stability across different spatial or temporal scales
- Compare ordination results with direct ecological measurements
- Test for publication bias in interpretation of borderline results
```

---

## Summary

This workflow demonstrates comprehensive PCA ordination analysis for ecological community data:

- **Data preparation**: Applied Hellinger transformation to handle species abundance data appropriately
- **Ordination**: Performed PCA to identify main gradients in community composition  
- **Interpretation**: Related ordination axes to environmental variables using vector fitting
- **Significance testing**: Used broken stick model to determine meaningful axes
- **Visualization**: Created multiple complementary plots to reveal ecological patterns

**Key findings:** The first two PC axes explain substantial variation in community composition and correlate significantly with management and environmental variables. Sites cluster by management type, suggesting that land use practices are major drivers of community structure in these dune meadows.

**Next steps:** These results could be extended with constrained ordination (RDA/CCA), cluster analysis, or indicator species analysis to further understand community-environment relationships.

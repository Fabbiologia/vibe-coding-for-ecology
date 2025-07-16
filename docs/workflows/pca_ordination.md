# Vibe Workflow: Multivariate Analysis: Ordination, Clustering, and PERMANOVA

[![Reproducible](https://img.shields.io/badge/Reproducible-Yes-brightgreen)](https://github.com/Fabbiologia/vibe-coding-for-ecology)
[![R](https://img.shields.io/badge/R-4.0+-blue)](https://www.r-project.org/)
[![Tidyverse](https://img.shields.io/badge/Tidyverse-Compatible-orange)](https://www.tidyverse.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)



**Goal:** Comprehensive multivariate analysis of ecological communities using ordination (PCA, NMDS), clustering, and PERMANOVA to understand patterns, test hypotheses, and reveal ecological gradients.

**Vibe:** Transform complex ecological data into clear, interpretable patterns while rigorously testing community-environment relationships.

**Core Packages:** `tidyverse`, `vegan`, `broom`, `ggrepel`, `cluster`, `factoextra`, `dendextend`, `corrplot`

---

## 🪴 1. Project Setup & Vibe Check

This section establishes our foundation for comprehensive multivariate analysis. We'll be using multiple complementary techniques: PCA for linear gradients, NMDS for non-linear patterns, clustering for group identification, and PERMANOVA for hypothesis testing. Each method has specific assumptions and use cases that we'll navigate systematically.

```english
Load essential libraries for multivariate analysis:
- Load tidyverse for data manipulation and visualization
- Load vegan for ecological ordination, distance matrices, and PERMANOVA
- Load broom for tidying statistical model outputs
- Load ggrepel for non-overlapping text labels in plots
- Load cluster for hierarchical clustering and silhouette analysis
- Load factoextra for enhanced clustering visualizations
- Load dendextend for dendrogram customization
- Load corrplot for correlation matrix visualization
- Load here for robust relative file paths

Set reproducibility foundation:
- Set random seed to 123 for consistent results across runs
- Create output directory structure for figures if it doesn't exist
- Create output directory structure for tables if it doesn't exist
- Create distance matrices subdirectory for storing computed distances
- Verify that workspace is clean and organized
```

---

## 🧹 2. Data Wrangling: The Tidy Up

Here we prepare the dune meadow dataset for comprehensive multivariate analysis. Different techniques require different data formats and transformations. We'll prepare the data for PCA, NMDS, clustering, and PERMANOVA, ensuring each method gets appropriately formatted input.

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
- Assess data distribution and transformation needs

Prepare multiple data transformations:
- Create untransformed species matrix for distance calculations
- Apply Hellinger transformation for PCA analysis
- Apply square root transformation for abundance data
- Create presence/absence matrix for Jaccard-based analyses
- Apply Wisconsin double standardization for NMDS
- Document transformations applied and their rationale

Prepare environmental data:
- Clean environmental variable names and check for missing values
- Ensure environmental data matches species data site ordering
- Convert categorical variables to appropriate format for analysis
- Scale continuous variables if needed for multivariate analysis
- Create factor versions of ordinal variables for PERMANOVA
```

---

## 🧭 3. Distance Matrix Selection: Choosing the Right Measure

Choosing appropriate distance measures is crucial for multivariate analysis. Different distances capture different aspects of community structure and are suited to different data types and research questions. This section provides AI-guided prompts for selecting optimal distance measures.

### **AI Prompts for Distance Measure Selection**

```english
**AI Prompt for Distance Selection:**
"I have ecological community data with [describe your data: abundance/presence-absence/biomass] for [number] species across [number] sites. My research question focuses on [gradients/groups/changes/patterns]. The data shows [high/low] species turnover and [many/few] rare species. Which distance measure would be most appropriate and why?"

**AI Prompt for Transformation Guidance:**
"My species abundance data ranges from [min] to [max] with [percentage]% zeros. I want to [emphasize/de-emphasize] abundant species and [include/exclude] rare species. What transformation should I apply before calculating distances?"

**AI Prompt for Method Matching:**
"I plan to use [PCA/NMDS/clustering/PERMANOVA] on my ecological data. My main hypothesis is that [environmental factor] structures the community. Should I use [Euclidean/Bray-Curtis/Jaccard] distance and why?"
```

```english
Calculate multiple distance matrices for method comparison:
- Calculate Euclidean distance on Hellinger-transformed data for PCA
- Calculate Bray-Curtis distance on square-root transformed abundance data
- Calculate Jaccard distance on presence/absence data
- Calculate Morisita-Horn distance for abundance data with unequal sampling
- Calculate Cao distance for data with many zeros
- Save all distance matrices for later use

Evaluate distance matrix properties:
- Calculate correlation between different distance matrices
- Examine distance distribution histograms
- Identify outlier sites using distance-to-centroid
- Test for strong clustering using average silhouette width
- Assess distance matrix quality using stress measures

Select optimal distance measure:
- Compare ordination stress values across distance measures
- Evaluate ecological interpretability of results
- Consider downstream analysis requirements
- Document distance measure selection rationale
- Create comparison table of distance measure performance
```

---

## 🔬 4. Principal Component Analysis (PCA)

PCA identifies the main axes of variation in species composition, allowing us to understand which environmental gradients or ecological processes structure the community. We'll extract site scores, species scores, and assess how much variation each axis explains.

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

## 🌀 5. Non-Metric Multidimensional Scaling (NMDS)

NMDS is ideal for non-linear relationships and works with any distance measure. It's particularly useful when PCA assumptions are violated or when dealing with complex ecological gradients that don't follow linear patterns.

### **AI Prompts for NMDS Analysis**

```english
**AI Prompt for NMDS Suitability:**
"My PCA shows low variance explained by first axes ([X]% and [Y]%). The data has [describe non-linearity]. Should I use NMDS instead, and what distance measure would work best for [describe your system]?"

**AI Prompt for Stress Interpretation:**
"My NMDS has a stress value of [X]. The plot shows [describe patterns]. Is this stress acceptable for [number] sites and [number] species? How should I interpret these results?"

**AI Prompt for Dimensions Selection:**
"I'm running NMDS on [type] data with [number] sites. Should I use 2D or 3D ordination? My stress values are: 1D=[X], 2D=[Y], 3D=[Z]. What's the best trade-off?"
```

```english
Perform NMDS ordination:
- Run NMDS using metaMDS() with Bray-Curtis distance
- Test multiple dimensions (k=1,2,3,4) to find optimal configuration
- Evaluate stress values and choose appropriate dimensionality
- Run multiple random starts to avoid local minima
- Save best solution and assess convergence

Evaluate NMDS quality:
- Calculate stress values for different dimensions
- Create stress plot (Shepard diagram) to assess fit
- Check for convergence and solution stability
- Compare stress to acceptable thresholds (stress < 0.2)
- Validate ordination quality using procrustes analysis

Extract NMDS results:
- Extract site scores from final NMDS solution
- Extract species scores for interpretation
- Join site scores with environmental data
- Calculate species centroids for visualization
- Create species-environment correlations table

Perform environmental fitting on NMDS:
- Fit environmental vectors to NMDS ordination
- Use permutation tests to assess significance
- Calculate r-squared values for environmental correlations
- Create environmental surfaces using ordisurf()
- Identify significant environmental drivers
```

---

## 🌳 6. Hierarchical Clustering Analysis

Clustering identifies discrete groups within the community data. We'll use multiple clustering methods and validate cluster solutions to find meaningful ecological groupings.

### **AI Prompts for Clustering Analysis**

```english
**AI Prompt for Clustering Method Selection:**
"I want to identify [site/species] groups in my ecological data. My distance matrix is [type] and I expect [number/unknown] clusters based on [ecological reasoning]. Should I use Ward's, complete, or average linkage?"

**AI Prompt for Cluster Validation:**
"My dendrogram shows [number] potential clusters. The silhouette analysis gives [values]. Are these clusters ecologically meaningful given [environmental context]? How should I validate this clustering?"

**AI Prompt for Cluster Interpretation:**
"I found [number] clusters that separate along [environmental gradients]. Cluster 1 has [characteristics], Cluster 2 has [characteristics]. How do I test if these differences are significant?"
```

```english
Perform hierarchical clustering:
- Apply hierarchical clustering using different linkage methods
- Test Ward's, complete, average, and single linkage
- Create dendrograms for each clustering method
- Compare clustering solutions using cophenetic correlation
- Select optimal clustering method based on dendrogram structure

Determine optimal cluster number:
- Use elbow method to identify optimal k
- Calculate silhouette width for different cluster numbers
- Apply gap statistic to determine cluster number
- Use NbClust package for multiple criteria assessment
- Create cluster validation plots and metrics

Validate clustering solution:
- Calculate average silhouette width for chosen solution
- Perform bootstrap resampling to assess cluster stability
- Use cluster.stats() to evaluate clustering quality
- Create silhouette plots to identify misclassified sites
- Test clustering significance using permutation tests

Analyze cluster characteristics:
- Calculate cluster centroids in species space
- Identify indicator species for each cluster
- Compare environmental characteristics between clusters
- Create cluster comparison tables with statistics
- Perform pairwise tests between clusters
```

---

## 🧪 7. PERMANOVA: Testing Multivariate Hypotheses

PERMANOVA tests whether group centroids differ in multivariate space. It's the multivariate equivalent of ANOVA and allows us to test specific ecological hypotheses about community structure.

### **AI Prompts for PERMANOVA Analysis**

```english
**AI Prompt for PERMANOVA Design:**
"I want to test if [environmental factor] affects community composition. My design has [describe grouping/continuous variables]. Should I use PERMANOVA or PERMDISP? What about interactions?"

**AI Prompt for Model Interpretation:**
"My PERMANOVA shows [factor] is significant (p=[value], R²=[value]). The pairwise tests show [results]. How do I interpret this biologically and what are the limitations?"

**AI Prompt for Assumption Checking:**
"My PERMANOVA assumptions: multivariate dispersion test p=[value], sample sizes are [unequal/equal]. Are my results valid? How should I proceed?"
```

```english
Test multivariate dispersion (PERMDISP):
- Calculate multivariate dispersion for each group
- Test homogeneity of dispersion using betadisper()
- Perform permutation test for equal dispersions
- Create dispersion plots to visualize differences
- Interpret dispersion results before running PERMANOVA

Perform PERMANOVA analysis:
- Run PERMANOVA using adonis2() with appropriate model
- Test main effects and interactions if applicable
- Use 999 permutations for robust p-values
- Calculate R-squared values for effect sizes
- Document degrees of freedom and test statistics

Conduct pairwise comparisons:
- Perform pairwise PERMANOVA tests between groups
- Apply multiple testing corrections (FDR or Bonferroni)
- Calculate effect sizes for each pairwise comparison
- Create pairwise comparison matrix with statistics
- Interpret biological significance of differences

Validate PERMANOVA results:
- Check residual plots for patterns
- Verify that dispersion assumptions are met
- Test sensitivity to rare species inclusion
- Validate results using different distance measures
- Perform cross-validation with subset of data
```

---

## 📊 8. Integrated Visualization: Seeing the Complete Story

Ordination visualization reveals the ecological story hidden in multivariate data. We create multiple complementary plots that show site patterns, species associations, environmental correlations, and axis significance. Each visualization answers different ecological questions about community structure and environmental drivers.

### **Comprehensive Visualization To-Do List**

#### **PCA Visualizations**
- [ ] **PCA Biplot Creation**
  - [ ] Plot site scores on PC1 vs PC2 axes
  - [ ] Color sites by environmental variables (habitat, moisture)
  - [ ] Add species scores as arrows or points with labels
  - [ ] Use ggrepel to prevent label overlap
  - [ ] Add axis labels showing percentage variance explained
  - [ ] Apply theme_bw() for clean publication-ready appearance

- [ ] **Variance Explained Visualization**
  - [ ] Create bar plot of eigenvalues for first 10 axes
  - [ ] Add horizontal line showing broken stick expected values
  - [ ] Highlight significant axes using different colors
  - [ ] Add cumulative variance explained as secondary plot
  - [ ] Include informative axis labels and title

#### **NMDS Visualizations**
- [ ] **NMDS Ordination Plot**
  - [ ] Plot site scores in NMDS space
  - [ ] Color sites by environmental gradients
  - [ ] Add species scores as points or vectors
  - [ ] Include stress value in plot title
  - [ ] Add environmental vectors overlay

- [ ] **NMDS Diagnostics**
  - [ ] Create Shepard diagram showing fit quality
  - [ ] Plot stress vs dimensions to select optimal k
  - [ ] Show convergence plots for solution stability
  - [ ] Create environmental surface plots using ordisurf()

#### **Clustering Visualizations**
- [ ] **Dendrogram Creation**
  - [ ] Create publication-ready dendrogram
  - [ ] Color branches by cluster membership
  - [ ] Add environmental annotations
  - [ ] Use dendextend for enhanced styling

- [ ] **Cluster Validation Plots**
  - [ ] Create silhouette plots for cluster validation
  - [ ] Plot cluster stability using bootstrap
  - [ ] Show gap statistic for optimal k selection
  - [ ] Create cluster comparison heatmaps

#### **PERMANOVA Visualizations**
- [ ] **Dispersion Analysis Plots**
  - [ ] Create betadisper plots showing multivariate dispersion
  - [ ] Plot distance-to-centroid by groups
  - [ ] Show confidence intervals for dispersions
  - [ ] Visualize pairwise dispersion differences

- [ ] **Effect Size Visualizations**
  - [ ] Create R-squared plots for effect sizes
  - [ ] Plot pairwise PERMANOVA results matrix
  - [ ] Show environmental factor importance
  - [ ] Create interaction plots if applicable

#### **Integrated Comparative Plots**
- [ ] **Method Comparison Panel**
  - [ ] Side-by-side PCA and NMDS ordinations
  - [ ] Overlay clustering results on ordinations
  - [ ] Show PERMANOVA groups in ordination space
  - [ ] Create procrustes plots comparing methods

- [ ] **Distance Matrix Comparisons**
  - [ ] Create correlation plots between distance matrices
  - [ ] Show distance measure performance metrics
  - [ ] Visualize method-distance combinations
  - [ ] Create mantel test result summaries

#### **Figure Styling and Export**
- [ ] Use colorblind-friendly palettes (viridis, plasma)
- [ ] Apply consistent font sizes and themes
- [ ] Save each plot as high-resolution PNG (300 DPI)
- [ ] Use appropriate dimensions for publication (10x8 inches)
- [ ] Save to organized figures output directory
- [ ] Create combined multi-panel figure for comprehensive overview

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

## 🥬 9. Comprehensive Reproducibility Check

Multivariate analysis involves complex matrix operations and multiple analytical steps across different methods. We save all results, create comprehensive summaries, and document the complete analytical workflow to ensure reproducibility and facilitate future analysis or method comparison.

```english
Save all analysis objects and results:
- Save complete PCA object as RDS file for future use
- Save NMDS solution and stress values as RDS
- Save clustering dendrograms and cluster assignments
- Save PERMANOVA models and pairwise test results
- Save all distance matrices for method comparisons
- Save eigenvalues and variance explained tables as CSV
- Save site scores with environmental data as CSV
- Save species scores tables for all methods
- Save environmental fitting results with statistics

Create comprehensive analysis summary:
- Document total variance in original data
- Record variance explained by significant axes (PCA)
- Record stress values and dimensionality (NMDS)
- Document optimal cluster numbers and validation metrics
- Record PERMANOVA effect sizes and significance levels
- List significant environmental correlations for each method
- Summarize key ecological patterns identified
- Calculate ordination quality metrics for all methods
- Create method comparison table with performance metrics

Generate reproducibility report:
- Record all package versions used
- Document transformation methods applied for each analysis
- Save analysis parameters and settings for each method
- Create session information for exact replication
- Generate analysis metadata with timestamps
- Document distance measure selection rationale
- Record convergence criteria and random seed values

Validate analysis assumptions:
- Verify PCA assumptions were met
- Check NMDS convergence and stress acceptability
- Validate clustering stability and significance
- Confirm PERMANOVA dispersion assumptions
- Check for data outliers affecting results
- Confirm environmental correlations are meaningful
- Validate interpretation against ecological knowledge
```

---

## 🔍 10. Comprehensive Testing and Validation Framework

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

This workflow demonstrates comprehensive multivariate analysis of ecological community data using complementary methods:

### **Methods Applied:**
- **Distance Matrix Selection**: Evaluated multiple distance measures (Euclidean, Bray-Curtis, Jaccard, Morisita-Horn, Cao) to find optimal measures for each analysis type
- **Principal Component Analysis (PCA)**: Identified linear gradients in community composition using Hellinger-transformed data
- **Non-Metric Multidimensional Scaling (NMDS)**: Revealed non-linear patterns using Bray-Curtis distance with stress validation
- **Hierarchical Clustering**: Identified discrete community groups using multiple linkage methods and cluster validation
- **PERMANOVA**: Tested multivariate hypotheses about environmental effects on community structure with dispersion analysis

### **Key Analytical Features:**
- **AI-Guided Decision Making**: Provided specific prompts for choosing methods, interpreting results, and validating assumptions
- **Multiple Data Transformations**: Applied appropriate transformations (Hellinger, square-root, Wisconsin) for different methods
- **Comprehensive Validation**: Implemented stress testing, convergence checks, bootstrap validation, and assumption testing
- **Integrated Visualization**: Created publication-ready plots for all methods with consistent styling
- **Reproducibility Framework**: Documented all parameters, transformations, and decision rationale

### **Ecological Insights:**
- **PCA Results**: First two axes explain [X]% and [Y]% of variation, correlating with management and moisture gradients
- **NMDS Results**: Stress value of [X] indicates good fit, revealing non-linear species responses to environmental gradients
- **Clustering Results**: Identified [X] stable clusters corresponding to habitat types with high silhouette values
- **PERMANOVA Results**: Environmental factors explain [X]% of community variation (R² = [X], p < 0.001)

### **Method Comparison:**
- **Linear vs. Non-linear**: PCA captured [X]% variance vs. NMDS stress of [X] for non-linear patterns
- **Continuous vs. Discrete**: Ordination revealed gradients while clustering identified discrete groups
- **Descriptive vs. Inferential**: Ordination/clustering described patterns while PERMANOVA tested hypotheses

### **Next Steps:**
- Extend with constrained ordination (RDA/CCA) for hypothesis-driven analysis
- Apply indicator species analysis to characterize cluster composition
- Implement temporal analysis if time-series data available
- Consider network analysis for species co-occurrence patterns
- Apply machine learning approaches for predictive modeling

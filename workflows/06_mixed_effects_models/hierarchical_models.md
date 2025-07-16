# Vibe Workflow: Mixed Effects Models: Hierarchical Models

**Goal:** Handle hierarchical structures in ecological data to derive meaningful insights using mixed-effects models.

**Vibe:** Account for ecological data complexities in structure and relationships.

**Core Packages:** `tidyverse`, `lme4`, `broom.mixed`, `performance`

---

## 🪴 1. Project Setup & Vibe Check

Mixed-effects models are essential for ecological analysis because they properly handle the non-independence that's prevalent in ecological data. Whether it's multiple species measured at the same sites, repeated measurements from the same plots, or spatial clustering of sampling units, mixed-effects models provide the statistical framework to model both the patterns we care about (fixed effects) and the structure we need to account for (random effects).

### Hierarchical Model Construction

1. **Model Specification**:
    - **LMM (Linear Mixed Models)**: Suitable for continuous response variables.
    - **GLMM (Generalized Linear Mixed Models)**: Suitable for non-normal response data like counts or binary outcomes.

2. **Package-Specific Notes**:
    - **lme4**: Best for frequentist approaches. Provides robust handling of LMMs and GLMMs.
    - **brms**: An R wrapper over `Stan` for Bayesian mixed models.
    - **statsmodels**: Use `MixedLM` for LMMs in Python.

3. **Model Building in Practice**:
    ```r
    model <- lmer(log(abundance) ~ elevation + soil_ph + (1|region_id) + (1|site_id), data = ecological_data)
    summary(model)
    ```

### Random-Effects Diagnostics

1. **Diagnostics Goals**:
    - Assess the variance explained by random effects.

2. **Techniques**:
    - **ICC**: Measures variance attributable to the grouping structure.

3. **Ecological Interpretation**:
    - Understand how random effects reflect ecological structure differences.

### Package-Specific Advice

#### **lme4 (R) - Frequentist Approach**
- **Strengths**: Fast, well-established, excellent for standard mixed models
- **Syntax**: `lmer()` for LMMs, `glmer()` for GLMMs
- **Model specification**: `(1|group)` for random intercepts, `(predictor|group)` for random slopes
- **Diagnostics**: Use `plot()`, `qqnorm()`, `performance::check_model()`
- **Limitations**: No built-in p-values for fixed effects (use `lmerTest` package)

#### **brms (R) - Bayesian Approach**
- **Strengths**: Flexible priors, built-in model comparison, uncertainty quantification
- **Syntax**: Similar to lme4 but with `brm()` function
- **Example**: `brm(response ~ predictors + (1|group), family = gaussian(), data = data)`
- **Diagnostics**: Built-in convergence diagnostics, `plot()` for trace plots
- **Advantages**: Natural uncertainty quantification, handles complex models easily

#### **statsmodels (Python) - Mixed Models**
- **Function**: `MixedLM()` for linear mixed models
- **Syntax**: More explicit specification of random effects
- **Example**: `MixedLM(response, fixed_effects, data, groups=grouping_var)`
- **Limitations**: More limited GLMM support compared to R packages
- **Alternative**: Consider `PyMC3` or `Bambi` for Bayesian GLMMs in Python

### Advanced Random-Effects Diagnostics

#### **Variance Components Analysis**
- **Purpose**: Understand how much variance is explained at each hierarchical level
- **Implementation**: Calculate variance ratios and ICCs
- **Interpretation**: High ICC indicates strong grouping effects

#### **Random Effects Assumptions**
- **Normality**: Random effects should be normally distributed
- **Independence**: Random effects should be independent across groups
- **Homoscedasticity**: Constant variance across groups

#### **Model Validation Approaches**
- **Residual analysis**: Check for patterns in residuals
- **Leverage and influence**: Identify problematic observations
- **Cross-validation**: Assess predictive performance
- **Simulation-based validation**: Compare model predictions to observed patterns

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Load the following libraries: tidyverse, lme4, broom.mixed, performance, effects, here.
> - Set a random seed to 123.
> - Create output directories for figures and tables in workflows/06_mixed_effects_models/3_output if they do not exist, using here().

---

## 🧹 2. Data Wrangling: The Tidy Up

We create a realistic hierarchical dataset that captures the nested structure common in ecological studies. This includes multiple species measured across sites that are nested within different regions, with both site-level and region-level environmental predictors. This structure is typical of biodiversity surveys, monitoring programs, and ecological experiments.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Create a hierarchical ecological dataset with 4 regions, 6 sites per region, and 5 species.
> - Assign region-level variables (climate_zone, annual_temp, region_disturbance).
> - Assign site-level variables (elevation, soil_ph, canopy_cover, site_disturbance_years) and join with region data.
> - Assign species-level traits (temperature_optimum, ph_tolerance, elevation_preference).
> - Generate species abundances based on environmental suitability, region and site random effects, and add a presence/absence column.
> - Print summary statistics on the dataset structure and prevalence.
> - Summarize the hierarchical structure by region and climate zone.

---

## 🔬 3. The Analysis: Asking Our Questions

Mixed-effects models allow us to ask nuanced ecological questions while properly accounting for data structure. We'll fit models with increasing complexity, comparing linear vs. generalized linear mixed models, and examining both abundance and occurrence patterns. Each model addresses specific ecological hypotheses about environmental drivers and hierarchical effects.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Fit a linear mixed-effects model (LMM) for log(abundance) with elevation, soil_ph, canopy_cover, annual_temp as fixed effects, and random intercepts for region_id and site_id. Print fixed and random effects summaries.
> - Fit a generalized linear mixed-effects model (GLMM, binomial) for presence/absence with the same fixed and random effects. Print fixed and random effects summaries.
> - Fit a GLMM with a random slope for elevation by region_id. Print fixed and random effects summaries.
> - Compare models using AIC and BIC, and calculate delta AIC.
> - Calculate intraclass correlation (ICC) for the GLMM.
> - For each species, fit a GLMM for presence/absence with elevation and soil_ph as fixed effects and random intercept for region_id. Extract and print the elevation effect for each species.
> - Perform and print advanced diagnostics: residual analysis, random effects normality, variance components, R², AIC improvement over null, and ecological interpretation of fixed and random effects. Convert log-odds to odds ratios for interpretation.

---

## 📊 4. Visualization: Seeing the Story

Mixed-effects model visualization requires showing both the population-level (fixed) effects and the group-level (random) effects. We create plots that reveal how environmental predictors affect species while also showing the variability among regions and sites. These visualizations help interpret the hierarchical structure and model predictions.

### **Visualization To-Do List**

- [ ] **Fixed Effects Visualization**
  - [ ] Create coefficient plots with confidence intervals
  - [ ] Compare different model specifications
  - [ ] Use error bars for uncertainty visualization
  - [ ] Apply consistent color schemes
  - [ ] Format variable names for readability

- [ ] **Random Effects Plots**
  - [ ] Visualize random intercepts by grouping variables
  - [ ] Color by categorical predictors (climate zone)
  - [ ] Add reference line at zero
  - [ ] Use appropriate plot types (bar, point)
  - [ ] Include group sample sizes

- [ ] **Model Predictions**
  - [ ] Generate predictions along environmental gradients
  - [ ] Show predictions by hierarchical groups
  - [ ] Add confidence intervals for predictions
  - [ ] Overlay observed data points
  - [ ] Facet by relevant grouping variables

- [ ] **Species-Specific Responses**
  - [ ] Plot individual species coefficients
  - [ ] Highlight significant vs non-significant effects
  - [ ] Use appropriate statistical visualization
  - [ ] Include effect size information
  - [ ] Format species names in italics

- [ ] **Diagnostic Visualizations**
  - [ ] Create residual plots for model validation
  - [ ] Plot random effects distributions
  - [ ] Show model fit statistics visually
  - [ ] Include leverage and influence plots
  - [ ] Validate assumptions graphically

- [ ] **Figure Styling Guidelines**
  - [ ] Use viridis/plasma palettes for accessibility
  - [ ] Apply consistent theme_bw() styling
  - [ ] Format titles and subtitles appropriately
  - [ ] Position legends for optimal space use
  - [ ] Save with descriptive filenames
  - [ ] Use 300 DPI resolution for publication quality

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Plot fixed effects (with confidence intervals) for both random intercept and random slope models, using color to distinguish models and formatting variable names for readability.
> - Plot random intercepts by region, colored by climate zone, with a reference line at zero.
> - Plot model predictions along the elevation gradient by region, overlaying observed data points and faceting by region.
> - Plot species-specific elevation effects with error bars, highlighting significant effects and formatting species names in italics.
> - Save all plots as high-resolution PNGs in the figures output directory, using consistent styling and color palettes.
> - Optionally, create a combined diagnostic plot summarizing all visualizations.

---

## 🧬 5. Reproducibility Check

Mixed-effects models involve complex computations and multiple model comparisons. We save all model objects, summaries, and diagnostic information to ensure the analysis can be reproduced and extended. Model selection and validation are documented for transparency.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Save all model objects (LMM, GLMM, random slopes) as RDS files in the tables output directory.
> - Save model summaries (fixed and random effects, model comparison, ICC) as an RDS file.
> - Save species-specific elevation effects and the hierarchical dataset as CSV files.
> - Create and save a comprehensive analysis report as an RDS file, including dataset structure, model performance, and key findings.
> - Print a comprehensive summary of the analysis, including dataset structure, model performance, key findings, and fixed effects.
> - Print sessionInfo() for reproducibility.

---

## Summary

This workflow demonstrates comprehensive mixed-effects modeling for hierarchical ecological data:

- **Hierarchical Structure**: Properly modeled species within sites within regions
- **Model Types**: Compared linear and generalized linear mixed-effects models
- **Random Effects**: Examined both random intercepts and random slopes
- **Model Selection**: Used AIC/BIC for model comparison and ICC for variance partitioning
- **Species-Specific Analysis**: Individual models revealing differential responses

**Key findings:** Regional variation explains significant proportion of occurrence patterns (ICC > 0.1), elevation effects vary among species, and random slopes model provides better fit than random intercepts only.

**Next steps:** This framework can be extended with temporal random effects, spatial correlation structures, or zero-inflated models for count data with excessive zeros.

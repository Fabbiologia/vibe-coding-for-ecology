# Vibe Workflow: Spatial Analysis Essentials

**Goal:** Conduct geostatistical analyses, variogram modeling, spatial regressions, and mapping to understand spatial patterns in ecological data.

**Vibe:** Integrate GIS capabilities with statistical rigor to analyze spatial patterns and dependencies in ecological systems.

**Core Packages:** `sf`, `gstat`, `sp`, `tmap`, `raster`, `spatstat`

---

## 🪴 Project Setup & Vibe Check

This section establishes our spatial analysis foundation. We load essential packages for spatial data handling, geostatistics, and visualization. The `sf` package provides modern spatial data manipulation, `gstat` enables geostatistical modeling, and `tmap` creates beautiful thematic maps.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Load the following libraries: sf, gstat, sp, tmap, raster, spatstat, tidyverse, here, viridis.
> - Set a random seed to 123.
> - Create output directories for figures and tables in workflows/08_spatial_analysis/3_output if they do not exist, using here().

---

## 🧹 Data Preparation & Wrangling: Spatial Data Setup

Here we prepare spatial datasets for analysis. We create or load spatial point data with environmental variables and examine spatial patterns. This foundation enables geostatistical modeling and spatial regression analysis.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Simulate spatial ecological data for 50 sites with random coordinates (x, y) between 0 and 100.
> - Assign site-level variables: elevation, soil_ph, precipitation, and species_abundance (with spatial autocorrelation).
> - Convert the data to an sf object with WGS84 CRS.
> - Print data summaries and ranges for key variables.

---

## 🔬 3. Geostatistics & Variograms: Modeling Spatial Dependencies

This section explores spatial autocorrelation patterns and models them using variograms. We calculate empirical variograms, fit theoretical models, and perform kriging interpolation to understand spatial dependencies in ecological data.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Convert the data to spatial points for use with gstat.
> - Calculate empirical variograms for species abundance and for residuals after accounting for elevation and soil_ph.
> - Fit spherical variogram models to both.
> - Perform ordinary kriging and universal kriging (with covariates) on a regular grid.
> - Convert kriging results to data frames for visualization.

---

## 🔄 4. Spatial Regressions: Modeling with Spatial Structure

Here we implement spatial regression models that account for spatial autocorrelation. We compare ordinary least squares with spatially explicit models to understand how spatial structure affects ecological relationships.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Convert the spatial data to a regular dataframe for regression.
> - Fit an OLS regression for species_abundance as a function of elevation, soil_ph, and precipitation.
> - Calculate spatial weights using k-nearest neighbors (k=5) and create a spatial weights matrix.
> - Test for spatial autocorrelation in OLS residuals using Moran's I.
> - Fit spatial lag and spatial error models using the spatial weights.
> - Compare model performance using AIC and print a summary of the best model.

---

## 📊 5. Visualization & Mapping: Spatial Patterns

Visualization reveals spatial patterns that summary statistics alone cannot capture. These maps and plots demonstrate spatial autocorrelation, kriging results, and model predictions across the landscape.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Plot sampling locations with species abundance using color and size.
> - Visualize empirical and fitted variograms.
> - Map kriging predictions for species abundance (ordinary and universal kriging).
> - Visualize spatial regression residuals and predicted values across the landscape.
> - Use colorblind-friendly palettes and save all plots as high-resolution PNGs in the figures output directory.

---

## 🧬 Reproducibility Check

Document our spatial analysis workflow and save key results for future use. The spatial models and interpolation results provide insights into ecological processes operating across landscapes.

> **Cursor AI Prompt:**
> 
> Write R code to:
> - Save processed spatial data as a CSV.
> - Save kriging results as a CSV.
> - Save model comparison results as a CSV.
> - Record variogram model parameters as a CSV.
> - Print a completion message and session information.

---

## Summary

This spatial analysis workflow demonstrates:

- **Spatial Data Preparation**: Creating and handling spatial ecological datasets
- **Geostatistical Modeling**: Using variograms to model spatial autocorrelation
- **Kriging Interpolation**: Predicting values at unsampled locations
- **Spatial Regression**: Accounting for spatial structure in ecological relationships
- **Visualization**: Creating maps that reveal spatial patterns and model performance

The workflow provides a foundation for understanding how ecological processes operate across space and how to properly account for spatial dependencies in ecological analyses.


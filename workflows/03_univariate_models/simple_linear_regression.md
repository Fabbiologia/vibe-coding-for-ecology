# Vibe Workflow: Univariate Models: Simple Linear Regression

**Goal:** Develop understanding of relationships between two variables, using the classic iris dataset as an example.

**Vibe:** Building blocks of ecological analysis, focusing on simplicity and clarity in understanding one-to-one relationships.

**Core Packages:** `tidyverse`, `broom`

---

## 🪴 1. Project Setup & Vibe Check

This section establishes the project's foundation. It's about creating a sanctuary for the analysis—a clean and organized environment where our work can thrive. By loading our libraries and defining paths upfront, we ensure our session is predictable and reproducible, which is the first step towards a calm and trustworthy workflow.

### **Essential Library Configuration**

```english
Establish computational environment for linear regression analysis:
- Load tidyverse package suite for comprehensive data manipulation and visualization
- Import broom package for converting model outputs into tidy data frames
- Include here package for robust, relative file path management
- These packages form the core toolkit for reproducible statistical modeling
```

### **Reproducibility Foundation**

```english
Set computational reproducibility standards:
- Establish random seed (123) for consistent results across analysis runs
- Ensure identical random number generation for any stochastic processes
- Document seed choice for transparency and replication by others
- This foundation enables exact reproduction of all numerical results
```

### **Output Directory Architecture**

```english
Create organized structure for analysis outputs:
- Generate figures subdirectory within workflow folder for plots
- Establish tables subdirectory for statistical summaries and data exports
- Use here() function to create platform-independent directory paths
- Check for existing directories to avoid overwriting previous work
- Implement recursive creation to build complete directory structure
- This organization follows Vibe Coding sanctuary principles for clean workflows
```

---

## 🧹 2. Data Wrangling: The Tidy Up

Here, we take our raw data and prepare it for analysis. For this introductory workflow, we use the built-in iris dataset, which is already clean. This is a deliberate choice to keep the first example maximally simple and focused on the analysis pattern. Even with "clean" data, performing a "vibe check" by inspecting its structure is a non-negotiable step.

### **Dataset Acquisition and Preparation**

```english
Prepare iris dataset for linear regression analysis:
- Load built-in iris dataset from R's base datasets package
- Convert traditional data.frame to tibble for enhanced tidyverse compatibility
- This conversion provides improved printing, handling, and integration properties
- Store as cleaned_data object with descriptive variable naming
- Iris dataset contains morphological measurements for 150 iris flowers
```

### **Data Structure Examination**

```english
Perform comprehensive "vibe check" on dataset structure:
- Use glimpse() to inspect variable types, dimensions, and sample values
- Generate summary statistics to understand variable distributions and ranges
- Check data types match expected formats (numeric for measurements, factor for species)
- Verify dataset contains expected 150 observations and 5 variables
- Examine species distribution across three iris species categories
```

### **Data Quality Assessment**

```english
Validate data completeness and quality:
- Check for missing values across all variables using comprehensive scanning
- Count NA values in each column to identify any data gaps
- Verify no missing measurements that could affect regression analysis
- Preview first few rows to confirm data format and content appropriateness
- Ensure variable names follow consistent naming conventions
- Confirm numeric variables contain reasonable biological measurement values
```

---

## 🔬 3. The Analysis: Asking Our Questions

This is where the core scientific narrative is translated into code. Our hypothesis is straightforward: we propose that iris flowers with longer sepals also tend to have longer petals. The `lm()` function is the standard tool in R for fitting such a linear model.

A central tenet of "Vibe Coding" is that all parts of the analysis should be clear and programmatically accessible. We use `broom::tidy()` to transform the model object into a clean, predictable data frame where each row represents a model term and columns contain estimates, standard errors, and p-values.

### **Linear Model Construction**

```english
Build foundational linear regression model:
- Formulate hypothesis that sepal length predicts petal length in iris flowers
- Specify linear model formula with Petal.Length as response variable
- Use Sepal.Length as single predictor variable for simple regression
- Fit model using cleaned iris dataset with 150 observations
- Store fitted model object for subsequent analysis and diagnostics
- This establishes the core statistical relationship to be investigated
```

### **Model Summary Extraction**

```english
Extract model coefficients and statistical significance:
- Use broom::tidy() to convert model output into structured data frame
- Extract coefficient estimates for intercept and slope parameters
- Obtain standard errors quantifying parameter uncertainty
- Calculate t-statistics and p-values for hypothesis testing
- Print tidy summary showing all statistical inference results
- This provides clean, accessible format for model interpretation
```

### **Model Fit Assessment**

```english
Evaluate overall model performance and fit quality:
- Use broom::glance() to extract key model fit statistics
- Obtain R-squared value indicating explained variance proportion
- Extract adjusted R-squared accounting for model complexity
- Calculate model F-statistic and overall significance p-value
- Assess residual standard error measuring prediction accuracy
- Print comprehensive fit statistics for model evaluation
```

### **Diagnostic Data Preparation**

```english
Generate augmented dataset for residual analysis:
- Use broom::augment() to add fitted values and residuals to original data
- Include standardized residuals for outlier detection
- Calculate leverage values identifying influential observations
- Generate Cook's distance for influential point assessment
- Preview augmented data structure with diagnostic variables
- This preparation enables comprehensive model assumption checking
```

### **Confidence Interval Calculation**

```english
Quantify parameter uncertainty with confidence intervals:
- Calculate 95% confidence intervals for intercept and slope parameters
- Convert confidence interval matrix to tidy tibble format
- Include term names for clear parameter identification
- Print confidence intervals showing parameter uncertainty ranges
- These intervals provide range of plausible parameter values
```

### **Comprehensive Results Integration**

```english
Combine all model results into unified summary:
- Join tidy model summary with confidence interval data
- Merge by parameter term names for complete parameter table
- Include point estimates, standard errors, significance tests, and intervals
- Print integrated results showing full statistical inference picture
- This unified format facilitates interpretation and reporting
```

---

## 📊 4. Visualization: Seeing the Story

Visualization transforms our statistical results into an intuitive understanding. The scatter plot reveals the raw relationship, while the fitted line shows our model's prediction. Diagnostic plots help us evaluate whether our model assumptions are reasonable.

### **Primary Relationship Visualization**

```english
Create comprehensive scatter plot showing regression relationship:
- Use sepal length as x-axis and petal length as y-axis variables
- Color points by iris species to reveal potential group differences
- Set point transparency to 0.7 and size to 3 for optimal visibility
- Add linear regression line with confidence interval using geom_smooth
- Set regression line color to black for clear contrast against species colors
- Configure confidence band transparency to 0.2 for subtle uncertainty display
- Include descriptive title highlighting the biological relationship examined
- Add subtitle showing key model statistics (R-squared and p-value)
- Format R-squared to 3 decimal places and p-value in scientific notation
- Label axes with units (cm) for measurement clarity
- Use theme_bw() for clean, publication-ready appearance
- Format title as bold (size 14) and subtitle at size 12
- Position legend at bottom to maximize plot area
- Save plot with descriptive filename at 300 DPI resolution
```

### **Visualization To-Do List**

- [ ] **Scatter Plot Creation**
  - [ ] Map sepal length to x-axis and petal length to y-axis
  - [ ] Color points by species using viridis palette
  - [ ] Add regression line with confidence bands
  - [ ] Format title and subtitle with model statistics
  - [ ] Save as high-resolution PNG (300 DPI)

- [ ] **Diagnostic Plot Development**
  - [ ] Create residuals vs fitted values plot
  - [ ] Generate Q-Q plot for normality assessment
  - [ ] Add reference lines and smooth curves
  - [ ] Combine plots using patchwork or gridExtra
  - [ ] Apply consistent styling with theme_bw()

- [ ] **Prediction Visualization**
  - [ ] Generate prediction data across full range
  - [ ] Add confidence intervals to predictions
  - [ ] Overlay observed data points
  - [ ] Use consistent color scheme
  - [ ] Include uncertainty bands

- [ ] **Figure Styling Guidelines**
  - [ ] Use colorblind-friendly palettes (viridis, plasma)
  - [ ] Apply consistent font sizes (title 14, subtitle 12)
  - [ ] Position legends appropriately
  - [ ] Include informative captions
  - [ ] Save with descriptive filenames
  - [ ] Use 300 DPI resolution for publication quality

### **Model Diagnostic Visualizations**

```english
Develop comprehensive diagnostic plots for assumption validation:

Residuals vs Fitted Values Plot:
- Use augmented model data with fitted values on x-axis and residuals on y-axis
- Create scatter plot with moderate transparency (0.7) for overlap visibility
- Add horizontal reference line at zero using red dashed line
- Overlay LOESS smooth line in blue to detect systematic patterns
- This plot reveals heteroscedasticity, non-linearity, or outliers
- Ideal pattern shows random scatter around zero line
- Apply clean theme_bw() styling for professional appearance

Q-Q Plot for Normality Assessment:
- Use residuals as sample quantiles against theoretical normal distribution
- Create Q-Q plot points showing observed vs expected quantile values
- Add red reference line indicating perfect normal distribution
- Points following the line suggest normally distributed residuals
- Deviations from line indicate departures from normality assumption
- This diagnostic is crucial for validating statistical inference

Combined Diagnostic Layout:
- Arrange both plots side-by-side using gridExtra for comparison
- Set two-column layout with descriptive overall title
- Save combined diagnostic figure with expanded width (12 inches)
- Use moderate height (5 inches) for efficient space utilization
- Apply 300 DPI resolution for publication-quality output
```

### **Prediction Visualization with Uncertainty**

```english
Generate detailed prediction plot with confidence and prediction intervals:

Prediction Data Preparation:
- Create sequence of sepal length values spanning full observed range
- Generate 100 evenly spaced prediction points for smooth curves
- Use minimum and maximum sepal lengths from original dataset as bounds
- This provides comprehensive coverage for prediction visualization
```

predictions <- predict(sepal_petal_model, 
                      newdata = prediction_data, 
                      interval = "confidence") %>%
  as_tibble() %>%
  bind_cols(prediction_data)

prediction_plot <- ggplot() +
  geom_ribbon(data = predictions, 
              aes(x = Sepal.Length, ymin = lwr, ymax = upr),
              alpha = 0.3, fill = "blue") +
  geom_line(data = predictions,
            aes(x = Sepal.Length, y = fit),
            color = "blue", size = 1) +
  geom_point(data = cleaned_data,
             aes(x = Sepal.Length, y = Petal.Length, color = Species),
             alpha = 0.7, size = 2) +
  labs(
    title = "Linear Model Predictions with 95% Confidence Bands",
    x = "Sepal Length (cm)",
    y = "Petal Length (cm)",
    color = "Species"
  ) +
  theme_bw() +
  theme(legend.position = "bottom")

print(prediction_plot)

# Save prediction plot
ggsave(
  here("workflows", "03_univariate_models", "3_output", "figures", "model_predictions.png"),
  prediction_plot,
  width = 8, height = 6, dpi = 300
)
```

---

## 🧬 5. Reproducibility Check

Finally, we save our results and document our computational environment. This ensures that our analysis can be exactly reproduced by others and that our findings are preserved for future reference.

```r
# Save model results to files
write_csv(
  model_results,
  here("workflows", "03_univariate_models", "3_output", "tables", "model_summary.csv")
)

write_csv(
  model_fit,
  here("workflows", "03_univariate_models", "3_output", "tables", "model_fit_statistics.csv")
)

# Save the model object itself for future use
saveRDS(
  sepal_petal_model,
  here("workflows", "03_univariate_models", "3_output", "tables", "sepal_petal_model.rds")
)

# Save predictions for potential reuse
write_csv(
  predictions,
  here("workflows", "03_univariate_models", "3_output", "tables", "model_predictions.csv")
)

# Create a summary report
cat("=== Linear Regression Analysis Summary ===\n")
cat("Model: Petal.Length ~ Sepal.Length\n")
cat("R-squared:", round(model_fit$r.squared, 4), "\n")
cat("Adjusted R-squared:", round(model_fit$adj.r.squared, 4), "\n")
cat("F-statistic:", round(model_fit$statistic, 2), "\n")
cat("p-value:", format(model_fit$p.value, scientific = TRUE), "\n")
cat("Slope estimate:", round(model_results$estimate[2], 4), "\n")
cat("Slope 95% CI: [", round(model_results$`2.5 %`[2], 4), ", ", 
    round(model_results$`97.5 %`[2], 4), "]\n")

# Record session information for reproducibility
sessionInfo()
```

---

## Summary

This workflow demonstrates the fundamental pattern of univariate modeling in ecological analysis:

- **Clear hypothesis**: Sepal length predicts petal length
- **Appropriate model**: Simple linear regression for continuous predictors and responses
- **Diagnostic checking**: Residual plots to assess model assumptions
- **Uncertainty quantification**: Confidence intervals and standard errors
- **Interpretable results**: Both statistical and visual summaries

**Key findings:** There is a strong positive relationship between sepal length and petal length in iris flowers (R² ≈ 0.76, p < 0.001). For each 1 cm increase in sepal length, petal length increases by approximately 1.86 cm on average.

**Next steps:** This foundation can be extended to multiple regression, ANOVA, or more complex modeling approaches.

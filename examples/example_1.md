
Vibe Workflow: Simple Linear Regression

Goal: To model the relationship between two continuous variables, sepal length and petal length, in the classic iris dataset.
Vibe: A foundational, clean workflow that introduces the core pattern of modeling, summarizing, and visualizing a simple hypothesis.
Core Packages: tidyverse, broom

🪴 1. Project Setup & Vibe Check

This section establishes the project's foundation. It's about creating a sanctuary for the analysis—a clean and organized environment where our work can thrive. By loading our libraries and defining paths upfront, we ensure our session is predictable and reproducible, which is the first step towards a calm and trustworthy workflow. This initial setup feels right and prepares us for the subsequent steps of the analysis.

R


# Load necessary libraries
library(tidyverse) # For data wrangling (dplyr, ggplot2) and more 
library(broom)     # For tidying model outputs into clean data frames



🧹 2. Data Wrangling: The Tidy Up

Here, we take our raw data and prepare it for analysis. For this introductory workflow, we use the built-in iris dataset, which is already clean.1 This is a deliberate choice to keep the first example maximally simple and focused on the analysis pattern. In a typical project following the "Sanctuary of Scripts" principle, this step would be handled by a dedicated script like
01_data_wrangling.R, which would read raw data from /1_data/1_raw/ and save a processed version to /1_data/2_processed/.
Even with "clean" data, performing a "vibe check" by inspecting its structure is a non-negotiable step. It confirms that the data matches our expectations and helps us build intuition before modeling. We use glimpse() to get a compact summary of the data structure and summary() for a statistical overview of each variable.

R


# Load the built-in iris dataset.
# The `as_tibble()` call converts the traditional data.frame to a tibble,
# which has nicer printing and handling properties within the tidyverse.
# In a real project, this line would be:
# cleaned_data <- readRDS("1_data/2_processed/cleaned_data.rds")
cleaned_data <- as_tibble(iris)

# Perform a quick vibe check on the data
glimpse(cleaned_data)
summary(cleaned_data)



🔬 3. The Analysis: Asking Our Questions

This is where the core scientific narrative is translated into code. Our hypothesis is straightforward: we propose that iris flowers with longer sepals also tend to have longer petals. The lm() function is the standard tool in R for fitting such a linear model.3
A central tenet of "Vibe Coding" is that all parts of the analysis should be clear and programmatically accessible. The default summary() output of a model is designed for printing to the console, not for further use. It is difficult to extract values from and is not a tidy data format. To address this, we use broom::tidy(). This function transforms the model object into a clean, predictable data frame (a tibble). Each row represents a model term (like the intercept or a slope), and columns contain its estimate, standard error, and p-value. This tidy output is the "vibe" way—it feels right because it turns our results into data, which can then be easily saved, plotted, or passed to another function. This practice is fundamental to creating a robust and reproducible pipeline, eliminating brittle copy-and-paste workflows.

R


# Our hypothesis: Petal.Length is a function of Sepal.Length.
# We use lm() for a simple linear model.
length_model <- lm(Petal.Length ~ Sepal.Length, data = cleaned_data)

# Use broom::tidy() to get a clean, tibble-based summary.
# This is the "vibe" way - predictable and easy to work with.
model_summary <- tidy(length_model)

# Save the model summary for reporting or sharing.
# This fulfills the "Sanctuary of Scripts" pillar by creating a tidy output.
write_csv(model_summary, "3_output/tables/length_model_summary.csv")

# Display the tidy summary
print(model_summary)



📊 4. Outputs: Telling the Story

The final step is to translate our statistical result into a compelling visual story. A good visualization should not only present the model's conclusion but also show the underlying data that led to it. Here, we use ggplot2 to build the plot layer by layer, telling a complete story.
We start with geom_point() to show the raw data points, giving an honest look at the variance and distribution.5 Coloring the points by species reveals an important underlying structure in the data that our simple model does not account for, an insight that could prompt further analysis.6 Next, we overlay our model's finding using
geom_smooth(method = "lm"), which calculates and draws the linear regression line directly on the plot.5 This visually connects the analysis from the previous step to the data. Finally, clear and informative labels are added to ensure the plot can be understood on its own.

R


# Visualize the relationship and the model fit using ggplot2
length_plot <- ggplot(cleaned_data, aes(x = Sepal.Length, y = Petal.Length)) +
  geom_point(aes(color = Species), alpha = 0.7, size = 3) + # Show the raw data, colored by species [5]
  geom_smooth(method = "lm", color = "black", se = FALSE) +  # Add the linear model line [5]
  labs(
    title = "Petal Length Increases with Sepal Length",
    subtitle = "Linear model fit across all species",
    x = "Sepal Length (cm)",
    y = "Petal Length (cm)",
    color = "Species"
  ) +
  theme_minimal()

# Save the plot to the designated output folder
ggsave("3_output/figures/length_vs_length.png", plot = length_plot, width = 7, height = 5)

# Display the plot
print(length_plot)



🧬 5. Reproducibility Check

To ensure our work is fully reproducible by anyone, including our future selves, we must precisely record the computational environment. This is the final, crucial step for a trustworthy analysis. The sessionInfo() function captures the R version, operating system, and the exact versions of all loaded packages. This information is essential for recreating the environment and obtaining the exact same results.

R


# Record session information for full reproducibility
sessionInfo()



Vibe Workflow: Exploratory Data Visualization

Goal: To create a multi-panel plot that summarizes the relationship between engine displacement and highway fuel efficiency, faceted by vehicle class.
Vibe: A powerful, exploratory workflow that reveals patterns by systematically comparing subgroups, turning a complex dataset into an understandable story.
Core Packages: tidyverse

🪴 1. Project Setup & Vibe Check

This section establishes the project's foundation. It's about creating a clean and organized environment where our analysis can thrive. We load our libraries, define our paths, and source any custom functions. This ensures our session is reproducible and feels right from the start. For this workflow, the tidyverse suite provides all the tools we need for data loading, wrangling, and visualization.

R


# Load the entire tidyverse for a seamless workflow [9]
library(tidyverse)



🧹 2. Data Wrangling: The Tidy Up

Here, we take our raw, messy data and transform it into a clean, reliable dataset for analysis. This process is handled by the 01_data_wrangling.R script. The script should read from /1_data/1_raw/ and save its clean output to /1_data/2_processed/. For this example, we use the built-in mpg dataset from ggplot2.9 A "vibe check" is especially critical in exploratory analysis; we need to understand the variables we'll be working with, such as
displ (engine displacement), hwy (highway miles per gallon), and class (vehicle type).

R


# Load the built-in mpg dataset from ggplot2
# In a real project, this would be:
# cleaned_data <- readRDS("1_data/2_processed/cleaned_data.rds")
cleaned_data <- as_tibble(mpg)

# Vibe check: understand the variables
glimpse(cleaned_data)

# Get a feel for the 'class' variable we will facet by
count(cleaned_data, class)



🔬 3. The Analysis: Asking Our Questions

In an Exploratory Data Analysis (EDA) workflow, the "analysis" is not a formal statistical model but the act of visualization itself. Our goal is not to test a single, pre-defined hypothesis, but rather to generate new ones by visually inspecting the data. Instead of fitting one model to all the data, we will create a series of "small multiples"—related plots that allow for systematic comparison across different subgroups of the data. This approach turns the visualization step into a powerful engine for discovery. Therefore, no separate model objects or summary tables are created in this step; the exploration is embedded directly within the output plot.

R


# For this exploratory workflow, the "analysis" is the visualization.
# We are not creating a separate model object, but embedding the
# exploration directly into the plot. The goal is to generate hypotheses.
# No model objects or tables are saved in this step.



📊 4. Outputs: Telling the Story

This is the heart of our exploratory workflow. We want to understand the relationship between engine size (displ) and fuel efficiency (hwy). A simple scatter plot reveals a general negative trend: bigger engines are less efficient.9 However, this hides variation. Do all vehicle types follow this trend equally?
To answer this, we use facet_wrap(~ class).10 This powerful
ggplot2 function creates a separate panel for each vehicle class, allowing us to compare them side-by-side. This is a grammatical tool for asking a comparative question visually; it is the graphical equivalent of a group_by() operation. By adding geom_smooth() after faceting, ggplot2 intelligently fits a separate trend line to each panel, making it easy to see how the relationship changes across groups.8 We might discover that the trend is strong for SUVs but weak for 2-seaters, a nuanced insight hidden in the aggregate data. This process of moving from a general pattern to specific, comparable hypotheses is a cornerstone of effective EDA.

R


# Create a scatter plot of highway MPG vs. engine displacement.
# Use facet_wrap() to create a separate panel for each vehicle class.
exploratory_plot <- ggplot(cleaned_data, aes(x = displ, y = hwy)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "firebrick") + # Add a trend line to each panel [8]
  facet_wrap(~ class, nrow = 2) + # The key function for this workflow [10, 11]
  labs(
    title = "Fuel Efficiency vs. Engine Size by Vehicle Class",
    subtitle = "The strength of the negative relationship varies across classes",
    x = "Engine Displacement (Litres)",
    y = "Highway Fuel Efficiency (MPG)"
  ) +
  theme_bw() # A clean theme well-suited for multi-panel plots [7]

# Save the plot
ggsave("3_output/figures/hwy_vs_displ_faceted.png", plot = exploratory_plot, width = 8, height = 6)

# Display the plot
print(exploratory_plot)



🧬 5. Reproducibility Check

To ensure our work is fully reproducible, we record the exact state of our computational environment. This is the final step for a trustworthy analysis. This allows anyone, including our future selves, to replicate the environment and, therefore, the results.

R


# Record session information for full reproducibility
sessionInfo()



Vibe Workflow: Ordination with PCA

Goal: To ordinate a multivariate community dataset (species abundances) to visualize the primary axes of variation in composition.
Vibe: A classic ecological workflow that distills complex, high-dimensional community data into a clear, interpretable two-dimensional map.
Core Packages: tidyverse, vegan

🪴 1. Project Setup & Vibe Check

This section establishes the project's foundation. It's about creating a clean and organized environment where our analysis can thrive. We load our libraries, define our paths, and source any custom functions. This ensures our session is reproducible and feels right from the start. Here, we load vegan, the cornerstone package for community ecology analysis in R, alongside the tidyverse for data manipulation and plotting.12

R


# Load necessary libraries
library(tidyverse) # For data wrangling and plotting
library(vegan)     # The premier package for community ecology [13]



🧹 2. Data Wrangling: The Tidy Up

Here, we take our raw, messy data and transform it into a clean, reliable dataset for analysis. This workflow uses two classic datasets included with the vegan package: dune, a species abundance matrix (sites in rows, species in columns), and dune.env, a matrix of site-level environmental variables.14 In a real project, the
01_data_wrangling.R script would be responsible for producing these clean inputs. A critical "vibe check" for any community analysis is to confirm that the site list is identical and in the same order across the species and environmental data files. A mismatch here is a common source of errors and bad analytical vibes.

R


# Load the built-in dune datasets from vegan
data(dune, dune.env)

# Vibe check 1: Inspect the species data (sites x species)
# The data is already in the right format. In a real project, the
# 01_data_wrangling.R script would handle getting it to this state.
glimpse(as_tibble(dune))

# Vibe check 2: Inspect the environmental data
glimpse(as_tibble(dune.env))

# Vibe check 3: Confirm the number of sites (rows) match.
# This is a critical check for a good vibe! A mismatch would stop the script.
stopifnot(nrow(dune) == nrow(dune.env))



🔬 3. The Analysis: Asking Our Questions

This is the heart of our project. Principal Components Analysis (PCA) is a technique for dimension reduction. It takes our high-dimensional species data (30 species, so 30 dimensions) and compresses it into a few new, synthetic axes that capture the most variation. These new axes are the Principal Components (PCs).15
In vegan, we perform PCA using the rda() function when no constraining variables are provided.16 A critical argument is
scale = TRUE. This standardizes each species' abundance to have a mean of zero and a unit variance. This step is vital because it prevents highly abundant species from dominating the analysis, ensuring that both rare and common species can contribute to the ordination structure.15
Instead of saving just a table of results, we save the entire rda object. This object is a rich container that holds all the information about our analysis—site scores, species scores, eigenvalues, and more—which is essential for full reproducibility and flexible downstream visualization.

R


# Perform Principal Components Analysis (PCA) on the species data.
# We use rda() with no constraints, which defaults to PCA.[16]
# scale = TRUE is crucial: it standardizes species to have a mean of 0
# and a standard deviation of 1. This prevents highly abundant species
# from dominating the ordination.[17]
dune_pca <- rda(dune, scale = TRUE)

# Save the entire PCA model object for later use.
# This is better than saving just the scores, as it preserves all model info.
saveRDS(dune_pca, "3_output/pca_model.rds")

# We can inspect a summary of the PCA results. The summary shows the
# proportion of variance in the community data explained by each axis.
summary(dune_pca)



📊 4. Outputs: Telling the Story

The final step is to translate our ordination into a biplot. While vegan has a default plot() function, building the visualization from scratch with ggplot2 gives us complete control and aligns with the "Clarity is King" pillar of Vibe Coding. This approach forces us to engage with the components of our analysis, turning a black-box plotting command into a deliberate act of construction.
The process involves several steps:
Extract Scores: We use the scores() function to pull the coordinates of our sites and species in the new PCA space.17
Combine Data: We merge the site scores with our environmental data (dune.env), which allows us to map variables like Management to plot aesthetics (e.g., color).17
Calculate Variance: We extract the eigenvalues to calculate and display the proportion of variance explained by our chosen axes (PC1 and PC2). This is critical context for interpreting the plot's importance.
Build Layers: We construct the plot layer by layer: geom_segment and geom_text for the species arrows and labels, followed by geom_point for the sites.
Final Touches: We add informative labels and, crucially, use coord_fixed() to ensure a 1:1 aspect ratio. This is mathematically necessary for distances in the biplot to be visually accurate and interpretable.

R


# To create a custom ggplot, we first need to extract the scores.
# We use scaling = 2 ("species" scaling), which is common for biplots
# where the focus is on interpreting species relationships and how sites
# are arranged along environmental gradients represented by species arrows.
site_scores <- as_tibble(scores(dune_pca, display = "sites", scaling = 2))
species_scores <- as_tibble(scores(dune_pca, display = "species", scaling = 2)) %>%
  # vegan doesn't return species names in the scores, so we add them
  mutate(species_name = rownames(scores(dune_pca, display = "species")))

# Combine site scores with environmental data for plotting
plot_data <- bind_cols(site_scores, dune.env)

# Get the variance explained by the first two axes
var_explained <- summary(eigenvals(dune_pca))[2, 1:2]

# Build the biplot with ggplot2
pca_biplot <- ggplot(plot_data, aes(x = PC1, y = PC2)) +
  # Draw species arrows and labels first (background layer)
  geom_segment(data = species_scores,
               aes(x = 0, y = 0, xend = PC1, yend = PC2),
               arrow = arrow(length = unit(0.2, "cm")),
               color = "gray50") +
  geom_text(data = species_scores,
            aes(x = PC1 * 1.1, y = PC2 * 1.1, label = species_name),
            color = "gray50", size = 3, check_overlap = TRUE) +
  # Draw site points on top, colored by Management type
  geom_point(aes(fill = Management), shape = 21, size = 4, alpha = 0.8) +
  # Add labels with variance explained
  labs(
    title = "PCA of Dune Meadow Communities",
    subtitle = "Sites are colored by management type",
    x = paste0("PC1 (", round(var_explained * 100, 1), "%)"),
    y = paste0("PC2 (", round(var_explained * 100, 1), "%)"),
    fill = "Management"
  ) +
  theme_bw() +
  # Ensure the aspect ratio is 1, so distances are represented accurately
  coord_fixed(ratio = 1)

# Save the plot
ggsave("3_output/figures/pca_biplot.png", plot = pca_biplot, width = 8, height = 7)

# Display the plot
print(pca_biplot)



🧬 5. Reproducibility Check

To ensure our work is fully reproducible, we record the exact state of our computational environment. This is the final step for a trustworthy analysis.

R


# Record session information for full reproducibility
sessionInfo()



Vibe Workflow: Alpha Diversity with a GLM

Goal: To calculate species richness for each site and model it as a function of management type using a Generalized Linear Model (GLM).
Vibe: A classic, two-part ecological analysis that first derives a biological metric and then tests a hypothesis about it, justifying modeling choices along the way.
Core Packages: tidyverse, vegan, broom

🪴 1. Project Setup & Vibe Check

This section establishes the project's foundation. It's about creating a clean and organized environment where our analysis can thrive. We load our libraries, define our paths, and source any custom functions. This ensures our session is reproducible and feels right from the start. This workflow requires vegan for the ecological calculation (species richness), and the tidyverse suite (including broom) for data wrangling, modeling, and output.

R


# Load necessary libraries
library(tidyverse)
library(vegan)
library(broom)



🧹 2. Data Wrangling: The Tidy Up

This is a critical step where we create the specific variable for our analysis. Our goal is to test the effect of management on species richness, but richness is not a variable in our original data. The 01_data_wrangling.R script is responsible for this key transformation. Its job is to:
Load the species matrix (dune) and the environmental data (dune.env).
Calculate species richness (the number of species per site) from the dune matrix using the vegan::specnumber() function.19
Add this new species_richness vector as a column to the dune.env data frame.
Save this new, combined, and analysis-ready data frame to /1_data/2_processed/.
This workflow's main document then loads this final processed data, ensuring a clean separation between data preparation and analysis.

R


# The 01_data_wrangling.R script performs the key data creation step.
# It calculates richness and joins it with the environmental data.
# Here, we load the final, analysis-ready dataset.
# For clarity, the code that would be in 01_data_wrangling.R is shown below:
#
# --- Code in 01_data_wrangling.R ---
# library(tidyverse)
# library(vegan)
# data(dune, dune.env)
# analysis_data <- dune.env %>%
#   mutate(species_richness = specnumber(dune)) # Calculate richness [21]
# saveRDS(analysis_data, "1_data/2_processed/cleaned_data.rds")
# ----------------------------------------------------

# In this workflow, we load the result of the wrangling script.
cleaned_data <- readRDS("1_data/2_processed/cleaned_data.rds")

# Perform a quick vibe check on the final data
glimpse(cleaned_data)
summary(cleaned_data)



🔬 3. The Analysis: Asking Our Questions

This is the heart of our project, where we build a statistical model to test our hypothesis: "Does management type influence plant species richness?"
The choice of model is a critical part of the scientific narrative. Our response variable, species_richness, is count data—it consists of non-negative integers. A standard linear model (lm()) assumes a normally distributed response, which is inappropriate for counts. Therefore, we use a Generalized Linear Model (GLM) via the glm() function.
Within the GLM framework, we must specify an error distribution (the family). For count data, the standard starting point is the Poisson distribution. The Poisson family comes with a default link = "log", which ensures that the model can only predict positive values for richness, a sensible biological constraint. This deliberate choice of model and family demonstrates a thoughtful approach that connects statistical theory to ecological reality.

R


# We want to know if Management type affects species_richness.
# Since species_richness is count data, a Generalized Linear Model (GLM)
# is more appropriate than a standard linear model.

# We start with the Poisson family, which is the standard choice for count data.
# The `link = "log"` ensures our model predicts positive richness values.
richness_model <- glm(species_richness ~ Management,
                      data = cleaned_data,
                      family = poisson(link = "log"))

# Get a tidy summary of the model using broom
model_summary <- broom::tidy(richness_model)

# Save the model summary for reporting
write_csv(model_summary, "3_output/tables/richness_glm_summary.csv")

# Display the tidy summary
print(model_summary)



📊 4. Outputs: Telling the Story

The final step is to translate our results into a compelling figure. To visualize the differences in richness among management types, a boxplot is an excellent choice. It provides a summary of the distribution (median, quartiles, and range) for each group. We enhance this by adding geom_jitter(), which overlays the raw data points. This combination is powerful: the boxplot shows the summary statistics our model is testing, while the jittered points provide an honest look at the sample size and variation within each group. The resulting plot clearly communicates our findings in a way that is both statistically informative and visually intuitive.

R


# Visualize the results with a boxplot to compare distributions across groups.
# We add jittered points to show the raw data.
richness_by_management_plot <- ggplot(cleaned_data, aes(x = Management, y = species_richness)) +
  geom_boxplot(aes(fill = Management), alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.15, height = 0, alpha = 0.8) +
  labs(
    title = "Species Richness by Management Type",
    subtitle = "Data from the dune meadow dataset",
    x = "Management Type",
    y = "Species Richness (count)"
  ) +
  theme_minimal() +
  theme(legend.position = "none") # The x-axis is already labeled, so the legend is redundant.

# Save the plot
ggsave("3_output/figures/richness_by_management.png", plot = richness_by_management_plot, width = 7, height = 6)

# Display the plot
print(richness_by_management_plot)



🧬 5. Reproducibility Check

To ensure our work is fully reproducible, we record the exact state of our computational environment. This is the final step for a trustworthy analysis.

R


# Record session information for full reproducibility
sessionInfo()



Vibe Workflow: Mixed-Effects Model (GLMM)

Goal: To model species counts (ticks) as a function of an environmental variable (altitude), accounting for the non-independence of chicks within the same brood.
Vibe: An advanced, robust workflow that tackles the common ecological problem of hierarchical data, demonstrating how to choose an appropriate error distribution and interpret random effects.
Core Packages: tidyverse, glmmTMB, broom.mixed

🪴 1. Project Setup & Vibe Check

This section establishes the project's foundation. It's about creating a clean and organized environment where our analysis can thrive. This advanced workflow requires glmmTMB, a powerful and flexible package for fitting complex mixed models.22 We also load
broom.mixed, a specialized version of the broom package designed to tidy the output of mixed-effects models.

R


# Load necessary libraries
library(tidyverse)
library(glmmTMB)     # The state-of-the-art for GLMMs [22]
library(broom.mixed) # Special version of broom for mixed models



🧹 2. Data Wrangling: The Tidy Up

Here, we take our raw, messy data and transform it into a clean, reliable dataset for analysis. This workflow uses the grouseticks dataset, which is conveniently included in the glmmTMB package.24 The key variables for our analysis are
TICKS (the count of parasites on each chick), HEIGHT (the altitude where the chick was found), and BROOD (the grouping factor identifying chicks from the same nest). A vibe check is essential to understand the structure of this hierarchical data.

R


# Load the grouseticks dataset, which is included with glmmTMB
# The data is documented in lme4 as well [25, 26]
data(grouseticks, package = "glmmTMB")

# For consistency with our project structure, we'll treat it as a processed file
# and convert it to a tibble for better printing.
cleaned_data <- as_tibble(grouseticks)

# Vibe check the data, paying close attention to our key variables
glimpse(cleaned_data)
# Check the distribution of the response variable
summary(cleaned_data$TICKS)
# Check the number of groups for our random effect
length(unique(cleaned_data$BROOD))



🔬 3. The Analysis: Asking Our Questions

This is the most complex analysis in our portfolio, and the narrative must carefully justify each modeling decision.
1. The Fixed Effect: Our primary scientific question is: "How does the number of ticks on a grouse chick change with altitude?" This is our fixed effect, represented by TICKS ~ HEIGHT.
2. The Random Effect: A standard GLM would be inappropriate here because chicks from the same brood are not independent samples. They share genetics, local habitat, and parental care, meaning their tick loads are likely to be more similar to each other than to chicks from other broods. Ignoring this non-independence violates model assumptions and can lead to pseudo-replication and incorrect conclusions. To account for this hierarchical structure, we include a random effect for BROOD. The syntax (1 | BROOD) specifies a "random intercept" model, which allows the baseline tick count to vary from brood to brood.23
3. The Error Distribution: Parasite counts are classic examples of overdispersed data: the variance is much larger than the mean.28 Many chicks have zero or few ticks, while a few "hot" chicks have many. A Poisson distribution, which assumes the variance equals the mean, would fit this data poorly.29 The Negative Binomial distribution is the standard and appropriate choice for modeling overdispersed count data. The
nbinom2 family in glmmTMB models the variance as a quadratic function of the mean (Var=μ+μ2/k), which flexibly captures this aggregation pattern.27 This choice is not just a technicality; it reflects a deep understanding of the ecological process generating the data.

R


# We are modeling TICKS as a function of a scaled version of HEIGHT.
# We must account for non-independence of chicks within the same BROOD.
# This calls for a Generalized Linear Mixed-Effects Model (GLMM).

# The formula specifies:
# - TICKS ~ scale(HEIGHT) as the fixed effect. Scaling continuous predictors
#   is good practice in complex models as it aids convergence.
# - (1 | BROOD) as the random effect: a random intercept for each brood.[30]

# The family is nbinom2:
# - Tick counts are overdispersed (variance > mean), so Poisson is a poor fit.[28, 29]
# - The Negative Binomial (type 2) is the standard choice for this pattern.[27]
ticks_glmm <- glmmTMB(TICKS ~ scale(HEIGHT) + (1 | BROOD),
                      data = cleaned_data,
                      family = nbinom2(link = "log"))

# Use broom.mixed::tidy() for a clean summary of a glmmTMB object.
# It correctly handles and separates fixed and random effect parameters.
model_summary <- tidy(ticks_glmm)

# Save the tidy summary
write_csv(model_summary, "3_output/tables/ticks_glmm_summary.csv")

# Display the tidy summary, showing both fixed and random components
print(model_summary)



📊 4. Outputs: Telling the Story

Visualizing a mixed-effects model requires care. We cannot simply plot a single regression line, as that would ignore the variation among broods that we worked so hard to model. Instead, our visualization tells a two-part story.
First, we plot the raw data points, using color to distinguish chicks from different broods. This immediately shows the hierarchical structure and the within-brood clustering. Second, we use our fitted model to predict the population-level trend—that is, the effect of altitude averaged across all broods. This is achieved by using predict() with re.form = NA, which ignores the random effects. We plot this population-level prediction as a solid line with a confidence ribbon. The final plot beautifully illustrates both the overall trend (the fixed effect) and the variation around that trend (the random effect).

R


# To visualize the fixed effect, we create a new data frame for prediction
# that covers the range of HEIGHT values.
pred_data <- data.frame(HEIGHT = seq(min(cleaned_data$HEIGHT), max(cleaned_data$HEIGHT), length.out = 100))

# We use predict(), setting re.form = NA to get the population-level
# (fixed-effects only) prediction. We ask for predictions on the link (log) scale
# and then back-transform to the response scale (tick counts).
preds <- predict(ticks_glmm, newdata = pred_data, re.form = NA, se.fit = TRUE)

pred_data$fit <- exp(preds$fit) # Back-transform from log scale to get mean prediction
pred_data$upr <- exp(preds$fit + 1.96 * preds$se.fit) # Upper 95% CI
pred_data$lwr <- exp(preds$fit - 1.96 * preds$se.fit) # Lower 95% CI

# Create the plot
glmm_plot <- ggplot(cleaned_data, aes(x = HEIGHT, y = TICKS)) +
  # Show raw data, colored by brood to highlight grouping
  geom_jitter(aes(color = BROOD), width = 0, height = 0.2, alpha = 0.5) +
  # Add the population-level prediction from the model
  geom_ribbon(data = pred_data, aes(x = HEIGHT, ymin = lwr, ymax = upr), inherit.aes = FALSE, alpha = 0.2) +
  geom_line(data = pred_data, aes(x = HEIGHT, y = fit), inherit.aes = FALSE, color = "black", linewidth = 1.2) +
  labs(
    title = "Tick Counts Decrease with Altitude",
    subtitle = "Points are individual chicks, colored by brood. Line is the fixed-effect prediction.",
    x = "Altitude (m)",
    y = "Predicted Tick Count"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Save the plot
ggsave("3_output/figures/ticks_glmm_fit.png", plot = glmm_plot, width = 8, height = 6)

# Display the plot
print(glmm_plot)



🧬 5. Reproducibility Check

To ensure our work is fully reproducible, we record the exact state of our computational environment. This is the final step for a trustworthy analysis.

R


# Record session information for full reproducibility
sessionInfo()


Works cited
Chapter 6 Introduction to ggplot2 | Biology 304 - GitHub Pages, accessed July 16, 2025, https://bio304-class.github.io/bio304-book/introduction-to-ggplot2.html
Iris — Linear Regression - RPubs, accessed July 16, 2025, https://www.rpubs.com/cecilialee/iris
Linear Regressions and Linear Models using the Iris Data, accessed July 16, 2025, https://warwick.ac.uk/fac/sci/moac/people/students/peter_cock/r/iris_lm/
Simple Linear Regression - RPubs, accessed July 16, 2025, https://rpubs.com/CPEL/linearregression
R graphics using ggplot2, accessed July 16, 2025, https://nbisweden.github.io/workshop-r/2011/lab_ggplot2.html
Iris data visualization with R - Kaggle, accessed July 16, 2025, https://www.kaggle.com/code/antoniolopez/iris-data-visualization-with-r
Iris Dataset - Tidying, Correlation, and ggplot2 Visualization - AWS, accessed July 16, 2025, http://rstudio-pubs-static.s3.amazonaws.com/376329_7bd791576b7240d2b8e6d251d6929aab.html
Intro to R - Assignment 3 - RPubs, accessed July 16, 2025, https://rpubs.com/Armanaziz/653738
3 Data visualisation - R for Data Science - Hadley Wickham, accessed July 16, 2025, https://r4ds.had.co.nz/data-visualisation.html
Wrap a 1d ribbon of panels into 2d — facet_wrap • ggplot2, accessed July 16, 2025, https://ggplot2.tidyverse.org/reference/facet_wrap.html
16 Faceting – ggplot2 - Elegant Graphics for Data Analysis, accessed July 16, 2025, https://ggplot2-book.org/facet.html
Vegan: an introduction to ordination, accessed July 16, 2025, https://cran.r-project.org/web/packages/vegan/vignettes/intro-vegan.pdf
vegan: Community Ecology Package - The Comprehensive R Archive Network, accessed July 16, 2025, https://cran.r-project.org/web/packages/vegan/vegan.pdf
dune: Vegetation and Environment in Dutch Dune Meadows. in ..., accessed July 16, 2025, https://rdrr.io/rforge/vegan/man/dune.html
Introduction to ordination - Coding Club, accessed July 16, 2025, https://ourcodingclub.github.io/tutorials/ordination/
vegan PCA: Principal Components Analysis with vegans rda function - RPubs, accessed July 16, 2025, https://rpubs.com/brouwern/veganpca
Customising vegan's ordination plots - From the bottom of the heap, accessed July 16, 2025, https://fromthebottomoftheheap.net/2012/04/11/customising-vegans-ordination-plots/
Customizing a vegan pca plot with ggplot2 - Stack Overflow, accessed July 16, 2025, https://stackoverflow.com/questions/46288467/customizing-a-vegan-pca-plot-with-ggplot2
vegan source: R/specnumber.R - rdrr.io, accessed July 16, 2025, https://rdrr.io/cran/vegan/src/R/specnumber.R
vegan cheatsheet - RPubs, accessed July 16, 2025, https://rpubs.com/an-bui/vegan-cheat-sheet
Vegan: ecological diversity, accessed July 16, 2025, https://cran.r-project.org/web/packages/vegan/vignettes/diversity-vegan.pdf
glmmTMB balances speed and flexibility among packages for Zero-inflated Generalized Linear Mixed Modeling - DTU Research Database, accessed July 16, 2025, https://orbit.dtu.dk/files/154739064/Publishers_version.pdf
Getting started with the glmmTMB package, accessed July 16, 2025, https://cran.r-project.org/web/packages/glmmTMB/vignettes/glmmTMB.pdf
grouseticks dataset | R PACKAGES, accessed July 16, 2025, https://r-packages.io/datasets/grouseticks
grouseticks: Data on red grouse ticks from Elston et al. 2001 - RDocumentation, accessed July 16, 2025, https://www.rdocumentation.org/packages/lme4/versions/1.1-35.5/topics/grouseticks
grouseticks: Data on red grouse ticks from Elston et al. 2001 in lme4: Linear Mixed-Effects Models using 'Eigen' and S4 - rdrr.io, accessed July 16, 2025, https://rdrr.io/cran/lme4/man/grouseticks.html
GLMM FAQ - GitHub Pages, accessed July 16, 2025, https://bbolker.github.io/mixedmodels-misc/glmmFAQ.html
Analysis of aggregation, a worked example: Numbers of ticks on red grouse chicks, accessed July 16, 2025, https://www.researchgate.net/publication/11945272_Analysis_of_aggregation_a_worked_example_Numbers_of_ticks_on_red_grouse_chicks
How do I fit a quasi-poisson model with lme4 or glmmTMB? - Stack Overflow, accessed July 16, 2025, https://stackoverflow.com/questions/68915173/how-do-i-fit-a-quasi-poisson-model-with-lme4-or-glmmtmb
Introduction to GLMMs - Bede Ffinian Rowe Davies, accessed July 16, 2025, https://bedeffinianrowedavies.com/statisticstutorialsglmm/introductionglmms

# ==== HIGH-LEVEL OBJECTIVE =====================================================
You are an autonomous coding agent.  
Create a public, beginner-friendly repository named **vibe-coding-for-ecology**.  
Its purpose is to host reusable, “Vibe Coding” workflows that make common
ecological analyses clear, reproducible, and inviting for collaboration.

Follow the Vibe Coding philosophy (Narrative-Driven Structure, Sanctuary of
Scripts, Clarity is King, Reproducibility by Design) as illustrated in the
example markdowns I provided ([examples/example_1.md](cci:7://file:///Users/fabiofavoretto/CBMC%20Dropbox/Fabio/vibe-coding-for-ecology/examples/example_1.md:0:0-0:0), [examples/example_2.md](cci:7://file:///Users/fabiofavoretto/CBMC%20Dropbox/Fabio/vibe-coding-for-ecology/examples/example_2.md:0:0-0:0)).

# ==== REPO ROOT LAYOUT ========================================================
📁 vibe-coding-for-ecology  
├── README.md                # Concept, quick-start, contributor guide  
├── CODE_OF_CONDUCT.md       # Community standards  
├── LICENSE                  # MIT or CC-BY 4.0 – your choice  
├── .gitignore               # R, Python, and data ignores  
│
├── rules/                   # Coding rulebook for ecology  
│   ├── R_rules.md           # See “Rules: R for Ecology” section below  
│   └── CONTRIBUTING.md      # How to propose new rules  
│
├── workflows/               # Thematic folders containing Vibe workflows  
│   ├── 01_data_wrangling/           # Tidy, join, re-shape  
│   ├── 02_visualization/            # ggplot, maps, dashboards  
│   ├── 03_univariate_models/        # t-tests, ANOVA, simple & multiple LM/GLM  
│   ├── 04_multivariate_analysis/    # PCA, NMDS, CCA, RDA  
│   ├── 05_diversity_metrics/        # Alpha, beta, rarefaction  
│   ├── 06_mixed_effects_models/     # LMM, GLMM, Bayesian hierarchical  
│   ├── 07_species_distribution/     # SDMs, ENMs, MaxEnt, Biomod2  
│   ├── 08_spatial_analysis/         # Raster & vector ecology, spatial stats  
│   ├── 09_time_series/              # ARIMA, GAMM, state-space, phenology  
│   ├── 10_population_simulation/    # IPMs, matrix models, agent-based sims  
│   └── 99_utilities/                # Helper functions, plotting themes  
│
├── data/                    # Mini demo datasets only (≤ 1 MB each)  
│   ├── raw/                 # Untouched originals  
│   └── processed/           # Cleaned versions (RDS/CSV)  
│
└── .github/WORKFLOW_TEMPLATES/       # Optional CI for R-CMD-check, pkgdown
==== POPULATE WORKFLOWS ======================================================
For every folder inside workflows/:

Add at least one fully-worked Vibe Markdown file that: • Follows the five-part template (🪴, 🧹, 🔬, 📊, 🧬).
• Uses only built-in or CRAN datasets ≤ 500 KB (iris, mpg, dune, etc.).
• Includes runnable R code blocks, explanatory prose, and ggsave() calls.
• Saves outputs to a relative 3_output/ path inside that workflow’s folder.
• Ends with sessionInfo() for reproducibility.
Where helpful, also create the companion script trio
(01_data_wrangling.R, 02_analysis.R, 03_visualization.R) so a user can run the analysis line-by-line outside the markdown if desired.
Keep raw data read-only and write cleaned data to data/processed/.
Ensure file paths are relative and use here::here().
Prefix each script numerically and name it descriptively, e.g. 02_analysis_glm_species_richness.R.
==== RULES: R for ECOLOGY ====================================================
Generate rules/R_rules.md containing ~20 concise, actionable guidelines tailored to ecological research (expand & refine the list below).

• Use theme_bw() or theme_minimal() by default; always label axes/units.
• Save plots via ggsave() with explicit width, height, dpi = 300.
• Prefer color-blind-safe palettes (viridis, RColorBrewer::“Set2”).
• Keep raw data immutable; processed data lives in data/processed/.
• Scripts must run top-to-bottom without manual intervention.
• Seed random generators (set.seed(123)) for any stochastic step.
• Log long operations (>10 s) to run.log via logging or futile.logger.
• Document every function with roxygen-style comments.
• Use renv for dependency snapshots; commit renv.lock.
• Write commit messages using Conventional Commits (feat:, fix:, etc.).
• … (add further best-practice bullets for testing, version control, etc.)

Invite users to open PRs on CONTRIBUTING.md to discuss & extend rules.

==== README CONTENT REQUIREMENTS ============================================
README.md must:

Define “Vibe Coding” in one paragraph.
Explain the repo’s goal: share, learn, and co-create ecological workflows.
Show the folder diagram above (in a fenced code block or ASCII tree).
Provide a 30-second quick-start (“clone → open in RStudio → run a workflow”).
Link to the rulebook and describe how to propose new rules or workflows.
Include a badges line (R-CMD-check, license, DOI once on Zenodo).
Describe how to add a new themed workflow (copy template, fill sections).
End with a friendly call-to-action: “🌱 Fork this repo, add your vibe!”
==== QUALITY & STYLE =========================================================
• All code chunks must be runnable on vanilla R 4.3 + tidyverse.
• Default plot theme theme_bw().
• Use <- for assignment.
• File paths: here::here("data", "processed", "cleaned_data.rds").
• Keep every markdown under 650 lines; break large examples into sub-files.
• Comment generously—explain the why, not just the what.

==== DELIVERABLE =============================================================
Return the complete repository as a zipped directory tree or via the tool’s native multi-file output mechanism. When finished, print a short “✅ Repo scaffolded” confirmation.
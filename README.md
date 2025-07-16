# 🌱 Vibe Coding for Ecology: Agentic AI Workflows

[![R-CMD-check](https://github.com/Fabbiologia/vibe-coding-for-ecology/workflows/R-CMD-check/badge.svg)](https://github.com/Fabbiologia/vibe-coding-for-ecology/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXXX.svg)](https://doi.org/10.5281/zenodo.XXXXXXX)

## What is Vibe Coding for Agentic AI?

**Vibe Coding** meets **Agentic AI** - a revolutionary approach to computational ecology that combines human-centric analysis patterns with intelligent AI assistance. This repository provides state-of-the-art **context prompt engineering workflows** specifically designed for agentic coding tools (like Claude, GPT, Cursor, etc.) to help researchers conduct sophisticated ecological analyses.

**The core philosophy**: AI agents work best when given clear, structured context that mirrors how ecologists actually think. Our workflows provide rich contextual scaffolding that transforms vague research questions into precise, executable analysis pipelines.

### Key Features for Agentic Coding:
- **Context-Rich Prompts**: Each workflow includes detailed ecological context, statistical assumptions, and interpretation guidelines
- **Structured Analysis Templates**: Pre-built frameworks that AI agents can understand and adapt
- **Domain-Specific Constraints**: Ecological principles and statistical best practices built into every workflow
- **Iterative Refinement Patterns**: Workflows designed for human-AI collaboration and continuous improvement

## Repository Goal

This repository serves as a **comprehensive prompt engineering library** for ecological analysis with AI agents. Our mission is to bridge the gap between ecological domain knowledge and AI capabilities, providing researchers with ready-to-use templates that can be copy-pasted into any agentic coding environment to instantly begin sophisticated ecological analyses.

## Repository Structure

```
📁 vibe-coding-for-ecology  
├── README.md                # This file - concept, quick-start, contributor guide  
├── CODE_OF_CONDUCT.md       # Community standards  
├── LICENSE                  # MIT license for open collaboration
├── .gitignore               # R, Python, and data ignores  
│
├── rules/                   # Coding rulebook for ecology  
│   ├── R_rules.md           # ~20 actionable R guidelines for ecologists
│   └── CONTRIBUTING.md      # How to propose new rules and workflows
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
```

## 🤖 Agentic Coding Quick Start

### For AI Agents (Claude, GPT, etc.):

1. **Copy any workflow template** from the `workflows/` folder
2. **Paste it into your AI coding environment** (Cursor, ChatGPT, Claude, etc.)
3. **Add your specific research question** and data context
4. **Let the AI adapt the template** to your ecological analysis needs
5. **Iterate and refine** using the structured feedback loops built into each workflow

### For Human Researchers:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Fabbiologia/vibe-coding-for-ecology.git
   cd vibe-coding-for-ecology
   ```

2. **Choose your workflow approach:**
   - **Agentic Mode**: Copy workflow templates to your AI coding assistant
   - **Traditional Mode**: Open workflows in RStudio and run interactively
   - **Hybrid Mode**: Use AI to adapt templates, then refine manually

3. **Install required packages:**
   ```r
   install.packages(c("tidyverse", "here", "renv"))
   ```

4. **Explore the structured approach:**
   - Each workflow follows the 5-part template: 🪴 Setup → 🧹 Wrangle → 🔬 Analyze → 📊 Visualize → 🧬 Reproduce
   - Context prompts guide AI agents through ecological reasoning
   - Built-in validation ensures scientific rigor

## Adding New Workflows

To contribute a new workflow theme:

1. **Read the rules:** Check `rules/R_rules.md` for our coding standards
2. **Copy the template:** Use an existing workflow as your starting point
3. **Follow the 5-part structure:** 🪴 🧹 🔬 📊 🧬 (see examples for details)
4. **Keep it accessible:** Use built-in datasets ≤ 500 KB, document thoroughly
5. **Test reproducibility:** Ensure your workflow runs from start to finish
6. **Submit a PR:** Include both the `.md` narrative and any companion R scripts

Detailed contribution guidelines are in `rules/CONTRIBUTING.md`.

## Proposing New Rules

Our coding standards evolve with the community. To suggest new guidelines or modifications:

1. Read existing rules in `rules/R_rules.md`
2. Open an issue with the `rule-proposal` label
3. Discuss with the community
4. Submit a PR with your proposed changes

## Community Standards

This project is committed to fostering an inclusive, welcoming environment. Please read our `CODE_OF_CONDUCT.md` before participating.

---

## 🌱 Fork this repo, add your vibe!

Whether you're fixing a typo, adding a new workflow, or proposing a better way to visualize species accumulation curves, every contribution makes ecological analysis more accessible. Let's build something beautiful together.

**Ready to start coding with vibe?** Open your first workflow and feel the difference that clarity and intention make in your analysis.

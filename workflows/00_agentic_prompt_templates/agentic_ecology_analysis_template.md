# 🤖 Agentic Ecology Analysis Template

**Context Prompt Engineering for AI-Assisted Ecological Analysis**

## 🎯 Template Overview

This template provides a comprehensive framework for conducting ecological analyses with AI agents. It combines domain-specific ecological knowledge with structured analytical patterns to guide AI assistants through sophisticated research workflows.

### 🧬 Core Design Principles

- **Domain-Aware Context**: Rich ecological background that informs every analytical decision
- **Statistical Rigor**: Built-in validation and assumption checking
- **Iterative Refinement**: Structured feedback loops for continuous improvement
- **Interpretability**: Clear pathways from data to biological insights
- **Reproducibility**: Version-controlled, documented, and testable workflows

---

## 📋 COPY-PASTE PROMPT TEMPLATE

```
# ECOLOGICAL ANALYSIS CONTEXT PROMPT

## Research Domain: [SPECIFY YOUR DOMAIN]
- **Ecosystem Type**: [e.g., forest, marine, grassland, urban]
- **Spatial Scale**: [e.g., plot-level, landscape, regional, global]
- **Temporal Scale**: [e.g., snapshot, seasonal, annual, long-term]
- **Study System**: [e.g., plant communities, animal populations, ecosystem services]

## Research Question
[STATE YOUR SPECIFIC RESEARCH QUESTION HERE]

## Data Context
- **Data Structure**: [e.g., species abundance matrix, time series, spatial layers]
- **Sample Size**: [number of sites/plots/individuals]
- **Variables**: [list key measurements and their units]
- **Collection Methods**: [brief description of sampling approach]
- **Potential Limitations**: [missing data, sampling bias, temporal gaps]

## Analytical Approach
- **Primary Method**: [e.g., ordination, regression, diversity analysis]
- **Statistical Framework**: [e.g., GLM, mixed-effects, Bayesian]
- **Expected Outcomes**: [what patterns/relationships you expect to find]

## Constraints and Requirements
- **Software**: R (with tidyverse, vegan, etc.)
- **Significance Level**: α = 0.05 (or specify other)
- **Multiple Comparisons**: [how to handle if applicable]
- **Biological Realism**: [ensure results make ecological sense]

## AI Assistant Instructions
1. **Validate the ecological reasoning** behind all analytical choices
2. **Check statistical assumptions** before applying methods
3. **Provide biological interpretation** for all results
4. **Suggest alternative approaches** if assumptions are violated
5. **Generate publication-ready visualizations** with proper ecological context
6. **Document all decisions** and their ecological justification

## Output Requirements
- Annotated R code with ecological explanations
- Assumption validation and diagnostic plots
- Results interpretation with biological context
- Visualization with proper ecological axes labels
- Reproducible workflow documentation

Please proceed with the analysis following these guidelines.
```

---

## 🔧 Advanced Template Customizations

### For Community Ecology Studies

```
## Community Ecology Context Extension

### Community Structure
- **Taxonomic Resolution**: [species, genus, family level]
- **Functional Groups**: [feeding guilds, growth forms, etc.]
- **Trophic Levels**: [producers, primary/secondary consumers]
- **Rarity Patterns**: [dominant vs. rare species expectations]

### Environmental Gradients
- **Abiotic Factors**: [climate, soil, water chemistry]
- **Biotic Factors**: [competition, predation, facilitation]
- **Disturbance Regime**: [fire, grazing, human impact]
- **Spatial Heterogeneity**: [habitat fragmentation, edge effects]

### Analysis-Specific Considerations
- **Zero-Inflation**: [expect many zero abundances]
- **Compositional Data**: [relative vs. absolute abundances]
- **Phylogenetic Signal**: [evolutionary relationships matter]
- **Spatial Autocorrelation**: [nearby sites may be similar]
```

### For Population Ecology Studies

```
## Population Ecology Context Extension

### Population Characteristics
- **Life History**: [r vs. K selection, generation time]
- **Demographic Structure**: [age/size classes, sex ratios]
- **Reproductive Strategy**: [semelparous vs. iteroparous]
- **Dispersal Patterns**: [philopatry, migration, gene flow]

### Population Dynamics
- **Density Dependence**: [competition, resource limitation]
- **Stochasticity**: [environmental vs. demographic]
- **Metapopulation Structure**: [source-sink dynamics]
- **Population Viability**: [extinction risk, minimum viable population]

### Analysis-Specific Considerations
- **Count Data**: [Poisson, negative binomial distributions]
- **Survival Analysis**: [censoring, hazard functions]
- **Mark-Recapture**: [detection probability, individual heterogeneity]
- **Time Series**: [autocorrelation, trend vs. cycle]
```

### For Ecosystem Services Studies

```
## Ecosystem Services Context Extension

### Service Categories
- **Provisioning**: [food, water, fiber, fuel]
- **Regulating**: [climate, water, disease, pollination]
- **Cultural**: [recreation, spiritual, aesthetic]
- **Supporting**: [primary production, nutrient cycling]

### Valuation Framework
- **Biophysical Assessment**: [service quantification methods]
- **Economic Valuation**: [market vs. non-market approaches]
- **Social Valuation**: [stakeholder preferences, equity]
- **Temporal Dynamics**: [service flow vs. stock, sustainability]

### Analysis-Specific Considerations
- **Multiple Services**: [trade-offs, synergies, bundles]
- **Spatial Heterogeneity**: [service providing areas vs. beneficiaries]
- **Uncertainty**: [model uncertainty, value uncertainty]
- **Policy Relevance**: [decision-making context, scenarios]
```

---

## 🎨 Visualization Templates

### Standard Ecological Plots

```r
# ECOLOGICAL VISUALIZATION CONTEXT

## Plot Type: [ordination/regression/diversity/composition]
## Aesthetic Guidelines:
- Use colorblind-friendly palettes (viridis, RColorBrewer)
- Include error bars for uncertainty visualization
- Apply consistent theme (theme_bw() or theme_minimal())
- Use italic formatting for species names
- Include proper units in axis labels
- Add informative titles and captions

## Ecological Interpretation Requirements:
- Explain biological meaning of axes (for ordination)
- Discuss ecological significance of patterns
- Address potential confounding factors
- Suggest follow-up analyses if needed
- Validate results against ecological theory
```

### Interactive Visualization for Exploration

```r
# INTERACTIVE VISUALIZATION CONTEXT

## Purpose: Data exploration and hypothesis generation
## Tools: plotly, shiny, leaflet (for spatial data)
## Features:
- Hover information with species/site details
- Zoom and pan capabilities for detailed inspection
- Linked brushing between multiple plots
- Dynamic filtering by environmental variables
- Export capabilities for static publication figures

## Ecological Considerations:
- Maintain biological context in interactive elements
- Provide tooltips with ecological explanations
- Include reference information (species traits, habitat preferences)
- Enable comparative analysis across sites/time periods
```

---

## 🔍 Quality Assurance Framework

### Statistical Validation Checklist

```
## Pre-Analysis Validation
- [ ] Data structure matches analytical requirements
- [ ] Sample sizes adequate for chosen methods
- [ ] Variables properly transformed if needed
- [ ] Missing data patterns assessed and handled
- [ ] Outliers identified and justified

## During Analysis
- [ ] Model assumptions checked and validated
- [ ] Overdispersion assessed for count data
- [ ] Multicollinearity examined for multiple predictors
- [ ] Spatial/temporal autocorrelation addressed
- [ ] Model fit evaluated with appropriate metrics

## Post-Analysis
- [ ] Results biologically interpretable
- [ ] Effect sizes ecologically meaningful
- [ ] Uncertainty appropriately quantified
- [ ] Alternative explanations considered
- [ ] Broader ecological context discussed
```

### Ecological Validation Checklist

```
## Biological Realism Check
- [ ] Results consistent with known ecology
- [ ] Patterns match expected species responses
- [ ] Environmental relationships make sense
- [ ] Temporal patterns follow ecological theory
- [ ] Spatial patterns reflect known processes

## Literature Integration
- [ ] Results compared with similar studies
- [ ] Contrasting findings discussed
- [ ] Methodological differences noted
- [ ] Ecological mechanisms explored
- [ ] Future research directions identified
```

---

## 🚀 Advanced AI Integration Patterns

### Multi-Agent Workflow

```
## AI Agent Roles:
1. **Data Analyst**: Statistical method selection and implementation
2. **Ecological Consultant**: Biological interpretation and validation
3. **Visualization Specialist**: Publication-ready graphics and interactive tools
4. **Literature Reviewer**: Context integration and comparison
5. **Quality Assurance**: Method validation and assumption checking

## Interaction Patterns:
- Sequential: Each agent builds on previous work
- Parallel: Multiple agents work on different aspects simultaneously
- Iterative: Agents refine each other's work through feedback loops
- Consensus: Agents vote on analytical decisions
```

### Adaptive Template Selection

```r
# ADAPTIVE TEMPLATE LOGIC

## Data-Driven Template Selection
if (data_type == "species_abundance") {
  if (spatial_autocorrelation) {
    template <- "spatial_community_analysis"
  } else if (temporal_component) {
    template <- "temporal_community_dynamics"
  } else {
    template <- "basic_community_analysis"
  }
} else if (data_type == "individual_counts") {
  if (hierarchical_structure) {
    template <- "mixed_effects_population"
  } else if (survival_data) {
    template <- "survival_analysis"
  } else {
    template <- "glm_population_analysis"
  }
}

## Context-Sensitive Prompt Generation
generate_context_prompt(
  template = template,
  study_system = user_input$system,
  research_question = user_input$question,
  data_characteristics = data_summary,
  constraints = user_input$constraints
)
```

---

## 📚 Integration with Existing Workflows

### Workflow Inheritance Pattern

```
## Base Template Structure
1. 🪴 Setup & Context Loading
2. 🧹 Data Validation & Preparation  
3. 🔬 Analysis with Assumption Checking
4. 📊 Visualization with Ecological Context
5. 🧬 Reproducibility & Documentation

## Specialized Extensions
- Extend base template with domain-specific context
- Add method-specific validation steps
- Include specialized visualization patterns
- Integrate domain literature and theory
- Provide method-specific interpretation guidelines
```

### Cross-Workflow Integration

```r
# WORKFLOW PIPELINE INTEGRATION

## Sequential Workflow Pattern
data_wrangling_output %>%
  community_analysis_workflow() %>%
  diversity_analysis_workflow() %>%
  spatial_analysis_workflow() %>%
  synthesis_workflow()

## Parallel Workflow Pattern
list(
  community = community_analysis_workflow(data),
  diversity = diversity_analysis_workflow(data),
  spatial = spatial_analysis_workflow(data)
) %>%
  integration_workflow()
```

---

## 🎯 Next Steps

1. **Copy the basic template** and customize for your research domain
2. **Add your specific research context** using the provided extensions
3. **Paste into your AI coding environment** (Claude, ChatGPT, Cursor, etc.)
4. **Iterate and refine** based on AI feedback and results
5. **Share improvements** back to the community

This template transforms how ecological research is conducted with AI assistance, providing the structured context that enables sophisticated, scientifically sound analyses.

# Contributing to Vibe Coding for Ecology

Thank you for your interest in contributing! This repository thrives on community input and collaboration. Whether you're fixing a typo, proposing a new workflow, or suggesting improvements to our coding standards, every contribution makes ecological analysis more accessible.

## Ways to Contribute

### 🐛 **Bug Reports & Issues**
- Found an error in a workflow? Open an issue with the `bug` label
- Include the workflow name, error message, and your R/package versions
- Provide a minimal reproducible example if possible

### 🌱 **New Workflow Proposals**
- Want to add a new analysis theme? Open an issue with the `workflow-proposal` label
- Describe the ecological context and analytical approach
- Mention which packages/methods you'd like to demonstrate
- We'll discuss scope and provide feedback before you start coding

### 📏 **Proposing New Coding Rules**
- Have a better way to handle ecological data? Open an issue with the `rule-proposal` label
- Explain the problem your rule solves
- Provide example code showing the "before" and "after"
- Include reasoning for why this improves clarity or reproducibility

### 🔧 **Improving Existing Content**
- Documentation improvements, code optimization, and clarity enhancements are always welcome
- Submit a PR directly for small changes
- Open an issue first for major restructuring

## Workflow Contribution Guidelines

### **Structure Requirements**
All new workflows must follow the 5-part Vibe Coding template:

```markdown
🪴 1. Project Setup & Vibe Check
🧹 2. Data Wrangling: The Tidy Up  
🔬 3. The Analysis: Asking Our Questions
📊 4. Visualization: Seeing the Story
🧬 5. Reproducibility Check
```

### **Technical Requirements**
- **R Version**: Compatible with R 4.3+ and tidyverse
- **Data**: Use only built-in or CRAN datasets ≤ 500 KB
- **Plots**: Default to `theme_bw()`, save with `ggsave()`
- **Paths**: Use `here::here()` for all file paths
- **Documentation**: Include `sessionInfo()` and thorough comments
- **Reproducibility**: Code must run from start to finish without intervention

### **Content Guidelines**
- **Narrative**: Write prose that explains the *why*, not just the *what*
- **Accessibility**: Assume readers are learning the method for the first time
- **Clarity**: Use descriptive variable names and logical flow
- **Length**: Keep workflows under 650 lines; break large examples into sub-files

### **File Organization**
For each new workflow theme, create:

```
workflows/XX_your_theme/
├── README.md                    # Overview of the theme
├── workflow_example.md          # Main Vibe workflow (required)
├── 01_data_wrangling.R         # Optional companion script
├── 02_analysis.R               # Optional companion script  
├── 03_visualization.R          # Optional companion script
└── 3_output/                   # Directory for generated outputs
    ├── figures/
    └── tables/
```

## Step-by-Step Contribution Process

### **1. Setup Your Development Environment**
```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR-USERNAME/vibe-coding-for-ecology.git
cd vibe-coding-for-ecology

# Create a new branch for your contribution
git checkout -b your-feature-branch
```

### **2. Follow Our Coding Standards**
- Read `rules/R_rules.md` thoroughly
- Test your code in a fresh R session
- Run `sessionInfo()` and include the output

### **3. Test Thoroughly**
- Ensure your workflow runs completely from start to finish
- Test with different R versions if possible
- Check that all file paths work on different operating systems

### **4. Submit Your Pull Request**
- Use a descriptive title: `feat: add time series analysis workflow` or `fix: correct PCA biplot scaling`
- Include a summary of changes in the PR description
- Reference any related issues
- Add screenshots of key visualizations if applicable

### **5. Respond to Feedback**
- Be open to suggestions and improvements
- Make requested changes promptly
- Ask questions if feedback is unclear

## Coding Style Checklist

Before submitting, ensure your contribution meets these standards:

- [ ] Uses `<-` for assignment (not `=`)
- [ ] Includes all necessary `library()` calls at the top
- [ ] Uses descriptive variable names (`species_richness_model` not `m1`)
- [ ] File paths use `here::here()`
- [ ] Plots use `theme_bw()` or `theme_minimal()`
- [ ] Plots saved with `ggsave()` including width, height, and dpi
- [ ] Includes `set.seed()` for any random operations
- [ ] Ends with `sessionInfo()`
- [ ] Comments explain the reasoning, not just the mechanics
- [ ] Code runs without errors from start to finish

## Community Guidelines

- **Be respectful**: Treat all contributors with kindness and respect
- **Be constructive**: Offer specific, actionable feedback
- **Be patient**: Everyone is learning and improving together
- **Be inclusive**: Welcome contributors of all skill levels

## Questions?

- Check existing issues and discussions first
- For workflow questions: open an issue with the `question` label  
- For technical problems: include your `sessionInfo()` output
- For general discussion: use the repository's discussion board

---

**Remember**: Every expert was once a beginner. Your contribution, no matter how small, helps make ecological analysis more accessible to the entire community. Thank you for being part of the Vibe Coding movement! 🌱

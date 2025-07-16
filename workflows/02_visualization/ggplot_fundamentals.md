# Vibe Workflow: ggplot2 Fundamentals for Ecological Data

**Goal:** Master the essential ggplot2 patterns for creating clear, informative, and publication-ready ecological visualizations.

**Vibe:** Building beautiful plots is storytelling with data. Every aesthetic choice should serve the narrative and help your audience understand the ecological patterns you've discovered.

**Core Packages:** `tidyverse`, `viridis`, `ggrepel`, `patchwork`

---

## 🪴 1. Project Setup & Vibe Check

This workflow teaches the grammar of graphics through ecological examples. We'll explore how to layer aesthetic mappings, geometries, and themes to create compelling visualizations that communicate ecological insights effectively. Each plot type serves a specific purpose in ecological analysis.

```english
Load essential libraries for ecological visualization:
- Load tidyverse for comprehensive data manipulation and ggplot2
- Load viridis for colorblind-friendly color palettes
- Load ggrepel for non-overlapping text labels in crowded plots
- Load patchwork for combining multiple plots into publication figures
- Load scales for professional axis formatting and label control
- Load here for robust relative file paths across systems

Establish reproducible visualization environment:
- Set random seed to 123 for consistent jittering and sampling
- Create output directory structure for figures if it doesn't exist
- Create output directory structure for tables if it doesn't exist
- Verify workspace is organized for systematic plot development
```

---

## 🧹 2. Data Wrangling: The Tidy Up

We'll use multiple datasets to demonstrate different visualization approaches. The iris dataset provides continuous variables for regression plots, while our custom ecological data shows discrete patterns. We prepare the data to highlight specific visualization principles.

```english
Prepare demonstration datasets:
- Load built-in iris dataset for continuous variable examples
- Load mtcars dataset for additional regression demonstrations
- Verify these datasets have appropriate structure for visualization examples

Create custom ecological demonstration dataset:
- Generate site identifiers with zero-padded numbering (Site_01, Site_02, etc.)
- Define habitat categories reflecting realistic ecological gradients
- Include four common species across different habitats
- Create abundance data that shows realistic species-habitat associations
- Add environmental variables (elevation, soil pH) with ecological realism
- Ensure data structure supports multiple visualization approaches

Generate summary statistics for visualization:
- Group data by habitat and species combinations
- Calculate mean abundance and standard error for error bar plots
- Count number of sites per group for statistical validity
- Create habitat-level summaries for categorical comparisons

Compute site-level diversity metrics:
- Group data by site with environmental characteristics
- Calculate species richness (count of species present)
- Compute total abundance across all species per site
- Calculate Shannon diversity index using standard ecological formula
- Prepare data structure for multidimensional scatter plots

# Quick data check
glimpse(species_data)
glimpse(habitat_summary)
glimpse(site_diversity)
```

---

## 🔬 3. The Analysis: Asking Our Questions

Before jumping into visualization, we explore our data to understand the patterns we want to highlight. Each plot type serves a specific analytical purpose - from showing distributions to revealing relationships to comparing groups. Understanding your data structure guides visualization choices.

```english
Develop habitat pattern summaries:
- Group data by habitat type across all sites
- Calculate mean species richness and total abundance per habitat
- Determine dominant species in each habitat based on abundance
- Sort habitats by mean species richness for visualization prioritization

Develop environmental correlation summaries:
- Compute pairwise correlations between environmental variables
- Round correlation coefficients to three decimal places for readability
- Display correlation matrix to identify key relationships

Develop species-specific pattern summaries:
- Group data by individual species across all sites
- Calculate total abundance summed across all occurrences
- Count number of sites where each species is present
- Determine mean elevation where species occurs (excluding absences)
- Identify preferred habitat using frequency of occurrence
- Sort species by total abundance for visualization prioritization

Conduct data inspection and validation:
- Check dimensions of all prepared datasets
- Verify species data contains expected number of observations
- Confirm habitat summary has appropriate grouping structure
- Validate site diversity calculations cover all sites
- Display species patterns to verify ecological realism
- Ensure data is ready for comprehensive visualization workflow
```

---

## 📊 4. Visualization: Seeing the Story

Each plot type serves a specific purpose in ecological communication. We demonstrate the full range of ggplot2 capabilities through six essential plot types that cover the most common ecological visualization needs. The grammar of graphics approach makes complex plots intuitive and customizable.

### **Plot 1: Basic Scatter Plot with Regression Lines**

```english
Create foundational scatter plot demonstrating core ggplot2 principles:
- Use site diversity data with elevation on x-axis and species richness on y-axis
- Color points by habitat type using viridis color palette for accessibility
- Set point size to 3 and alpha to 0.8 for optimal visibility
- Add linear regression lines with confidence intervals using geom_smooth
- Apply facet wrapping by habitat with free x-scales to show habitat-specific patterns
- Include descriptive title, subtitle, and caption for context
- Use theme_bw() for clean, publication-ready appearance
- Position legend at bottom to maximize plot area
- Format title as bold and subtitle with appropriate sizing
```

### **Plot 2: Advanced Box Plots with Individual Points**

```english
Develop sophisticated box plot combining statistical summaries with raw data:
- Filter species data to include only sites where species are present
- Reorder species by median abundance for logical visual progression
- Create box plots filled by species using viridis color palette
- Set box plot alpha to 0.7 and suppress outlier points to avoid duplication
- Overlay jittered points with controlled width (0.2) and appropriate transparency
- Suppress fill legend as species names appear on axis
- Flip coordinates to improve species name readability
- Include informative title explaining statistical elements shown
- Apply italics to species names following taxonomic conventions
- Use consistent theme_bw() styling for professional appearance
```

### **Plot 3: Faceted Bar Chart with Error Bars**

```english
Construct faceted bar chart demonstrating habitat-specific patterns:
- Use habitat summary data with species reordered by mean abundance within each habitat
- Create column chart with bars filled by habitat using plasma color option
- Add error bars showing standard error of the mean with appropriate width
- Apply facet wrapping by habitat with free x-scales for habitat-specific comparisons
- Set bar transparency to 0.8 for visual appeal
- Suppress fill legend as habitat information appears in facet labels
- Flip coordinates to accommodate species names
- Include clear title and subtitle explaining error bar meaning
- Apply italic formatting to species names and bold to facet labels
- Use descriptive caption highlighting main ecological insight
```

### **Plot 4: Heatmap with Custom Color Scale**

```english
Develop association matrix heatmap revealing species-habitat relationships:
- Group species data by habitat and species to calculate mean abundance
- Reorder species by mean abundance for logical arrangement
- Create tile geometry with white borders (0.5 size) for clear separation
- Fill tiles using inferno color palette based on mean abundance values
- Overlay white text labels showing rounded abundance values (1 decimal place)
- Use bold font face for text labels with appropriate size (4)
- Create informative color legend with line break in title
- Include title emphasizing association matrix concept
- Apply italic formatting to species names and angle x-axis labels
- Use descriptive caption explaining both color and number meanings
```

### **Plot 5: Complex Multi-aesthetic Scatter Plot**

```english
Create sophisticated multi-dimensional visualization demonstrating advanced aesthetics:
- Use site diversity data with elevation vs Shannon diversity as base relationship
- Map soil pH to color using plasma palette for continuous environmental gradient
- Map total abundance to point size with range from 2 to 8 for clear differentiation
- Map habitat type to point shape using distinct shapes (circle, triangle, square)
- Set overall point transparency to 0.8 for optimal visibility with overlaps
- Add non-overlapping site number labels using text repel functionality
- Configure separate scales for color (continuous), size (continuous), and shape (manual)
- Position all legends horizontally at bottom to avoid plot crowding
- Set legend title positions to top for compact arrangement
- Include comprehensive title describing multi-dimensional relationships
- Provide detailed caption explaining each aesthetic mapping
```

### **Plot 6: Elevation Profile with Uncertainty Bands**

```english
Develop profile plot demonstrating ribbon and line combinations:
- Sort site diversity data by elevation to create logical sequence
- Create base relationship between elevation and species richness
- Add uncertainty ribbon with ±0.5 species buffer around richness values
- Set ribbon transparency to 0.3 and fill with steelblue color
- Overlay thick line (size 1.2) in matching steelblue for trend emphasis
- Add colored points by habitat type using viridis palette
- Set point size to 3 for clear visibility over ribbon and line
- Use theme_minimal() for clean, modern appearance
- Remove minor grid lines to reduce visual clutter
- Position legend at bottom for space efficiency
- Include explanatory subtitle describing ribbon meaning
- Use descriptive caption explaining elevation-based arrangement logic
```

### **Saving Individual Plots**

```english
Save each visualization using systematic file naming and high-quality settings:
- Create output directory path using here() for relative path management
- Save scatter plot with dimensions 8x6 inches at 300 DPI for publication quality
- Save box plot with wider dimensions (10x6) to accommodate species names
- Save faceted bar chart with expanded width (12x6) for multiple panels
- Save heatmap with standard dimensions (8x6) for matrix display
- Save complex scatter plot with taller format (10x8) for multiple legends
- Save elevation profile with wide format (10x6) for gradient visualization
- Use consistent PNG format for compatibility and quality
- Apply descriptive filenames indicating plot type and content
```

### **Creating Combined Figure Layouts**

```english
Develop multi-panel figure using patchwork for comprehensive presentation:
- Combine scatter and box plots in top row using addition operator
- Combine bar chart and heatmap in bottom row for visual balance
- Stack rows using division operator for logical arrangement
- Add overall annotation with workshop title and subtitle
- Include attribution caption identifying Vibe Coding source
- Configure title formatting with increased size (16) and bold weight
- Set subtitle size to 14 for hierarchy and caption to 12 with italics
- Save combined figure with expanded dimensions (16x12) for clarity
- Use high resolution (300 DPI) for presentation and publication use
```

---

## 🧬 5. Reproducibility Check

We document our visualization choices and save the underlying data. Good ecological visualizations are not just beautiful—they're also reproducible and transparent about the design decisions that shape how patterns are perceived and interpreted.

### **Data Preservation for Reproducibility**

```english
Save all processed datasets used in visualization workflow:
- Export species abundance data to RDS format with descriptive filename
- Save habitat summary statistics preserving calculated means and standard errors
- Archive site diversity metrics including richness and Shannon indices
- Use relative paths via here() for cross-platform compatibility
- Store in dedicated tables subdirectory for organized data management
- Include clear naming convention indicating data purpose and processing stage
```

### **Visualization Metadata Documentation**

```english
Create comprehensive metadata list documenting design decisions:
- Record color palette choice (viridis for colorblind accessibility)
- Document base themes used (theme_bw and theme_minimal)
- Specify figure dimensions range (8x6 to 16x12 inches)
- Set standard resolution (300 DPI) for publication quality
- Define font size hierarchy (title 14, subtitle 12, axis 11, caption 10)
- List core design principles ensuring consistency and accessibility
- Document all plot types demonstrated in workshop
- Save metadata as RDS file for programmatic access
```

### **Ecological Plotting Reference Guide**

```english
Generate comprehensive plotting guide for future reference:
- Create structured table with plot types and their optimal applications
- Match visualization approaches to ecological question types
- Specify key geometric combinations for each plot category
- Include specific ecological use cases and research contexts
- Export guide as CSV for easy sharing and reference
- Structure columns for plot type, best use cases, key functions, and applications
```

### **Session Documentation and Summary**

```english
Document analysis session for complete reproducibility:
- Print comprehensive summary of visualization accomplishments
- Count and list all plot types successfully demonstrated
- Display design principles applied throughout workflow
- Confirm color palette and resolution settings used
- Enumerate plot types with clear numbering system
- List all design principles with bullet formatting
- Record complete session information including package versions
- Save session info for dependency tracking and troubleshooting
```

---

## Summary

---

## 🧪 6. Testing and Validation Framework

Every visualization workflow must include comprehensive testing to ensure accuracy, accessibility, and reproducibility. This testing framework validates both the underlying data processing and the visualization output quality.

### **Data Integrity Validation**

```english
Verify data processing accuracy before visualization:
- Check that original dataset dimensions are preserved through transformations
- Validate that no data points are lost during joining or filtering operations
- Confirm species names remain consistent and properly formatted throughout
- Test that calculated diversity metrics fall within expected biological ranges
- Verify habitat classifications match original study design specifications
- Ensure elevation values are realistic for study region and properly scaled
- Check for and document any missing value patterns or outliers
- Validate that summary statistics calculations are mathematically correct
```

### **Visualization Output Quality Assurance**

```english
Test visualization quality and technical specifications:
- Verify all plots render without errors or warning messages
- Check that color palettes display correctly across different devices
- Confirm text elements (titles, labels, captions) are legible and properly sized
- Test that legends are positioned appropriately and contain accurate information
- Validate file outputs save to correct directories with proper naming
- Ensure plot dimensions and DPI settings meet publication standards
- Check that faceted plots display all groups with appropriate scaling
- Verify combined plots maintain proper alignment and spacing
```

### **Accessibility and Design Standards Validation**

```english
Ensure visualizations meet accessibility and scientific communication standards:
- Test color palette accessibility using colorblind simulation tools
- Verify sufficient contrast between text and background elements
- Check that plots remain interpretable when printed in grayscale
- Validate font sizes meet minimum readability requirements
- Ensure axis labels and titles provide complete context without abbreviations
- Test that plot layouts work across different aspect ratios and sizes
- Confirm species names follow proper taxonomic formatting conventions
- Verify mathematical symbols and statistical notation are correctly displayed
```

### **Ecological Interpretation Validation**

```english
Validate biological and ecological meaningfulness of visualizations:
- Confirm that species-environment relationships shown are ecologically plausible
- Check that diversity patterns align with known ecological theory
- Verify abundance distributions reflect realistic population dynamics
- Test that habitat associations match expected species ecology
- Ensure elevation gradients show biologically meaningful patterns
- Validate that uncertainty representations accurately reflect data limitations
- Check community composition patterns for ecological coherence
- Confirm statistical summaries accurately represent underlying biological processes
```

### **Reproducibility Stress Testing**

```english
Test workflow robustness across different computational environments:
- Run complete workflow in clean R environment to test dependency management
- Verify results remain identical across different operating systems
- Test that relative file paths work correctly in different directory structures
- Confirm random seed settings produce identical results across runs
- Validate that package version differences don't affect output quality
- Test workflow performance with different dataset sizes and structures
- Ensure error handling works appropriately for edge cases
- Document any platform-specific requirements or limitations
```

### **Output Validation Protocols**

```english
Implement systematic checks for all workflow outputs:
- Verify that all expected figure files are created with correct dimensions
- Check saved data files contain expected variables and observations
- Validate metadata files include complete documentation
- Test that plotting guide contains accurate and useful information
- Confirm session information captures all relevant software details
- Ensure file naming conventions follow project standards consistently
- Check that output directory structure matches specified organization
- Validate that all outputs can be successfully loaded and used in subsequent analyses
```

This workflow demonstrates comprehensive ggplot2 usage for ecological data visualization:

- **Grammar of Graphics**: Built plots systematically using aesthetic mappings, geometries, scales, and themes
- **Plot Diversity**: Created six distinct plot types, each serving specific analytical purposes
- **Design Principles**: Applied consistent, accessible design choices throughout
- **Layering Strategy**: Demonstrated how to combine multiple geometries effectively
- **Color Theory**: Used viridis palettes for accessibility and scientific credibility

**Key techniques learned:**

- Aesthetic mapping to multiple variables simultaneously
- Faceting for categorical comparisons
- Error bar overlays for uncertainty communication  
- Text repulsion for clean labels
- Multi-panel composition with patchwork

**Next steps:** These visualization patterns can be adapted for any ecological dataset. Consider extending with interactive plots using `plotly` or animated plots using `gganimate` for time series data.

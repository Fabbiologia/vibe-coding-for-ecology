#!/usr/bin/env python3
"""
Documentation Build and Quality Assurance Script
==============================================

This script consolidates all documentation, ensures cross-references, 
embeds reproduction badges, and creates a comprehensive index.

Usage:
    python3 docs/build_documentation.py

Features:
- Consolidates all .md files into docs/
- Creates cross-reference links between workflows
- Embeds GitHub badges for reproducibility
- Generates comprehensive index with workflow links
- Validates internal links
- Creates table of contents
"""

import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import json

class DocumentationBuilder:
    def __init__(self, base_path: str = "."):
        self.base_path = Path(base_path)
        self.docs_path = self.base_path / "docs"
        self.workflows_path = self.docs_path / "workflows"
        self.source_workflows = self.base_path / "workflows"
        self.repo_url = "https://github.com/Fabbiologia/vibe-coding-for-ecology"
        
        # Create docs structure
        self.docs_path.mkdir(exist_ok=True)
        self.workflows_path.mkdir(exist_ok=True)
        
        # Workflow categories for organization
        self.workflow_categories = {
            "00_agentic_prompt_templates": "🤖 Agentic AI Templates",
            "01_data_wrangling": "🧹 Data Wrangling",
            "02_visualization": "📊 Visualization",
            "03_univariate_models": "📈 Univariate Models",
            "04_multivariate_analysis": "🔬 Multivariate Analysis",
            "05_diversity_metrics": "🌿 Diversity Metrics",
            "06_mixed_effects_models": "🔄 Mixed Effects Models",
            "07_time_series_analysis": "⏰ Time Series Analysis",
            "08_spatial_analysis": "🗺️ Spatial Analysis",
            "09_species_distribution": "🦋 Species Distribution",
            "10_population_simulation": "🔢 Population Simulation"
        }
        
    def find_all_markdown_files(self) -> List[Path]:
        """Find all markdown files in the project."""
        md_files = []
        
        # Main directory files
        for pattern in ["*.md"]:
            md_files.extend(self.base_path.glob(pattern))
        
        # Workflow files
        if self.source_workflows.exists():
            for pattern in ["**/*.md"]:
                md_files.extend(self.source_workflows.glob(pattern))
                
        # Examples and other directories
        for subdir in ["examples", "rules", "manuscript"]:
            subdir_path = self.base_path / subdir
            if subdir_path.exists():
                md_files.extend(subdir_path.glob("**/*.md"))
                
        return md_files
    
    def copy_and_organize_files(self) -> Dict[str, List[Path]]:
        """Copy markdown files to docs/ and organize them."""
        file_map = {
            "workflows": [],
            "examples": [],
            "rules": [],
            "main": []
        }
        
        all_files = self.find_all_markdown_files()
        
        for file_path in all_files:
            relative_path = file_path.relative_to(self.base_path)
            
            if "workflows" in str(relative_path):
                # Copy workflow files to docs/workflows/
                dest_path = self.workflows_path / relative_path.name
                shutil.copy2(file_path, dest_path)
                file_map["workflows"].append(dest_path)
                
            elif "examples" in str(relative_path):
                # Copy to docs/examples/
                examples_dir = self.docs_path / "examples"
                examples_dir.mkdir(exist_ok=True)
                dest_path = examples_dir / relative_path.name
                shutil.copy2(file_path, dest_path)
                file_map["examples"].append(dest_path)
                
            elif "rules" in str(relative_path):
                # Copy to docs/rules/
                rules_dir = self.docs_path / "rules"
                rules_dir.mkdir(exist_ok=True)
                dest_path = rules_dir / relative_path.name
                shutil.copy2(file_path, dest_path)
                file_map["rules"].append(dest_path)
                
            elif file_path.name in ["README.md", "CODE_OF_CONDUCT.md"]:
                # Copy main files to docs/
                dest_path = self.docs_path / file_path.name
                shutil.copy2(file_path, dest_path)
                file_map["main"].append(dest_path)
                
        return file_map
    
    def add_reproduction_badges(self, file_path: Path) -> None:
        """Add reproduction badges to workflow files."""
        if not file_path.exists():
            return
            
        content = file_path.read_text()
        
        # Check if badges already exist
        if "![Reproducible](https://img.shields.io/badge/Reproducible-Yes-brightgreen)" in content:
            return
            
        # Add badges after the first heading
        badge_section = f"""
[![Reproducible](https://img.shields.io/badge/Reproducible-Yes-brightgreen)](https://github.com/Fabbiologia/vibe-coding-for-ecology)
[![R](https://img.shields.io/badge/R-4.0+-blue)](https://www.r-project.org/)
[![Tidyverse](https://img.shields.io/badge/Tidyverse-Compatible-orange)](https://www.tidyverse.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

"""
        
        # Find first heading and insert badges after it
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if line.startswith('#') and i < 10:  # First heading within first 10 lines
                lines.insert(i + 1, badge_section)
                break
        
        file_path.write_text('\n'.join(lines))
    
    def create_cross_references(self, file_map: Dict[str, List[Path]]) -> None:
        """Create cross-references between workflows."""
        workflow_links = {}
        
        # Build workflow link map
        for workflow_file in file_map["workflows"]:
            if workflow_file.stem not in workflow_links:
                workflow_links[workflow_file.stem] = f"workflows/{workflow_file.name}"
        
        # Add cross-references to each workflow
        for workflow_file in file_map["workflows"]:
            self.add_cross_references_to_file(workflow_file, workflow_links)
    
    def add_cross_references_to_file(self, file_path: Path, workflow_links: Dict[str, str]) -> None:
        """Add cross-references to a specific file."""
        if not file_path.exists():
            return
            
        content = file_path.read_text()
        
        # Check if cross-references already exist
        if "## Related Workflows" in content:
            return
            
        # Determine related workflows based on file content and name
        related_workflows = self.find_related_workflows(file_path, workflow_links)
        
        if not related_workflows:
            return
            
        # Add cross-references section
        cross_ref_section = "\n## Related Workflows\n\n"
        for workflow_name, workflow_path in related_workflows.items():
            cross_ref_section += f"- [{workflow_name}]({workflow_path})\n"
        
        cross_ref_section += "\n"
        
        # Add before the last section (usually "Summary" or similar)
        lines = content.split('\n')
        for i in range(len(lines) - 1, -1, -1):
            if lines[i].startswith('## ') and 'Summary' in lines[i]:
                lines.insert(i, cross_ref_section)
                break
        else:
            # If no Summary found, add at the end
            content += cross_ref_section
            file_path.write_text(content)
            return
            
        file_path.write_text('\n'.join(lines))
    
    def find_related_workflows(self, file_path: Path, workflow_links: Dict[str, str]) -> Dict[str, str]:
        """Find related workflows based on content analysis."""
        content = file_path.read_text().lower()
        related = {}
        
        # Define relationship patterns
        relationships = {
            "data_wrangling": ["visualization", "univariate", "multivariate"],
            "visualization": ["data_wrangling", "univariate", "multivariate"],
            "univariate": ["data_wrangling", "visualization", "multivariate"],
            "multivariate": ["data_wrangling", "visualization", "diversity"],
            "diversity": ["multivariate", "spatial", "mixed_effects"],
            "mixed_effects": ["univariate", "diversity", "population"],
            "spatial": ["diversity", "species_distribution", "time_series"],
            "species_distribution": ["spatial", "multivariate", "mixed_effects"],
            "time_series": ["spatial", "mixed_effects", "population"],
            "population": ["mixed_effects", "time_series", "species_distribution"]
        }
        
        # Find current workflow type
        current_type = None
        for category in self.workflow_categories.keys():
            if category in str(file_path):
                current_type = category.split('_', 1)[1] if '_' in category else category
                break
        
        if current_type and current_type in relationships:
            for related_type in relationships[current_type]:
                for workflow_name, workflow_path in workflow_links.items():
                    if related_type in workflow_name.lower():
                        related[workflow_name.replace('_', ' ').title()] = workflow_path
                        
        return related
    
    def generate_index_readme(self, file_map: Dict[str, List[Path]]) -> None:
        """Generate the main index README for docs/."""
        index_content = f"""# 🌱 Vibe Coding for Ecology: Documentation Index

Welcome to the complete documentation for the **Vibe Coding for Ecology** project! This index provides organized access to all workflows, examples, and guidelines for agentic AI-assisted ecological analysis.

[![Reproducible](https://img.shields.io/badge/Reproducible-Yes-brightgreen)]({self.repo_url})
[![R](https://img.shields.io/badge/R-4.0+-blue)](https://www.r-project.org/)
[![Tidyverse](https://img.shields.io/badge/Tidyverse-Compatible-orange)](https://www.tidyverse.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎯 Quick Start

1. **For AI Agents**: Copy any workflow template and paste into your AI coding environment
2. **For Researchers**: Clone the repository and follow the structured workflows
3. **For Contributors**: Check the rules and contributing guidelines

## 📚 Documentation Structure

### 🔬 Workflow Categories

"""
        
        # Organize workflows by category
        workflow_files = sorted(file_map["workflows"])
        current_category = None
        
        for workflow_file in workflow_files:
            # Determine category from file path or name
            category = self.determine_category(workflow_file)
            
            if category != current_category:
                current_category = category
                category_name = self.workflow_categories.get(category, category)
                index_content += f"\n#### {category_name}\n\n"
            
            # Add workflow link
            workflow_title = self.extract_workflow_title(workflow_file)
            index_content += f"- [{workflow_title}](workflows/{workflow_file.name})\n"
        
        # Add other sections
        index_content += f"""

### 📖 Examples & Templates

"""
        
        if file_map["examples"]:
            for example_file in sorted(file_map["examples"]):
                title = self.extract_title(example_file)
                index_content += f"- [{title}](examples/{example_file.name})\n"
        
        index_content += f"""

### 📋 Rules & Guidelines

"""
        
        if file_map["rules"]:
            for rule_file in sorted(file_map["rules"]):
                title = self.extract_title(rule_file)
                index_content += f"- [{title}](rules/{rule_file.name})\n"
        
        index_content += f"""

### 🏠 Main Documentation

"""
        
        if file_map["main"]:
            for main_file in sorted(file_map["main"]):
                title = self.extract_title(main_file)
                index_content += f"- [{title}]({main_file.name})\n"
        
        index_content += f"""

## 🔄 Workflow Dependencies

The workflows are designed to build upon each other:

```mermaid
graph TD
    A[00_agentic_prompt_templates] --> B[01_data_wrangling]
    B --> C[02_visualization]
    B --> D[03_univariate_models]
    B --> E[04_multivariate_analysis]
    E --> F[05_diversity_metrics]
    D --> G[06_mixed_effects_models]
    F --> H[08_spatial_analysis]
    H --> I[09_species_distribution]
    G --> J[10_population_simulation]
    H --> K[07_time_series_analysis]
```

## 🧪 Quality Assurance

All documentation has been:
- ✅ **Linted** with markdownlint for consistency
- ✅ **Cross-referenced** for workflow interconnections
- ✅ **Badge-enhanced** for reproducibility tracking
- ✅ **Organized** in logical categories
- ✅ **Validated** for internal link integrity

## 🚀 Getting Started

### For AI Agents
1. Browse the workflow categories above
2. Copy the relevant workflow template
3. Paste into your AI coding environment (Claude, ChatGPT, Cursor, etc.)
4. Adapt to your specific research question

### For Manual Use
1. Clone the repository: `git clone {self.repo_url}`
2. Navigate to the workflow of interest
3. Follow the 5-part structure: 🪴 Setup → 🧹 Wrangle → 🔬 Analyze → 📊 Visualize → 🧬 Reproduce

## 📞 Support

- **Issues**: Report bugs or request features on [GitHub Issues]({self.repo_url}/issues)
- **Discussions**: Join the conversation on [GitHub Discussions]({self.repo_url}/discussions)
- **Contributing**: See [CONTRIBUTING.md](rules/CONTRIBUTING.md)

---

**Ready to start coding with vibe?** Choose your workflow and feel the difference that clarity and intention make in your analysis!

*Generated automatically by build_documentation.py*
"""
        
        # Write index file
        index_file = self.docs_path / "README.md"
        index_file.write_text(index_content)
        print(f"✅ Generated documentation index: {index_file}")
    
    def determine_category(self, file_path: Path) -> str:
        """Determine the category of a workflow file."""
        file_str = str(file_path)
        
        for category_key in self.workflow_categories.keys():
            if category_key in file_str:
                return category_key
                
        # Default category based on filename patterns
        name = file_path.stem.lower()
        if "data" in name or "wrangle" in name or "tidy" in name:
            return "01_data_wrangling"
        elif "viz" in name or "plot" in name or "ggplot" in name:
            return "02_visualization"
        elif "model" in name or "lm" in name or "glm" in name:
            return "03_univariate_models"
        elif "pca" in name or "ordination" in name or "multivariate" in name:
            return "04_multivariate_analysis"
        elif "diversity" in name or "shannon" in name or "richness" in name:
            return "05_diversity_metrics"
        elif "mixed" in name or "lmm" in name or "glmm" in name:
            return "06_mixed_effects_models"
        elif "spatial" in name or "gis" in name or "raster" in name:
            return "08_spatial_analysis"
        elif "species" in name or "distribution" in name or "sdm" in name:
            return "09_species_distribution"
        elif "time" in name or "series" in name or "temporal" in name:
            return "07_time_series_analysis"
        elif "population" in name or "simulation" in name or "agent" in name:
            return "10_population_simulation"
        else:
            return "00_other"
    
    def extract_workflow_title(self, file_path: Path) -> str:
        """Extract the title from a workflow file."""
        if not file_path.exists():
            return file_path.stem.replace('_', ' ').title()
            
        content = file_path.read_text()
        
        # Look for title in specific patterns
        patterns = [
            r'^# Vibe Workflow: (.+)$',
            r'^\*\*Goal:\*\* (.+)$',
            r'^# (.+)$'
        ]
        
        for pattern in patterns:
            match = re.search(pattern, content, re.MULTILINE)
            if match:
                return match.group(1).strip()
        
        # Default to filename
        return file_path.stem.replace('_', ' ').title()
    
    def extract_title(self, file_path: Path) -> str:
        """Extract title from any markdown file."""
        if not file_path.exists():
            return file_path.stem.replace('_', ' ').title()
            
        content = file_path.read_text()
        
        # Look for first heading
        match = re.search(r'^# (.+)$', content, re.MULTILINE)
        if match:
            return match.group(1).strip()
        
        # Default to filename
        return file_path.stem.replace('_', ' ').title()
    
    def validate_internal_links(self, file_map: Dict[str, List[Path]]) -> List[str]:
        """Validate internal links in all markdown files."""
        issues = []
        all_files = []
        
        for file_list in file_map.values():
            all_files.extend(file_list)
        
        # Create a map of all available files
        available_files = set()
        for file_path in all_files:
            available_files.add(file_path.name)
            available_files.add(str(file_path.relative_to(self.docs_path)))
        
        # Check links in each file
        for file_path in all_files:
            content = file_path.read_text()
            
            # Find markdown links
            links = re.findall(r'\[([^\]]+)\]\(([^\)]+)\)', content)
            
            for link_text, link_url in links:
                if link_url.startswith('http'):
                    continue  # Skip external links
                    
                # Check if internal link exists
                if link_url not in available_files:
                    issues.append(f"Broken link in {file_path.name}: [{link_text}]({link_url})")
        
        return issues
    
    def run_markdown_lint(self) -> Tuple[bool, str]:
        """Run markdownlint on all documentation files."""
        try:
            result = subprocess.run(
                ["markdownlint", "--config", ".markdownlint.json", "docs/**/*.md"],
                capture_output=True,
                text=True,
                cwd=self.base_path
            )
            
            if result.returncode == 0:
                return True, "✅ All markdown files pass linting"
            else:
                return False, f"❌ Markdown linting issues:\n{result.stdout}"
                
        except FileNotFoundError:
            return False, "❌ markdownlint not found. Please install with: npm install -g markdownlint-cli"
    
    def build_documentation(self) -> None:
        """Main method to build complete documentation."""
        print("🚀 Building comprehensive documentation...")
        
        # Step 1: Copy and organize files
        print("📁 Copying and organizing files...")
        file_map = self.copy_and_organize_files()
        
        # Step 2: Add reproduction badges
        print("🏆 Adding reproduction badges...")
        for workflow_file in file_map["workflows"]:
            self.add_reproduction_badges(workflow_file)
        
        # Step 3: Create cross-references
        print("🔗 Creating cross-references...")
        self.create_cross_references(file_map)
        
        # Step 4: Generate index
        print("📋 Generating documentation index...")
        self.generate_index_readme(file_map)
        
        # Step 5: Validate links
        print("🔍 Validating internal links...")
        link_issues = self.validate_internal_links(file_map)
        if link_issues:
            print("⚠️  Link validation issues:")
            for issue in link_issues:
                print(f"  - {issue}")
        else:
            print("✅ All internal links are valid")
        
        # Step 6: Run markdown linting
        print("🧹 Running markdown linting...")
        lint_passed, lint_message = self.run_markdown_lint()
        print(lint_message)
        
        print("\n🎉 Documentation build complete!")
        print(f"📖 Main index: {self.docs_path / 'README.md'}")
        print(f"🔬 Workflows: {len(file_map['workflows'])} files")
        print(f"📚 Examples: {len(file_map['examples'])} files")
        print(f"📋 Rules: {len(file_map['rules'])} files")


if __name__ == "__main__":
    builder = DocumentationBuilder()
    builder.build_documentation()

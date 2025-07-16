# Introducing Vibe Coding in Ecology: AI-Assisted Workflows and Structured Thinking

**Authors:**  
Fabio Favoretto<sup>1</sup>, Alberto Rivera<sup>1</sup>, Eduardo León Solorzano<sup>2</sup>, Octavio Aburto<sup>1</sup>  

<sup>1</sup>Scripps Institution of Oceanography, University of California San Diego  
<sup>2</sup>Centro para la Biodiversidad Marina y la Conservación, A.C.  
<sup>\*</sup>Corresponding author: fabio@gocmarineprogram.org

---

## Abstract

Ecological research increasingly relies on coding for data analysis, modeling, and simulation. While programming languages like R and Python have empowered ecologists to develop flexible, reproducible workflows, traditional approaches to coding instruction conflate statistical reasoning with technical syntax, creating barriers to deep conceptual understanding and reproducibility. Here, we describe "vibe coding"—an AI-assisted approach that separates analytical design from code implementation, enabling ecologists to articulate their scientific logic in natural language and collaborate with large language models (LLMs) to generate, refine, and audit code. We outline a structured framework for AI-assisted workflows, discuss emerging tools, and provide recommendations for education and ethical practice. Vibe coding elevates the ecologist’s role from script-writer to workflow architect, fostering more transparent, robust, and reproducible ecological science.

---

## Why do Ecologists Code?

Ecologists increasingly rely on coding for data analysis, modeling, and simulations. Unlike traditional point-and-click statistical software, programming languages offer flexibility, allowing ecologists to customize analyses specifically for their unique and often complex ecological datasets. Coding also enhances reproducibility since every analytical step is explicitly preserved within scripts, facilitating transparency and trust in ecological studies. As a result, proficiency in coding has become fundamental to ecological training and research.
The R programming language, introduced in 1993 by statisticians Ross Ihaka and Robert Gentleman, was designed primarily for statistical analyses. Its rapid adoption within academia accelerated with the establishment of the Comprehensive R Archive Network (CRAN) in 1997, which grew from a few initial packages to over 21,000 today. This extensive ecosystem of analytical tools, including widely used packages like ggplot2 and the tidyverse, significantly lowered barriers to advanced data visualization and transformation for ecologists.
Similarly, Python, developed in the early 1990s as a general-purpose programming language, gained prominence in scientific computing through powerful libraries such as pandas, numpy, scipy, and matplotlib. These libraries offered robust tools for data manipulation, analysis, visualization, and expanded capabilities into machine learning and software development, complementing R’s statistical strengths. Both languages share a critical advantage for ecologists: their adaptability to messy, real-world ecological data without the constraints imposed by rigid software interfaces.
Since the early 2000s, the widespread adoption of R and Python has profoundly transformed ecological analysis. Ecologists gained the flexibility to directly script nonlinear models, spatial analyses, and simulations. Coding enabled researchers to create analytical tools tailored precisely to their study systems—such as specialized data cleaning routines or models designed for unique ecological distributions. This innovation contributed to reproducibility through openly shared scripts, aligning with the growing emphasis from journals and funding agencies on reproducible research. Guidelines like “A Guide to Reproducible Code in Ecology and Evolution” further cemented best practices in code management, version control, and documentation, making coding indispensable for modern ecological research.
Yet, despite these advantages, ecological coding culture remains fragile due to the way coding is typically taught. In contrast to fields like physics or engineering, which explicitly train students in systematic programming and computational theory, ecology often presents coding merely as a practical instrument for statistical analysis. Programming is frequently taught concurrently with statistical methods, causing students to conflate the theoretical understanding of statistics with technical coding skills. This conflation can result in significant confusion, often described as “code fear” or “statistics anxiety,” among students. Learners struggling with R’s cryptic error messages or syntax may mistakenly attribute these difficulties to their grasp of statistical concepts, and vice versa.
Moreover, traditional ecology education often fails to distinguish clearly between statistical theory and its computational implementation. Students typically learn statistical methods (e.g., linear regression) simultaneously with specific coding commands (e.g., lm(y ~ x, data=data)), which can obscure the conceptual basis underlying the statistical techniques. Beginners may either misinterpret coding errors as gaps in their ecological or statistical understanding or mechanically execute scripts without truly comprehending the assumptions or ecological implications of the analyses. Educators have noted that the cognitive load involved in managing code syntax and computational details often distracts students from higher-level ecological reasoning. Ideally, students would first articulate analytical objectives in plain language (e.g., “compare species richness between sites using a t-test after validating assumptions”) before translating them into executable code. However, in practice, coding often precedes careful analytical planning, limiting students' deeper conceptual engagement.
This approach to coding education contributes directly to the reproducibility crisis in ecology and other sciences. Although scripting analyses theoretically enhances reproducibility, poorly organized scripts—characterized by inconsistent filenames, inadequate documentation, and unclear workflows—frequently undermine this goal. Ecological coding projects commonly evolve as exploratory digital notebooks intended for trial-and-error experimentation rather than as structured computational solutions. Studies attempting to replicate published ecological research regularly encounter challenges such as undocumented code, missing dependencies, and opaque analytical procedures. Thus, despite the clear intent for reproducibility, the absence of structured workflow practices limits the realization of coding's potential benefits.
To address these challenges, ecological coding education must move beyond its instrumental and informal roots toward a more structured approach. Clearly separating statistical theory from computational practice, systematically training students in coding workflow management, and emphasizing thoughtful planning prior to scripting could significantly reduce confusion, anxiety, and reproducibility issues. By recognizing coding as an independent skillset requiring explicit training—alongside, but distinct from, statistical reasoning—ecology can fully harness the potential of coding to foster robust, transparent, and reproducible scientific practice.


## From Coder to Architect: Introducing Vibe Coding in Ecology

The emergence of large language models (LLMs) like ChatGPT, Claude, and GitHub's Copilot offers ecologists a transformative approach to coding, termed "vibe coding." Traditionally, ecological coding has involved manually writing and debugging scripts—often conflating statistical reasoning with technical coding skills. With vibe coding, ecologists articulate analytical goals clearly in plain English, prompting the AI to generate initial scripts. For example, an ecologist might instruct: "I have species count data from two habitats and want to test if habitat A has higher species richness than habitat B, checking normality first and using a non-parametric test if needed." The AI then produces code performing these exact steps. By handling routine coding tasks, vibe coding frees ecologists to concentrate on experimental design, model assumptions, and ecological interpretation, preserving cognitive resources for higher-order scientific reasoning.
Importantly, this shift does not diminish the necessity of coding proficiency. Instead, it emphasizes clear analytical planning, logical decomposition of problems, and rigorous validation of AI-generated solutions. Ecologists' roles evolve from traditional coders to "architects," capable of defining and supervising analytical workflows rather than solely focusing on manual script writing.

### The Four Pillars of Vibe Coding

- Narrative-Driven Structure: The code is structured like a story. Each script and section has a clear purpose that contributes to the overall analytical narrative. Use comments to explain the why, not just the what.
- Sanctuary of Scripts: The project directory is clean and predictable. Raw data is sacred and never modified directly. Scripts are numbered sequentially to show the flow of work. Outputs are tidy and systematically named.
- Clarity is King: Use descriptive variable names (e.g., species_richness_model instead of m1). Use pipes (|>) and tools like the tidyverse to make data manipulation readable as a series of steps. The code should feel intuitive and easy to follow for someone new to the project.
- Reproducibility by Design: The entire analysis must be runnable from start to finish with a single command or by running scripts in order. All package dependencies and session information must be documented, ensuring anyone can replicate the environment and results.

In the vibe coding framework, ecologists adopt three primary roles:
- Architect: Conceptualizes and structures the analytical pipeline before any code is written. This includes explicitly defining data inputs, analytical methods (e.g., statistical tests, data cleaning procedures), and desired outputs (visualizations, statistical summaries). This systematic, structured approach parallels practices found in systems engineering.
- Reviewer: Critically assesses AI-generated scripts, prioritizing scientific integrity and logical correctness rather than minor syntax debugging. Reviewers ensure scripts correctly implement the intended ecological and statistical concepts.
- Supervisor: Iteratively guides AI-generated outputs through clear, natural-language instructions rather than manual code adjustments. Supervisors provide specific feedback, such as "Refit the model using a negative binomial distribution due to observed overdispersion," ensuring analytical rigor and accuracy.


Vibe coding addresses critical limitations inherent to current ecological programming education, which often conflates statistical understanding with coding mechanics, creating unnecessary cognitive burden and fostering confusion or anxiety among students. By separating conceptual thinking from syntactical details, vibe coding significantly lowers entry barriers to programming, broadening the accessibility of computational methods. As a result, while the number of purely technical coding jobs may diminish, the overall number of people effectively engaging with programming and computational analysis will likely increase, reinforcing the need for structured planning and critical thinking.
Moreover, vibe coding inherently promotes reproducibility by encouraging structured and explicitly planned workflows. By clearly articulating analytical goals upfront, researchers ensure reproducibility and transparency, essential in addressing ongoing reproducibility challenges in ecology. Shared workflows become crucial, as AI tools benefit greatly from standardized, well-documented procedures, potentially customizable within AI-enhanced Integrated Development Environments (IDEs).

### A Cultural Shift Toward Systems Thinking

Vibe coding embodies a fundamental cultural shift toward systems thinking in ecological research. This perspective views analyses as interconnected pipelines rather than isolated tasks, recognizing that decisions at each step (e.g., handling missing data or choosing analytical models) influence subsequent stages of research.
The "Iceberg Model" from systems thinking effectively illustrates this:
Event Level (Reactive): Fixing immediate code errors without addressing root causes.
Pattern Level (Observational): Recognizing recurring issues, such as repetitive errors in data handling.
Structure Level (Design): Establishing robust workflow structures to prevent recurring issues.
Mental Model Level (Cultural Shift): Valuing structured workflow design as integral to scientific quality, not merely as a technical detail.
Vibe coding inherently operates at structural and mental model levels, incentivizing ecologists to invest in upfront planning and systematic design, ultimately improving analytical rigor and reproducibility.
Emerging AI Tools to Support Vibe Coding
The transition to vibe coding is supported by emerging AI-native development tools, exemplified by two distinct IDEs: Cursor AI and Windsurf AI.
Cursor AI (Augmentation): Built upon the familiar VS Code environment, Cursor acts as an intelligent assistant enhancing code refinement, debugging, and inline editing. Key features include inline generation, codebase context-awareness, conversational debugging, and agentic testing—ideal for refining well-defined analytical steps into robust, reproducible code.
Windsurf AI (Architecture): Emphasizing comprehensive workflow planning and architectural design, Windsurf's key features include structured prompting, cascade task generation, reusable workflows, and a persistent planning mode. Windsurf excels in decomposing complex hypotheses into structured analytical plans, standardizing project organization, and systematically documenting scientific intent before detailed coding begins.
Together, these tools provide the technological infrastructure necessary for ecologists to effectively transition from manual coding to strategic workflow design, selecting the appropriate tool for each cognitive task.
Educational and Ethical Considerations
Effective implementation of vibe coding requires thoughtful pedagogical strategies. Students and researchers must critically assess AI-generated code rather than accept outputs uncritically. Educators, following recommendations by Cooper et al. (2024), should teach students effective prompting strategies and critical evaluation skills, reinforcing analytical clarity and rigor. This practice aligns with best practices in pseudocode writing and systematic commenting, promoting conceptual understanding over rote coding.
Furthermore, ethical considerations—including potential AI misuse, over-reliance, and the risks of AI-generated inaccuracies ("hallucinations")—necessitate training ecologists in critical, reflective engagement with AI tools.
Vibe coding represents a paradigm shift, transforming ecological coding from manual scriptwriting toward strategic, structured planning and critical evaluation of AI-assisted workflows. This shift does not simplify ecological programming by reducing required skills; rather, it refines and expands the ecologist’s role into that of an architect, supervisor, and reviewer, ultimately enhancing analytical quality, reproducibility, and scientific transparency.







## Emerging AI Tools

AI-native IDEs such as **Cursor AI** and **Windsurf AI** support different stages of workflow development:

| Feature                | Cursor AI                        | Windsurf AI               | Implication for Ecologists                                    |
|------------------------|----------------------------------|---------------------------|---------------------------------------------------------------|
| Core Philosophy        | Code Augmentation                | Workflow Architecture     | Separates implementation from design                          |
| Primary Use Case       | Refining code blocks/functions   | Project and pipeline design | Use Windsurf for planning; Cursor for coding/refinement       |
| Prompting Style        | Conversational, context-aware    | Structured, multi-layered | Prompts become formal research plans                          |
| Reproducibility        | Ensures code/library correctness | Standardizes workflows    | Automates creation of correct, repeatable pipelines           |
| Ideal Research Stage   | Analysis & Refinement            | Hypothesis & Design       | Dedicated tools for each stage of research                    |

## Practical Applications

- **Exploratory Analysis**: AI helps articulate and structure hypotheses, suggesting pipelines and outlining analytical steps.
- **Prompt Logging & Decision Auditing**: Interactive prompt logs document decisions, aiding collaboration and reproducibility.
- **Real-Time Co-Development**: AI automates routine coding and testing, allowing researchers to focus on ecological reasoning.
- **From Exploration to Pipelines**: Messy exploratory scripts are rapidly refactored into clean, documented modules.

## Educational Implications

The rise of AI-assisted coding shifts the educational focus from low-level syntax to high-level conceptual and algorithmic thinking:

- **Problem Decomposition**: Students practice articulating analysis plans in natural language before coding.
- **Separation of Concerns**: Assignments distinguish between statistical reasoning and coding mechanics.
- **Inclusion and Accessibility**: LLMs lower barriers for students who struggle with coding or for whom English is a second language.
- **Prompting and Critical Thinking**: Teaching effective AI communication and critical evaluation of outputs.
- **Ethics and Best Practices**: Clear guidelines for AI use, attribution, and responsibility for scientific integrity.
- **Fundamental Skills**: Curricula maintain foundational coding instruction to ensure students can interpret, verify, and refine AI-generated code.

## Ethical Considerations and Limitations

| Ethical Issue              | Specific Risk                                                         | Mitigation Strategy                                               |
|---------------------------|----------------------------------------------------------------------|------------------------------------------------------------------|
| Algorithmic Bias           | Skewed models due to biased data                                     | Rigorous data review and sensitivity analysis                     |
| Intellectual Property      | Infringement or lack of copyright                                    | Document, verify licenses, seek legal guidance                    |
| Data Privacy               | Sensitive data exposure via third-party AIs                          | Use secure/local AIs, anonymize data, review privacy policies     |
| Reproducibility            | Stochastic AI outputs hinder replication                             | Save code versions, maintain prompt logs, disclose AI involvement |
| Quality Control            | Hidden errors or inefficiencies                                      | Rigorous human review and unit testing                            |
| Over-reliance              | Skill erosion                                                        | Maintain manual coding practice                                   |
| Hallucinations             | Incorrect methods or references                                      | Cross-check outputs, request explanations, remain skeptical       |
| Security Risks             | Data leakage via AI systems                                          | Use secure or local services, anonymize sensitive data            |

## Summary

Vibe coding transforms ecological research and education by foregrounding statistical reasoning, logical planning, and critical evaluation, while treating coding syntax as a tool—sometimes wielded manually, sometimes delegated to AI. When coupled with rigorous ethical practice and foundational coding skills, this paradigm fosters a new generation of ecologists skilled as both architects and reviewers of robust, transparent, and reproducible scientific workflows.

## Conclusion

The integration of large language models into ecological research marks a transformative moment. By adopting vibe coding, the community can move beyond the "accidental programmer" model and cultivate ecologists who design, supervise, and validate robust analytical workflows. This shift empowers researchers to focus on scientific logic and reproducibility, programming in the true language of science—critical thinking and hypothesis-driven inquiry. Realizing this vision requires proactive engagement: educators must pioneer new curricula, researchers must uphold rigorous standards, and the community must guide the ethical development and deployment of AI tools. Embracing this opportunity will strengthen ecological science for the challenges ahead.

---

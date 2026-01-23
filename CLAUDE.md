# CLAUDE.md - AI Assistant Guide for This Repository

## Repository Overview

**Project Name**: AI for Teachers, Researchers and Students
**Author**: Zahid Asghar, School of Economics, QAU, Islamabad
**Type**: Quarto-based Educational Website
**Live Site**: https://zahedasghar.github.io/ai
**Repository**: https://github.com/Zahedasghar/ai
**License**: CC BY-SA 4.0

### Purpose
This repository contains comprehensive educational materials focused on AI applications for teaching, research, economic policy analysis, and public sector professionals. It includes workshop materials, prompt engineering guides, AI tools documentation, and practical examples for integrating AI into academic and professional workflows.

---

## Technology Stack

### Core Technologies
- **Quarto**: Static site generator for scientific and technical publishing
- **R Markdown**: Code execution and dynamic content generation
- **GitHub Pages**: Hosting platform (via gh-pages branch)
- **GitHub Actions**: CI/CD for automated publishing

### File Formats
- `.qmd` - Quarto markdown files (primary content format)
- `.yml` - Configuration files
- `.scss/.css` - Custom styling
- `.csv` - Data files for examples
- `.webp/.png/.gif/.jpg` - Images and media
- `.typ` - Typst template files
- `.pdf/.pptx` - Presentation materials

---

## Repository Structure

```
/
├── .github/workflows/     # GitHub Actions workflows
│   └── publish.yml        # Auto-publishes to gh-pages on push to main
├── data/                  # Sample datasets for workshops
│   ├── diabetes.csv
│   ├── insurance.csv
│   ├── ds_salaries.csv
│   └── south_asian_countries_data.csv
├── images/                # Media assets (logos, screenshots, diagrams)
│   └── zahid/            # Author photos
├── slides/                # Presentation versions of content
├── _freeze/               # Cached Quarto outputs (auto-generated)
├── _quarto.yml           # Main Quarto configuration
├── *.qmd                 # 29+ Quarto markdown content files
├── custom*.scss          # Custom styling
└── README.md             # Repository documentation
```

### Key Configuration Files

- `_quarto.yml` - Central configuration for:
  - Website structure and navigation
  - Sidebar organization
  - Theme settings
  - Output formats (HTML, RevealJS)
  - Rendering options

- `.gitignore` - Excludes:
  - R project files (.Rproj.user, .Rhistory)
  - Build outputs (_site/, docs/, *.html, *.pdf)
  - Cache directories (_freeze/, *_files/)

---

## Content Organization

### Main Content Sections

#### 1. Getting Started
- `index.qmd` - Homepage and introduction
- `materials.qmd` - Course materials and resources

#### 2. Workshops
- `AI_workshop_pips.qmd` - PND UNICEF Workshop
- `AI_Seminar_Activity_Handout.qmd` - Group activities

#### 3. Teaching with AI
- `ai for teaching, research and publishing.qmd` - Overview
- `ai_intro.qmd` - Introduction to Generative AI
- `socratic_method.qmd` - Using AI for Socratic teaching
- `The Future of Thinking How AI redefines intelligence.qmd`

#### 4. AI & Economics
- `AI Agents in Economics.qmd` - AI agents in economic analysis
- `economic_policy_prompts_carousel.qmd` - Policy-focused prompts

#### 5. Prompt Engineering
- `prompts.qmd` - **Comprehensive prompt engineering guide**
- `ai_prompts_pnd.qmd` - XML-based prompting techniques
- `econometric_prompts_sol.qmd` - Economics-specific prompts
- `prompt_one_percent.qmd` - Incremental improvement techniques

#### 6. AI Tools & Platforms
- `gpt5_power_users.qmd` - Advanced ChatGPT usage
- `ai_nlp.qmd` - Natural language processing tools

#### 7. Research & Publishing
- `ai_pub.qmd` - AI in academic publishing
- `literature.qmd` - Literature review automation

---

## Development Workflows

### Adding New Content

1. **Create a new .qmd file** in the root directory
2. **Add YAML frontmatter**:
   ```yaml
   ---
   title: "Your Title"
   author: "Zahid Asghar"
   date: "`r Sys.Date()`"
   format:
     html:
       toc: true
       toc-depth: 3
       code-fold: true
   ---
   ```
3. **Update `_quarto.yml`** to add the new page to navigation
4. **Test locally** with `quarto preview`
5. **Commit and push** to main branch (auto-deploys via GitHub Actions)

### Modifying Existing Content

1. **Locate the .qmd file** corresponding to the page
2. **Edit using Quarto markdown syntax**:
   - Standard markdown headings, lists, links
   - Code blocks with execution: ` ```{r}` or ` ```{python}`
   - Cross-references: `[Link text](file.qmd)`
3. **Preview changes**: Run `quarto preview` locally
4. **Commit changes** with descriptive messages

### Working with Images

- **Location**: Store images in `images/` directory
- **Reference in .qmd files**:
  ```markdown
  ![Alt text](images/filename.webp)
  ```
- **Preferred formats**: .webp (for web optimization), .png, .jpg
- **Naming convention**: Use lowercase, descriptive names with hyphens

### Working with Data

- **Location**: Store datasets in `data/` directory
- **Formats**: CSV files for tabular data
- **Usage in .qmd**:
  ```r
  data <- read.csv("data/filename.csv")
  ```

---

## Deployment Pipeline

### Automatic Deployment
- **Trigger**: Push to `main` branch
- **Workflow**: `.github/workflows/publish.yml`
- **Process**:
  1. Checks out repository
  2. Sets up Quarto
  3. Renders all .qmd files
  4. Publishes to `gh-pages` branch
  5. GitHub Pages serves the site

### Manual Deployment
- Can be triggered via GitHub Actions "workflow_dispatch"
- Navigate to Actions tab → Quarto Publish → Run workflow

---

## Key Conventions for AI Assistants

### Content Guidelines

1. **Maintain Educational Tone**: Content is for academic and professional audiences
2. **Focus on Practical Applications**: Emphasize hands-on, actionable advice
3. **Include Examples**: Use concrete examples from economics, policy, and education
4. **Pakistani Context**: Many examples use Pakistani economic/policy context
5. **Accessibility**: Write for diverse skill levels (beginners to advanced)

### Code Conventions

1. **Language Choice**:
   - Primarily R for statistical examples
   - Python for NLP/ML examples
   - Mix as appropriate for the content

2. **Code Blocks**:
   - Always specify language: ` ```{r}` or ` ```{python}`
   - Use `#| echo: true` for showing code
   - Use `#| eval: false` for non-executable examples

3. **Data References**:
   - Use relative paths: `data/filename.csv`
   - Document data sources and context

### Formatting Standards

1. **Headings**: Use hierarchical structure (H1 → H2 → H3)
2. **Lists**: Use numbered lists for sequences, bullets for collections
3. **Emphasis**:
   - **Bold** for key terms
   - *Italics* for emphasis
   - `Code formatting` for technical terms

4. **Links**: Always use descriptive link text, not "click here"

### Quarto-Specific

1. **YAML Frontmatter**: Always include title, author, format
2. **Table of Contents**: Enable with `toc: true` for content pages
3. **Code Folding**: Use `code-fold: true` to keep pages clean
4. **Caching**: Leverage `freeze: auto` for expensive computations

---

## Common Tasks

### Task 1: Add a New Workshop Module

```bash
# 1. Create new .qmd file
touch ai_workshop_new_topic.qmd

# 2. Add frontmatter and content
# 3. Update _quarto.yml under "Workshops" section
# 4. Preview locally
quarto preview

# 5. Commit and push
git add ai_workshop_new_topic.qmd _quarto.yml
git commit -m "Add new workshop module on [topic]"
git push origin main
```

### Task 2: Update an Existing Prompt Guide

```bash
# 1. Locate file (e.g., prompts.qmd)
# 2. Edit content following existing structure
# 3. Test any code examples
# 4. Preview changes
quarto preview prompts.qmd

# 5. Commit changes
git add prompts.qmd
git commit -m "Update prompt engineering guide with [change]"
git push origin main
```

### Task 3: Add New Sample Data

```bash
# 1. Place CSV in data/ directory
cp ~/Downloads/new_data.csv data/

# 2. Create or update .qmd file to use the data
# 3. Document the data source in the content
# 4. Commit both files
git add data/new_data.csv relevant_file.qmd
git commit -m "Add new dataset for [purpose]"
git push origin main
```

### Task 4: Modify Site Navigation

```bash
# 1. Edit _quarto.yml
# 2. Update sidebar → contents section
# 3. Follow existing structure with sections and contents
# 4. Preview entire site
quarto preview

# 5. Commit changes
git add _quarto.yml
git commit -m "Update site navigation: [description]"
git push origin main
```

---

## Content Themes and Patterns

### Prompt Engineering Content

This repository has extensive prompt engineering materials. When working on prompt-related content:

1. **Follow established frameworks**:
   - T.C.R.E.I. (Task, Context, Reference, Evaluate, Iterate)
   - Master Prompt Templates
   - CATS, DOGS, SMART frameworks

2. **Include practical examples**:
   - Policy analysis prompts
   - Economic research prompts
   - Teaching and education prompts
   - Office productivity prompts

3. **Provide copy-paste ready prompts**:
   - Use code blocks for easy copying
   - Include customization instructions
   - Add placeholders in **bold** or [brackets]

### Workshop Materials

Workshop content follows this pattern:
1. Learning objectives
2. Agenda/outline
3. Hands-on exercises
4. Group activities
5. Real-world case studies

### Economic Policy Content

Policy-focused materials typically include:
1. Context (Pakistani or regional focus)
2. Analytical framework
3. Data-driven insights
4. Policy recommendations
5. Ethical considerations

---

## Quality Standards

### Before Committing

- [ ] All .qmd files render without errors
- [ ] Links are valid (internal and external)
- [ ] Images load correctly
- [ ] Code examples execute (or are marked `eval: false`)
- [ ] YAML frontmatter is complete
- [ ] Navigation is updated if adding new pages
- [ ] Content follows accessibility guidelines

### Writing Quality

- [ ] Clear, concise language
- [ ] Proper grammar and spelling
- [ ] Consistent terminology
- [ ] Appropriate academic tone
- [ ] Examples are relevant and tested
- [ ] Citations are properly formatted

---

## Troubleshooting

### Common Issues

**Issue**: Quarto render fails
**Solution**: Check YAML syntax, ensure all referenced files exist, verify code block syntax

**Issue**: Images not displaying
**Solution**: Verify file path is correct, check image file exists, ensure proper markdown syntax

**Issue**: Navigation not updating
**Solution**: Verify _quarto.yml syntax, ensure file paths match exactly, rebuild entire site

**Issue**: Code blocks not executing
**Solution**: Check language specification, verify required packages are available, check for syntax errors

### Getting Help

1. **Quarto Documentation**: https://quarto.org/docs/guide/
2. **Repository Issues**: https://github.com/Zahedasghar/ai/issues
3. **Discord Community**: Link in website footer

---

## File-Specific Notes

### Critical Files (Do Not Delete)

- `_quarto.yml` - Site configuration
- `index.qmd` - Homepage
- `.github/workflows/publish.yml` - Deployment automation
- `.nojekyll` - Prevents Jekyll processing on GitHub Pages
- `robots.txt` - Search engine instructions

### Auto-Generated Files (Do Not Edit)

- `_freeze/` directory - Cached computational outputs
- `*_files/` directories - Generated by Quarto rendering
- `search.json` - Generated search index
- `sitemap.xml` - Auto-generated sitemap

### Template Files

- `custom.scss`, `custom.css` - Global styling (edit with caution)
- `typst-template.typ` - PDF export template

---

## Git Workflow

### Branch Strategy
- `main` - Production branch (auto-deploys)
- `gh-pages` - Auto-generated by GitHub Actions (do not edit directly)
- Feature branches - Use for major changes, then merge to main

### Commit Message Style
```
<type>: <short description>

<optional longer description>

Examples:
- feat: Add new workshop on AI ethics
- fix: Correct broken links in prompts.qmd
- docs: Update README with installation instructions
- style: Improve CSS for mobile responsiveness
- refactor: Reorganize economics section
```

### Pull Request Guidelines
1. Create descriptive PR title
2. List changes in bullet points
3. Reference any related issues
4. Ensure CI passes before merging
5. Delete branch after merge

---

## Contact and Contribution

**Repository Owner**: Zahid Asghar
**Email**: zasghar@qua.edu.pk
**GitHub**: https://github.com/Zahedasghar

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request with clear description
5. Respond to review feedback

---

## Additional Resources

### Learning Quarto
- Official Guide: https://quarto.org/docs/guide/
- Quarto for Academics: https://quarto.org/docs/manuscripts/
- RevealJS Presentations: https://quarto.org/docs/presentations/revealjs/

### AI and Education
- See `literature.qmd` for curated academic references
- Check `materials.qmd` for course resources

### Prompt Engineering
- `prompts.qmd` - Main reference guide (35,000+ characters)
- `ai_prompts_pnd.qmd` - Advanced XML techniques
- `prompt_one_percent.qmd` - Iterative improvement methods

---

## Version History

**Last Updated**: 2025-01-23
**Repository Status**: Active Development
**Primary Focus**: Educational content on AI for teaching, research, and policy

---

## Notes for AI Assistants

When working with this repository:

1. **Respect the educational context** - Content should maintain academic rigor while being accessible
2. **Preserve existing patterns** - Follow the established structure in similar files
3. **Test thoroughly** - Always preview Quarto output before committing
4. **Document changes** - Update this file if you discover new patterns or conventions
5. **Maintain consistency** - Use existing naming conventions, formatting styles, and organizational patterns
6. **Consider the audience** - Content serves teachers, researchers, students, and policy professionals
7. **Honor the license** - All content is CC BY-SA 4.0, maintain attribution
8. **Preserve Pakistani context** - Many examples use Pakistani economic/policy scenarios; maintain cultural relevance

### When to Update This File

- New content categories are added
- New workflows or tools are introduced
- Significant structural changes occur
- New quality standards are established
- Common issues and solutions are identified

---

*This CLAUDE.md file serves as the comprehensive guide for AI assistants working with this repository. Keep it updated as the project evolves.*

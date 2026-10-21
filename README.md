# A Bayesian decision-theoretic framework for evaluating joint nitrogen and irrigation management in maize

## Overview

This repository contains the code and supplementary materials associated with the research paper **"A Bayesian decision-theoretic framework for evaluating joint nitrogen and irrigation management in maize."**

**DOI:** [To be added upon publication]

The primary purpose of this repository is to support the reproducibility of the methodological framework proposed in the paper. It provides the R and Stan code used to implement the Bayesian model, perform statistical analyses, and generate the figures presented in the study.

The repository also includes a technical appendix describing the analytical workflow, model implementation, and diagnostic procedures.

## Repository Contents

The repository contains the following files:

| File | Description |
|---|---|
| `technical_appendix.pdf` | Step-by-step documentation of the analytical workflow, including model implementation, statistical procedures, and Bayesian model diagnostics. |
| `simu_data.csv` | Simulated dataset generated from the fitted Bayesian model, provided for reproducibility purposes. |
| `graphics_paper.rmd` | R Markdown file containing the code used to reproduce the main figures and graphical analyses presented in the paper. |
| `paper_bayes.stan` | Stan code defining the Bayesian model, including prior specifications and the implementation of canonical analysis. |

## Reproducibility and Workflow

The recommended starting point is `technical_appendix.pdf`, which provides detailed guidance on the methodological steps required to reproduce the analytical framework.

The appendix describes the statistical procedures, model implementation, and diagnostic analyses used to evaluate the fitted Bayesian model.

The workflow is implemented primarily in **R and Stan**, allowing researchers to examine the computational procedures and adapt the framework to other agricultural management problems.

### Data Availability

The original experimental dataset used in the paper cannot be publicly shared due to data confidentiality restrictions.

To facilitate reproducibility, this repository provides `simu_data.csv`, a simulated dataset generated using the fitted Bayesian model.

This dataset allows users to explore and demonstrate the analytical workflow without accessing the original experimental observations.

**Important:** Results obtained from the simulated dataset may differ from those reported in the published paper. The simulated data are intended to demonstrate the methodology and computational implementation rather than reproduce the exact empirical findings.

### Figures and Graphical Analyses

The file `graphics_paper.rmd` contains the main R code used to generate the figures and graphical analyses presented in the paper.

Researchers can use this file to examine the visualization procedures and reproduce the graphical workflow using the provided simulated dataset.

Because the publicly available dataset is simulated, the resulting figures may differ from those in the publication.

### Bayesian Model Implementation

The file `paper_bayes.stan` contains the Stan implementation of the Bayesian model developed in the study.

The code allows researchers to examine:

- The model structure and parameter specifications.
- The prior distributions assigned to model parameters.
- The Bayesian estimation procedure.
- The implementation of canonical analysis within the Stan framework.

Stan provides a flexible computational environment for Bayesian inference, facilitating posterior estimation and the assessment of parameter uncertainty.


## Author and Contact

Arthur Hintz
Repository author and maintainer  
Email: [arthurhintz@ksu.edu](mailto:arthurhintz@ksu.edu)

Questions, suggestions, and feedback regarding the code, methodology, or reproducibility of the framework are welcome.


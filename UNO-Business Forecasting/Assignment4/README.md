# Bayesian A/B Testing on Cookie Cats Retention

This project performs a **Bayesian A/B test** using **PyMC** to analyze the effect of moving a game level gate from **level 30 to level 40** on **1-day and 7-day retention rates**.

## Features
- Loads the **Cookie Cats dataset** from a GitHub repository.
- Implements **Bayesian inference** using **Beta distributions** for retention probabilities.
- Computes the **posterior distributions** for the retention rates of two experimental groups (`gate_30` and `gate_40`).
- Estimates **delta ($\delta$)**, the difference between retention rates.
- Visualizes the **posterior distributions** of retention rates and $\delta$.
- Calculates the probability that $\delta > 0$ to determine if the change increased retention.

## Dataset
The dataset contains:
- `version`: Experiment group (`gate_30` = control, `gate_40` = treatment).
- `retention_1`: Binary indicator of whether a user was retained after 1 day.
- `retention_7`: Binary indicator of whether a user was retained after 7 days.

## Installation
To run this analysis, install the required Python libraries:

```bash
pip install pandas numpy pymc matplotlib

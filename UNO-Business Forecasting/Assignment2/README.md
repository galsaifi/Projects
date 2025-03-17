# Meal Prediction using Decision Tree Classifier

This project builds a **Decision Tree Classifier** to predict meal choices based on various features in the dataset.

## Features
- Loads training and test data from a remote GitHub repository.
- Preprocesses data by removing unnecessary columns (`id`, `DateTime`).
- Splits data into training and test sets (60%-40% split).
- Trains a **Decision Tree Classifier** with `min_samples_leaf=2`.
- Evaluates model performance using **in-sample and out-of-sample accuracy**.

## Dataset
The dataset consists of meal choices with the following columns:
- `meal`: Target variable representing the type of meal.
- `id`: Unique identifier for each record (removed for training).
- `DateTime`: Timestamp of the meal record (removed for training).
- Other feature columns related to meal preferences.

## Installation
To run this analysis, install the required Python libraries:

```bash
pip install pandas numpy scikit-learn

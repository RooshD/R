# R repository
Compilation of my R projects

## Project 1: Predictive modeling for Diabetes
This project contains the R code and visualization outputs for a project focused on predicting diabetes using statistical machine learning techniques. 
### Project Overview
- **Objective**: Predict the occurrence of diabetes based on various health indicators.
- **Methods Used**:
  - Data ingestion, cleaning, and preprocessing
  - Exploratory data analysis
  - Building and evaluating a Decision Tree model
  - Building and evluating a Random Forest model
- **Attached files**:
  - 'Healthcare-Diabetes.csv': Contains the original dataset obtained from Kaggle
  - 'Diabetes Indicator Predictive Model.R': Contains the code for data processing, visualizations, and machine learning models
- **Visualizations**:
  <figure>
  <img src="CorrMatrix.png" alt="Correlation Matrix">
  <figcaption>This is a table showing the correlation coefficients between variables in the dataset.</figcaption>
  </figure>

  <figure>
  <img src="PieChart.png" alt="Pie chart of Diabetes vs. No diabetes">
  <figcaption>This is a pie chart showing the distribution of patients that have diabetes vs. no diabetes.</figcaption>
  </figure>

  <figure>
  <img src="Age vs. Glucose scatter.png" alt="Scatterplot of Age vs. Glucose Level">
  <figcaption>This is a scatterplot showing the distribution of patients' age vs. glucose level.</figcaption>
  </figure>
  
- **Conclusion**:
  I used 70% of the initial dataset to train the ML models and 30% of the dataset to test them. This resulted in the Decision Tree model being able to predict the target variable (Outcome) with 83.98% accuracy overall and the Random Forest model being able to predict the target variable with 98.80% accuracy overall. The Random Forest model I implemented for predicting diabetes has demonstrated excellent performance, proven to be both reliable and accurate. The model correctly identified whether individuals had diabetes with an impressive accuracy rate of 98.8%. This high level of accuracy means that the model makes very few mistakes, which is critical for medical predictions.

  Here's a breakdown of its key strengths:
  - The model correctly identified the majority of diabetic cases (99.45% accuracy), showing its strong ability to detect those who need further medical examination and potential treatment.
  - It was also highly effective at confirming when individuals do not have diabetes, with a success rate of 97.53%. This is important for avoiding unnecessary medical procedures or anxiety for those who are healthy.
  - Overall, the model's predictions were reliable 98.5% of the time, regardless of whether the individuals had diabetes or not, showcasing balanced performance across different scenarios.

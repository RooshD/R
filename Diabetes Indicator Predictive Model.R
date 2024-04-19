#install.packages("corrplot")
# Column definitions
# Id: Unique identifier for each data entry.
# Pregnancies: Number of times pregnant.
# Glucose: Plasma glucose concentration over 2 hours in an oral glucose tolerance test.
# BloodPressure: Diastolic blood pressure (mm Hg).
# SkinThickness: Triceps skinfold thickness (mm).
# Insulin: 2-Hour serum insulin (mu U/ml).
# BMI: Body mass index (weight in kg / height in m^2).
# DiabetesPedigreeFunction: Diabetes pedigree function, a genetic score of diabetes.
# Age: Age in years.
# Outcome: Binary classification indicating the presence (1) or absence (0) of diabetes.

library(tidyverse)
library(ggplot2)
library(corrplot)

diabetes <- read_csv("/Users/rushi/Documents/Portfolio/Healthcare-Diabetes.csv")
dim(diabetes) #dimensions of dataset
str(diabetes) #get structure and data types
head(diabetes, 10) #view top 10 rows of dataset

#check for any null values
if (sum(is.na(diabetes)) > 0){
  diabetes_cleaned <- na.omit(diabetes)
  message("NA values detected and removed.")
} else {
  diabetes_cleaned <- diabetes
  print("No NA values found. No data removed.")
}

#check for duplicate rows
num_duplicates <- sum(duplicated(diabetes_cleaned))
if (num_duplicates > 0){
  diabetes_cleaned <- diabetes_cleaned[!duplicated(diabetes_cleaned),] #keep rows that are not duplicates
  message(paste("Removed", num_duplicates, "duplicate rows."))
} else {
  print("No duplicate rows found.")
}

diabetes_cleaned <- diabetes_cleaned %>%
  select(-Id) #drop Id as it is not a predictive variable in this case

#Correlation matrix
corr_matrix <- cor(diabetes_cleaned)
corrplot(corr_matrix,method="color", addCoef.col = "black", tl.col = "black") 
#addCoef.col sets color of text inside each rectangle
#tl.col sets text label color for variables

#Count vs. Type of Outcome
ggplot(diabetes_cleaned, aes(x=as.factor(Outcome))) + #factor maintains information about the levels of the categorical variable
  geom_bar(fill="black") +
  labs(x="Outcome", y="Count", title="Count vs. Type of Outcome") +
  theme_minimal() +
  theme(plot.title = element_text(hjust=0.5)) 

#Pie chart of type of outcome
outcome_count <- count(diabetes_cleaned, Outcome)
outcome_count <- outcome_count %>%
  mutate(Percentage = (n/sum(n))*100)
outcome_count$Outcome2 <- ifelse(outcome_count$Outcome == 0, "No diabetes", "Diabetes")
labels_Percentage <- paste(outcome_count$Outcome2, "-", round(outcome_count$Percentage, 2), "%")
pie(outcome_count$n, labels = labels_Percentage, col = c("green", "red"))

#Age vs. Glucose scatterplot
ggplot(diabetes_cleaned, aes(x=Age,y=Glucose)) +
  geom_jitter(aes(color = as.factor(Outcome)), alpha=0.5, width=0.1, height=0) + #color determined by Outcome variable
  labs(x="Age",y="Glucose Level") 
  
#Since we want to predict diabetes (binary outcome variable), this is a classification problem. Implement decision tree. 
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("caret")
#install.packages("vctrs")
#install.packages("randomForest")
library(rpart)
library(rpart.plot)
library(caret)
library(randomForest)

diabetes_cleaned_predict <- diabetes_cleaned
set.seed(456) #set arbitrary seed
train_index <- createDataPartition(diabetes_cleaned_predict$Outcome, p=0.70, list = FALSE) #split the dataset for 70% training and 30% testing
trainSet <- diabetes_cleaned_predict[train_index, ] #data[rows,columns]; include all columns from these rows
testSet <- diabetes_cleaned_predict[-train_index, ]
trainSet$Outcome <- as.factor(trainSet$Outcome) #convert outcome to factor
testSet$Outcome <- as.factor(testSet$Outcome)

#Train the Decision Tree model
decision_tree_model <- rpart(Outcome ~ ., data = trainSet, method = "class") #Outcome is dependent variable, all other columns are predictors
rpart.plot(decision_tree_model) #Plot decision tree

predictions_test <- predict(decision_tree_model, testSet, type="class") #Make predictions on test set
dt_confusion_matrix <- confusionMatrix(as.factor(predictions_test), testSet$Outcome) #confusion matrix is used to describe the performance of the classification model

#Train Random Forest model
random_forest_model <- randomForest(Outcome ~ ., data = trainSet, ntree=500, mtry=floor(sqrt(ncol(trainSet)))) #ncol(trainset)=9; so 3 variables randomly sampled at each split
rf_predictions <- predict(random_forest_model, testSet)
rf_confusion_matrix <- confusionMatrix(as.factor(rf_predictions), testSet$Outcome)

#Summary
#str(rf_confusion_matrix)
accuracy_decision_tree <- dt_confusion_matrix$overall['Accuracy']
accuracy_rf <- rf_confusion_matrix$overall['Accuracy']
sprintf("Decision Tree Accuracy: %.2f%% ", accuracy_decision_tree*100)
sprintf("Random Forest Accuracy: %.2f%%", accuracy_rf*100)


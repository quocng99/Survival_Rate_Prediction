# Heart_failure_prediction
# Introduction

Logistic regression analysis is a commonly used model when the response variable is a binary dependent variables. When there are more than two classes, we would prefer the multinomial logistic regression. Logistic regression not only can predict the possibility of one observation based on predictors, but it is also helpful in measuring the relationship between the dependent variable and other independent variables.

In this project, I will utilize the logistic regression model not only to identify the relationship between medical predictors and heart failure but also  to predict the survival of a patient based on these healthcare variables. 

# Dataset

Dataset used in this project contains the health records of 299 heart failure patients at the Faisalabad Institute of Cardiology and at the Allied Hospital in Faisalabad (Punjab, Pakistan), during April–December 2015. The patients consisted of 105 women and 194 men, and their ages range between 40 and 95 years old . All 299 patients had left ventricular systolic dysfunction and had previous heart failures that put them in classes III or IV of New York Heart Association (NYHA) classification of the stages of heart failure. (Download data here: https://archive.ics.uci.edu/dataset/519/heart+failure+clinical+records).

Dataset contains 12 variables and one dependent variables. All the variables will be described below: 

* **age**: age of the patient (Years)
* **anaemia**: decrease of red blood cells or hemoglobin. 0 as no anaemia; 1 otherwise
* **creatinine_phosphokinase**: level of the CPK enzyme in the blood (mcg/L)
* **diabetes**: if the patient has diabetes. 0 if patient has no diabetes; 1 otherwise
* **ejection_fraction**: percentage of blood leaving the heart at each contraction (Percentage)
* **high_blood_pressure**: if the patient has hypertension. 0 as no high blood; 1 otherwise
* **platelets**: platelets in the blood (kiloplatelets/mL) 
* **serum_creatinine**: level of serum creatinine in the blood (mg/dL)
* **serum_sodium**: level of serum sodium in the blood (mEq/L)
* **sex**: woman or man. 0 as woman; 1 as man
* **smoking**: if the patient smokes or not. 0 as no-smoking; 1 otherwise
* **time**: follow-up period
* **DEATH_EVENT**: if the patient died during the follow-up period. 0 as survived; 1 as dead

# Methodology

In this project, I focused on Logistic Regression to understand the relationship between survival class and other relevant clinical covariates. Using different ways of selection, the final Logistic Regression was applied to predict the survival rate at the end.
![summary_logistic_model](https://github.com/quocng99/Survival_Rate_Prediction/assets/124481291/b27830cb-82df-486d-aefd-4b94642c51fc)

At the end, I also compare the final logistic regression with other machine learning models, such as Random Forest, Naive Bayes. The accuracy and sensitivity of logistic regression on test dataset is not good as other models, but it gained very high specificity and AUC. 




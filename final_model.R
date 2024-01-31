library(shiny)
library(ggplot2)

# Load data
df1 <- read.csv("D:/prediction/heart_failure_clinical_records_dataset.csv")

# Factorize columns
factor_cols <- c("DEATH_EVENT", "anaemia", "diabetes", "high_blood_pressure", "sex", "smoking")
df1[factor_cols] <- lapply(df1[factor_cols], as.factor)

#Log transformation
df1$logplatelets<-log(df1$platelets)
df1$logcreatinine_phosphokinase<-log(df1$creatinine_phosphokinase)

#use 70% of dataset as training set and 30% as test set
sample <- sample(c(TRUE, FALSE), nrow(df1), replace=TRUE, prob=c(0.7,0.3))
train  <- df1[sample, ]
test   <- df1[!sample, ]


#Add the intersection between gender and other variables
logistic_regression<-glm(DEATH_EVENT~age + ejection_fraction + serum_creatinine + 
              serum_sodium + sex + time + logcreatinine_phosphokinase+
              sex*ejection_fraction+
              sex*logcreatinine_phosphokinase, 
            family = binomial, data = train)

# Run the model on test dataset
test_prob_logistic<-predict(logistic_regression,test,type ="response")
# Choose threshold=0.5
test_pred_logistic<-ifelse(test_prob_logistic > 0.5,"1","0")
#Compare
cat("Confusion matrix of logistic regression on test data")
table(test_pred_logistic,test$DEATH_EVENT)

#Accuracy on testing dataset

accuracy_logistic<-round(mean(test_pred_logistic==test$DEATH_EVENT),4)

saveRDS(logistic_regression, paste0("D:/prediction", "final_model.rds"))
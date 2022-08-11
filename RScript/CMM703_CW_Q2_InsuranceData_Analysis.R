##install.packages("readr")
##install.packages("caTools")

## Load packages ##
library(readr)
library(ggplot2)
library(tidyr)
library(psych)
library(caTools)
library(knitr)
library(rmarkdown)
library(tinytex)
#library(magrittr)
#library(tidyverse)
#library(tidymodels)

options(knitr.duplicate.label = "allow")

## Get the current working directory / project path ##
getwd()

## Assign the source data path into a variable
dataSource_Path <-"D:/Academic/BDA/CMM703_DA/CW/CMM703_DA/CMM703_CW_Practicles_with_R/Data/For_Q2/insuranceData.csv"

## Load data and assign it to a dataframe, insurance_dataFrame ##
data_tibble<-read_csv(dataSource_Path)

## Convert the tibble to a dataframe ##
insurance_dataFrame <- as.data.frame(data_tibble)

## Remove the index column ##
insurance_dataFrame <- insurance_dataFrame[,-1]

## Explore Data ##

## Get the first part of the DF ##
head(insurance_dataFrame)

## Get the last part of the DF ##
tail(insurance_dataFrame)

## Get the Structure of the DF ##
str(insurance_dataFrame) 

## Check for null values ##
sapply(insurance_dataFrame,is.null)
sapply(insurance_dataFrame,function(x) sum(is.null(x)))

## Check for missing values ##
sapply(insurance_dataFrame,function(x) sum(is.na(x)))

## Convert character variables into factors ##
insurance_dataFrame[sapply(insurance_dataFrame, is.character)] <- lapply(insurance_dataFrame[sapply(insurance_dataFrame, is.character)], 
                                                                          as.factor)

describe(insurance_dataFrame)

## Levels of factors ##
#lapply(insurance_dataFrame[sapply(insurance_dataFrame,is.factor)],unique)

## select factor variables which should be converted as numeric ##
#must_convert<-sapply(insurance_dataFrame,is.factor)

## All factor variables transformed approximately its original numeric values using unclass function ##
#faclevels_dataFrame<-sapply(insurance_dataFrame[,must_convert],unclass)

## complete DF with all variables put together ##
#insurance_dataFrame<-cbind(insurance_dataFrame[,!must_convert],faclevels_dataFrame)

## Data distribution of predictor variable - premium ##
hist(insurance_dataFrame$premium, breaks = 30, main="Histogram for Insurance Premium", 
     xlab="Premium")

## Discover the relationships between features ##
cor(insurance_dataFrame[c("age", "bmi", "num_kids", "premium")])

## Scatterplot matrix using psych package ##
pairs.panels(insurance_dataFrame[c("age", "bmi", "num_kids", "premium")])


## Box plots to numerical varibales ##
numdata_boxplot <- insurance_dataFrame[,c('age','bmi','num_kids','premium')]

boxplot(numdata_boxplot, col = rgb(0, 0, 0, alpha = 0.25), main=("Boxplots for Numerical Variables") )

## Remove outliers using interqurtile range ##
rm_outliers <- function(x){
  qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
  H <- 1.5 * IQR(x, na.rm = T)
  lb<-qnt[1] - H
  ub<-qnt[2] + H
  x[x < lb] <- lb
  x[x > ub] <- ub
  return(x)
}
insurance_dataFrame$bmi<-rm_outliers(insurance_dataFrame$bmi)
insurance_dataFrame$premium<-rm_outliers(insurance_dataFrame$premium)

numdata_boxplotintq <- insurance_dataFrame[,c("age","bmi","num_kids","premium")]

boxplot(numdata_boxplotintq, col = rgb(0, 0, 1, alpha = 0.25), 
        main=("Boxplots for Numerical Variables without Outliers") )


##### Model Buildup #####

model_df <- insurance_dataFrame

# Splitting the DF into training and test data sets ##

set.seed(123)
## set the index on training data set to split the data on 0.8:0.2 ratio based on index##
traindt_index <- sample(seq_len(nrow(model_df)), size = floor(0.80 * nrow(model_df)))

##  the data ##
training_df <- model_df[traindt_index, ]
test_df <- model_df[-traindt_index, ]

training_df
test_df

##Training the data for model using training df ##
## Fit Multiple Linear Regression to the training df with all independent variables##
insu_model <- lm(premium ~ ., data = training_df)

## Check for the model accuracy ##
summary(insu_model)

#### Improve the Model ####

### Transforming, Recoding variables where it's needed ###

## Considering client's age Vs premium & couldn't defined a linear relationship##
model_df$age_ <- model_df$age^2

## Decide a health factor according to continuous variable BMI ## 
model_df$bmi_30 <- ifelse(model_df$bmi >= 30, 1, 0)

## Split the data again with additional columns ##

training_impdf <- model_df[traindt_index, ]
test_impdf <- model_df[-traindt_index, ]

## Fit the model again with interaction features ##
insu_impmodel <- lm(premium ~ age + age_ + num_kids + bmi + gender +
                   bmi_30*smoking_status , data = training_impdf)

## Check for the model accuracy ##
summary(insu_impmodel)

####### Validate the model ########

##### Model prediction of premium with test data set ######
mdl_premiumPredicted = predict(insu_impmodel, newdata = test_impdf)

### Correlation between actual vs predicted of premium ###
cor(mdl_premiumPredicted, test_impdf$premium)

## Plot actual vs predicted of premium ###
plot(mdl_premiumPredicted, test_impdf$premium, 
     main = 'Actual Vs Predicted Insurance Premium', xlab = 'Predicted Premium',
     ylab = 'Actula Premium')
abline(a = 0, b = 1, col = "red", lwd = 3, lty = 2)


# Insurance_Premium_Prediction
This was done to predict the insurance premium of a customer based on given data with R coding.

The choosen insuranceData file contains a sample of 1471 records of insurance contractors currently enrolled in an insurance plan 
in a famous insurance company in Sri Lanka. 

Data set is about the insurance premium of the customer according to the entitled health insurance plan. Data set contains some factors of the patient which are consider deciding the insurance plan.It includes some characteristics of the patient and the premium decided by the insurance company.

The features are:

                  * age: age of the insurance contractor
                  
                  * sex: gender of the insurance contractor 
                  
                  * bmi: body mass index of the contractor (kg / m ^ 2)
                  
                  * num_kids: number of children covered by health insurance
                  
                  * smoking_status: smoking status of the insurance contractor
                  
                  * district: residential area of the beneficiary; Colombo, Galle, Badulla and Trinco
                  
                  * premium: monthly insurance premium decided by health insurance company

So, in our use case we are going to build up an accurate model to predict the monthly insurance premium based on the given factors .
Conducted a thorough descriptive analysis first explored the numerical insights of the given data set by extracting summarized values of numerical variables . Basically, it provides the high level information of numerical data with measures of central tendency along with the way of data distribution. And for categorical data we can use visualization to analyze the pattern and relationships in between variables.

Install and load particular libraries into R program in order to conduct the analysis and build up the model.

Import the given csv file to access the data set & assign it to data frame.

## Explore Data

Let’s look for the insights of data in the DF.

Using head(),tail(),str() functions we can get the first part of data , last part of data & structure of the data in the created DF respectively.

![image](https://user-images.githubusercontent.com/9928449/184149049-8541f84a-4a0c-4ae7-a722-85c50ad356c7.png)

According to the above output we can determine our data set contains 7 variables and mainly 3 are categorical(qualitative) and 4 are numerical(quantitative).

Furthermore, numerical  variables can be identified as 2 discrete variables and 2 are continues variables. Summary about the data is as below.

![image](https://user-images.githubusercontent.com/9928449/184149191-73f2fb5e-4e82-487f-9edc-786649cc591c.png)

![image](https://user-images.githubusercontent.com/9928449/184149272-2fb37846-631f-4f01-9ee7-e4cad9437d42.png)

As per the above we can see the internal structure of the data frame ,it consists with 1471 rows & 7 columns. Out of 7, 4 columns have numeric data , and rest have character data.(3) [‘gender’,’smoking_status’,’district’]

Since we are stepping up to build a ML model, we can’t directly use character variables in modeling hence should convert them into factors. In the Data Preprocessing stage will do the transformation.

### Data Preprocessing 

As the most important step in the process of data analyzing we should use necessary data cleansing techniques and transformation methods to form a neat and tidy data set.

Before dealing with data in the data frame we should check for null or missing data points & handle them with appropriate techniques in order to build up strong predictions through an accurate model.

![image](https://user-images.githubusercontent.com/9928449/184149656-a7122af6-8c90-459b-bbf0-f700c9d5e634.png)

It’s clear there is neither null nor missing values in the DF. So, the data set is pretty clear.

As in the begging stated about data type transformation now, we may convert character variables to factor variables. Here used more convenient functions in R as lapply & sapply instead of using a for loop.

![image](https://user-images.githubusercontent.com/9928449/184149838-894d93ec-090d-4bfc-9264-7f69a706404e.png)

As factor variables has levels , will have a closer look about levels of each categorical variable which we converted to factor data type in above step.

![image](https://user-images.githubusercontent.com/9928449/184149907-aefc7837-5e63-4528-b8df-1ae7a5cd7aea.png)

Out put Summary : 
                  $gender : has 2 levels,
                  
		              $smoking_status : has 2 levels
                  
		              $district has : 4 levels  

To have an overall summary picture let’s get  the summary & the description of the DF.

![image](https://user-images.githubusercontent.com/9928449/184150098-aefd5d6c-2e5d-406c-a6df-462319a06481.png)

According to the summary we can conclude there is no garbage values in the DF too.

The summary view of data gives the min, max, median, mean, 1st quartile & 3rd quartile as the measures of central tendency for numerical data and the frequency for categorical data.

### Numerical Data Insights

Age of the clients is in the range of 18 – 64 years and mean is 40 .

BMI is in the range of 16.82 and 53.13. Mean is 30.92 . As per the health indicators if a person’s BMI is equal or greater than 30 it’s identified as clinically obese. Average of BMI in this data set also above the obese level. So, there is an effect from BMI when deciding the premium.   
Num of Kids covered by the Insurance , most of the clients doesn’t have kids and highest num of kids that clients have is 1 and next is 2.

Premium is our predicting/ independent variable, and its data distribution is right skewered.

### Categorical Data Insights
Gender & District variables have pretty good balance in proportion. So, the data distribution is normal. But Smoking_status has a ratio of 1: 5 in data distribution among the two levels. Also it’s an important fact to be determined the premium of customer since this is a health insurance plan.

Data Distribution of Predictor Variable

![image](https://user-images.githubusercontent.com/9928449/184150333-da404941-f268-4658-8a41-c95aecb72243.png)

### Discover the relationships between features

To explore relationship of numerical features can use a correlation matrix.

![image](https://user-images.githubusercontent.com/9928449/184150578-cb77b958-b5ee-4bf1-ba79-0951b8ee4a03.png)

Can check for the existence of any relationships among features using the cor function. As per the comparison among features we can see that the age field is highly correlated with insurance premium - correlation value of 0.31. So, age is an important feature. The num of kids is the least correlated column with a value of 0.12 to premium. BMI is reasonably correlated with premium. Perfection of circles on lower graphs also shows the correlation among features. As per the ellipse between age and premium  has stretched out significantly , it implies there is a stronger leaner relationship in between those features. 

![image](https://user-images.githubusercontent.com/9928449/184150857-9510c21f-caad-4c43-9b91-7a5119829c81.png)

Can discover the distribution of data points in numerical variables using box plots.

![image](https://user-images.githubusercontent.com/9928449/184151019-8649302b-21cd-475f-b23c-a14827f8f24a.png)

![image](https://user-images.githubusercontent.com/9928449/184151066-18f3a3ce-1d9b-49bf-9e49-503b83253cd1.png)

As per the above figure there are outliers in BMI & Premium columns. So have to handle them before use the data in a model.

### Outlier Handling.

There are some popular methods to handle outliers or else can completely remove them. But our data set is not that much a large then we have to preserve data points. So here used interquartile lower and upper bound values to impute the outliers.

![image](https://user-images.githubusercontent.com/9928449/184151215-930277c9-f362-4d56-ac2d-10b5d4e792ea.png)

As per the figure now there is no any outliers and data set is pretty clean in use to build up a model.

As discussed earlier there are some independent  variables those have a leaner relationship with dependent variable premium. So here used multiple LR with numerical variables as identified above. 

Split initial data set into test & train data sets with 80%:20% ratio in order to train the model & test the model output.

![image](https://user-images.githubusercontent.com/9928449/184151487-d587e905-fc88-4e10-80e7-5d65f4e3f1ea.png)

![image](https://user-images.githubusercontent.com/9928449/184151524-7b243e05-cf43-4620-b32c-83e946ce38af.png)

### Fit the LR model with train data set.

![image](https://user-images.githubusercontent.com/9928449/184151673-5d9cbb29-f4cb-43a1-9904-610f61bfd6f5.png)

As per the summary output residuals/ errors depicts max error as 21951 in an underestimate scenario, means that the actual premium is more than the predicted premium. In an overestimating scenario, the highest error is -10037. This means model output is more than the actual premium.

This confusion matrix describes the accuracy. The model for numerical prediction is likely to be rated upon feature selection and p-value. This summary function gives the range of residuals/errors , the coefficient’s estimation, standard error, p-values, t values, R square & correlation coefficients.

Here age, bmi ,num_kids , smoking_status , districtcolombo ,districttrinco are significant and can ignore the rest when model development. R square of the model is 0.753 means model is giving an 75% of accurate output. 

![image](https://user-images.githubusercontent.com/9928449/184151878-e1c4736c-c826-42d7-9538-0eabd001957d.png)

### Transform and recoding variables where it needed.

As noticed the leaner relationship in between age & premium at earlier we cannot say when getting older insurance premium is going to be increased. So, we can make it non leaner relationship by changing the value of age and added it as a new column.

Also, at the very beginning we identified we can examine the health condition based on the BMI value according to health measurements. So, another new column , bmi_30, is added by categorize the numerical value BMI feature into two portions; 0 for BMI below 30 and 1 for BMI above. Since the smoking can lead to health issues and can say it makes a significant effect on BMI. So here we can add an interaction column with the combination of smoking status and BMI.

![image](https://user-images.githubusercontent.com/9928449/184152117-ac2705c9-a651-4c15-8692-d9ecdd27e2fe.png)

The improved model with additional terms is shown below. Can observe that the newly added terms, age_, bmi_30 and bmi_30:smoking_statusyes are all significant by p-values. Here we have a R squared value 0.811 which is more than the previous one.

As we know, a good threshold to use is the 5% threshold. If the P-value is lower than 5%, the independent variable will be highly statistically significant. When it will be greater than 5% then it is less statistically significant. Among all the independent variables, the statistically strongest predictor is the product of the bmi indicator & smoker, which has the lowest P-value. The manipulated age, district colombo & num_kids are also relatively strong predictors. This improved model gives the output with accuracy around 80%. So can say this is the optimum model.

![image](https://user-images.githubusercontent.com/9928449/184152306-249222dc-df2d-427d-802a-e6dee8c30825.png)

Can compare the correlation between the predicted insurance premium and the actual using the test data set applying cor function, which obtains a value of 0.8703. Which means they are highly correlated, and the thought put have a good accuracy.

![image](https://user-images.githubusercontent.com/9928449/184152372-f2270d0c-16d9-4920-a796-fa40fd3b0a72.png)

Plotting the Actual and Modle output.

![image](https://user-images.githubusercontent.com/9928449/184152446-44d27181-a912-44f3-904d-85f63b80a2eb.png)

Here can find the annotaded source code with descriptions and the outputs / plots/ charts/ matrices.

[CMM703_CW_Q2_InsuranceData_Analysis.pdf](https://github.com/susudu/Insurance_Premium_Prediction/files/9309319/CMM703_CW_Q2_InsuranceData_Analysis.pdf)

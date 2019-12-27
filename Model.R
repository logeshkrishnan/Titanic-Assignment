# DATA PREPROCESSING 
# reading train and test 
train <- read.csv(choose.files(), header = T)
test <- read.csv(choose.files(), header = T)

# loading packages 
library(ggplot2)
library(tidyverse)
library(dplyr)
library(corrplot)

# Combining the train and test datasets 
train$Set <- "train"
test$Set <- "test"
test$Survived <- NA
full <- rbind(train, test)

# Exploratory analysis 
# check data
str(full)
summary(full)
full$Survived <- as.factor(full$Survived)
full$Set <- as.factor(full$Set)

# Summary statistics
summary(full)
colSums(is.na(full))

# From the above summary we can see that Age has fair amount of NA's, Embarked has two missing values and
# Cabin has 1014 missing values in them therefore it is best not to include this variable for predcition and 
# finally fare has one NA 

# Treating missing values in the dataset 
# replace missing values in age with mean and also forming agegroup variable for analysis  
full <- full %>%
  mutate(Age = ifelse(is.na(Age), mean(full$Age, na.rm = T), Age),
         'Age_Group' = case_when(Age < 13 ~ "child",
                                 Age >= 13 & Age < 18 ~ "teen",
                                 Age >= 18 & Age <60 ~ "adult",
                                 Age >= 60 ~ "elderly"))
table(full$Age_Group)

# Replacing missing values in Embarked with 'S' most occurances 
full$Embarked[which(full$Embarked == '')] <- 'S'

# Replacing one NA in fare with mean 
full$Fare[which(is.na(full$Fare))] <- mean(full$Fare, na.rm = T)

# Removing cabin and passengerid from the dataset 
newfull <- full[,-c(1,11)]

# Ratio of survived vs not survived in train
table(train$Survived)
# 549 people perished and 342 people survived from the train data therefore we can see that the training data
# is balanced enough for the model to learn well

# unique values per column
lapply(full, function(x) length(unique(x)))
# from the above observations few things we can notice is that there are three unique values in Survived
# that is because of the NA values in test dataset, there are 1307 unique values in Names which means that 
# there are two names that are shared by four people.
which(table(full$Name) > 1)

# FEATURE CREATION
# Extracting title from the name
names <- full$Name
title <-  gsub("^.*, (.*?)\\..*$", "\\1", names)
head(names)
full$title <- title
table(title)

# grouping other miss titles into miss and mrs
full$title[full$title == 'Mlle'] <- 'Miss' 
full$title[full$title == 'Ms']   <- 'Miss'
full$title[full$title == 'Mme']  <- 'Mrs' 
full$title[full$title == 'Lady']  <- 'Miss'
full$title[full$title == 'Dona']  <- 'Miss'

# combining other titles into officer since they are army people may help in prediction
full$title[full$title == 'Capt']    <- 'Officer' 
full$title[full$title == 'Col']     <- 'Officer' 
full$title[full$title == 'Major']   <- 'Officer'
full$title[full$title == 'Dr']   <- 'Officer'
full$title[full$title == 'Rev']   <- 'Officer'
full$title[full$title == 'Don']   <- 'Officer'
full$title[full$title == 'Sir']   <- 'Officer'
full$title[full$title == 'the Countess']   <- 'Officer'
full$title[full$title == 'Jonkheer']   <- 'Officer'  
table(full$title)

# creating family groups
full$familysize <- full$Parch + full$SibSp + 1
full$familysized[full$familysize == 1] <- 'single'
full$familysized[full$familysize < 5 & full$familysize >= 2] <- 'small'
full$familysized[full$familysize >= 5] <- 'big'
full$familysized=as.factor(full$familysized)
table(full$familysized)

# Visualization 
# Pclass vs Survival 
ggplot(train, aes(x=Pclass,fill=factor(Survived))) + 
  geom_bar() + 
  labs(fill = "Survived") +
  ggtitle("Pclass vs Survival") + 
  theme_minimal()

# It is evident that passengers in first class has higher survival rate when compared to other classes, we can 
# assume that people who bought first class tickets were the first to life boats

# Sex vs Survival 
ggplot(train, aes(x=Sex,fill=factor(Survived))) + 
  geom_bar() + 
  labs(fill = "Survived") +
  ggtitle("Sex vs Survival") + 
  theme_minimal()

# Female and children would have been saved first which is clear from the above plot
# Let us dive deep with comparing the Surivival rate with both Pclass and Sex 
ggplot(train, aes(Pclass,fill=factor(Survived))) + 
  facet_wrap(~Sex) +
  geom_bar() + 
  labs(fill = "Survived") +
  ggtitle("Pclass and Sex vs Survival") + 
  theme_minimal()
# From the above plot we can make sure if the passenger is female and has a first or second class ticket they 
# have more than 90% survival rate

# Age_group vs Survival
ggplot(full[1:891,], aes(Age_Group,fill=factor(Survived))) + 
  geom_bar() + 
  labs(fill = "Survived") +
  ggtitle("Sex vs Survival") + 
  theme_minimal()
# As the age increases the surivival rate decreases 

# Title vs Survival 
ggplot(full[1:891,], aes(title,fill=factor(Survived))) + 
  geom_bar() + 
  labs(fill = "Survived") +
  ggtitle("Sex vs Survival") + 
  theme_minimal()
# We created the title officer with people who had some special titles like col, don etc., as that might
# give us some idea on what happened with those people and as we can see that officers had less survival 
# rate than others. Miss, Mrs and Master had better survival rates when compared to Mr 

# Family size vs Survival 
ggplot(newfull[(newfull$Set == "train"),], aes(familysized,fill=factor(Survived))) + 
  geom_bar() + 
  labs(fill = "Survived") +
  ggtitle("familysize vs Survival") + 
  theme_minimal()
# We can see that family of small size survived better than single and big. It makes sense as big families 
# would've been hard to get to safety

# Model Building 
# Splitting train and test datasets
train <- newfull[(newfull$Set == "train"), ]
test <- newfull[(newfull$Set == "test"), ]

# splitting train dataset into train and test for model building and prediction
# Split is based on random sampling, 70% is used for training and 30% is used for testing 
set.seed(123)
ind <- sample(2, nrow(train), replace = T, prob = c(0.7,0.3))
newtrain <- train[ind==1,]
newtest <- train[ind==2,]
str(newtest)
newtest$title <- as.factor(newtest$title)

# Random Forest 
myformula <- Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + title + familysized 
set.seed(123)
rf_model <- randomForest(myformula, data = newtrain)
plot(rf_model)

# prediction
rfpred <- predict(rf_model, newtest)

# confusion matrix
confusionMatrix(rfpred, newtest$Survived)
# Random Forest predicted with an accuracy of 85.5%

# logistic regression
log_model <- glm(myformula, family=binomial(link='logit'), data = newtrain)
summary(log_model)

# prediction 
logpred <- predict(log_model,newtest)
logpred <- as.factor(ifelse(logpred > 0.5,1,0))

# Classification Matrix 
confusionMatrix(logpred, newtest$Survived)
# logistic regression predicted with 84.73% accuracy.

# Decision Tree
dt_model<- rpart(myformula, data = newtrain, method="class")
rpart.plot(dt_model)

# prediction
dtpred <- predict(dt_model, newtest, type = 'class')

# confusion matrix
confusionMatrix(dtpred, newtest$Survived)
# Decision tree predicted with an accuracy of 85.11%

# Between the three models Random Forest predicted with high accuracy

# prediction for test dataset 
maintest <- predict(log_model,test)
maintest <- as.factor(ifelse(maintest > 0.5,1,0))
test$PassengerId <- full$PassengerId[(full$Set == "test"),]


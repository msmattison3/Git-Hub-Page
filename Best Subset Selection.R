rm(list = ls())
install.packages("ISLR")
# Retrieve data from Hitters dataset in R
library(ISLR)
fix(Hitters)
# What are the names of columns and the dimensions?
names(Hitters)
dim(Hitters)
# How many N/A and omit NA
sum(is.na(Hitters$Salary))
Hitters=na.omit(Hitters)
# Dimnesion of cleaned data and sum of N/a = 0
dim(Hitters)
sum(is.na(Hitters))
install.packages('leaps')
library(leaps)
# fit model and summarize data
regfit.full=regsubsets(Salary~.,Hitters)
# Summary fuction also returns R^2, RSS, adjusted R^2, Cp and BIC
summary(regfit.full)
regfit.full=regsubsets(Salary~.,data=Hitters, nvmax=19)
reg.summary=summary(regfit.full)
names(reg.summary)
# Show R^2 increases from 32% to 55% when all varaibles are included
reg.summary$rsq
# Plot RSS, adj R^2,Cp, and BIC
par(mfrow=c(2,2))
plot(reg.summary$rss, xlab="Number of Variables", ylab="RSS")
plot(reg.summary$adjr2, xlab="Number of Varaibles", ylab="Adjusted RSq")
which.max(reg.summary$adjr2)
points(11, reg.summary$adjr2[11],col="red",cex=2,pch=20)
plot(reg.summary$cp, xlab="Number of Variables", ylab="Cp")
which.min(reg.summary$cp)
points(10, reg.summary$cp[10], col="red", cex=2, pch=20)
which.min(reg.summary$bic)
plot(reg.summary$bic, xlab="Number of Varaibles", ylab="BIC")
points(6, reg.summary$bic[6], col="red", cex=2, pch=20)
# The top row of each plot contains a black square for each varaible
# selected according to the optimal model associated with that statistic
plot(regfit.full ,scale="r2")  
plot(regfit.full ,scale="adjr2")
plot(regfit.full ,scale="Cp") 
plot(regfit.full ,scale="bic")
# See the coefficent estimates associated with this model
coef(regfit.full, 6)

## Forward and Backward Stepwise Selection
# use regsubset) to perform forward stepwise or backward stepwise
# using the arguemnet method ="forward" or "backward"
regfit.fwd=regsubsets(Salary~.,data=Hitters,nvmax=19,method="forward")
summary(regfit.fwd)
regfit.bwd=regsubsets(Salary~.,data=Hitters,nvmax=10,method="backward")
summary(regfit.bwd)
#For forward stepwise selection, the best one model contains only CRBI
# the best two -variables model additionaly includes Hits
#he best one-variable through sixvariable models are each identical for 
#best subset and forward selection. However, the best seven-variable models 
#identi???ed by forward stepwise selection, backward stepwise selection, and best
#subset selection are di???erent
coef(regfit.full, 7)
coef(regfit.fwd, 7)
coef(regfit.bwd, 7)

# Choosing Amoung Models Using the Validation Approach and Cross-Validation
# in order to yield accurate estimates of the test error,
# must use only the training observations
# To use the validation approach
  # split the observations int a training set and a test set
  # set a random seed so that the user will obtain the same traing set/test set split
set.seed(1)
train=sample(c(TRUE,FALSE), nrow(Hitters),rep=TRUE)
train
test=(!train)
test
# apply regsubsets()to the training set in order to perform best subset selection
regfit.best=regsubsets(Salary~.,data=Hitters[train,],nvmax=19)
regfit.best
# make a model matrix from the test data
test.mat=model.matrix(Salary~.,data=Hitters[test ,])
dim(test.mat)
# run a loop, for each size i, we extract the coefficients from regfit.best for the best
# model of that size, multiply them into the appropriate columns of the test model matrix
# to form the predictions, and compute the test MSE
install.packages('Metrics')
library(Metrics)
val.errors=rep(NA,19)
for(i in 1:19){
  coefi=coef(regfit.best,id=i)
  pred=test.mat[,names(coefi)]%*%coefi
  val.errors[i]=mean((Hitters$Salary[test]-pred)^2)
}                     
val.errors
# Find the best model is the one that contains ten varaibles
which.min(val.errors)
coef(regfit.best,10)
# Can capture our steps above and write our own predict method
predict.regsubsets=function(object,newdata,id,...) {
  form=as.formula(object$call[[2]])
  mat=model.matrix(form,newdata)
  coefi=coef(object,id=id)
  xvars=names(coefi)
  mat[,xvars]%*%coefi
}
#perform best subset selecction on the full data set and select best ten-variable
#observe that the best ten=variable model on the full data set has a different
#set of variables than the best ten-varaible model on the training set
regfit.best=regsubsets(Salary~.,data=Hitters, nvmax=19)
coef(regfit.best,10)
# must perform best subset selection within each of the k taining sets
# create a vector that allocates each observatin to one of k =10 folds and
# we create a matrxi in which we will store the results
k=10
set.seed(1)
folds=sample(1:k,nrow(Hitters),replace=TRUE)
cv.errors=matrix(NA,k,19, dimnames=list(NULL, paste(1:19)))
#write for lop that peforms cross-validation
#in the jth fold, the elements of folds that equal j are in the test set
#and the remainder are in the training set
#make prediciton for each model size(predict method(), compute the test errors on the
#appropriate subset, and store them in the appropriate slot in the matrix cv.errors
for(j in 1:k){
  best.fit=regsubsets(Salary~.,data=Hitters[folds!=j,],
                      nvmax=19)
  for(i in 1:19){
    pred=predict(best.fit,Hitters[folds==j,],id=i)
    cv.errors[j,i]=mean( (Hitters$Salary[folds==j]-pred)^2)
    }
  }
#a 10x10 matrix, which (i,j) element corresponds to the test MSE for the ith cross-validation
#fold for the best j-varaible model. We use the apply() function to average over the columns of 
#this matrix in order to obtain a vector for which the jth element is the cross-validation error for the j-variable model
mean.cv.errors=apply(cv.errors,2,mean)
mean.cv.errors
par(mfrow=c(1,1))
plot(mean.cv.errors, type='b')
# cross-validation selects an 11-variable model, we now perform best subset selection on the full data set
# in order to obtain the 11-variable model
reg.best=regsubsets(Salary~.,data=Hitters, nvmax=19)
coef(reg.best,11)


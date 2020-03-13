rm(list = ls())
# use the glmnet package in order to perform ridge regressin and the lasso
x=model.matrix(Salary~.,Hitters)[,-1]
y=Hitters$Salary
y=na.omit(y)
#model.matrix produces a matrix corresponding to the 19 predictors but it also
#automatically transforms any qualitative variables into dummy variables
# if alpha = 0 then a ridge regression model is fit, and if alpha =1 then a lasso
# model is fit
#install.packages('glmnet')
library(glmnet)
grid=10^seq(10,-2,length=100)
ridge.mod=glmnet(x,y,alpha=0,lambda=grid)
# this package perform ridge regression for an automatically selected range penalty values
#ridge regresion standardizes the varaibles so that they are on the same scale
#use standardize=FALSE to turn off in settings
dim(coef(ridge.mod))
#expect the coefficient estimates to be much smallers, in terms of ls norm, when a large
#value of lambda is used, as compared to when a small value of lambda is used
#these are the coefficients when lambda = 11,498, along with their l2 norm
ridge.mod$lambda[50]
coef(ridge.mod)[,50]
sqrt(sum(coef(ridge.mod)[-1,50]^2))
#much larger ls norm of the coefficients associated with this small value of lambda
ridge.mod$lambda[60]
coef(ridge.mod)[,60]
sqrt(sum(coef(ridge.mod)[-1,60]^2))
# we can use the predic() function for a number of purpose
#we can obtain the ridge regression coefficients for a new value of lamda, say 50:
predict(ridge.mod, s=50, type="coefficients")[1:20,]
#split the samples into a training set and a test set in order to estimate the test error
#of ridge regression and the lasso
set.seed(1)
train=sample(1:nrow(x), nrow(x)/2)
test=(-train)
y.test=y[test]
#fit a ridge regression model on the training set, and evaluate its MSE on the test set
#this time we ge predictions for a test set, by replacing type="coefficients" with the newx argument
ridge.mod=glmnet(x[train,],y[train],alpha=0,lambda=grid,
                 thresh=1e-12)
ridge.pred=predict(ridge.mod,s=4,newx=x[test,])
mean((ridge.pred-y.test)^2)
# The test MSE is 142199.2 
# Note that if we had instead simply ???t a model with just an intercept, we would have predicted 
# each test observation using the mean of the training observations. In that case, we could compute
# the test set MSE like this
mean((mean(y[train])-y.test)^2)
# so fitting a ridge regression with a lambda-4 leads to a much lower test MSE
#than fitting a model with just an intercept
ridge.pred=predict(ridge.mod,s=0,newx=x[test,])
mean((ridge.pred-y.test)^2)
#use to fit a unpenalized least squares model
lm(y~x, subset=train) 
predict(ridge.mod,s=0,type="coefficients")[1:20,]
# can use cross-validation to choose the tuning parameter lambda
# use cv.glmnet, by default it performs ten-fold cross-validation
set.seed(1)
cv.out=cv.glmnet(x[train,],y[train],alpha=0)
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam
# set the value of lambda that results in the smalles cross validation error is 326.
# What is the test MSE associated with this value of lambda?
ridge.pred=predict(ridge.mod,s=bestlam,newx=x[test,])
mean((ridge.pred-y.test)^2)
# #refit our ridge regression model on the full data set, using the value of lamda chosen
# by cross-validation and examne coefficient estimates
out=glmnet(x,y,alpha=0)
predict(out,type="coefficients",s=bestlam)[1:20,]

# THE LASSO
lasso.mod=glmnet(x[train,],y[train],alpha=1,lamda=grid)
plot(lasso.mod)
# we can see the coefficient plot that depending on the choice of tuning parameter, 
# someo f the coefficients will be exactly equal to zero
# perform cross-validation and compute the associated test error
set.seed(1)
cv.out=cv.glmnet(x[train,],y[train],alpha=1)
plot(cv.out)
bestlam=cv.out$lambda.min
lasso.pred=predict(lasso.mod,s=bestlam,newx=x[test,])
mean((lasso.pred=y.test)^2)
# The lasso has a substantial advantage over ridge regression in that the resulting
# coefficient estimate are sparse. Here we see that 12 of the 19 coefficient estimates 
# exactly zero. The lasso model with lambda choseb by cross-validation contains only seven variables
out=glmnet(x,y,alpha=1,lamda=grid)
lasso.coef=predict(out,type="coefficients",s=bestlam)[1:20,]
lasso.coef
lasso.coef[lasso.coef!=0]

# Principal component regression can be performed using pcr()
install.packages('pls')
library(pls)
set.seed(2)
# Setting validation to CV causes pcr() to compute the ten-fold-cross-validation
# error for each possible value of M, the number of principal components used
pcr.fit=pcr(Salary~., data=Hitters,scale=TRUE,
            validation="CV")
# The summary function provides the percentage of varaince explained in the predictors, for example,
# M = 1 captures 38.31% of all the varaince in the predictors
summary(pcr.fit)
# PCR reports the root mean squared error, in order to obtain the usual MSE, we must 
# square this quantity. For instance, a root mean squared error of 352.8 corresponds to
# an MSE of 352.8^2
validationplot(pcr.fit, val.type="MSEP")
# perform PCR on the traing dat and evaluate its test set performance
set.seed(1)
pcr.fit=pcr(Salary~., data=Hitters,subset=train,scale=TRUE,
            validation="CV")
validationplot(pcr.fit, val.type="MSEP")
# Find the lowest cross-validation error occuring when M = 7 component are used
pcr.pred=predict(pcr.fit,x[test,],ncomp=7)
mean((pcr.pred-y.test)^2)
pcr.fit=pcr(y~x,scale=TRUE,ncomp=7)
summary(pcr.fit)

# Partial Least Squares
set.seed(1)
pls.fit=plsr(Salary~., data=Hitters, subset=train, scale=TRUE, validation="CV")
summary(pls.fit)        
validationplot(pls.fit,val.type="MSEP")
# The lowest cross-validation error occurs when only M=2 partial least squares
# directions are used. Evaluate the corresponding test set MSE. 
# Is it higher than ridge regression, the lasso, and PCR?
pls.pred=predict(pls.fit,x[test,],ncomp=2)
mean((pls.pred-y.test)^2)
# Perform PLS using the full data set, using M=2
pls.fit=plsr(Salary~.,data=Hitters,scale=TRUE,ncomp=2)
summary(pls.fit)
# two- componenet PLS fit explains, 46.40% is almost as much as that explained
# using the final seven-component model PCR fit, 46.69%. This because PCR
# only attempts to maximize the amount of varaince explained in the predictors,
# while PLS searches for directions that explain varaince in both the predictors 
# and the response
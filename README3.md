## Tree Method, Random Forest, Bagging, Boosting - R Studio

rm(list=ls())
install.packages('tree')
library(tree)
# Use the classification trees to analyze the Carseat data set.
# We begn by recoding it as a binary variable. Use the ifelse() function
# to create a varaible called High.
library(ISLR)
attach(Carseats)
High=ifelse(Sales<=8,"No","Yes")
# Use the data frame () to merge High with the rest of the Carseats data
Carseats=data.frame(Carseats,High)
# Use the data.frame() function to merge High with the rest of the Carseats
# data
tree.carseats=tree(High~.-Sales,Carseats)
# Summary() lists the varaibles that are used as internal nodes in the tree,
# the number of terminal nodes, and the training error rate
# See the training error rate is 9%. A small deviance indicates a trree that
# provides a good fit to the (training) data. The residual mean deviance reported
# is 400 - 27 = 373/
summary(tree.carseats)
plot(tree.carseats)
text(tree.carseats,pretty=0)
# details of tree
tree.carseats
# Estimate the test error to evaluate the performance of classification tree
# Split the observation into a training set and a test set
# build the tree using the training set, and evaluate is performance
# on the test data. When classification tree, type="class".
set.seed(2)
train=sample(1:nrow(Carseats),200)
Carseats.test=Carseats[-train,]
High.test=High[-train]
tree.carseats=tree(High~.-Sales,Carseats,subset=train)
tree.pred=predict(tree.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(104+50)/200
# Consider pruning the tree might lead to improved results.
# use cv.tree() performs cross-validation in order to determin
# the optimal level of tree complexitiy. Use the argument FUN=prune.misclass
# in order to indicate that we want the classification error rate
# to guide the cv and pruning process.
set.seed(3)
cv.carseats=cv.tree(tree.carseats,FUN=prune.misclass)
names(cv.carseats)
# Despite the name, dev corresponds to the cross-validation error rate in this 
# instance. The tree with 9 terminal nodes results in the lowest cv error rate,
# with 50 cv errors. Plot the error rate as a function of both size and k
par(mfrow=c(1,2))
plot(cv.carseats$size, cv.carseats$dev, type="b")
plot(cv.carseats$k, cv.carseats$dev, type="b")
# Now apply the prune.misclass() function in the order to the prune the tree to
# obtain the nine-node tree
prune.carseats=prune.misclass(tree.carseats, best=9)
plot(prune.carseats)
text(prune.carseats,pretty=0)
# How well does this pruned tree perform on the test data set
tree.pred=predict(prune.carseats, Carseats.test, type="class")
table(tree.pred,High.test)
(97+58)/200
# Now 77% are correctly classified rather than 71%. The pruning
# produced a more interpretable tree and improved the classification 
# acuracy
prune.carseats=prune.misclass(tree.carseats,best=15)
plot(prune.carseats)
text(prune.carseats, pretty=0)
tree.pred=predict(prune.carseats,Carseats.test,type="class")
table(tree.pred,High.test)
(102+53)/200
# This produce a 77.5% accuracy rate

# Fitting Regression Trees
# here we fit a regression tree to the Boston data set. Create
# a training set, and fit the tree to the training data.
library(MASS)
set.seed(1)
train=sample(1:nrow(Boston),nrow(Boston)/2)
tree.boston=tree(medv~.,Boston,subset=train)
summary(tree.boston)
# Notice that the output of summary() indicates that only three of the
# variables have been used in constructing the tree.
plot(tree.boston)
text(tree.boston,pretty=0)
# Now we use the cv.tree() to see whether pruning the tree will
# improve performance
cv.boston=cv.tree(tree.boston)
plot(cv.boston$size, cv.boston$dev, type='b')
# Most complex tree is selected by cv. We wish to prune the
# tree using the prune.tree()
prune.boston=prune.tree(tree.boston,best=5)
plot(prune.boston)
text(prune.boston, pretty=0)
# In keeping with the cv, we use the unpruned tree to make predictioons
# on the test set
yhat=predict(tree.boston,newdata=Boston[-train,])
boston.test=Boston[-train,"medv"]
plot(yhat,boston.test)
abline(0,1)
MSE <- mean((yhat-boston.test)^2)
sqrt(MSE)
# The test MSE associated with the regression tree is 35.28. The squre root
# of the MSE. The sqrt is 5.9402, indicating that this model
# leads to test predictions that within around $5,9402 of the
# true median home values for the suburb

# Bagging and Random Forests
# Bagging is simply a special case of a random forest 
# with m = p. randomForest() can be used to perform both
# random forests and bagging.
install.packages("randomForest")
library(randomForest)
set.seed(1)
library(MASS)
View(Boston)
train = sample(1:nrow(Boston), nrow(Boston)/2)
boston.test=Boston[-train, "medv"]
# mtry=13 indicates that all 13 predictors should be considered for each
# split of the tree
bag.boston=randomForest(medv~., data=Boston, subset=train, mtry=13,importance=TRUE)
bag.boston
yhat.bag = predict(bag.boston, newdata=Boston[-train,])
plot(yhat.bag, boston.test)
abline(0,1)
# The test set MSE associated with the bagged regression
# tree is 16.29
mean((yhat.bag-boston.test)^2)
# Should change the number of trees using the ntree argument
bag.boston=randomForest(medv~.,data=Boston,subset=train,mtry=13,ntree=25)
yhat.bag=predict(bag.boston,newdata=Boston[-train,])
mean((yhat.bag-boston.test)^2)
# By default randomForest() uses p/3 variables when building a 
# a random forest of regression trees, and sqrt(p) variables
# when building a random forest of classification trees
# Here we use mtry=6
set.seed(1)
rf.boston=randomForest(medv~.,data=Boston,subset=train,mtry=6,importance=TRUE)
yhat.rf = predict(rf.boston, newdata=Boston[-train,])
# The test set MSE is 11.31, this indicates that random forests yielded
# an improvement over bagging in this case.
# Use the importance() function, we can view the importance of each variable
importance(rf.boston)
mean((yhat.rf-boston.test)^2)
# Plots of these importance measures can be produced using the varImpPlot()
varImpPlot(rf.boston)

# Boosting 
# use the gbm package to fit boosted regression trees to the Boston data set
# Run gbm() with the option distribution="guassian" since this is a
# regression problem, if it were a binary classification problem. 
# Use distribution="bernoulli". n.trees=5000 indicates that we want 
# 5000 trees, and the option interaction.depth=4 limits the depth of each tree
install.packages("gbm")
library(gbm)
set.seed(1)
boost.boston=gbm(medv~.,data=Boston[train,],distribution="gaussian",n.trees=5000,interaction.depth=4)
# The summary() produces a relative influence plot and also outputs the relative influence statistics
# Shows that lstat and rm are by far the most important variables
summary(boost.boston)
# PRoduce partial dependence plots for these two variables. Illustrate the marginal
# effect of the selected varaibles on the response after integrating out the other 
# variables.
par(mfrow=c(2,2))
plot(boost.boston, i="rm")
plot(boost.boston, i="lstat")
# Use the boost model to predict medv on the test set
yhat.boost=predict(boost.boston,newdata=Boston[-train,],n.trees=5000)
# The test MSE obtained is 16.38. Default shrinkage parameter is 0.0001,
# here we take it to 0.2. Because it leads to a slightly lower test MSE
mean((yhat.boost-boston.test)^2)

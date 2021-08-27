library(corrplot)
library("Hmisc")
library(car)

setwd("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data")
rm(list=ls())

# Read data
data <- read.csv("/Users/zihuige/ACSE/ACSE-9/Project/ACSE_9_PROJECT/data/training_set.csv",header=TRUE)
# output first two rows of data
head(data, n = 2)

# Run a correlation test for selected variables
cor_data <- cor(data[, 2:6])
corr <- cor_data
col2 = colorRampPalette(c('blue', 'white', 'red'))  
par(mfrow= c(1,1))
corrplot(corr, method = 'color', type = 'lower', order = 'alphabet', 
         tl.col = 'black', addCoef.col = 'black',
         cl.ratio = 0.2, tl.srt = 40, col = col2(20))

# excluded data from vapour and wind
# apply correlation test again 
data <- data[, -c(5,6)]
cor_data <- cor(data[, 2:4])
cor_data

# convert fire into different labels based on FRP values 
FireBand <-ifelse(data$FRP>=1500, 4, data$FRP)
FireBand <-ifelse(1500>=data$FRP & data$FRP>1000, 3, FireBand)
FireBand <-ifelse(1000>=data$FRP & data$FRP>500, 2, FireBand)
FireBand <-ifelse(500>=data$FRP & data$FRP>100, 1, FireBand)
FireBand <-ifelse(100>=data$FRP & data$FRP>=0, 0, FireBand)

dataclass <- data.frame(data[, 1:4], FireBand)

# Create lists to store model information
Model<- c()
Accuracy <- c()
ErrorRate <- c()
FPR_0 <- c()
FPR_1 <- c()
FPR_2 <- c()
FPR_3 <- c()
FPR_4 <- c()


### Decision tree ###

library('rattle')
library('pROC')
library('rpart')

set.seed(0465)
datatree <- dataclass

# Split train and test sets
nrows <- nrow(datatree)
trainset <- sample(1:nrows, .80*nrows)
testset <- setdiff(1:nrows, trainset)
traintree <- datatree[trainset,]
testtree <- datatree[testset,]

# Build a decision tree model for training
control <- rpart.control(minsplit = 2, minbucket = 1, cp = 0.0001)

tree.fire <- rpart(FireBand ~ ., data = traintree,
                    method = 'class', parms = list(split = "information"),
                    control = control)

# Prune the classification tree
head(tree.fire$cptable, 10)

# We can see from 'cptable', when cp=0.000238,
# x-val relative error has the minimum value '1.0'
# We'll let cp=0.000238 to prune the decision tree
CP <- 0.000238

prunedtree <- prune(tree.fire, cp = CP)

# Evaluate model
prunedtree_preds <- predict(prunedtree, newdata = testtree, type = 'class')
err_list <- table(testtree$FireBand, prunedtree_preds, dnn=c("Observed", "Predicted"))
err_list

# Calculate accuracy for each class
Model[1]<- 'Decision Tree'
Accuracy[1] <- (sum(diag(err_list)))/sum(err_list)
ErrorRate[1] <- 1 - Accuracy[1]
FPR_0[1] <- (err_list[1,2]+err_list[1,3]+err_list[1,4]+err_list[1,5])/sum(err_list[1,])
FPR_1[1] <- (err_list[2,1]+err_list[2,3]+err_list[2,4]+err_list[2,5])/sum(err_list[2,])
FPR_2[1] <- (err_list[3,1]+err_list[3,2]+err_list[3,4]+err_list[4,5])/sum(err_list[3,])
FPR_3[1] <- (err_list[4,1]+err_list[4,2]+err_list[4,3]+err_list[4,5])/sum(err_list[4,])
FPR_4[1] <- (err_list[5,1]+err_list[5,2]+err_list[5,3]+err_list[5,4])/sum(err_list[5,])


### Random Forest ###

library('randomForest')

set.seed(0465)
datatree <- dataclass

# Split train and test sets
nrows <- nrow(datatree)
trainset <- sample(1:nrows, .80*nrows)
testset <- setdiff(1:nrows, trainset)
traintree <- datatree[trainset,]
testtree <- datatree[testset,]

# Create an initial Random Forest model with ntree=500, mtry=1
model <- randomForest(as.factor(FireBand) ~ .,
                            data=traintree,
                            ntree=500,mtry=1,
                            importance=TRUE, 
                            na.action=na.roughfix,
                            replace=TRUE)
print(model)

# Due to the device memory limitation, I simulated random forest models with a series of
# 'ntree' and 'ntry' on Colab with a virtual machine. I have also uploaded a colab verson 
# file.
# 
# ntree_list <- c(50,100,500,1000)
# ntry_list <- c(1,2,3)
# min_ntree <- c()
# OBB_err <- c()
# 
# for(ntree in ntree_list){
#   for (ntry in ntry_list ){
#     model.RandomForest <- randomForest(as.factor(FireBand) ~ .,
#                                        data=traintree, 
#                                        ntree=ntree, mtry=ntry,
#                                        importance=TRUE, 
#                                        na.action=na.roughfix,
#                                        replace=TRUE)
#     a <- which(model.RandomForest$err.rate[,"OOB"]== min(model.RandomForest$err.rate[,"OOB"]))[1]
#     b <- model.RandomForest$err.rate[which(model.RandomForest$err.rate[,"OOB"] 
#                                            == min(model.RandomForest$err.rate[,"OOB"]))[1]]
#     
#     cat("ntry:", ntry, " ")
#     cat("ntree:", a, ", ")
#     cat("xerror:", b, "  ;")
#   }
# }

# ntree_list <- c(50,100,500,1000)
# ntry_list <- c(1,2,3)
# ntree: 50  ntry: 0.1208671
# ntree: 50 ntry: 0.1239824
# ntree: 50 ntry: 0.1246875 //

# ntree: 99 ntry: 0.1186236
# ntree: 93 ntry: 0.1220979
# ntree: 99 ntry: 0.122803 //

# ntree: 215  ntry: 0.1172263
# ntree: 393  ntry: 0.1193928
# ntree: 375  ntry: 0.1211107 //

# ntree: 730  ntry: 0.116957
# ntree: 823  ntry: 0.1194954
# ntree: 968  ntry: 0.1204441

# The error rate has the smallest value when ntree=730, mtry=1.
model.final <- randomForest(as.factor(FireBand) ~ .,
                         data=traintree, 
                         ntree=730, mtry=1,
                         importance=TRUE, 
                         na.action=na.roughfix,
                         replace=TRUE)

# Print the importance for variables
importance_variable <- round(model.final$importance, 4)
importance_variable[-1,]

# Evaluate model
random_preds <- predict(model.final, newdata = testtree, type = 'class')
err_list <- table(testtree$FireBand, random_preds,dnn=c("Observed", "Predicted"))
err_list

# Calculate the rates of accuracy
Model[2]<- 'Random Forest'
Accuracy[2]  <- (sum(diag(err_list)))/sum(err_list) 
ErrorRate[2] <- 1 - Accuracy[2] 
FPR_0[2] <- (err_list[1,2]+err_list[1,3]+err_list[1,4]+err_list[1,5])/sum(err_list[1,])
FPR_1[2] <- (err_list[2,1]+err_list[2,3]+err_list[2,4]+err_list[2,5])/sum(err_list[2,])
FPR_2[2] <- (err_list[3,1]+err_list[3,2]+err_list[3,4]+err_list[4,5])/sum(err_list[3,])
FPR_3[2] <- (err_list[4,1]+err_list[4,2]+err_list[4,3]+err_list[4,5])/sum(err_list[4,])
FPR_4[2] <- (err_list[5,1]+err_list[5,2]+err_list[5,3]+err_list[5,4])/sum(err_list[5,])

# Merge all information together
OVERALL <-  data.frame(Model, Accuracy, ErrorRate,FPR_0,FPR_1,
                       FPR_2,FPR_3,FPR_4)
OVERALL

# Plot AUC curves (ROC)
library(ROCR)
par(mfrow= c(1,1))
roc.pred <- predict(model.final, testtree,type="prob")

ran_roc <- multiclass.roc(testtree$FireBand, roc.pred[,1])
auc(ran_roc)

plot(ran_roc$rocs[[1]],col='#cc0000')
ran_roc <- multiclass.roc(testtree$FireBand, roc.pred[,2])
plot.roc(ran_roc$rocs[[2]],add=TRUE,col='#cc9900')
ran_roc <- multiclass.roc(testtree$FireBand, roc.pred[,3])
plot.roc(ran_roc$rocs[[3]],add=TRUE,col='#99cc00')
ran_roc <- multiclass.roc(testtree$FireBand, roc.pred[,4])
plot.roc(ran_roc$rocs[[4]],add=TRUE,col='#cc33cc')
ran_roc <- multiclass.roc(testtree$FireBand, roc.pred[,5])
plot.roc(ran_roc$rocs[[5]],add=TRUE,col='#3300cc')
legend("bottomright", lty=1, cex=1, bty="n",
       c("Fire Category 1","Fire Category 2","Fire Category 3","Fire Category 4", "Fire Category 5"),
       col=c("#cc0000","#cc9900","#99cc00","#cc33cc","#3300cc"))

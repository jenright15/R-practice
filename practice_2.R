
library(MASS)
library(bestglm)
set.seed(438)
#1
#data preprocess
c_bool = rep(0,length(Boston$crim))
c_bool[Boston$crim>median(Boston$crim)] = 1
data_1 = data.frame(Boston,c_bool)
train_index = sample(1:nrow(data_1), nrow(data_1)*0.8)
test_index = -train_index
train_data = data_1[train_index,]
test_data = data_1[test_index,]

#logistic regression
logistic_all = glm(c_bool ~ .-crim, data = train_data, family = binomial)
logistic_all_pred = predict(logistic_all, test_data)
pred_bool=rep(0,length(logistic_all_pred))
pred_bool[logistic_all_pred>0.5] = 1
mean(pred_bool == test_data$c_bool)
#0.912
logistic_all = glm(c_bool ~ .-crim-zn, data = train_data, family = binomial)
logistic_all = glm(c_bool ~ .-crim-rm, data = train_data, family = binomial)
#both 0.923

#LDA
lda_all = lda(c_bool ~ .-crim, data = train_data)
lda_pred=predict(lda_all,test_data)
mean(lda_pred$class == test_data$c_bool)
#0.882
lda_all = lda(c_bool ~ .-crim-chas-chas-lstat-nox-indus-zn, data = train_data)
lda_pred=predict(lda_all,test_data)
mean(lda_pred$class == test_data$c_bool)
#0.853
library(class)
#knn


train_mod = train_data[ ,-which(names(train_data) %in% c("crim","c_bool"))]
test_mod = test_data[ ,-which(names(test_data) %in% c("crim","c_bool"))]
knn.pred = knn(train_mod, test_mod, train_data$c_bool, k = 10)
mean(knn.pred == test_data$c_bool)
#0.923


train_mod = train_data[ ,-which(names(train_data) %in% c("crim","c_bool","zn","rm"))]
test_mod = test_data[ ,-which(names(test_data) %in% c("crim","c_bool","zn","rm"))]
knn.pred = knn(train_mod, test_mod, train_data$c_bool, k = 10)
mean(knn.pred == test_data$c_bool)
#0.892





#2
data_2_a = data_2[ ,which(names(data_2) %in% c("V5","V6","V7","V8","V9","V10"))]
pairs(data_2_a[1:5])
cols <- character(nrow(data_2_a))
cols[]<-"black"
cols[data_2_a$V10 == 3] <- "blue"
cols[data_2_a$V10 == 2] <- "red"
pairs(data_2_a[1:5],col=cols)


lda_2 = lda(V10 ~ . , data = data_2_a)
lda_2_pred=predict(lda_2,data_2_a)
mean(lda_2_pred$class == data_2_a$V10)

qda_2 = qda(V10 ~ . , data = data_2_a)
qda_2_pred=predict(qda_2,data_2_a)
mean(qda_2_pred$class == data_2_a$V10)
#without CV qda is better

V5=c(0.98)
V6=c(122)
V7=c(544)
V8=c(186)
V9=c(184)
df=data.frame(V5,V6,V7,V8,V9)
predict(qda_2,df)
#3
predict(lda_2,df)
#2


4
set.seed(1)
x=rnorm(100)
y=x-2*x^2+rnorm(100)

x2=x^2
x3=x^3
x4=x^4

#LOOCVfrombestglm
LOOCV(as.matrix(x),as.matrix(y))
# 7.288162 16.662385
df=data.frame(x2,x)
LOOCV(df,as.matrix(y))
# 0.9374236 1.1941645
df=data.frame(x3,x2,x)
LOOCV(df,as.matrix(y))
# 0.9566218 1.2081650
df=data.frame(x4,x3,x2,x)
LOOCV(df,as.matrix(y))
# 0.9539049 1.1930592


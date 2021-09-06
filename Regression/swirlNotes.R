setwd(paste0(getwd(), "/Regression/"))

# lesson 1: intro
plot(child ~ parent, galton)
plot(jitter(child,4) ~ parent, galton)

# lm (y ~ x)
# lm (formula, dataset)
regrline <- lm(child ~ parent, galton)

# add line to plot -> abline
abline(regrline, lwd=3, col='red')

# check regression diagnostics
summary(regrline)

# lesson 2: residuals

# errors in estimates have mean zero, uncorrelated with predictors (x)
fit <- lm(child ~  parent, galton)
summary(fit)
fit$residuals # vector of residuals
mean(fit$residuals)
cov(fit$residuals, galton$parent)

sqe(ols.slope+sl,ols.intercept+ic) == (deviance(fit) + sum(est(sl,ic)^2))
ols.ic <- fit$coefficients[1]
ols.slope <- fit$coef[2]
all.equal(lhs, rhs)

varChild <- var(galton$child)
varRes <- var(fit$residuals)
varEst <- var(est(ols.slope, ols.ic))

# we have:
# var(data) = var(estimate) + var(residuals)

# hence, 
# the variance of the estimate is ALWAYS less than the variance of the data

# generate regression plot 
efit <- lm(accel ~ mag+dist, attenu)
mean(efit$residuals)
cov(efit$residuals, attenu$mag)

# lesson 3: least squares estimation
myPlot <- function(beta){
  y <- galton$child - mean(galton$child)
  x <- galton$parent - mean(galton$parent)
  freqData <- as.data.frame(table(x, y))
  names(freqData) <- c("child", "parent", "freq")
  plot(
    as.numeric(as.vector(freqData$parent)), 
    as.numeric(as.vector(freqData$child)),
    pch = 21, col = "black", bg = "lightblue",
    cex = .15 * freqData$freq, 
    xlab = "parent", 
    ylab = "child"
  )
  abline(0, beta, lwd = 3)
  points(0, 0, cex = 2, pch = 19)
  mse <- mean( (y - beta * x)^2 )
  title(paste("beta = ", beta, "mse = ", round(mse, 3)))
}

manipulate(myPlot(beta), beta = slider(0.4, .8, step = 0.02))

# recall:
# the slope of the regression line is the correlation
# between the two sets of heights multiplied by the ratio of the standard
# deviations (y to x or outcomes to predictors)

l_nor <- lm(gch_nor ~ gpa_nor)

# plot the original Galton data points with larger dots for more freq pts
y <- galton$child
x <- galton$parent
freqData <- as.data.frame(table(galton$child, galton$parent))
names(freqData) <- c("child", "parent", "freq")
plot(as.numeric(as.vector(freqData$parent)), 
     as.numeric(as.vector(freqData$child)), 
     pch = 21, col = "black", bg = "lightblue",
     cex = .07 * freqData$freq, xlab = "parent", ylab = "child")

# original regression line, children as outcome, parents as predictor
abline(mean(y) - mean(x) * cor(y, x) * sd(y) / sd(x), #intercept
       sd(y) / sd(x) * cor(y, x),  #slope
       lwd = 3, col = "red")

# new regression line, parents as outcome, children as predictor
abline(mean(y) - mean(x) * sd(y) / sd(x) / cor(y, x), #intercept
       sd(y) / cor(y, x) / sd(x), #slope
       lwd = 3, col = "blue")

# assume correlation is 1 so slope is ratio of std deviations
abline(mean(y) - mean(x) * sd(y) / sd(x), #intercept
       sd(y) / sd(x),  #slope
       lwd = 2)
points(mean(x), mean(y), cex = 2, pch = 19) #big point of intersection
 
# lesson 4: residual variation
fit <- lm(child ~ parent, galton)
sqrt(sum((fit$residuals)^2) /(n -2))
summary(fit)$sigma
sqrt(deviance(fit)/(n-2))
mu <- mean(galton$child)
sTot<- sum((galton$child - mu)^2)
sRes <- deviance(fit)
1 - sRes/sTot
summary(fit)$r.squared
cor(galton$parent, galton$child)^2

# lesson 5: multivariate regression
ones <- rep(1, nrow(galton))
lm(child ~ ones + parent -1, galton)
lm(child ~ 1, galton)

fit <- lm(Volume ~ Girth + Height + Constant -1, trees)
trees2 <- eliminate("Girth", trees)
fit2 <- lm(Volume ~ Height + Constant -1, trees2)
lapply(list(fit, fit2), coef)

# lesson 6: MultiVar examples 1
all <- lm(Fertility ~ ., swiss)
summary(all)
cor(swiss$Examination, swiss$Education)
cor(swiss$Agriculture, swiss$Education)
makelms()
ec <- swiss$Examination + swiss$Catholic
efit <- lm(Fertility ~ . + ec, swiss)
all$coefficients - efit$coefficients

# lesson 7: MultiVar examples 2
dim(InsectSprays)
summary(InsectSprays[,2])
sapply(InsectSprays, class)
fit <- lm(count ~ spray, InsectSprays)
summary(fit)$coef
est <- summary(fit)$coef[,1]

# -1 to omit the "intercept"
nfit <- lm(count ~ spray -1, InsectSprays)
summary(nfit)$coef
spray2 <- relevel(InsectSprays$spray, "C")
fit2 <- lm(count ~ spray2, InsectSprays)
summary(fit2)$coef
(fit$coef[2] - fit$coef[3]) / 1.6011

# lesson 8: MultiVar examples 3
dim(hunger)
fit <- lm(Numeric ~ Year, hunger)
summary(fit)$coef

# the following will not work
lmF <- lm(Numeric ~ Year, hunger[hunger$Sex=="Female"])
# rather use
lmF <- lm(Numeric[Sex=="Female"] ~ Year[Sex=="Female"], hunger)
lmM <- lm(Numeric[Sex=="Male"] ~ Year[Sex=="Male"], hunger)
lmBoth <- lm(Numeric ~ Year + Sex, hunger)
summary(lmBoth)
lmInter <- lm(Numeric ~ Year + Sex + Sex*Year, hunger)

# lesson 9: Residuals Diagnostics and Variation
fit <- lm(y ~ x, out2)
plot(fit, which = 1)
fitno <- lm(y ~ x, out2[-1,])
plot(fitno, which = 1)
coef(fit) - coef(fitno)
head(dfbeta(fit))
resno <- out2[1, "y"] - predict(fitno, out2[1,])
1-resid(fit)[1]/resno
head(hatvalues(fit))
sigma <- sqrt(deviance(fit)/(fit$df.residual))

# standardized residual
rstd <- resid(fit) / (sigma*sqrt(1-hatvalues(fit)))
head(cbind(rstd, rstandard(fit)))
plot(fit, which=3)
plot(fit, which = 2)
sigma1 <- sqrt(deviance(fitno) / fitno$df.residual)
resid(fit)[1] / (sigma1*sqrt(1 - hatvalues(fit)[1]))
head(rstudent(fit))

# Cook's distance
dy <- predict(fitno, out2) - predict(fit, out2)
sum(dy^2) / (2*sigma^2)
plot(fit, which = 5)

# lesson 10: Variance Inflation Factor
mdl <- lm(Fertility ~ ., swiss)
vif(mdl)
mdl2 <- lm(Fertility ~ .-Examination, swiss)
vif(mdl2)

# lesson 11: Overfitting and Underfitting
x1c <- simbias()
apply(x1c, 1, mean)
fit1 <- lm(Fertility ~ Agriculture, swiss)
fit3 <- lm(Fertility ~ Agriculture + 
             Examination + Education, swiss)
anova(fit1, fit3)
deviance(fit3)
d <- deviance(fit3) / 43
n <- (deviance(fit1) - deviance(fit3)) / 2
n / d
pf(n/d, 2, 43, lower.tail = FALSE)
shapiro.test(fit3$residuals)
anova(fit1, fit3, fit5, fit6)

# lesson 12: Binary Outcomes
ravenData
mdl <- glm(ravenWinNum ~ ravenScore, family = binomial, 
           data = ravenData)
lodds <- predict(mdl, data.frame(ravenScore=c(0,3,6)))
summary(mdl)
exp(confint(mdl))
anova(mdl)
qchisq(.95,1)

# lesson 13: Count Outcomes
var(rpois(1000,50))
# In a Poisson regression, the log of lambda is assumed to be a linear function of
# the predictors
class(hits[,'date'])
as.integer(head(hits[,'date']))
mdl <- glm(visits ~ date, family = poisson, data = hits)
summary(mdl)
exp(confint(mdl, 'date'))
which.max(hits[,'visits'])
hits[704,]
lambda <- mdl$fitted.values[704]
qpois(.95, lambda)
mdl2 <- glm(simplystats ~ date, family = poisson, data = hits,
            offset = log(visits+1))
qpois(.95, mdl2$fitted.values[704])

# Quiz 1
# Q1
x <- c(0.18, -1.54, 0.42, 0.95)
mean(x)

# Q2
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)
mydata <- data.frame(y,x)
fit1 <- lm(y~x, mydata)
summary(fit1)

# Q3
data("mtcars")
mtcars$cyl <- factor(mtcars$cyl)
fit1 <- lm(mpg ~ cyl + wt, mtcars)
fit2 <- lm(mpg ~ cyl, mtcars)
summary(fit1)$coef[3,1]
summary(fit2)$coef[3,1]


# Quiz 2
x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)
mydata <- data.frame(y,x)
fit1 <- lm(y~x, mydata)

fit_interaction <- lm(mpg ~ cyl + wt + cyl:wt, mtcars)
lm(mpg ~ I(wt * 0.5) + factor(cyl), data = mtcars)

# Quiz 4
install.packages("MASS")
library(MASS)
data("shuttle")
library(dplyr)
as.integer(tail(shuttle[,7], 30))
shuttle <- mutate(shuttle, use = relevel(use, ref = "noauto"))
shuttle$use.bin <- as.integer(shuttle$use) -1 
mymdl <- glm(use.bin ~ wind - 1, family = 'binomial', data = shuttle)
summary(mymdl)
exp(coef(mymdl))
exp(coef(mymdl))[1] / exp(coef(mymdl))[2] 

mymdl2 <- glm(use.bin ~ wind + magn - 1, family = 'binomial', data = shuttle)
exp(coef(mymdl2))[1] / exp(coef(mymdl2))[2] 

x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)

plot(x, y, pch = 21,  cex = 2, col="grey20", bg="cadetblue2")

knots <- 0
splineTerms <- sapply(knots, function(knot) (x > knot) * (x - knot))
xmat <- cbind(1, x, splineTerms)
mdl6 <- lm(y~xmat-1)
yhat<-predict(mdl6)
lines(x, yhat, col = "red", lwd = 2)
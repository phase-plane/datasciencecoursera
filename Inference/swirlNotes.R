#  swirl exercises

packageVersion("swirl") 
install_from_swirl("Statistical Inference")

# lesson 7: Common Distributions
choose(n,x)

choose(5,5) * (0.8)^5 * (1-0.8)^(5-5) + 
  choose(5,4) * (0.8)^4 * (1-0.8)^(5-4) + 
  choose(5,3) * (0.8)^3 * (1-0.8)^(5-3)

pbinom(2, 5, .8, lower.tail = FALSE)

# returns value of x (quantile), 0.1 to the left
qnorm(0.1)

qnorm(0.975, mean = 3, sd = 2)

# probability that X > 1200
pnorm(1200, mean = 1020, sd = 50, lower.tail = FALSE)

pnorm((1200 - 1020) / 50, lower.tail = FALSE)
qnorm(.75, mean = 1020, sd = 50)

ppois(3, 2.5*4)

# use Poisson to estimate Binomial
pbinom(5, 1000, .01)
ppois(5, 1000*.01)

# lesson 8: Asymptotics 7 confidence intervals
qnorm(.95)

.6 + c(-1,1)*qnorm(.975)*sqrt(.6 *.4/100)
binom.test(60, 100)$conf.int

lamb + c(-1,1)*qnorm(.975)*sqrt(lamb/94.32)
poisson.test(5, 94.32)$conf

# lesson 9: t confidence intervals
qt(p = .975, df = 2)
range()
s <- sd(difference)
mn + c(-1,1)*qt(.975, 9)*s/sqrt(10)
t.test(difference)$conf.int

# 4 methods
rbind(
  mn + c(-1, 1) * qt(.975, n-1) * s / sqrt(n),
  as.vector(t.test(difference)$conf.int),
  as.vector(t.test(g2, g1, paired = TRUE)$conf.int),
  as.vector(t.test(extra ~ I(relevel(group, 2)), paired = TRUE, data = sleep)$conf.int)
)

sp <- (8-1)*15.34^2 + (21-1)*18.23^2
ns <- 7 + 20
sp <- sqrt(sp/ns)

132.86-127.44 + c(-1,1)*qt(.975, ns)*sp*sqrt(1/8 + 1/21)

sp <- sqrt((9*var(g1) + 9*var(g2)) / 18)
md + c(-1,1)*qt(.975,18)*sp*sqrt(1/10 + 1/10)
# or
t.test(g2,g1, paired = FALSE, var.equal = TRUE)$conf
t.test(g2,g1, paired = TRUE)$conf

num <- (15.34^2 / 8 + 18.23^2 / 21)^2

den <- 15.34^4/8^2/7 + 18.23^4/21^2/20

132.86 - 127.44 + c(-1,1)*qt(.975, mydf)*sqrt(15.34^2 / 8 + 18.23^2 / 21)
# rather call
t.test(var.equal = FALSE)

# lesson 10: hypothesis testing
t.test(fs$fheight, fs$sheight, paired = TRUE)

# lesson 11: p-values
pt(q = 2.5, df = 15, lower.tail = FALSE)
qnorm(0.95)
pnorm(2)
pnorm(2, lower.tail = FALSE)
pbinom(6, size=8, prob=.5, lower.tail = FALSE) # P(X > 6)
pbinom(7, 8, .5, lower.tail = TRUE) # P(X <= 7)

ppois(9, 5, lower.tail = FALSE)

# lesson 12: power

# We have not fixed the probability 
# of a type II error (accepting H_0 when it is false), 
# called beta. 

# The term POWER refers to the quantity 1-beta,
# and it represents the probability of rejecting H_0 when it's false.

# This is used to determine appropriate sample sizes in experiments.

# the probability of rejecting the null hypothesis when it is false,
# which is good and proper

# comes into play when you're designing an experiment

# to determine if a null result (failing to reject a null hypothesis) is meaningful
# <=>
# Power gives you the opportunity to detect if your ALTERNATIVE hypothesis is true

# things that increase power:
# 1. sample size
# 2. more extreme alt. hypothesis
# 3. lower sample standard dev.

# power increases as larger values of alpha are used

# (mu_a - mu_0) / sigma is called the EFFECT SIZE
power.t.test(n = 16, delta = 2 / 4, sd=1, type = "one.sample", 
             alt = "one.sided")$power

# keeping the effect size (the ratio delta/sd) constant preserved the power

# we could also:
# specify a power we want and solve for the sample size n

power.t.test(power = .8, delta = 2 / 4, sd=1, 
             type = "one.sample", alt = "one.sided")$n

power.t.test(n = 26, sd = 1, power = .8, 
             type = "one.sample", alternative = "one.sided")$delta

# lesson 13: multiple testing

# multiple testing addresses compensating for errors
sum(pValues < 0.05)
sum(p.adjust(pValues, method = "bonferroni") < 0.05)
sum(p.adjust(pValues, method = "BH") < 0.05)
table(pValues2 < 0.05, trueStatus)
table(p.adjust(pValues2, method = "bonferroni") < 0.05, trueStatus)

# lesson 14: resampling methods
# bootstrapping & permutation testing

# The basic bootstrap principle uses OBSERVED data to construct an
# ESTIMATED population distribution using random sampling with replacement. 
# From this distribution (constructed from the observed data) we can estimate the
# distribution of the statistic we're interested in.

# bootstrapping
median(resampledMedians)
median(sh)
sam <- sample(fh, nh*B, replace = TRUE)
resam <- matrix(sam, nrow = B, ncol = nh)
meds <- apply(resam, 1, median)
quantile(resampledMedians, c(.025, .975))

# permutation testing
dim(InsectSprays)
names(InsectSprays)
range(Bdata$count)
sample(group)

# code used in project:
data(ToothGrowth)
head(ToothGrowth)
names(ToothGrowth)

Length <- ToothGrowth$len
Supplement <- ToothGrowth$supp

summary(ToothGrowth)
boxplot(Length~Supplement, data = ToothGrowth, 
        main = "Summary Statistics", col = c("red", "grey"), 
        horizontal = TRUE)
tapply(Length, Supplement, mean)


Dose05 <- t.test(len ~ supp, 
              data = rbind(ToothGrowth[(ToothGrowth$dose == 0.5) & 
                                         (ToothGrowth$supp == "OJ"),],
                           ToothGrowth[(ToothGrowth$dose == 0.5) & 
                                         (ToothGrowth$supp == "VC"),]), 
              var.equal = FALSE)

Dose1 <- t.test(len ~ supp, 
             data = rbind(ToothGrowth[(ToothGrowth$dose == 1) & 
                                        (ToothGrowth$supp == "OJ"),],
                          ToothGrowth[(ToothGrowth$dose == 1) & 
                                        (ToothGrowth$supp == "VC"),]), 
             var.equal = FALSE)

Dose2 <- t.test(len ~ supp, 
             data = rbind(ToothGrowth[(ToothGrowth$dose == 2) & 
                                        (ToothGrowth$supp == "OJ"),],
                          ToothGrowth[(ToothGrowth$dose == 2) & 
                                        (ToothGrowth$supp == "VC"),]), 
             var.equal = FALSE)


results <- data.frame(
  "p-value" = c(Dose05$p.value, Dose1$p.value, Dose2$p.value),
  "Conf.Low" = c(Dose05$conf.int[1],Dose1$conf.int[1], Dose2$conf.int[1]),
  "Conf.High" = c(Dose05$conf.int[2],Dose1$conf.int[2], Dose2$conf.int[2]),
  row.names = c("Dosage 0.5","Dosage 1","Dosage 2"))

results
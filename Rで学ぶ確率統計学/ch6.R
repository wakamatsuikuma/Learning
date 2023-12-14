# 95%信頼区間と真の平均
n <- 50
plot(c(0, n), c(35, 65), type="n", axes=FALSE, xlab="", ylab="")
axis(1)

abline(h=50) # 真の値

y1 <- y2 <- numeric(n)
for(i in 1:n){
  y <- rnorm(20, 50, 10) # 個数20, 平均50, 標準偏差10の乱数
  y1[i] <- t.test(y)$conf.int[1]
  y2[i] <- t.test(y)$conf.int[2]
  segments(i, y1[i], i, y2[i])
}


# 1変数での区間推定
sugar <- c(10.2, 10.0, 9.9, 9.8, 10.1)
t.test(sugar, mu=10.5)

# data:  sugar
# t = -7.0711, df = 4, p-value = 0.002111
# alternative hypothesis: true mean is not equal to 10.5
# 95 percent confidence interval:
#   9.803676 10.196324
# sample estimates:
#   mean of x 
# 10 
# 結果: 10.5は母平均とはいえない


# 対標本の平均値の比較
bfr <- c(18, 12, 16, 15, 20)
aft <- c(15, 13, 14, 11, 17)

t.test(bfr, aft, paired=TRUE, alternative="greater")
# data:  bfr and aft
# t = 2.5574, df = 4, p-value = 0.0314
# alternative hypothesis: true mean difference is greater than 0
# 95 percent confidence interval:
#   0.3661161       Inf
# sample estimates:
#   mean difference 
# 2.2 
# 結果: 差あり

# 対応の無い2標本の母平均の差の検定(Weltchの検定)
men <- c(79, 56, 91, 60, 51, 82)
women <- c(97, 66, 83, 75, 53)

t.test(men, women)

# data:  men and women
# t = -0.49733, df = 8.5542, p-value = 0.6315
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -27.73893  17.80560
# sample estimates:
#   mean of x mean of y 
# 69.83333  74.80000 
# 結果: 差異なし


# コーエンの効果量
install.packages("effsize")
library(effsize)
set.seed(100)
x <- rnorm(100, 50, 10)
y <- rnorm(100, 55, 15)
cohen.d(x, y)
# Cohen's d
# 
# d estimate: -0.46251 (small)
# 95 percent confidence interval:
#      lower      upper 
# -0.7450994 -0.1799206 
# 効果量は0.5。バラつきを考慮した上での差。


# 信頼区間の変化
plot(c(0, n), c(50, 90), type="n")

x <- read.csv("csv/blood pressure.csv")[ , "diastolic.blood.pressure"]
x
n = length(x)
y1 <- y2 <- numeric(n)
for ( i in 3:n){
  y1[i] <- t.test(x[1:i])$conf.int[1]
  y2[i] <- t.test(x[1:i])$conf.int[2]
  segments(i, y1[i], i, y2[i])
}

# Welthの検定
x1 <- c(35, 29, 29, 28, 27, 26, 24, 23, 17, 14)
x2 <- c(19, 19, 16, 15, 15, 14, 14, 13, 12, 10)
t.test(x1, x2)

# data:  x1 and x2
# t = 4.9333, df = 12.696, p-value = 0.000293
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   5.890717 15.109283
# sample estimates:
#   mean of x mean of y 
# 25.2      14.7 
# 結果:有意差あり

# sleepの検定
head(sleep)
length(sleep)
x1 <- sleep[ , "extra"][1:10]
x2 <- sleep[ , "extra"][11:20]
t.test(x1, x2, paired = TRUE, alternative = "less")
# 伸ばす効果あり

# 信頼区間にどれぐらい入るかのシミュレーション
count <- 0
for (i in 1:1000){
  x <- rnorm(10, 50, 10)
  count <- count + (t.test(x, mu = 50)$p.value < 0.05)
}
print(count)



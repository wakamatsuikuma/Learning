
# ch3
# 1. ポアソン分布の描画
k <- 50
lambda = 2
print(dpois(0:k, lambda=lambda))
barplot(dpois(0:k, lambda=lambda), name=0:k, xlab="x")

k <- 50
lambda = 20
print(dpois(0:k, lambda=lambda))
barplot(dpois(0:k, lambda=lambda), name=0:k, xlab="x")
## ラムダが大きいと正規分布っぽくなる


# 2. 対数正規分布の描画（関数の挙動の確認）
rlognormal <- function(nsize=10, mean =1, sd =1){
  a <- log(1+sd^2/mean^2)
  mean_log <- log(mean) -0.5 * a
  sd_log <- sqrt(a)
  
  return (rlnorm(nsize, meanlog <- mean_log, sdlog <- sd_log))
  
}

x1 <- rlnorm(10000, meanlog <- 10, sdlog <- 3 )
x2 <- rlognormal(10000, meanlog <- 10, sdlog <- 3)
x3 <- log10(rnorm(10000, mean <- 10, sd <- 3))

hist(x1, prob=TRUE)
hist(x2, prob=TRUE)
hist(x3, prob=TRUE)
## ちょっとよくわからない挙動。rlnormで指定するmeanlogとsdlogが何の確率分布をもつデータの、どの統計量を指定しているのか？


# ch4
# cauchy distribution
x <- rcauchy(1000)
hist(x)

# monte carlo method
x <- runif(10000, 0, 1)
y <- runif(10000, 0, 2)
plot(x, y, col = ifelse( (x^2+(y-1)^2<=1)&((x-2)^2+y^2<=4), "black", "white"), pch = 20, asp = 1)
# area calculating
1 * 2 * sum((x^2+(y-1)^2<=1)&((x-2)^2+y^2<=4)) / 10000

# exponential distribution and CLT
x <- rexp(1000*3,rate=5)
xm3 <- matrix(x,nrow=1000,ncol=3)
z3 <- apply(xm3,1,mean)
hist(z3, prob=TRUE, xlim=c(0,0.60), ylim=c(0,5))
par(new=TRUE)
plot(function(x)dnorm(x,mean=mean(z3),sd=sd(z3)), 
     xlim=c(0,0.60),ylim=c(0,5))


# ch5
# maximum likelihood method by fitdistr
library(MASS)
n <- 10000
x <- rexp(n, rate = 3.8)
hist(x, prob=TRUE)
fitdistr(x, "exponential")
curve(dexp(x, 3.819932), add = TRUE)
# > fitdistr(x, "exponential")
# rate   
# 3.83121147 
# (0.03831211)

# estimation of parameter by fitdistr
library(MASS)
?fitdistr
n <- 10000
x_norm <- rnorm(n, 3, 8)
x_poisson <- rpois(n, 3)
x_cauchy <- rcauchy(n, 2, 4)
fitdistr(x_norm, "normal")
fitdistr(x_poisson, "Poisson")
fitdistr(x_cauchy, "cauchy")
# > fitdistr(x_norm, "normal")
# mean          sd    
# 2.94968200   8.02943956 
# (0.08029440) (0.05677671)
# > fitdistr(x_poisson, "Poisson")
# lambda  
# 3.01470000 
# (0.01736289)
# > fitdistr(x_cauchy, "cauchy")
# location      scale   
# 1.95517690   3.95794184 
# (0.05593227) (0.05601549)


# ch6
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
# [1] 49
# 1,000回中49回であり、おおよそ5 %


# ch7
# 適合度検定
nankai <- c(0, 2, 0, 0, 0, 0, 0, 2, 1, 1, 1, 5)
chisq.test(nankai) # pのデフォルトは一様分布

# カイ二乗分布
N <- 1000 # サンプル数
p <- c(10, 9, 8, 7, 6, 5, 4, 3, 2, 1) / 55 
x <- rmultinom(N, size = 100, prob = p)
expmatrix <- rep(N * p, N)
z <- x - expmatrix
chisqval <- apply(z*z/expmatrix, 2, sum)
# print(x)
# print(expmatrix)
# print(z)
# print(chisqval)
hist(chisqval)

# メンデルのえんどう豆の形質の遺伝のカイ二乗検定
total <- 556
expect_prob <- c(9, 3, 3, 1) / 16
obs_data <- c(315, 101, 108, 32)
chisq.test(obs_data, p = expect_prob)
# Chi-squared test for given probabilities
# 
# data:  obs_data
# X-squared = 0.47002, df = 3, p-value = 0.9254
# 結果: 仮説は棄却されない

# サークルの血液型の分布のカイ二乗検定
population_prob <- c(0.38, 0.31, 0.22, 0.09)
obs_data <- c(15, 9, 2, 1)
chisq.test(obs_data, p = population_prob)

obs_data_10 <- obs_data * 10
chisq.test(obs_data_10, p = population_prob)
# サンプルサイズを10倍した方は棄却


# 次のAが自由度2のカイ二乗分布に従うことの確認
x1 <- rnorm(10000)
x2 <- rnorm(10000)
x3 <- rnorm(10000)
m <- (x1 + x2 + x3) / 3
A <- (x1 - m)^2 + (x2- m)^2 + (x3 - m)^2

hist(A, ylim = c(0, 0.5), prob = TRUE) # Aのヒストグラム
curve(dchisq(x, df = 2), add = TRUE) # 自由度2のカイ二乗統計量の分布

# 次のBが自由度3のカイ二乗分布に従うことの確認
x1 <- rnorm(10000)
x2 <- rnorm(10000)
x3 <- rnorm(10000)
B <- x1^2 + x2^2 + x3^2

hist(B, ylim = c(0, 0.25), prob = TRUE) # Bのヒストグラム
curve(dchisq(x, df = 3), add = TRUE) # 自由度3のカイ二乗統計量の分布


# ch8
# 1行のカイ二乗検定と残差分析
num <- c(48, 52, 59, 71, 64, 50, 35, 49)
chisq.test(num)
# X-squared = 15.963, df = 7, p-value = 0.02546 -> 有意であり、関係はありそう
result <- chisq.test(num)
result$stdres
pnorm(abs(result$stdres), lower.tail = FALSE)*2 
# 標準化残差の絶対値をとることで、lower.tail=FALSEおよび2かけでの両側検定とすることができている
# 有意に4-5は多く、7-8は少ないと判定できる


# 入試結果の分析
seq <- c(220 - 57, 266 - 48, 57, 48)
table <- matrix(seq, 2, 2)
chisq.test(table)
# 性別と合格のしやすさが独立は棄却できる
result <- chisq.test(table)
result$stdres
pnorm(abs(result$stdres), lower.tail = FALSE) * 2
# 残差分析の結果のp値が5%未満であるので、そうであると言える。


# サリドマイドと奇形の有無
seq <- c(90, 22, 2, 186)
table <- matrix(seq, 2, 2)
result <- chisq.test(table)
result
result$stdres
pnorm(abs(result$stdres), lower.tail = FALSE) * 2
# カイ二乗検定の結果、有意であると判定できる
# 残差分析の結果、服用することで症状が発生するという判定ができる


# 予防接種と罹患の関係
# 関係性があるかどうかをカイ二乗検定し、有意となった場合は残差分析を行い有効性の評価を行う
seq <- c(1, 15, 22, 62)
table <- matrix(seq, 2, 2)
chisq.test(table)
chisq.test(table, correct = FALSE)
# イェーツの補正をしなくても棄却できない。効果があるとはいえない。


# ch9
# 回帰分析における定数項の有無による決定係数の変化
plot(cars) # 散布図
res_const <- lm(data = cars, formula = dist ~ speed)
res_no_const <- lm(data = cars, formula = dist ~ speed - 1)
summary(res_const)
summary(res_no_const)
abline(res_const)
abline(res_no_const, lty = "dotted")
# Multiple R-squared:  0.6511,	Adjusted R-squared:  0.6438 
# Multiple R-squared:  0.8963,	Adjusted R-squared:  0.8942 
# 定数項が無い方(パラメータが少ない方)が決定係数が大きくなっていて(当てはまりの良いモデルになっている)違和感
# これは定数項が無い時点で、決定係数の定義が当てはまりを評価できない式になってしまい、本来の意味を失うため


# オゾン量とオゾン濃度の関係
w <- airquality$Wind
o <- airquality$Ozone
plot(w, o)
res <- lm(data = airquality, formula = Ozone ~ Wind)
abline(res)
summary(res)
# 5.55 ppb減少


# ch10
# 定数項有り: R2とAICの両方を比較
res_liner <- lm(data = women, formula = weight ~ height)
res_quad <- lm(data = women, formula = weight ~ I(height^2) + height)
plot(women)
abline(res_liner)
lines(women$height, fitted(res_quad))
summary(res_liner)
summary(res_quad)
AIC(res_liner, res_quad)
# R2ではそこまで差が無いが、AICでは顕著に差が見られた。2次式の方が当てはまりが良い。


# 定数項0: R2は本来の意味を失うので、AICで当てはまりを比較する
res_liner <- lm(data = women, formula = weight ~ height - 1)
res_quad <- lm(data = women, formula = weight ~ I(height^2) + height - 1)
plot(women)
abline(res_liner)
lines(women$height, fitted(res_quad))
AIC(res_liner, res_quad)
# こちらも2次式の方が当てはまりが良い。


# 等高線の描画（KL(カルバック・ライブラー)情報量をイメージ）。
x <- seq(-5, 5, length = 1000)
y <- seq(0.1, 8, length = 1000)
z <- outer(x, y, function(x, y) x^2/(2*y^2) + log(y) + (1 / y^2 - 1) / 2)
filled.contour(x, y, z, level = seq(0.01, 2, by=0.5))


# ch11
# Prestigeの回帰分析における対数変換有無の比較

## install.packages("car")
## library("car")
head(Prestige)
income <- Prestige$income
hist(income, breaks = 10)
hist(log(income), breaks = 10) # 正規分布っぽくなっている

res1 <- lm(data = Prestige, formula = prestige ~ education + income)
res2 <- lm(data = Prestige, formula = prestige ~ education + log(income))
summary(res1)
summary(res2)
AIC(res1, res2)
# R2、AICの双方の観点で対数変換した方が当てはまりが良好

# 定数項が0としても回帰分析（"prestigeはアンケート結果であり、負の値は発生し得ない"という考え方）
#　一方で、収入0ということは仕事をしていないとも考えられ、アンケート対象となり得ないとも考えられる
res1 <- lm(data = Prestige, formula = prestige ~ education + income - 1)
res2 <- lm(data = Prestige, formula = prestige ~ education + log(income) - 1)
summary(res1)
summary(res2) 
# res2(対数変換)のlog(income)の偏回帰係数が有意で無かった。


# Productionの回帰分析。
# コブ・ダグラス型生産関数のパラメータ推定(収穫一定)
# 式変形により、以下の回帰モデルで分析が可能
data <- read.csv("csv/Production.csv")
res <- lm(data = data, formula = I(log(Output) - log(Capital)) ~ I(log(Labor) - log(Capital)))
summary(res)

# ch12
# 交互作用項を含めた上での変数選択の比較
airquality
res1 <- lm(data = airquality, formula = Ozone ~ (Solar.R + Wind + Temp)^2)
res2 <- lm(data = airquality, formula = Ozone ~ Wind + Temp + Solar.R:Temp + Wind:Temp)
summary(res1)
summary(res2)
AIC(res1, res2)
# 偏回帰係数は全て有意であるが、R2とAICで見ると全選択している方が当てはまりは良い

# 試験に対する補習の効果の有無の推定
x1 <- c(58, 48, 93, 87, 66, 91, 24, 90, 60, 72, 45, 20)
x2 <- c(68, 61, 82, 77, 62, 80, 56, 79, 59, 66, 67, 50)
z <- c(1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1)
res <- lm(formula = x2 ~ x1 + z)
summary(res)

# 因果構造はz -> x2 <- x1, x1 -> z
# 有意であり、補習の効果は11点上昇

# ch13



# ch14

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


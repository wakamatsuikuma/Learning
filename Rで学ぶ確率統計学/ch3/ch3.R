
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
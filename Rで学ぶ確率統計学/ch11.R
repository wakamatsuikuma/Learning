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
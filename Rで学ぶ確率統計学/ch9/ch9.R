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
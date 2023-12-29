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

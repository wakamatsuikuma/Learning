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
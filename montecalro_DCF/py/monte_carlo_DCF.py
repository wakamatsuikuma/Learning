import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
from matplotlib import font_manager 

# 生成するシナリオの数
num_scenarios = 10000

# キャッシュフロー予測期間（年）
prediction_period = 5

# WACC( = 割引率、要求収益率)の計算
cost_of_equity = 0.2 # 株主資本コスト
cost_of_debt = 0.03 # 負債コスト
tax_rate = 0.3 # 実効税率
market_capitalization = 20e6 # 株式時価総額
debt = 30e6 # 有利子負債
asset = market_capitalization + debt
required_rate_of_return = (
    cost_of_equity * (market_capitalization / asset) + 
    cost_of_debt * (debt / asset) * (1 - tax_rate)
)
print(f"WACC: {required_rate_of_return}")

# 開始FCFE
initial_FCFE = 10e6

# 成長率
growth_rate = 0.1
# 成長率の変動
std_growth_rate = growth_rate * 0.1

# 永久成長率
terminal_growth_rata = 0.01

# シミュレーション
present_FCFE_li_2d = []
present_terminal_value_li = []
present_value_li = []
for _ in range(num_scenarios): 

    # 予測期間のキャッシュフロー
    future_FCFE = initial_FCFE
    future_FCFE_li =[]
    for i in range(prediction_period):
        future_FCFE = future_FCFE * (1 + np.random.normal(growth_rate, std_growth_rate))
        future_FCFE_li.append(future_FCFE)

    # キャッシュフローの現在価値
    present_FCFE_li = []
    for i, fcfe in enumerate(future_FCFE_li):
        present_fcfe = fcfe/(1 + required_rate_of_return)**(i+1)
        present_FCFE_li.append(present_fcfe)

    # ターミナルバリューの現在価値
    terminal_value = future_FCFE_li[prediction_period - 1] / (required_rate_of_return - terminal_growth_rata)
    present_terminal_value = terminal_value / ( 1 + required_rate_of_return )**(prediction_period)

    # 現在価値
    present_value = sum(present_FCFE_li) + present_terminal_value

    # present_FCFE_li_2d.append(present_FCFE_li)
    # present_terminal_value_li.append(present_terminal_value)
    present_value_li.append(present_value)

# 現在価値の分布を描画
present_values = np.array(present_value_li)
font = font_manager.FontProperties(family='Arial', size=14)
plt.style.use('bmh')
fig, ax = plt.subplots(figsize=(12, 8))
ax.hist(present_values, bins=25, color='#006699')

ax.set_title("Distribution of the company value", fontproperties=font)
ax.set_xlabel("value", fontproperties=font)
ax.set_ylabel("frequency", fontproperties=font);
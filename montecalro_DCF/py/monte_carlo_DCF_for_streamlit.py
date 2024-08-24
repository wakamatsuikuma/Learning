# waccの小数点丸める、中央値と95%信頼区間の表示、他の可視化、三角分布の適用、割引率算定に何かしらの数理モデル実装
import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
from matplotlib import font_manager 
from matplotlib.lines import Line2D
import streamlit as st

# wacc計算の関数
def calc_wacc(cost_of_equity, cost_of_debt, tax_rate,
         market_capitalization, debt):
    
    asset = market_capitalization + debt
    required_rate_of_return = (
        cost_of_equity * (market_capitalization / asset) + 
        cost_of_debt * (debt / asset) * (1 - tax_rate)
    )
    return required_rate_of_return

# シミュレーション関数(初期値は入力済み)
def monte_carlo_dcf_simulation(num_scenarios = 10000, prediction_period = 5, 
                               cost_of_equity = 0.2, cost_of_debt = 0.03, tax_rate = 0.3,
                               market_capitalization = 20e6, debt = 30e6, initial_FCFF = 10e6,
                               growth_rate = 0.1, std_growth_rate = 0.1, terminal_growth_rata = 0.01):
    # 割引率
    required_rate_of_return = calc_wacc(cost_of_equity, cost_of_debt, 
                                        tax_rate, market_capitalization, debt)
    future_FCFF_li_2d =[]
    present_FCFF_li_2d = []
    present_terminal_value_li = []
    present_value_li = []
    for _ in range(num_scenarios):

        # 予測期間のキャッシュフロー
        future_FCFF = initial_FCFF
        future_FCFF_li =[]
        for i in range(prediction_period):
            future_FCFF = future_FCFF * (1 + np.random.normal(growth_rate, growth_rate * std_growth_rate))
            future_FCFF_li.append(future_FCFF)

        # 予測期間のキャッシュフローの現在価値
        present_FCFF_li = []
        for i, fcfe in enumerate(future_FCFF_li):
            present_fcff = fcfe/(1 + required_rate_of_return)**(i+1)
            present_FCFF_li.append(present_fcff)

        # ターミナルバリュー（継続価値）の現在価値
        terminal_value = (
            future_FCFF_li[prediction_period - 1] * (1 + terminal_growth_rata)
            / (required_rate_of_return - terminal_growth_rata)
        )
        present_terminal_value = terminal_value / ( 1 + required_rate_of_return )**(prediction_period)

        # 現在価値
        present_value = sum(present_FCFF_li) + present_terminal_value

        future_FCFF_li_2d.append(future_FCFF_li)
        present_FCFF_li_2d.append(present_FCFF_li)
        present_terminal_value_li.append(present_terminal_value)
        present_value_li.append(present_value)

    pres_value_median = np.median(present_value_li)
    pres_value_2_5_per = np.percentile(present_value_li, 2.5)
    pres_value_5_per = np.percentile(present_value_li, 97.5)
    pres_value_95_per = np.percentile(present_value_li, 2.5)
    pres_value_97_5_per = np.percentile(present_value_li, 97.5)


    result = {
        "future_FCFF_li_2d":future_FCFF_li_2d,
        "present_value_li": present_value_li,
        "present_FCFF_li_2d":present_FCFF_li_2d,
        "present_terminal_value_li":present_terminal_value_li, 
        "wacc": required_rate_of_return,
        "pres_value_median": pres_value_median,
        "pres_value_2_5_per": pres_value_2_5_per,
        "pres_value_5_per": pres_value_5_per,
        "pres_value_95_per": pres_value_95_per,
        "pres_value_97_5_per": pres_value_97_5_per
    }
    
    return result


# アプリ
# タイトルとアプリ説明
st.title('モンテカルロDCF法: 事業価値の算定')

# ===パラメータ設定===

# 任意に設定
num_scenarios = st.number_input('シミュレーション回数', value=10000)
prediction_period = st.number_input('キャッシュフロー予測期間（年）', value=5)
growth_rate = st.number_input('成長率', value=0.1)
std_growth_rate = st.number_input('成長率の変動(=成長率の標準偏差):成長率に対しての比率', value=0.1)
terminal_growth_rata = st.number_input('永久成長率', value=0.01)

# 割引率の計算
cost_of_equity = st.number_input('株主資本コスト', value=0.2)
cost_of_debt = st.number_input('負債コスト', value=0.03)
tax_rate = st.number_input('実効税率', value=0.3)
market_capitalization = st.number_input('株式時価総額', value=20e6)
debt = st.number_input('有利子負債', value=30e6)
asset = market_capitalization + debt
required_rate_of_return = (
    cost_of_equity * (market_capitalization / asset) + 
    cost_of_debt * (debt / asset) * (1 - tax_rate)
)

# フリーキャッシュフロー
initial_FCFF = st.number_input('開始FCFE', value=10e6)

# シミュレーション
if st.button("シミュレーション実行"):

    # 処理
    calc_result = monte_carlo_dcf_simulation(num_scenarios, prediction_period, 
                                cost_of_equity, cost_of_debt, tax_rate,
                                market_capitalization, debt, initial_FCFF,
                                growth_rate, std_growth_rate, terminal_growth_rata)

    # 結果取得
    present_value_li = calc_result["present_value_li"]
    wacc = round(calc_result["wacc"] * 100, 1)
    pres_value_median = round(calc_result["pres_value_median"])
    formatted_pres_value_median = f"{pres_value_median:,}"
    pres_value_2_5_per = round(calc_result["pres_value_2_5_per"])
    pres_value_97_5_per = round(calc_result["pres_value_97_5_per"])
    formatted_pres_value_2_5_per = f"{pres_value_2_5_per:,}"
    formatted_pres_value_97_5_per = f"{pres_value_97_5_per:,}"
    present_FCFF_array = np.array(calc_result["present_FCFF_li_2d"])
    future_FCFF_array = np.array(calc_result["future_FCFF_li_2d"])

    # wacc表示
    st.write(f"割引率(=wacc): {wacc:.1f}%")
    st.write(f"現在価値の中央値: {formatted_pres_value_median}'円")
    st.write(f"現在価値の95%信頼区間: {formatted_pres_value_2_5_per}円 〜 {formatted_pres_value_97_5_per}円")

    # ヒストグラム可視化
    present_values = np.array(present_value_li)
    fig, ax = plt.subplots()
    ax.hist(present_values, bins=100, edgecolor='black')
    ax.set_title('Distribution of the present value')
    ax.set_xlabel('Value')
    ax.set_ylabel('Frequency')
    st.pyplot(fig) # アプリ描画

    # グラフを作成
    fig1, ax1 = plt.subplots()
    # 将来キャッシュフローの推移
    for row in future_FCFF_array:
        line_data = np.insert(row, 0, initial_FCFF)  # 始点を10000000に設定
        ax1.plot(line_data, color="blue", linewidth=0.5, alpha=0.05)

    # 将来キャッシュフローを現在価値に直した場合の推移
    for row in present_FCFF_array:
        line_data = np.insert(row, 0, initial_FCFF)  # 始点を10000000に設定
        ax1.plot(line_data, color="green", linewidth=0.5, alpha=0.05)

    legend_elements = [Line2D([0], [0], color='blue', label='Future'),
                    Line2D([0], [0], color='green', label='Present')]
    ax1.legend(handles=legend_elements, loc='upper left') # 凡例を追加

    ax1.set_title('FCFF trend')
    ax1.set_xlabel('year')
    ax1.set_ylabel('value')
    st.pyplot(fig1) # アプリの描画
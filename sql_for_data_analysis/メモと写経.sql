-- postgresql起動
brew services start postgresql

-- データベース一覧表示
psql -l

-- データベースにログイン
psql (データベース名)

-- データベースからログアウト
\q

-- postgresql停止
brew services stop postgresql

-- 
select count(*) 
from retail_sales;

select convert_timezone('pst', '2023-091-01 00:00:00 -0');

select sales_month, sum(sales)
from retail_sales
group by sales_month;

-- 毎月の小売および食品サービス売上高のトレンド
select sales_month, sales
from retail_sales
where kind_of_business='Retail and food services sales, total'
order by sales_month
;

-- 年間の小売および食品サービス売上高のトレンド
with a as(
    select
        date_part('year', sales_month) as sales_year, 
        sum(sales) as sales
    from retail_sales
    where kind_of_business='Retail and food services sales, total'
    group by sales_month
    order by sales_month
)
select
    sales_year,
    sum(sales) as sales
from a
group by sales_year
order by sales_year
;

-- 年間のスポーツ用品、趣味、楽器、書籍の売り上げ
with a as(
select
    date_part('year', sales_month) as sales_year,
    kind_of_business,
    sum(sales) as sales
from retail_sales
where 
    kind_of_business in 
    ('Book stores','Sporting goods stores','Hobby, toy, and game stores')
group by sales_month, kind_of_business
order by sales_month
)

select
    sales_year,
    kind_of_business,
    sum(sales) as sales
from a
group by sales_year, kind_of_business
order by sales_year
;

-- 女性および男性衣料品店の売上高の年間トレンド
with a as(
select
    date_part('year', sales_month) as sales_year,
    kind_of_business,
    sum(sales) as sales
from retail_sales
where 
    kind_of_business in 
    ('Men''s clothing stores','Women''s clothing stores')
group by sales_month, kind_of_business
order by sales_month
)

select
    sales_year,
    kind_of_business,
    sum(sales) as sales
from a
group by sales_year, kind_of_business
order by sales_year
;

-- カラムを分けて女性および男性衣料品店の売上高の年間トレンド
with a as(
select
    date_part('year', sales_month) as sales_year,
    kind_of_business,
    sum(sales) as sales
from retail_sales
where 
    kind_of_business in 
    ('Men''s clothing stores','Women''s clothing stores')
group by sales_month, kind_of_business
order by sales_month
)

select
    sales_year,
    sum(case 
            when kind_of_business='Women''s clothing stores' then sales
        else 0 end) as women_sales,
    sum(case 
            when kind_of_business='Men''s clothing stores' then sales
        else 0 end) as men_sales
from a
group by sales_year
order by sales_year
;

-- 男性衣料品の売上高に対する女性衣料品の売上高の年間比
with a as(
select
    date_part('year', sales_month) as sales_year,
    kind_of_business,
    sum(sales) as sales
from retail_sales
where 
    kind_of_business in 
    ('Men''s clothing stores','Women''s clothing stores')
group by sales_month, kind_of_business
order by sales_month
),

b as(
select
    sales_year,
    sum(case 
            when kind_of_business='Women''s clothing stores' then sales
        else 0 end) as women_sales,
    sum(case 
            when kind_of_business='Men''s clothing stores' then sales
        else 0 end) as men_sales
from a
group by sales_year
order by sales_year
)

select
    sales_year,
    women_sales / men_sales
from b
;

-- 月間売上高に占める男性と女性衣料品店の売上高の割合
with a as(
select
    sales_month,
    sum(case 
            when kind_of_business='Women''s clothing stores' then sales
        else 0 end) as women_sales,
    sum(case 
            when kind_of_business='Men''s clothing stores' then sales
        else 0 end) as men_sales

from retail_sales
where 
    kind_of_business in 
    ('Men''s clothing stores','Women''s clothing stores')
group by sales_month
order by sales_month
)

select 
    *,
    men_sales / (women_sales + men_sales) * 100 as men_pct,
    women_sales / (women_sales + men_sales) * 100 as women_pct
from a
;

-- 女性と男性衣料品店の年間売上高に占める各月の割合
with a as(
select
    sales_month,
    sum(case 
            when kind_of_business='Women''s clothing stores' then sales
        else 0 end) as women_sales,
    sum(case 
            when kind_of_business='Men''s clothing stores' then sales
        else 0 end) as men_sales

from retail_sales
where 
    kind_of_business in 
    ('Men''s clothing stores','Women''s clothing stores')
group by sales_month
order by sales_month
)

select
    sales_month,
    100 * men_sales / 
    sum(men_sales) 
        over(partition by date_part('year', sales_month)) 
        as men_pct_yearly,
    100 * women_sales / 
    sum(women_sales) 
        over(partition by date_part('year', sales_month)) 
        as women_pct_yearly
from a
;

-- 1992年に対して指標化した女性衣料用品店の売上高
with a as(
select
    date_part('year', sales_month) as sales_year,
    sum(sales) as sales
from retail_sales
where kind_of_business='Women''s clothing stores'
group by sales_month
order by sales_month
)

select
    sales_year,
    sum(sales) as sales,
    first_value(sum(sales)) over(order by sales_year) as index_sales,
    (sum(sales) / 
        first_value(sum(sales)) over(order by sales_year) - 1) * 100
        as pct_from_index
from a
group by sales_year
order by sales_year
;


-- 女性衣料品店の月間売上高と12ヶ月移動平均売上高(自己結合方式)
select
    a.sales_month,
    a.sales,
    b.sales_month as rolling_sales_month,
    b.sales as rolling_sales
from retail_sales a
join retail_sales b
on a.kind_of_business = b.kind_of_business
    and b.kind_of_business = 'Women''s clothing stores'
    and b.sales_month between 
        a.sales_month - interval '11 month' and a.sales_month
where a.kind_of_business = 'Women''s clothing stores'
    and a.sales_month <= '2019-12-01'
    and a.sales_month >= '2019-09-01'
order by a.sales_month
;

select
    a.sales_month,
    a.sales,
    avg(b.sales) as moving_avg,
    count(b.sales) as records_count
from retail_sales a
join retail_sales b
on a.kind_of_business = b.kind_of_business
    and b.kind_of_business = 'Women''s clothing stores'
    and b.sales_month between 
        a.sales_month - interval '11 month' and a.sales_month
where a.kind_of_business = 'Women''s clothing stores'
    and a.sales_month >= '1993-01-01'
group by a.sales_month, a.sales 
order by a.sales_month, a.sales
;


-- 女性衣料品店の月間売上高と12ヶ月移動平均売上高(ウィンドウ関数)
select
    sales_month,
    avg(sales) over(order by sales_month
        rows between 11 preceding and current row)
        as moving_avg,
    count(sales) over(order by sales_month 
        rows between 11 preceding and current row)
        as records_count 
from retail_sales
where kind_of_business = 'Women''s clothing stores'
order by sales_month
;

-- 累積値の計算(ウィンド関数で)
select
    sales_month,
    sales,
    sum(sales) over(partition by date_part('year', sales_month) order by sales_month) as sale_ytd
from retail_sales
where kind_of_business = 'Women''s clothing stores'
;

select
    date_part('year', sales_month),
    sales,
    sum(sales) over(partition by date_part('year', sales_month) order by sales_month) as sale_ytd
from retail_sales
where kind_of_business = 'Women''s clothing stores'
;

-- 米国書店の前月からの増加率
select
    sales_month,
    sales,
    lag(sales) over(partition by kind_of_business 
        order by sales_month) as prev_month,
    (sales 
        / lag(sales) 
        over(partition by kind_of_business 
        order by sales_month)
        - 1
        ) * 100 as pct_growth_from_previous
from retail_sales
where kind_of_business = 'Book stores'
;


-- 書店売上高のYoY差とYoY増加率
select
    sales_month,
    sales,
    lag(sales) over(partition by 
        date_part('month', sales_month) 
        order by sales_month) as prev_year_sales,
    sales - lag(sales) over(partition by 
        date_part('month', sales_month) 
        order by sales_month) as yoy_diff,
    (sales / lag(sales) over(partition by 
        date_part('month', sales_month) 
        order by sales_month) 
        - 1) * 100 as yoy_pct
from retail_sales
where kind_of_business = 'Book stores'
order by sales_month
;

-- 書店売上高の過去3年の各月の移動平均に対する割合(lag関数を使ってカラムを作って計算)
with a as(
select
    sales_month,
    sales,
    lag(sales) over (partition by 
        date_part('month', sales_month) 
        order by sales_month)
        as prev_sales_1,
    lag(sales, 2) over (partition by 
        date_part('month', sales_month)
        order by sales_month)
        as prev_sales_2,
    lag(sales, 3) over (partition by 
        date_part('month', sales_month)
        order by sales_month)
        as prev_sales_3
from retail_sales
where kind_of_business = 'Book stores'
)

select
    sales_month,
    sales, 
    sales / (
        (prev_sales_1 
        + prev_sales_2
        + prev_sales_3) / 3
        ) as pct_prevv_3
from a
order by sales_month
;

-- 書店売上高の過去3年の各月の移動平均に対する割合(フレーム句でそのまま作りに行く)
select
    sales_month,
    sales/avg(sales) over(
        partition by date_part('month', sales_month) 
        order by sales_month 
        rows between 3 preceding and 1 preceding)
        as pct_prev_3
from retail_sales
where kind_of_business = 'Book stores'
;



CREATE TABLE orders(
	order_id TEXT ,
	order_date TEXT,
	website_session_id TEXT,
	user_id TEXT,
	primary_product_id TEXT,
	items_purchased TEXT,
	price_usd TEXT,
	cogs_usd TEXT
);

CREATE TABLE order_items(
order_item_id TEXT,
created_at TEXT,
order_id TEXT,
product_id TEXT,
is_primary_item TEXT,
price_usd TEXT,
cogs_usd TEXT
);

CREATE TABLE order_item_refunds(
order_item_refund_id TEXT,
created_at TEXT,
order_item_id TEXT,
order_id TEXT,
refund_amount_usd TEXT
);

CREATE TABLE products(
product_id TEXT,
created_at TEXT,
product_name TEXT
);

--Monthly Revenue Trend
SELECT  DATE_TRUNC('month', order_date::TIMESTAMP)::DATE AS revenue_month,
SUM(price_usd::NUMERIC)AS total_revenue
FROM orders
GROUP BY revenue_month
ORDER BY revenue_month;

--Top 5 Products by Revenue
SELECT p.product_id, p.product_name,
SUM(oi.price_usd::NUMERIC)AS revenue
FROM order_items oi
JOIN products p 
ON p.product_id =  oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;

--Products With Highest Refund Rate
SELECT p.product_name,
COUNT(r.order_item_id)AS refund,
COUNT(oi.order_item_id)AS orders_refund,
ROUND(
	COUNT(r.order_item_id)::NUMERIC/
	COUNT(oi.order_item_id) * 100
,2)AS refund_percent
FROM order_items oi
LEFT JOIN order_item_refunds r 
ON r.order_item_id = oi.order_item_id
JOIN products p 
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY refund_percent DESC;

--Monthly Profit Trend
SELECT DATE_TRUNC('months', order_date::TIMESTAMP)::DATE AS months,
SUM(price_usd::NUMERIC - cogs_usd::NUMERIC)AS profit
FROM orders
GROUP BY months
ORDER BY months;

--Top Customers by Spending
SELECT user_id, SUM(price_usd::NUMERIC)AS total_spent
FROM orders
GROUP BY user_id
ORDER BY totaL_spent DESC;


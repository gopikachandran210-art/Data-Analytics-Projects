/* select all the transactions in chennai*/
SELECT * FROM sales.transactions 
where market_code = "Mark001";
/* select all the transactions and sales dates joined through
dates column*/

select sales.transactions.*, sales.date.* 
from sales.transactions inner join sales.date 
ON sales.transactions.order_date = sales.date.date ;

/* select the sum of all the transactions in the year 2020*/

select sum(sales.transactions.sales_amount), sales.date.* 
from sales.transactions inner join sales.date 
ON sales.transactions.order_date = sales.date.date 
where year = '2020';

/* select the sum of all transactions in chennai in year 2020*/
select sum(sales.transactions.sales_amount) as sales_sum, sales.date.* 
from sales.transactions inner join sales.date 
ON sales.transactions.order_date = sales.date.date 
where year = '2020' and market_code = "Mark001";

/* select all the distinct product sales in chennai*/

select distinct sales.products.product_code 
from sales.products 
where sales.markets.market_code="Mark001";
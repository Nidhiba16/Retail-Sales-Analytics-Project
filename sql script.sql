create database Retail_Project;
Use Retail_Project;

CREATE TABLE sales (
    Row_ID INT,
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code INT,
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,2),
    Year INT,
    Month INT
);


/*Monthly Revenue*/

select
     Year,
     Month,
     round(Sum(Sales), 2) as Total_Sales
from cleaned_sales_data
group by Year,Month
order by Year,Month;

/*Top 5 customers*/

select 'Customer_ID',
       'Customer_Name',
       round(Sum(Sales), 2) as Total_spent
from cleaned_sales_data
group by 'Customer_ID', 'Customer_Name'
order by Total_spent desc
limit 5;

/*Repeat customers*/

select *
from(
     select 
           'Customer ID',
           count(distinct 'Order ID') as Order_count
	from cleaned_sales_data
    group by 'Customer ID') t
    where Order_count > 1;
    
    /*Running Total*/
    
    select 
           year,
           month,
           sum(sales)as Monthly_sales,
           sum(sum(sales)) over (order by year,month) as Running_Total
  from cleaned_sales_data
  group by year, month
  order by year, month;
  
  /*Profit margin Analysis*/
  
  select 
        Category,
        round(sum(profit) , 2) as Total_Profit,
        round(sum(sales) , 2) as Total_Sales,
        round((sum(profit)/sum(sales))*100, 2) as Profit_Margin_Percentage
from cleaned_sales_data
group by category;

/*Rank customers based on total sales*/

with customer_sales as(
     select 
           'Customer ID',
           'Customer Name',
           sum(sales) as Total_sales
	from cleaned_sales_data
    group by 'Customer ID', 'Customer_Name'
)
select 
     'Customer ID',
     'Customer Name',
     Total_sales,
     Rank() over (order by Total_sales desc) as Sales_Rank
from customer_sales;
     
/*Top customers in each region*/

with regional_sales as(
			  select Region,
                     'customer ID',
                     'customer Name',
                     Sum(sales) as Total_sales
			from Sales
            group by Region,'customer ID','customer Name'
)

select *
from(
   select *,
          rank () over (partition by Region order by Total_sales desc) as rnk
   from regional_sales
   ) t
   where rnk = 1;
              


/*Assignment 3 Nicole Mattison
-October 27, 2019*/

### Query 1 ###
SELECT country, jobTitle, count(*) 
FROM offices o, employees e
where o.officeCode=e.officeCode
group by country,jobTitle
order by jobTitle;

### Query 2  ###  I'vee counted and ordered each customer. 
### Although it gives the same answer of the top customers,
### it does not give the correct quantity ordered and there
### are more than two customers with more than 10 orders.
select c.customerName, c.country, count(d.quantityOrdered) as 'Number of Orders'
from customers c, orderdetails d, orders o
where c.customerNumber=o.customerNumber and o.orderNumber=d.orderNumber
group by c. customerName, c.country
having count(d.quantityOrdered) > 10
order by count(d.quantityOrdered) desc;




### Query 3 ### Done
SELECT customerName, sum(quantityOrdered*priceEach) as 'Total Spent'
FROM customers c, orderdetails o, orders d
where c.customerNumber=d.customerNumber and
d.orderNumber=o.orderNumber
group by customerName 
Order by sum(quantityOrdered*priceEach) desc
limit 10;


### Query 4 ### Done
Create or replace view CustomerSalesByOrder
As select c.customerNumber, o.orderNumber, sum(d.quantityOrdered*d.priceEach) as 'Total Amount'
from customers c, orders o, orderdetails d
where o.orderNumber=d.orderNumber and c.customerNumber=o.customerNumber
group by c.customerNumber, o.orderNumber;


select c.country, c.customerName, e.lastName, e.firstName, e.email, avg(customersalesbyorder.`Total Amount`) as 'Average Order Amount'
FROM customers c, employees e, customersalesbyorder
where c.customerNumber=customersalesbyorder.customerNumber and
e.employeeNumber=c.salesRepEmployeeNumber
group by c.country, c.customerName, e.lastName, e.firstName, e.email
order by avg(customersalesbyorder.`Total Amount`) desc
limit 1;




##### Query 5 ### Done
select c.customerName, o.orderDate, sum(d.quantityOrdered*d.priceEach) 
from customers c, orders o, orderdetails d
where c.customerNumber=o.customerNumber and
d.orderNumber=o.orderNumber 
group by customerName
order by sum(d.quantityOrdered*priceEach) desc
limit 1;

#from customers c, orderdetails d, orders o
#where c.customerNumber=o.customerNumber and
#d.orderNumber=o.orderNumber and
#c.customerName='Euro+ Shopping Channel' 
#group by orderDate;

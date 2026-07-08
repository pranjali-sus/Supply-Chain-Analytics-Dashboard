CREATE DATABASE DataCo;
USE DataCo;

SELECT `order date (DateOrders)`, `shipping date (DateOrders)` FROM Orders LIMIT 5;
SELECT Date FROM Date LIMIT 5;

SELECT SUM(`order date (DateOrders)` LIKE '%/%') AS Slash_Format,
       SUM(`order date (DateOrders)` LIKE '%-%') AS Dash_Format
FROM Orders;

SELECT SUM(`shipping date (DateOrders)` LIKE '%/%') AS Slash_Format,
       SUM(`shipping date (DateOrders)` LIKE '%-%') AS Dash_Format
FROM Orders;

SELECT DISTINCT `order date (DateOrders)` FROM Orders LIMIT 20;
SELECT DISTINCT `shipping date (DateOrders)` FROM Orders LIMIT 20;

ALTER TABLE Orders
ADD COLUMN Order_Date DATETIME,
ADD COLUMN Shipping_Date DATETIME;

SET SQL_SAFE_UPDATES = 0;

UPDATE Orders
SET Order_Date =
CASE
    WHEN `order date (DateOrders)` LIKE '%/%'
        THEN STR_TO_DATE(`order date (DateOrders)`, '%m/%d/%Y %H:%i')

    WHEN `order date (DateOrders)` LIKE '%-%'
        THEN STR_TO_DATE(`order date (DateOrders)`, '%d-%m-%Y %H:%i')
END;

UPDATE Orders
SET Shipping_Date =
CASE
    WHEN `shipping date (DateOrders)` LIKE '%/%'
        THEN STR_TO_DATE(`shipping date (DateOrders)`, '%m/%d/%Y %H:%i')

    WHEN `shipping date (DateOrders)` LIKE '%-%'
        THEN STR_TO_DATE(`shipping date (DateOrders)`, '%d-%m-%Y %H:%i')
END;

SET SQL_SAFE_UPDATES = 1;

SELECT `order date (DateOrders)`, Order_Date, `shipping date (DateOrders)`, Shipping_Date
FROM Orders LIMIT 20;

ALTER TABLE Orders
DROP COLUMN `order date (DateOrders)`,
DROP COLUMN `shipping date (DateOrders)`;

ALTER TABLE Orders
CHANGE COLUMN Order_Date Order_Date DATETIME,
CHANGE COLUMN Shipping_Date Shipping_Date DATETIME;

-- Add Primary Keys
ALTER TABLE Customers ADD PRIMARY KEY (`Customer Id`);
ALTER TABLE Categories ADD PRIMARY KEY (`Category Id`);
ALTER TABLE Departments ADD PRIMARY KEY (`Department Id`);
ALTER TABLE Products ADD PRIMARY KEY (`Product Card Id`);
ALTER TABLE Shipping ADD PRIMARY KEY (`Shipping ID`);
ALTER TABLE Locations ADD PRIMARY KEY (`Location ID`);
ALTER TABLE `Date` ADD PRIMARY KEY (`Date ID`);
ALTER TABLE Orders ADD PRIMARY KEY (`Order Item Id`);

-- Add Foreign Keys
ALTER TABLE Products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (`Category Id`)
REFERENCES Categories(`Category Id`);

ALTER TABLE Products
ADD CONSTRAINT fk_products_department
FOREIGN KEY (`Department Id`)
REFERENCES Departments(`Department Id`);

ALTER TABLE Orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (`Customer Id`)
REFERENCES Customers(`Customer Id`);

ALTER TABLE Orders
ADD CONSTRAINT fk_orders_product
FOREIGN KEY (`Product Card Id`)
REFERENCES Products(`Product Card Id`);

ALTER TABLE Orders
ADD CONSTRAINT fk_orders_shipping
FOREIGN KEY (`Shipping ID`)
REFERENCES Shipping(`Shipping ID`);

ALTER TABLE Orders
ADD CONSTRAINT fk_orders_location
FOREIGN KEY (`Location ID`)
REFERENCES Locations(`Location ID`);

SELECT DISTINCT o.`Location ID`
FROM Orders o
LEFT JOIN Locations l
ON o.`Location ID` = l.`Location ID`
WHERE l.`Location ID` IS NULL;

SELECT COUNT(*) AS Missing_Locations
FROM Orders o
LEFT JOIN Locations l
ON o.`Location ID` = l.`Location ID`
WHERE l.`Location ID` IS NULL;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Orders;
TRUNCATE TABLE Shipping;
TRUNCATE TABLE Locations;

SET FOREIGN_KEY_CHECKS = 1;

SHOW COLUMNS FROM Orders;
DROP TABLE Orders;
DESCRIBE Orders;
ALTER TABLE Orders
ADD COLUMN Order_Date DATETIME,
ADD COLUMN Shipping_Date DATETIME;

SET SQL_SAFE_UPDATES = 0;

UPDATE Orders
SET Order_Date =
CASE
    WHEN `order date (DateOrders)` LIKE '%/%'
        THEN STR_TO_DATE(`order date (DateOrders)`, '%m/%d/%Y %H:%i')
    WHEN `order date (DateOrders)` LIKE '%-%'
        THEN STR_TO_DATE(`order date (DateOrders)`, '%d-%m-%Y %H:%i')
END;

UPDATE Orders
SET Shipping_Date =
CASE
    WHEN `shipping date (DateOrders)` LIKE '%/%'
        THEN STR_TO_DATE(`shipping date (DateOrders)`, '%m/%d/%Y %H:%i')
    WHEN `shipping date (DateOrders)` LIKE '%-%'
        THEN STR_TO_DATE(`shipping date (DateOrders)`, '%d-%m-%Y %H:%i')
END;

SELECT Order_Date, Shipping_Date FROM Orders LIMIT 10;

ALTER TABLE Orders
DROP COLUMN `order date (DateOrders)`,
DROP COLUMN `shipping date (DateOrders)`;

SELECT COUNT(*) AS Missing_Location_IDs
FROM Orders o
LEFT JOIN Locations l
ON o.`Location ID` = l.`Location ID`
WHERE l.`Location ID` IS NULL;

SELECT COUNT(*) AS Missing_Shipping_IDs
FROM Orders o
LEFT JOIN Shipping s
ON o.`Shipping ID` = s.`Shipping ID`
WHERE s.`Shipping ID` IS NULL;

SELECT *
FROM Orders o
JOIN Customers c
ON o.`Customer Id` = c.`Customer Id`;

SELECT ROUND(SUM(Sales),2) AS Total_Sales FROM Orders;

SELECT ROUND(SUM(`Order Profit Per Order`),2) AS Total_Profit FROM Orders;

SELECT COUNT(DISTINCT `Order Id`) AS Total_Orders FROM Orders;

SELECT COUNT(*) AS Total_Customers FROM Customers;

SELECT ROUND(SUM(Sales)/COUNT(DISTINCT `Order Id`),2) AS Average_Order_Value FROM Orders;

SELECT p.`Product Name`, ROUND(SUM(o.Sales),2) AS Total_Sales
FROM Orders o
JOIN Products p
ON o.`Product Card Id` = p.`Product Card Id`
GROUP BY p.`Product Name`
ORDER BY Total_Sales DESC LIMIT 10;

SELECT p.`Product Name`, ROUND(SUM(o.`Order Profit Per Order`),2) AS Profit
FROM Orders o
JOIN Products p
ON o.`Product Card Id`=p.`Product Card Id`
GROUP BY p.`Product Name`
ORDER BY Profit DESC LIMIT 10;

SELECT c.`Category Name`, ROUND(SUM(o.Sales),2) AS Sales FROM Orders o
JOIN Products p
ON o.`Product Card Id` = p.`Product Card Id`
JOIN Categories c
ON p.`Category Id`=c.`Category Id`
GROUP BY c.`Category Name`
ORDER BY Sales DESC;

SELECT c.`Category Name`, ROUND(SUM(o.`Order Profit Per Order`),2) AS Profit FROM Orders o
JOIN Products p
ON o.`Product Card Id`=p.`Product Card Id`
JOIN Categories c
ON p.`Category Id`=c.`Category Id`
GROUP BY c.`Category Name`
ORDER BY Profit DESC;

SELECT d.`Department Name`, ROUND(SUM(o.Sales),2) AS Sales FROM Orders o
JOIN Products p
ON o.`Product Card Id`=p.`Product Card Id`
JOIN Departments d
ON p.`Department Id`=d.`Department Id`
GROUP BY d.`Department Name`
ORDER BY Sales DESC;

SELECT c.`Customer Segment`, COUNT(DISTINCT o.`Order Id`) AS Orders,
ROUND(SUM(o.Sales),2) AS Sales,
ROUND(SUM(o.`Order Profit Per Order`),2) AS Profit FROM Orders o
JOIN Customers c
ON o.`Customer Id`=c.`Customer Id`
GROUP BY c.`Customer Segment`;

SELECT c.`Customer Fname`, ROUND(SUM(o.Sales),2) AS Sales FROM Orders o
JOIN Customers c
ON o.`Customer Id`=c.`Customer Id`
GROUP BY c.`Customer Fname`
ORDER BY Sales DESC LIMIT 10;

SELECT YEAR(Order_Date) AS Year, MONTHNAME(Order_Date) AS Month,
ROUND(SUM(Sales),2) AS Sales FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

SELECT YEAR(Order_Date) AS Year, MONTHNAME(Order_Date) AS Month,
ROUND(SUM(`Order Profit Per Order`),2) AS Profit FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

SELECT `Order Status`, COUNT(*) AS Orders FROM Orders
GROUP BY `Order Status`;

SELECT ROUND(AVG(TIMESTAMPDIFF(DAY,Order_Date,Shipping_Date)),2) AS Avg_Shipping_Days FROM Orders;

SELECT COUNT(*) AS Late_Orders FROM Shipping
WHERE Late_delivery_risk=1;

SELECT `Shipping Mode`, COUNT(*) AS Orders FROM Shipping
GROUP BY `Shipping Mode`;

SELECT `Order Id`, ROUND(`Order Profit Per Order`,2) AS Profit FROM Orders
ORDER BY Profit DESC LIMIT 10;

SELECT `Order Id`, ROUND(`Order Profit Per Order`,2) AS Profit FROM Orders
ORDER BY Profit LIMIT 10;

SELECT Order_Date, Sales,
SUM(Sales) OVER(ORDER BY Order_Date) AS Running_Sales FROM Orders;

SELECT p.`Product Name`, ROUND(SUM(o.Sales),2) AS Sales,
RANK() OVER(ORDER BY SUM(o.Sales) DESC) AS Sales_Rank FROM Orders o
JOIN Products p
ON o.`Product Card Id`=p.`Product Card Id`
GROUP BY p.`Product Name`;

WITH CustomerSales AS (
SELECT c.`Customer Fname`, SUM(o.Sales) AS Sales 
FROM Orders o
JOIN Customers c
ON o.`Customer Id`=c.`Customer Id`
GROUP BY c.`Customer Fname`
)
SELECT * FROM CustomerSales
ORDER BY Sales DESC LIMIT 5;

CREATE VIEW Sales_Analysis AS
SELECT o.`Order Id`, o.Order_Date, c.`Customer Segment`, p.`Product Name`,
cat.`Category Name`, d.`Department Name`, o.Sales, o.`Order Profit Per Order` FROM Orders o
JOIN Customers c
ON o.`Customer Id`=c.`Customer Id`
JOIN Products p
ON o.`Product Card Id`=p.`Product Card Id`
JOIN Categories cat
ON p.`Category Id`=cat.`Category Id`
JOIN Departments d
ON p.`Department Id`=d.`Department Id`;

SELECT * FROM Sales_Analysis LIMIT 20;
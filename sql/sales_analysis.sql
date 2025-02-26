ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN InvoiceNo NVARCHAR(50);

ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN StockCode NVARCHAR(50);

ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN Description NVARCHAR(255);

ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN Quantity INT;

ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN InvoiceDate DATETIME2;

ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN UnitPrice DECIMAL(10,2);

ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN CustomerID NVARCHAR(50);

ALTER TABLE OnlineRetail_Cleaned
ALTER COLUMN Country NVARCHAR(100);


EXEC sp_rename 'OnlineRetail_Cleaned', 'OnlineRetail';

EXEC sp_columns OnlineRetail;
SELECT TOP 5 * FROM OnlineRetail;

/*Checking data size*/

SELECT COUNT(*) AS Total_Records FROM OnlineRetail;

/*Total number of records is 541909*/ 



/*Checking for missing values*/

SELECT 
    SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceNo,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Missing_Description,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Missing_UnitPrice,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM OnlineRetail;

/*Missing_Description 1454*/

/*Monthly revenue trends*/

SELECT 
    FORMAT(InvoiceDate, 'yyyy-MM') AS Month,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM OnlineRetail
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY Month;

/*Month	TotalRevenue
2010-12	748957.02
2011-01	560000.26
2011-02	498062.65
2011-03	683267.08
2011-04	493207.12
2011-05	723333.51
2011-06	691123.12
2011-07	681300.11
2011-08	682680.51
2011-09	1019687.62
2011-10	1070704.67
2011-11	1461756.25
2011-12	433668.01*/

/*Top Selling Products*/

SELECT 
    StockCode, 
    Description, 
    SUM(Quantity) AS TotalSold,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM OnlineRetail
GROUP BY StockCode, Description
ORDER BY TotalSold DESC;


/* StockCode	Description	TotalSold	TotalRevenue
84077	WORLD WAR 2 GLIDERS ASSTD DESIGNS	53847	13587.93
85099B	JUMBO BAG RED RETROSPOT	47363	92356.03
84879	ASSORTED COLOUR BIRD ORNAMENT	36381	58959.73
22197	POPCORN HOLDER	36334	33969.46
21212	PACK OF 72 RETROSPOT CAKE CASES	36039	21059.72
85123A	WHITE HANGING HEART T-LIGHT HOLDER	35317	99668.47
23084	RABBIT NIGHT LIGHT	30680	66756.59
22492	MINI PAINT SET VINTAGE 	26437	16810.42
22616	PACK OF 12 LONDON TISSUES 	26315	7972.76
21977	PACK OF 60 PINK PAISLEY CAKE CASES	24753	12189.47 */

/* Best Customers (Based on Total Spending) */
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    SUM(Quantity * UnitPrice) AS TotalSpent
FROM OnlineRetail
GROUP BY CustomerID
ORDER BY TotalSpent DESC

/* CustomerID	TotalOrders	TotalSpent
NULL	3710	1447682.12
14646	77	279489.02
18102	62	256438.49
17450	55	187482.17
14911	248	132572.62
12415	26	123725.45
14156	66	113384.14
17511	46	88125.38
16684	31	65892.08
13694	60	62653.10
15311	118	59419.34*/

/* Customer Segmentation (New vs. Returning Customers)*/
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS OrdersCount,
    CASE 
        WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'New Customer'
        ELSE 'Returning Customer'
    END AS CustomerType
FROM OnlineRetail
GROUP BY CustomerID
ORDER BY OrdersCount DESC;


/*CustomerID	OrdersCount	CustomerType
NULL	3710	Returning Customer
14911	248	Returning Customer
12748	224	Returning Customer
17841	169	Returning Customer
14606	128	Returning Customer
15311	118	Returning Customer
13089	118	Returning Customer
12971	89	Returning Customer
14527	86	Returning Customer
13408	81	Returning Customer
14646	77	Returning Customer */


/* Geographic Revenue Breakdown*/

SELECT 
    Country,
    COUNT(DISTINCT CustomerID) AS TotalCustomers,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM OnlineRetail
GROUP BY Country
ORDER BY TotalRevenue DESC;

/* Country	TotalCustomers	TotalRevenue
United Kingdom	3950	8187806.36
Netherlands	9	284661.54
EIRE	3	263276.82
Germany	95	221698.21
France	87	197403.90
Australia	9	137077.27
Switzerland	21	56385.35
Spain	31	54774.58
Belgium	25	40910.96
Sweden	8	36595.91 */


------------------------- Creating Tables for the Dataset --------------------

/* Product Table */
CREATE TABLE Product (
	"ProductKey" INT PRIMARY KEY,
	"Product" VARCHAR (240) NOT NULL, 
	"Standard Cost" DECIMAL (18, 2), 
	"Color" VARCHAR (100), 
	"Subcategory" VARCHAR (300),
	"Category" VARCHAR (200),
	"Background Color Format" VARCHAR (200),
	"Font Color Format" VARCHAR (200)	
	);

CREATE TEMPORARY TABLE Product_Staging (
    "ProductKey" INT PRIMARY KEY,
    "Product" VARCHAR(255) NOT NULL,
    "Standard Cost" VARCHAR(255),  -- Temporary as VARCHAR
    "Color" VARCHAR(255),
    "Subcategory" VARCHAR(255),
    "Category" VARCHAR(255),
    "Background Color Format" VARCHAR(255),
    "Font Color Format" VARCHAR(255)
);

COPY Product_Staging ("ProductKey","Product","Standard Cost","Color","Subcategory","Category","Background Color Format","Font Color Format")
FROM 'C:\Users\HP\Downloads\HANKALI INTEL\LMS - Data Senior Track\Dataset\Test\Adventure Works 2022\Product.csv'
DELIMITER E'\t'
CSV HEADER;

INSERT INTO Product ("ProductKey", "Product", "Standard Cost", "Color", "Subcategory", "Category", "Background Color Format", "Font Color Format")
SELECT
    "ProductKey",
    "Product",
    NULLIF(REGEXP_REPLACE("Standard Cost", '[$,]', '', 'g'), '')::DECIMAL,  -- Remove $ and commas, then convert to DECIMAL
    "Color",
    "Subcategory",
    "Category",
    "Background Color Format",
    "Font Color Format"
FROM Product_Staging;

ALTER TABLE Product ADD UNIQUE ("ProductKey");

SELECT * FROM Product;

/* Region Table */
CREATE TABLE Region (
	"SalesTerritoryKey" INT PRIMARY KEY,
	"Region" VARCHAR (240) NOT NULL, 
	"Country" VARCHAR (200), 
	"Group" VARCHAR (100) 	
	);

INSERT INTO Region VALUES (11, 'United Kingdom','Ireland','Europe');

SELECT * FROM Region;

ALTER TABLE Region
ADD Race VARCHAR (100);

ALTER TABLE Region
DROP COLUMN Race;

COPY Region ("SalesTerritoryKey","Region","Country","Group")
FROM 'C:\Users\HP\Downloads\HANKALI INTEL\LMS - Data Senior Track\Dataset\Test\Adventure Works 2022\Region.csv'
DELIMITER E'\t'
CSV HEADER;

/* Reseller Table */
CREATE TABLE Reseller (
	"ResellerKey" INT PRIMARY KEY,
	"Business Type" VARCHAR (240) NOT NULL, 
	"Reseller" VARCHAR (1000), 
	"City" VARCHAR (100), 
	"State-Province" VARCHAR (300),
	"Country-Region" VARCHAR (200)	
	);

COPY Reseller ("ResellerKey","Business Type","Reseller","City","State-Province","Country-Region")
FROM 'C:\Users\HP\Downloads\HANKALI INTEL\LMS - Data Senior Track\Dataset\Test\Adventure Works 2022\Reseller.csv'
DELIMITER E'\t'
CSV HEADER;

SELECT * FROM Reseller;

/* Salesperson Table */
CREATE TABLE Salesperson (
    "EmployeeID" INT NOT NULL,
	"EmployeeKey" INT NOT NULL,
    "Salesperson" VARCHAR(255),
    "Title" VARCHAR(255),
    "UPN" VARCHAR(255),
	PRIMARY KEY ("EmployeeKey", "EmployeeID")  -- Composite Primary Key
);

COPY Salesperson ("EmployeeKey","EmployeeID","Salesperson","Title","UPN")
FROM 'C:\Users\HP\Downloads\HANKALI INTEL\LMS - Data Senior Track\Dataset\Test\Adventure Works 2022\Salesperson.csv'
DELIMITER E'\t'
CSV HEADER;

ALTER TABLE salesperson ADD UNIQUE ("EmployeeKey");
ALTER TABLE salesperson ADD UNIQUE ("EmployeeID");

SELECT * FROM Salesperson;

/* SalespersonRegion Table */
CREATE TABLE SalespersonRegion (
	"EmployeeKey" INT,
	"SalesTerritoryKey" INT,
	FOREIGN KEY ("EmployeeKey") REFERENCES Salesperson("EmployeeKey"),
	FOREIGN KEY ("SalesTerritoryKey") REFERENCES Region ("SalesTerritoryKey")
);

COPY SalespersonRegion ("EmployeeKey","SalesTerritoryKey")
FROM 'C:\Users\HP\Downloads\HANKALI INTEL\LMS - Data Senior Track\Dataset\Test\Adventure Works 2022\SalespersonRegion.csv'
DELIMITER E'\t'
CSV HEADER;

SELECT * FROM SalespersonRegion;

/* Sales Table */
CREATE TABLE Sales (
    "SalesOrderNumber" VARCHAR(50),
    "OrderDate" DATE,
    "ProductKey" INT,
    "ResellerKey" INT,
    "EmployeeKey" INT,
    "SalesTerritoryKey" INT,
    "Quantity" INT,
    "UnitPrice" DECIMAL(18, 2),
    "Sales" DECIMAL(18, 2),
    "Cost" DECIMAL(18, 2),
	FOREIGN KEY ("ProductKey") REFERENCES Product("ProductKey"),
	FOREIGN KEY ("ResellerKey") REFERENCES Reseller("ResellerKey"),
    FOREIGN KEY ("EmployeeKey") REFERENCES Salesperson("EmployeeKey"),
    FOREIGN KEY ("SalesTerritoryKey") REFERENCES Region("SalesTerritoryKey")
);

CREATE TEMPORARY TABLE Sales_Staging (
    "SalesOrderNumber" VARCHAR(50),
    "OrderDate" DATE,
    "ProductKey" INT,
    "ResellerKey" INT,
    "EmployeeKey" INT,
    "SalesTerritoryKey" INT,
    "Quantity" VARCHAR(255),
    "UnitPrice" VARCHAR(255),
    "Sales" VARCHAR(255),
    "Cost" VARCHAR(255)
);

COPY Sales_Staging ("SalesOrderNumber","OrderDate","ProductKey","ResellerKey","EmployeeKey","SalesTerritoryKey","Quantity","UnitPrice","Sales","Cost")
FROM 'C:\Users\HP\Downloads\HANKALI INTEL\LMS - Data Senior Track\Dataset\Test\Adventure Works 2022\Sales.csv'
DELIMITER E'\t'
CSV HEADER;

INSERT INTO Sales ("SalesOrderNumber","OrderDate","ProductKey","ResellerKey","EmployeeKey","SalesTerritoryKey","Quantity","UnitPrice","Sales","Cost")
SELECT
    "SalesOrderNumber",
    "OrderDate",
	"ProductKey",
	"ResellerKey",
	"EmployeeKey",
	"SalesTerritoryKey",
	NULLIF(REGEXP_REPLACE("Quantity", '[$,]', '', 'g'), '')::DECIMAL,  -- Remove $ and commas, then convert to DECIMAL
	NULLIF(REGEXP_REPLACE("UnitPrice", '[$,]', '', 'g'), '')::DECIMAL,  -- Remove $ and commas, then convert to DECIMAL
	NULLIF(REGEXP_REPLACE("Sales", '[$,]', '', 'g'), '')::DECIMAL,  -- Remove $ and commas, then convert to DECIMAL
	NULLIF(REGEXP_REPLACE("Cost", '[$,]', '', 'g'), '')::DECIMAL  -- Remove $ and commas, then convert to DECIMAL
FROM Sales_Staging;

ALTER TABLE Sales ADD UNIQUE ("SalesOrderNumber");

SELECT * FROM Sales;

/* Targets Table */
CREATE TABLE Targets (
	"EmployeeID" INT,
	"Target" VARCHAR(180),
	"TargetMonth" DATE,
	FOREIGN KEY ("EmployeeID") REFERENCES Salesperson("EmployeeID")
);

COPY Targets ("EmployeeID","Target","TargetMonth")
FROM 'C:\Users\HP\Downloads\HANKALI INTEL\LMS - Data Senior Track\Dataset\Test\Adventure Works 2022\Targets.csv'
DELIMITER E'\t'
CSV HEADER;

SELECT * FROM Targets;

ALTER TABLE Targets
ALTER COLUMN "Target" TYPE NUMERIC(10, 2) 
USING NULLIF(REGEXP_REPLACE("Target", '[$,]', '', 'g'), '')::NUMERIC(10, 2);

ALTER TABLE Targets
ALTER COLUMN "TargetMonth" TYPE DATE
USING NULLIF("TargetMonth", '')::DATE;
  

----------------Manipulating Datasets in SQL using Statements----------------


/* Working with Operators */
SELECT * FROM Sales;

SELECT "Sales" - "Cost" AS "Profit" 
FROM Sales;

ALTER TABLE Sales
ADD COLUMN "Profit" DECIMAL(10, 2);

UPDATE sales
SET "Profit" = "Sales" - "Cost";


/* Aggregated Sum */
SELECT * FROM Sales;
SELECT * FROM Targets;
SELECT * FROM Reseller;

SELECT 
    SUM("Sales") AS "TotalSales",
    SUM("Quantity") AS "TotalQuantity",
    SUM("Cost") AS "TotalCost",
    SUM("Profit") AS "TotalProfit"
FROM Sales;

SELECT COUNT ("SalesOrderNumber") 
FROM Sales
WHERE "Sales" > 1000;


/* Grouping */
SELECT * FROM Sales;
SELECT * FROM Targets;

SELECT 
	COUNT ("SalesOrderNumber") AS "IDCount",
	SUM("Sales") AS "TotalSales",
    SUM("Quantity") AS "TotalQuantity",
    SUM("Cost") AS "TotalCost",
    SUM("Profit") AS "TotalProfit"
FROM Sales
GROUP BY "ResellerKey";

SELECT 
	COUNT("EmployeeID") AS IDCount,
	SUM("Target") AS "TotalTarget"
FROM Targets
GROUP BY "EmployeeID";


/* MIN & MAX */
SELECT 
	MIN("UnitPrice") AS MinPrice, 
	MIN("Quantity") AS MinSQty, 
	MIN("Profit") MinProfit, 
	MIN("Cost") AS MinCost
FROM Sales;

SELECT 
	MAX("UnitPrice") AS MaxPrice, 
	MAX("Quantity") AS MaxQty, 
	MAX("Profit") MaxProfit, 
	MAX("Cost") AS MaxCost
FROM Sales;


-----------------------------Filtering Datasets-------------------------------

/* Warehouse and Location */
SELECT * FROM Reseller;

SELECT "Business Type", "City", "State-Province", "Country-Region"
FROM Reseller
	WHERE "Business Type" = 'Warehouse';

SELECT "Business Type", "City", "State-Province", "Country-Region"
FROM Reseller
	WHERE "Business Type" = 'Warehouse'
	AND "Country-Region" = 'France';


/* City & u*/
SELECT "Business Type", "City","State-Province", "Country-Region"
	FROM Reseller
	WHERE "City" LIKE '%u%';

SELECT "Business Type", "City","State-Province", "Country-Region"
	FROM Reseller
	WHERE "City" LIKE '%u';

SELECT "Business Type", "City","State-Province", "Country-Region"
	FROM Reseller
	WHERE "City" LIKE 'u%';


/* Ordered High Quantity */ 
SELECT * FROM Sales;

SELECT "UnitPrice", "Quantity", "Cost", "Profit"
FROM Sales
	WHERE "Quantity" BETWEEN 30 AND 45
ORDER BY "Profit" DESC;

SELECT "Sales", "Profit", "Cost"
FROM Sales
WHERE "UnitPrice" > 1000
ORDER BY "Quantity" DESC

	
/* Continent & Salesperson */ 
SELECT * FROM Region;
SELECT * FROM Salesperson;

SELECT * 
FROM Region
WHERE "Group" IN ('Europe','Pacific');

SELECT * 
FROM Salesperson
WHERE "Title" LIKE 'Sale%';

SELECT CONCAT ("Salesperson",' ','is',' ',"Title") AS NameTitle, "UPN"
FROM Salesperson;


/* Working with Dates */

SELECT * FROM Sales;
SELECT * FROM Targets;	

SELECT * 
FROM Targets 
WHERE "TargetMonth" = '2020-12-01'
ORDER BY "Target" ASC;

SELECT "Target", EXTRACT(MONTH FROM "TargetMonth") AS "Month"
FROM Targets
WHERE EXTRACT(MONTH FROM "TargetMonth") = '12';

SELECT "OrderDate", ('2020-01-13' - '2021-01-13'::DATE) AS DateDiff, "Quantity", "Sales"
FROM Sales;

SELECT "UnitPrice", "Profit", EXTRACT(MONTH FROM "OrderDate") AS "Month"
FROM Sales
WHERE EXTRACT(MONTH FROM "OrderDate") = '12'
ORDER BY "UnitPrice" ASC, "Profit" DESC;


---------------------------------- Working Across datasets -----------------------

SELECT * FROM Product
SELECT * FROM Region
SELECT * FROM Reseller
SELECT * FROM Sales
SELECT * FROM Salesperson
SELECT * FROM Salespersonregion
SELECT * FROM Targets;


---------------------- Rename the Reseller Table --------------------------------------

ALTER TABLE Reseller 
	RENAME "Country-Region" TO "Region";

/* INNER JOIN */

SELECT * FROM Region;
SELECT * FROM Reseller;

SELECT Region."Region", Region."Group", Reseller."City"
FROM Region
INNER JOIN Reseller ON Region."Region"=Reseller."Region";

/* LEFT JOIN */

SELECT * FROM Product;
SELECT * FROM Sales;

SELECT Product."Product", product."Subcategory", product."Standard Cost", Sales."Quantity", Sales."UnitPrice", Sales."Profit"
FROM Product
LEFT JOIN Sales
ON Product."ProductKey" = Sales."ProductKey";

SELECT * FROM Salesperson;
SELECT * FROM Targets;
	
SELECT Salesperson."EmployeeID", Salesperson."Salesperson", Salesperson."Title", SUM(Targets."Target") As "Target"
FROM Salesperson
LEFT JOIN Targets
ON Salesperson."EmployeeID" = Targets."EmployeeID"
	GROUP BY Salesperson."EmployeeID", Salesperson."Salesperson", Salesperson."Title"
	ORDER BY "Target" DESC;

/* RIGHT JOIN */

SELECT * FROM Region;
SELECT * FROM Sales;

SELECT Region."Region", Region."Country", SUM(Sales."Sales") AS "Sales", SUM(Sales."Cost") AS "Cost", SUM(Sales."Profit") AS "Profit"
FROM Region
RIGHT JOIN Sales
ON Sales."SalesTerritoryKey" = Region."SalesTerritoryKey"
	GROUP BY Region."Region", Region."Country" 
	ORDER By "Profit" DESC;

/* OUTER JOIN */

SELECT * FROM Salesperson;
SELECT * FROM Sales;

SELECT Salesperson."Salesperson", Salesperson."Title", Salesperson."UPN", SUM (Sales."Quantity") AS Quantity, SUM (Sales."UnitPrice") AS UPrice, SUM(Sales."Sales") AS Sales, SUM(Sales."Cost") AS "Cost", SUM (Sales."Profit") AS Profit
FROM Salesperson
FULL OUTER JOIN Sales ON Salesperson."EmployeeKey"=Sales."EmployeeKey"
GROUP BY Salesperson."Salesperson", Salesperson."Title", Salesperson."UPN"
ORDER BY Profit DESC;

-------------------------- Joining 3 or more tables ------------------------------------
SELECT * FROM Region; -- SalesTerritoryKey
SELECT * FROM Reseller; -- ResellerKey
SELECT * FROM Product; -- ProductKey
SELECT * FROM Salesperson; -- EmID, EMKey
SELECT * FROM Sales; -- *
SELECT * FROM Targets; -- EMID
SELECT * FROM Salespersonregion; -- 

SELECT Region."Country", Reseller."Business Type", Reseller."Reseller", Reseller."Region",
Product."Product", Product."Category", Product."Subcategory", Product."Standard Cost",
Salesperson."Salesperson", Salesperson."Title", Sales."Quantity", Sales."UnitPrice", Sales."Sales", 
Sales."Cost", Sales."Profit", Targets."Target" 
FROM Sales
JOIN Region
ON Sales."SalesTerritoryKey" = Region."SalesTerritoryKey" 
JOIN Reseller
ON Sales."ResellerKey"=Reseller."ResellerKey"
JOIN Product
ON Sales."ProductKey"=Product."ProductKey"
JOIN Salesperson
ON Sales."EmployeeKey"= Salesperson."EmployeeKey"
JOIN Salespersonregion
ON Sales."EmployeeKey"= Salespersonregion."EmployeeKey"
JOIN Targets
ON Salesperson."EmployeeID" = Targets."EmployeeID"


/* SUBQUERIES */

--- Subquery under SELECT ---
	
SELECT "Product", "Color", "Subcategory", "Category", (SELECT AVG("Standard Cost") FROM Product)
FROM Product
GROUP BY "Product", "Color", "Subcategory", "Category";


--- Subquery under FROM ---

/* What is the average number of categories based on colors */

SELECT "Category", AVG("Product Count") AS "Avg Count" FROM 
	(SELECT "Category", "Color", COUNT (*) AS "Product Count"
	FROM Product
	GROUP BY 1, 2) subquery
GROUP BY 1;


----------------- Subquery under WHERE -----

SELECT Region."Country", Reseller."City", Reseller."Reseller", Reseller."Region",
Product."Product", Product."Category", Product."Subcategory", Product."Standard Cost",
Salesperson."Salesperson", Salesperson."Title", Sales."Quantity", Sales."UnitPrice", Sales."Sales", 
Sales."Cost", Sales."Profit", Targets."Target" 
FROM Sales
JOIN Region
ON Sales."SalesTerritoryKey" = Region."SalesTerritoryKey" 
JOIN Reseller
ON Sales."ResellerKey"=Reseller."ResellerKey"
JOIN Product
ON Sales."ProductKey"=Product."ProductKey"
JOIN Salesperson
ON Sales."EmployeeKey"= Salesperson."EmployeeKey"
JOIN Salespersonregion
ON Sales."EmployeeKey"= Salespersonregion."EmployeeKey"
JOIN Targets
ON Salesperson."EmployeeID" = Targets."EmployeeID"
WHERE "Business Type" IN (SELECT "Business Type" FROM Reseller WHERE "City" LIKE LOWER ('%o%'))




SET GLOBAL local_infile = 1;

CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DOUBLE,
    CustomerID VARCHAR(20),
    Country VARCHAR(50)
);

LOAD DATA LOCAL INFILE 'C:\Users\ogunl\Downloads\archive (1)\OnlineRetail.csv'
INTO TABLE online_retail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @InvoiceDate, UnitPrice, @CustomerID, Country)
SET
    InvoiceDate = STR_TO_DATE(@InvoiceDate, '%m/%d/%Y %H:%i'),
    CustomerID = NULLIF(@CustomerID, '');
    
SHOW VARIABLES LIKE 'secure_file_priv';


LOAD DATA LOCAL INFILE 'C:/Users/ogunl/Downloads/archive (1)/OnlineRetail.csv'
INTO TABLE online_retail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @InvoiceDate, UnitPrice, @CustomerID, Country)
SET
    InvoiceDate = STR_TO_DATE(@InvoiceDate, '%m/%d/%Y %H:%i'),
    CustomerID = NULLIF(@CustomerID, '');
    
LOAD DATA LOCAL INFILE 'C:/Users/ogunl/Downloads/archive (1)/OnlineRetail.csv'
INTO TABLE online_retail
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @InvoiceDate, UnitPrice, @CustomerID, Country)
SET
    InvoiceDate = STR_TO_DATE(@InvoiceDate, '%m/%d/%Y %H:%i'),
    CustomerID = NULLIF(@CustomerID, '');
    
    
SELECT *
FROM online_retail;

SELECT InvoiceNo, Quantity, InvoiceDate, CustomerID
FROM online_retail
LIMIT 10;

SELECT COUNT(*)
FROM online_retail
WHERE CustomerID IS NULL OR CustomerID = " ";

SELECT DISTINCT Country
FROM online_retail;

SELECT COUNT(*)
FROM online_retail
WHERE InvoiceDate IS NULL;

SELECT COUNT(*)
FROM online_retail 
WHERE Description IS NULL OR Description = "";

SELECT COUNT(*)
FROM online_retail 
WHERE StockCode IS NULL OR StockCode = "";

SELECT COUNT(*)
FROM online_retail 
WHERE Quantity IS NULL OR Quantity < 0;

SELECT COUNT(*)
FROM online_retail 
WHERE UnitPrice IS NULL OR UnitPrice <= 0;

SELECT * 
FROM online_retail
WHERE Description = "";

SELECT InvoiceNo
FROM online_retail;

ALTER TABLE online_retail ADD COLUMN IsInvalidPrice BOOLEAN;

UPDATE online_retail SET IsInvalidPrice = (UnitPrice <= 0);

SELECT IsInvalidPrice, COUNT(*)
FROM online_retail
GROUP BY IsInvalidPrice;

ALTER TABLE online_retail DROP COLUMN IsReturn;

ALTER TABLE online_retail ADD COLUMN IsReturnOrCancelled BOOLEAN;

UPDATE online_retail SET IsReturnOrCancelled = (Quantity < 0);

SELECT COUNT(IsReturnOrCancelled),  IsReturnOrCancelled
FROM online_retail
GROUP BY IsReturnOrCancelled;


ALTER TABLE online_retail ADD COLUMN IsGuest BOOLEAN;

UPDATE online_retail 
SET IsGuest = (CustomerID IS NULL OR CustomerID = "");

SELECT IsGuest, 
COUNT(*)
FROM online_retail
GROUP BY IsGuest;

UPDATE online_retail
SET Description = "Unknown"
WHERE Description IS NULL OR Description = "";

SELECT COUNT(*)
FROM online_retail
WHERE Description = "Unknown";

SELECT InvoiceNo,
StockCode,
Description,
Quantity,
InvoiceDate,
UnitPrice,
CustomerID,
Country,
COUNT(*)
FROM online_retail
GROUP BY InvoiceNo,
StockCode,
Description,
Quantity,
InvoiceDate,
UnitPrice,
CustomerID,
Country
HAVING COUNT(*) > 1;

ALTER TABLE online_retail ADD COLUMN temp_id INT AUTO_INCREMENT PRIMARY KEY;


DELETE FROM online_retail
WHERE temp_id NOT IN (
	SELECT min_id FROM (
	SELECT MIN(temp_id) min_id
    FROM online_retail
    GROUP BY InvoiceNo,
	StockCode,
	Description,
	Quantity,
	InvoiceDate,
	UnitPrice,
	CustomerID,
	Country) keep_rows);
    
    SHOW PROCESSLIST;
    
    KILL 16;
    
    SELECT COUNT(*)
    FROM online_retail;
    
    ALTER TABLE online_retail DROP COLUMN temp_id;
    
    SELECT DISTINCT Country 
    FROM online_retail;
    
UPDATE online_retail
SET Country = 'United States of America'
WHERE REPLACE(Country, CHAR(13), '') = 'USA';

UPDATE online_retail
SET Country = 'South Africa'
WHERE REPLACE(Country, CHAR(13), '') = 'RSA';
    
    UPDATE online_retail
SET Country = 'Ireland'
WHERE REPLACE(Country, CHAR(13), '') = 'EIRE';
    
    SELECT Country, HEX(Country) FROM online_retail WHERE Country LIKE '%USA%' LIMIT 1;
    
    SELECT DISTINCT Country
    FROM online_retail
    WHERE Country LIKE "%EIRE%" OR Country LIKE "%USA%";
    
    SELECT DISTINCT Country, LENGTH(Country)
    FROM online_retail
    WHERE Country LIKE "%EIRE%" OR Country LIKE "%USA%";
    
    SELECT DISTINCT Description
    FROM online_retail
    LIMIT 20;
    
    
    
    SELECT 
	AVG(Quantity),
    MIN(Quantity),
    MAX(Quantity),
    STDDEV(Quantity),
	AVG(UnitPrice),
    MIN(UnitPrice),
    MAX(UnitPrice),
    STDDEV(UnitPrice)
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND
IsInvalidPrice = FALSE;

SELECT *
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE 
ORDER BY Quantity DESC
LIMIT 5;

SELECT *
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE 
ORDER BY UnitPrice DESC
LIMIT 5;

SELECT Description, SUM(Quantity) total_qty
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE 
GROUP BY Description
ORDER BY total_qty DESC
LIMIT 10;

SELECT COUNT(*), SUM(Quantity)
FROM online_retail
WHERE Description = "PAPER CRAFT , LITTLE BIRDIE" AND  IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE;

SELECT DISTINCT Description, LENGTH(Description)
FROM online_retail
WHERE Description LIKE "%PAPER CRAFT%";

SELECT Country, SUM(Quantity * UnitPrice) total_revenue
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE
GROUP BY Country
ORDER BY total_revenue desc
LIMIT 10;


SELECT DATE_FORMAT(InvoiceDate, "%Y-%m") AS month, SUM(Quantity * UnitPrice) total_revenue
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE
GROUP BY month
ORDER BY month;

SELECT MAX(InvoiceDate)
FROM online_retail;

SELECT Description, COUNT(DISTINCT InvoiceNo)  num_orders
FROM online_retails
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE
GROUP BY Description
ORDER BY num_orders desc
LIMIT 10;

SELECT 
    COUNT(DISTINCT InvoiceNo) / COUNT(DISTINCT CustomerID) AS avg_orders_per_customer,
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT CustomerID) AS avg_spend_per_customer
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE
  AND IsGuest = FALSE;
  
  
  SELECT CustomerID, SUM(Quantity * UnitPrice) AS customer_spend
FROM online_retail
WHERE IsReturnOrCancelled = FALSE AND IsInvalidPrice = FALSE
  AND IsGuest = FALSE
GROUP BY CustomerID;
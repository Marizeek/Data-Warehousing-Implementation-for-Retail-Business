-- Create Blue Sky Online database
CREATE DATABASE BlueSkyOnline;

-- Create Date dimensional table
CREATE TABLE dbo.DateDim(
DateKey int IDENTITY(1,1),
FullDate date,
DateName date,
DayOfWeek int,
DayNameOfWeek nvarchar(30),
DayOfMonth int,
DayOfYear int,
WeekdayWeekend nvarchar(30),
WeekOfYear int,
MonthName nvarchar(30),
MonthOfYear int,
IsLastDayOfMonth char(10),
CalendarQuarter int,
CalendarYear int,
CalendarYearMonth nvarchar(50),
CalendarYearQtr nvarchar(50),
FiscalMonthOfYear int,
FiscalQuarter int,
FiscalYear int,
FiscalYearMonth nvarchar(50),
FiscalYearQtr nvarchar(50)
) ON [PRIMARY];


-- Create Customer dimensonal table
CREATE TABLE dbo.CustomerDim(
CustomerKey int IDENTITY(1,1),
Name varchar(50),
CustomerCode nvarchar(30),
BirthDate varchar(50),
MaritalStatus char(10),
Gender char(10),
PostCode nvarchar(30),
City varchar(50),
Income varchar(20)
) ON [PRIMARY];


-- Create Payment Type dimensional table
CREATE TABLE dbo.PaymentTypeDim(
PaymentTypeKey int IDENTITY(1,1),
Name varchar(30),
RetailerPaymentTypeId int
) ON [PRIMARY];


-- Create Selling Channel dimensional table
CREATE TABLE dbo.ChannelTypeDim(
ChannelTypeKey int IDENTITY(1,1),
Name varchar(30),
Code char(10),
CommissionRate int
) ON [PRIMARY];


-- Create Sales Transaction fact table
CREATE TABLE dbo.SalesFact(
CustomerKey int,
DateKey int,
PaymentTypeKey int,
ChannelTypeKey int,
InvoiceNumber nvarchar(30),
TotalCost float,
TotalRetailPrice float,
) ON [PRIMARY];



-- Add primary key constraints to the dimensional tables
ALTER TABLE dbo.DateDim
ADD CONSTRAINT PK_DateDim PRIMARY KEY (DateKey);
ALTER TABLE dbo.CustomerDim
ADD CONSTRAINT PK_CustomerDim PRIMARY KEY (CustomerKey);
ALTER TABLE dbo.PaymentTypeDim
ADD CONSTRAINT PK_PaymentTypeDim PRIMARY KEY (PaymentTypeKey);
ALTER TABLE dbo.ChannelTypeDim
ADD CONSTRAINT PK_ChannelTypeDim PRIMARY KEY (ChannelTypeKey);


-- Add foreign key constraints to the Sales Transaction fact table
ALTER TABLE dbo.SalesFact
ADD CONSTRAINT FK_SalesFact_CustomerKey FOREIGN KEY (CustomerKey) REFERENCES dbo.CustomerDim(CustomerKey),
    CONSTRAINT FK_SalesFact_DateKey FOREIGN KEY (DateKey) REFERENCES dbo.DateDim(DateKey),
    CONSTRAINT FK_SalesFact_PaymentTypeKey FOREIGN KEY (PaymentTypeKey) REFERENCES dbo.PaymentTypeDim(PaymentTypeKey),
    CONSTRAINT FK_SalesFact_ChannelTypeKey FOREIGN KEY (ChannelTypeKey) REFERENCES dbo.ChannelTypeDim(ChannelTypeKey);


-- Step 1: Create Staging Tables
-- Create a Staging Table for Date dimension table
CREATE TABLE StagingDateDim (
    DateKey varchar(50),
    FullDate varchar(50),
    DateName varchar(50),
    DayOfWeek varchar(50),
    DayNameOfWeek varchar(50),
    DayOfMonth varchar(50),
    DayOfYear varchar(50),
    WeekdayWeekend varchar(30),
    WeekOfYear varchar(50),
    MonthName varchar(30),
    MonthOfYear varchar(50),
    IsLastDayOfMonth varchar(50),
    CalendarQuarter varchar(50),
    CalendarYear varchar(50),
    CalendarYearMonth varchar(50),
    CalendarYearQtr varchar(50),
    FiscalMonthOfYear varchar(50),
    FiscalQuarter varchar(50),
    FiscalYear varchar(50),
    FiscalYearMonth varchar(50),
    FiscalYearQtr varchar(50)
);

-- Create a Staging Table for Customer dimension table
CREATE TABLE StagingCustomerDim (
    Name varchar(50),
    CustomerCode nvarchar(30),
    BirthDate varchar(50),
    MaritalStatus char(10),
    Gender char(10),
    PostCode nvarchar(30),
    City varchar(50),
    Income varchar(20)
);


--- Create a Staging Table for PaymentType Dimension table
CREATE TABLE StagingPaymentTypeDim (
    Name varchar(30),
    RetailerPaymentTypeId int
);

-- Create a Staging Table for Selling Channel Dimension table
CREATE TABLE StagingChannelTypeDim (
    Name varchar(30),
    Code char(10),
    CommissionRate int
);

-- Step 2: Bulk Insert into Staging Table
-- For Date Dim table
BULK INSERT StagingDateDim
FROM '/Generated DateTime.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM StagingDateDim

-- For Customer Dim table
BULK INSERT StagingCustomerDim
FROM '/CustomerDetails-1.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- For Payment Type Dim table
BULK INSERT StagingPaymentTypeDim
FROM '/PaymentsData.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

-- For Selling Channel Dim table
BULK INSERT StagingChannelTypeDim
FROM '/Selling Channels.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


-- Step 3: Insert Data into Actual Tables & Drop Staging Tables
-- For Date Dim table
SET IDENTITY_INSERT dbo.DateDim ON;
INSERT INTO dbo.DateDim (DateKey, FullDate, DateName, DayOfWeek, DayNameOfWeek, DayOfMonth, DayOfYear, WeekdayWeekend, WeekOfYear, MonthName, MonthOfYear, IsLastDayOfMonth, CalendarQuarter, CalendarYear, CalendarYearMonth, CalendarYearQtr, FiscalMonthOfYear, FiscalQuarter, FiscalYear, FiscalYearMonth, FiscalYearQtr)
SELECT
    CAST(DateKey AS int),
    CONVERT(date, FullDate, 103),  
    CONVERT(date, DateName, 103),  
    CAST(DayOfWeek AS int),
    DayNameOfWeek,
    CAST(DayOfMonth AS int),
    CAST(DayOfYear AS int),
    WeekdayWeekend,
    CAST(WeekOfYear AS int),
    MonthName,
    CAST(MonthOfYear AS int),
    IsLastDayOfMonth,
    CAST(CalendarQuarter AS int),
    CAST(CalendarYear AS int),
    CalendarYearMonth,  
    CalendarYearQtr,    
    CAST(FiscalMonthOfYear AS int),
    CAST(FiscalQuarter AS int),
    CAST(FiscalYear AS int),
    FiscalYearMonth,    
    FiscalYearQtr       
FROM StagingDateDim;
SET IDENTITY_INSERT dbo.DateDim OFF;


-- For Customer Dim table
INSERT INTO dbo.CustomerDim (Name, CustomerCode, BirthDate, MaritalStatus, Gender, PostCode, City,Income)
SELECT Name, CustomerCode, BirthDate, MaritalStatus, Gender, PostCode, City,Income
FROM StagingCustomerDim;
DROP TABLE StagingCustomerDim;

-- For Payment Type Dim table
INSERT INTO dbo.PaymentTypeDim (Name, RetailerPaymentTypeId)
SELECT Name, RetailerPaymentTypeId
FROM StagingPaymentTypeDim;
DROP TABLE StagingPaymentTypeDim;

-- For Selling Channel Dim table
INSERT INTO dbo.ChannelTypeDim (Name, Code, CommissionRate)
SELECT Name, Code, CommissionRate
FROM StagingChannelTypeDim;
DROP TABLE StagingChannelTypeDim;

SELECT * FROM dbo.ChannelTypeDim
-----------------------------------------------------------------------------------------------------------------------------------------

--Create Date key look up table
CREATE TABLE dbo.DateKeyLookUp(
    Date varchar(50) NOT NULL PRIMARY KEY, 
    DateKey int NOT NULL 
);

-- Create Customer key look up table
CREATE TABLE dbo.Customerkeylookup(
    CustomerCode varchar(50) NOT NULL PRIMARY KEY,
    CustomerKey int NOT NULL
);

-- Create PaymentType key look up table
CREATE TABLE dbo.PaymentTypekeylookup(
    PaymentTypeId int NOT NULL PRIMARY KEY,
    PaymentTypeKey int NOT NULL
);

-- Create ChannelType key look up table
CREATE TABLE dbo.ChannelTypekeylookup(
    SellingChannel char(10) NOT NULL PRIMARY KEY,
    ChannelTypeKey int NOT NULL
);

-- Populate Date Key Lookup
INSERT INTO dbo.DateKeyLookup (Date, DateKey)
SELECT CONVERT(VARCHAR(50), FullDate, 120), DateKey FROM dbo.DateDim;

-- Populate Customer Key Lookup
INSERT INTO dbo.CustomerKeyLookup (CustomerCode, CustomerKey)
SELECT CustomerCode, CustomerKey FROM dbo.CustomerDim
WHERE CustomerCode IS NOT NULL;

-- Populate Payment Type Key Lookup
INSERT INTO dbo.PaymentTypeKeyLookup (PaymentTypeId, PaymentTypeKey)
SELECT RetailerPaymentTypeId, PaymentTypeKey FROM dbo.PaymentTypeDim;


-- Populate Channel Type Key Lookup
INSERT INTO dbo.ChannelTypeKeyLookup (SellingChannel, ChannelTypeKey)
SELECT Code, ChannelTypeKey FROM dbo.ChannelTypeDim;

SELECT * FROM dbo.ChannelTypekeylookup

-- Create Staging Table for Sales Transactions:
CREATE TABLE dbo.StagingSalesTransactions(
    Date varchar(50),
    CustomerCode nvarchar(50),
    InvoiceNumber nvarchar(30),
    TotalCost float,
    TotalRetailPrice float,
    PaymentTypeId int,
    SellingChannel char(10)
);

-- Bulk Insert into Staging Fact Table 
BULK INSERT dbo.StagingSalesTransactions
FROM '/CustomerSaleTransactions.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


-- Use the lookup tables to fetch the respective keys and insert data into the SalesFact table.
INSERT INTO dbo.SalesFact (CustomerKey, DateKey, PaymentTypeKey, ChannelTypeKey, InvoiceNumber, TotalCost, TotalRetailPrice)
SELECT 
    ckl.CustomerKey, 
    dkl.DateKey, 
    ptkl.PaymentTypeKey, 
    ctkl.ChannelTypeKey, 
    sst.InvoiceNumber, 
    sst.TotalCost, 
    sst.TotalRetailPrice
FROM 
    dbo.StagingSalesTransactions sst
    JOIN dbo.CustomerKeyLookup ckl ON sst.CustomerCode = ckl.CustomerCode
    JOIN dbo.DateKeyLookup dkl ON sst.Date = dkl.Date
    JOIN dbo.PaymentTypeKeyLookup ptkl ON sst.PaymentTypeId = ptkl.PaymentTypeId
    JOIN dbo.ChannelTypeKeyLookup ctkl ON sst.SellingChannel = ctkl.SellingChannel;

-- Drop the Staging Table
DROP TABLE dbo.StagingSalesTransactions;

SELECT * FROM dbo.SalesFact


USE AdventureWorks2014
SELECT * FROM Purchasing.PurchaseOrderHeader
SELECT * FROM Purchasing.Vendor

--Simple SP with no parameters
CREATE PROC usp_Top10TaxPO
AS
BEGIN
	SELECT TOP 10 * FROM Purchasing.PurchaseOrderHeader
	ORDER BY TaxAmt DESC
END

EXEC usp_Top10TaxPO

--SP with a single input parameter
CREATE PROC usp_YearModified(@ModYear INT)
AS
BEGIN
	SELECT * FROM Purchasing.PurchaseOrderHeader
	WHERE YEAR(ModifiedDate) = @ModYear
END

EXEC usp_YearModified 2014

--SP with multiple input parameters
CREATE PROC usp_VendorAndEmployee(@VendID INT, @EmpID INT)
AS
BEGIN
	SELECT SUM(SubTotal) AS TotalAmout FROM Purchasing.PurchaseOrderHeader
	WHERE VendorID = @VendID AND EmployeeID = @EmpID
END

EXEC usp_VendorAndEmployee 1580,258

--SP with default values
CREATE PROC usp_PurchaseOrderDetails(@PONumber INT = 15)
AS
BEGIN
	SELECT * FROM Purchasing.PurchaseOrderHeader
	WHERE PurchaseOrderID = @PONumber
END

EXEC usp_PurchaseOrderDetails 10
EXEC usp_PurchaseOrderDetails

--SP with text parameter
CREATE PROC usp_NameLike(@NameText NVARCHAR(MAX))
AS
BEGIN
	SELECT * FROM Purchasing.Vendor
	WHERE NAME LIKE '%'+ @NameText +'%'
END

EXEC usp_NameLike 'bike'
EXEC usp_NameLike 'bicycles'

SELECT * FROM Purchasing.Vendor

--SP using variable
ALTER PROC usp_CompanyList(@CreditRt INT)
AS
BEGIN
	DECLARE @FirmList NVARCHAR(MAX)
	SET @FirmList = ''
	SELECT @FirmList=@FirmList + Name + CHAR(10) FROM Purchasing.Vendor
	WHERE CreditRating= @CreditRt
	PRINT @FirmList
END

EXEC usp_CompanyList 3

SELECT * FROM Purchasing.PurchaseOrderHeader
SP using output parameter
CREATE PROC usp_VendorTaxAmt(@VendID INT, @VendTaxAmt DECIMAL(10,2) OUTPUT)
AS
BEGIN
	SELECT @VendTaxAmt = SUM(TaxAmt) FROM Purchasing.PurchaseOrderHeader
	WHERE VendorID = @VendID
END

DECLARE @VendTax DECIMAL(10,2)
EXEC usp_VendorTaxAmt 1496, @VendTax OUTPUT
PRINT @VendTax

DECLARE @VendorTax DECIMAL(10,2)
EXEC usp_VendorTaxAmt @VendID = 1496, @VendTaxAmt= @VendorTax OUT
PRINT @VendorTax


SELECT * FROM Purchasing.PurchaseOrderHeader
SELECT * FROM Purchasing.Vendor


--Without using RETURN Clause
CREATE PROC usp_VendorCountByYear(@ModYear INT,@VendCount INT OUT)
AS
BEGIN
	SELECT @VendCount =  COUNT(VendorID) FROM Purchasing.PurchaseOrderHeader
	WHERE YEAR(ModifiedDate) = @ModYear
END

DECLARE @VendorCount INT
EXEC usp_VendorCountByYear 2015, @VendorCount OUT
SELECT @VendorCount AS 'Number of vendors'


--With using RETURN clause
CREATE PROC usp_VendorCountByYear2(@ModYear INT)
AS
BEGIN
	RETURN
	(SELECT COUNT(VendorID) FROM Purchasing.PurchaseOrderHeader
	WHERE YEAR(ModifiedDate) = @ModYear)
END

DECLARE @VendorCount INT
EXEC @VendorCount =  usp_VendorCountByYear2 2015
SELECT @VendorCount 

Fetch STRING value without using RETURN Clause
CREATE PROC usp_NameByID(@BID INT, @FirmName NVARCHAR(MAX) OUT)
AS
BEGIN
	SELECT @FirmName = Name FROM Purchasing.Vendor
	WHERE BusinessEntityID = @BID
END

DECLARE @BizName NVARCHAR(MAX)
EXEC usp_NameByID 1508, @BizName OUT
SELECT @BizName AS 'Business Name'



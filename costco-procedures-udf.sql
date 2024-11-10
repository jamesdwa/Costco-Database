-- 1. A procedure to get an ID
--Behavior: Gets the specific product type ID depending on the users specified department ID,
--          product name, and the cost of the product. Prints out the product type ID to
--          the user where the user must specify all three categories to get a product type ID.
--Exception: N/A
--Return: the product type ID specified by the user depending on the department ID, product name, 
--        and cost of the product.
--Parameter: N/A 
CREATE OR ALTER PROCEDURE GetProductTypeID_ldinh2
@DepartmentTypeID INT, 
@ProductTypeName VARCHAR(30),
@ProductCost INT,
@ProductTypeID INT OUTPUT 
AS 
SET @ProductTypeID = (
    SELECT ProductTypeID 
    FROM tblPRODUCT_Type 
    WHERE DepartmentTypeID = @DepartmentTypeID 
    AND ProductTypeName = @ProductTypeName 
    AND ProductCost = @ProductCost
)
GO 
DECLARE @ProductTypeID INT 
EXEC GetProductTypeID_ldinh2
    @DepartmentTypeID = 1, 
    @ProductTypeName = 'T-shirt',
    @ProductCost = 19,
    @ProductTypeID = @ProductTypeID OUTPUT 
print(@ProductTypeID)

-- 2. A procedure to insert a value into a table
GO
ALTER PROCEDURE Update_Customer_table
@Customer_Typename VARCHAR(40),
@Customer_Lname varchar(40),
@Customer_Email varchar(60),
@Customer_BDate DATE,
@Customer_Adress varchar(50),
@CustomerDescr varchar(80),
@Customer_FirstName varchar(40), 
@Membership varchar(60)
AS
DECLARE @Customer_Type_IDS INTEGER
SET @Customer_Type_IDS = (Select CustomerTypeID FROM tblCUSTOMER_TYPE WHERE Customer_TypeName =
@Customer_Typename)
Begin Transaction UPDATING_CUSTOMER
INSERT INTO tblCUSTOMER(CustomerFname, CustomerLname, CustomerBirthDate, CustomerAddress, CustomerEmail, CustomerDescr, 
CustomerTypeID, Membership)
VALUES(@Customer_FirstName, @Customer_Lname, @Customer_BDate, @Customer_Adress, @Customer_Email, @CustomerDescr, 
@Customer_Type_IDS, @Membership)
COMMIT TRANSACTION UPDATING_CUSTOMER
GO

INSERT INTO tblCUSTOMER_TYPE(Customer_TypeName, Customer_TypeDescr, BeginDate, Endate)
VALUES('Buyer' , 'Buys in single quantities', '2000-01-03', '2012-08-03')

-- 3. A computed column relative to your database
CREATE FUNCTION costco_totalQuantity(@PK INT)
RETURNs INT
AS
BEGIN
DECLARE @RET INT = ( SELECT SUM(O.OrderQuantity)
								FROM tblCUSTOMER AS C
                                    JOIN tblORDER AS O
                                        ON C.CustomerID = O.CustomerID
                                WHERE C.CustomerID = @PK
)
RETURN @RET
END
GO
ALTER TABLE tblCUSTOMER
ADD costco_totalQuantity AS (dbo.costco_totalQuantity(CustomerID))
GO

-- 4. A business rule relative to your database

CREATE FUNCTION dbo.CKCustomerAgeForPurchase()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0

    IF EXISTS (
        SELECT *
        FROM tblCustomer C
        JOIN tblCUSTOMER_TYPE CT ON C.CustomerTypeID = CT.CustomerTypeID
        WHERE CT.BeginDate <= GETDATE() -- check if customer type is valid
        AND DATEDIFF(YEAR, C.CustomerBirthDate, GETDATE()) < 18 -- check over 18
    )
    BEGIN 
        SET @RET = 1    --customer under 18, do not allow
    END 

    RETURN @RET
END
GO

ALTER TABLE dbo.tblCustomer WITH NOCHECK
ADD CONSTRAINT CK_CustomerAgeForPurchase2 CHECK (
    DATEDIFF(YEAR, CustomerBirthDate, GETDATE()) >= 18
)
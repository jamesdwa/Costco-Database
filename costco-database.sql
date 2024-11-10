CREATE TABLE tblCUSTOMER_TYPE
(
CustomerTypeID Integer identity(1,1) primary key,
Customer_TypeName varchar(40),
Customer_TypeDescr varchar(80),
BeginDate DATE,
Endate DATE
)

CREATE TABLE tblCUSTOMER
(
CustomerID Integer identity(1,1) primary key,
CustomerFname varchar(50),
CustomerLname varchar(50),
CustomerEmail varchar(50),
CustomerBirthDate DATE,
CustomerAddress varchar(50),
CustomerDescr varchar(70),
Membership varchar(50)
)

ALTER TABLE tblCUSTOMER
ADD CustomerTypeID INTEGER
FOREIGN KEY REFERENCES tblCUSTOMER_TYPE(CustomerTypeID)

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

INSERT INTO tblCUSTOMER_TYPE(Customer_TypeName, Customer_TypeDescr, BeginDate, Endate)
VALUES('Consumer' , 'Buys large quanties of Stock', '2000-04-18', NULL)

INSERT INTO tblCUSTOMER_TYPE(Customer_TypeName, Customer_TypeDescr, BeginDate, Endate)
VALUES('tech Enthusiasts' , 'Enages with technical stocks', '2000-01-13', '2023-05-19')

INSERT INTO tblCUSTOMER(CustomerFname, CustomerTypeID, CustomerLname, CustomerEmail,
CustomerBirthDate, CustomerAddress, CustomerDescr, Membership)
VALUES('James', (Select CustomerTypeID From tblCUSTOMER_TYPE WHERE Customer_TypeName =
'Buyer'),
'Lebron', 'jamesLebronn11@gmail.com', 'March 11 2001', '1977 south anderson st',
'Black', 'Business Membership')

INSERT INTO tblCUSTOMER(CustomerFname, CustomerTypeID, CustomerLname, CustomerEmail,
CustomerBirthDate, CustomerAddress, CustomerDescr, Membership)
VALUES('Curry', (Select CustomerTypeID From tblCUSTOMER_TYPE WHERE Customer_TypeName =
'tech Enthusiasts'),
'Stephen', 'stephencurry30@gmail.com', 'April 9 2008', '2045 south east pines st',
'Black', 'Exceutive Membership')

INSERT INTO tblCUSTOMER(CustomerFname, CustomerTypeID, CustomerLname, CustomerEmail,
CustomerBirthDate, CustomerAddress, CustomerDescr, Membership)
VALUES('Ant', (Select CustomerTypeID From tblCUSTOMER_TYPE WHERE Customer_TypeName =
'Consumer'),
'Edwards', 'anthonyedwards100@gmail.com', 'August 9 2001', '9876 east yesler st',
'White Asian', 'Exceutive Membership')

----------------------------------------------------------------------------------

CREATE TABLE tblORDER_TYPE (
    OrderTypeID INT PRIMARY KEY,
    OrderTypeName VARCHAR(256),
    OrderTypeDesc VARCHAR(256),
    OrderStatus  VARCHAR(256)
)

CREATE TABLE tblORDER (
    OrderID INT PRIMARY KEY,
    OrderTypeID INT,
    CustomerID INT,
    OrderDate Date,
    OrderQuantity INT,
    OrderTotal INT
    FOREIGN KEY (OrderTypeID) REFERENCES tblORDER_TYPE(OrderTypeID)
)

CREATE PROCEDURE addORDER 
@SP_OrderID INT, 
@SP_OrderTypeID INT, 
@SP_CustomerID INT,
@SP_OrderDate DATE,  
@SP_OrderQuantity INT, 
@SP_OrderTotal INT 
AS 
BEGIN TRANSACTION T3 
INSERT INTO tblORDER(OrderID, OrderTypeID, CustomerID, OrderDate, OrderQuantity, OrderTotal)
VALUES(@SP_OrderID, @SP_OrderTypeID, @SP_CustomerID , @SP_OrderDate, @SP_OrderQuantity, @SP_OrderTotal)
COMMIT TRANSACTION T3

CREATE PROCEDURE addOrder_Type 
@SP_OrderTypeID INT, 
@SP_OrderTypeName VARCHAR(256), 
@SP_OrderTypeDesc VARCHAR(256),
@SP_OrderStatus VARCHAR(256)
AS 
BEGIN TRANSACTION T4 
INSERT INTO tblORDER_TYPE(OrderTypeID, OrderTypeName, OrderTypeDesc, OrderStatus)
VALUES(@SP_OrderTypeID, @SP_OrderTypeName, @SP_OrderTypeDesc, @SP_OrderStatus)
COMMIT TRANSACTION T4

EXEC addOrder_Type
@SP_OrderTypeID = 1, 
@SP_OrderTypeName = 'In Store',
@SP_OrderTypeDesc = 'In person',
@SP_OrderStatus = 'Completed Purchase'

-- 1 = in store -- 2 = online 
EXEC addOrder_Type
@SP_OrderTypeID = 2, 
@SP_OrderTypeName = 'Online Purchase',
@SP_OrderTypeDesc = 'Online Shopper',
@SP_OrderStatus = 'In progress'

EXEC addOrder_Type
@SP_OrderTypeID = 3, 
@SP_OrderTypeName = 'Order pickup',
@SP_OrderTypeDesc = 'In person',
@SP_OrderStatus = 'In progress'

EXEC addORDER 
@SP_OrderID = 1, 
@SP_OrderTypeID = 1, 
@SP_CustomerID = 1, 
@SP_OrderDate = '2019-01-04',
@SP_OrderQuantity = 1, 
@SP_OrderTotal = 90 

EXEC addORDER 
@SP_OrderID = 2, 
@SP_OrderTypeID = 2,
@SP_CustomerID = 2,  
@SP_OrderDate = '2024-02-25',
@SP_OrderQuantity = 1, 
@SP_OrderTotal = 50 

EXEC addORDER 
@SP_OrderID = 3, 
@SP_OrderTypeID = 3,
@SP_CustomerID = 3,  
@SP_OrderDate = '2023-12-23',
@SP_OrderQuantity = 2, 
@SP_OrderTotal = 400 

----------------------------------------------------------------------------------

 -- tblDEPARTMENTTYPE represents the specific department for a product 
--  with its department id for the product, and the department type for the specific product 
-- SET IDENTITY_INSERT tblDEPARTMENT_TYPE ON 

CREATE TABLE tblDEPARTMENT_TYPE(
    DepartmentTypeID INT PRIMARY KEY, 
    DepartmentType VARCHAR(30), 
)

-- tblPRODUCTTYPE is the specific type of the product with association of the product types id, 
-- department types id that references the department type id (foreign key), and the product type name 
-- which represent the department name that is mapped with the id 

CREATE TABLE tblPRODUCT_TYPE(
    ProductTypeID INT PRIMARY KEY, 
    DepartmentTypeID INT,
    ProductTypeName VARCHAR(30), 
    ProductCost INT,
    FOREIGN KEY (DepartmentTypeID) REFERENCES tblDEPARTMENT_TYPE(DepartmentTypeID), 
)

CREATE TABLE tblPRODUCT (
    ProductID INT PRIMARY KEY,
    ProductTypeID INT,
    ProductName VARCHAR(256),
    FOREIGN KEY (ProductTypeID) REFERENCES tblPRODUCT_TYPE(ProductTypeID)
)

CREATE PROCEDURE addDepartment_Type
@SP_DepartmentTypeID INT, 
@SP_DepartmentType VARCHAR(30)
AS 
BEGIN TRANSACTION T1 
INSERT INTO tblDEPARTMENT_TYPE(DepartmentTypeID, DepartmentType)
VALUES(@SP_DepartmentTypeID, @SP_DepartmentType)
COMMIT TRANSACTION T1

EXEC addDepartment_Type
@SP_DepartmentTypeID = 1, 
@SP_DepartmentType = 'Clothing'

EXEC addDepartment_Type
@SP_DepartmentTypeID = 2, 
@SP_DepartmentType = 'Grocery'

EXEC addDepartment_Type
@SP_DepartmentTypeID = 3, 
@SP_DepartmentType = 'Electronic'

CREATE PROCEDURE addProduct_Type
@SP_ProductTypeID INT, 
@SP_DepartmentTypeID INT, 
@SP_ProductTypeName VARCHAR(30),
@SP_ProductCost INT
AS 
BEGIN TRANSACTION T2
INSERT INTO tblPRODUCT_TYPE(ProductTypeID, DepartmentTypeID, ProductTypeName, ProductCost)
VALUES(@SP_ProductTypeID, @SP_DepartmentTypeID, @SP_ProductTypeName, @SP_ProductCost)
COMMIT TRANSACTION T2

EXEC addProduct_Type
    @SP_ProductTypeID = 1, 
    @SP_DepartmentTypeID = 1, 
    @SP_ProductTypeName = 'T-shirt', 
    @SP_ProductCost = 19 

EXEC addProduct_Type
    @SP_ProductTypeID = 2, 
    @SP_DepartmentTypeID = 3, 
    @SP_ProductTypeName = 'Ipad', 
    @SP_ProductCost = 1024 

EXEC addProduct_Type
    @SP_ProductTypeID = 3, 
    @SP_DepartmentTypeID = 2, 
    @SP_ProductTypeName = 'Banana', 
    @SP_ProductCost = 2 

EXEC addProduct_Type
    @SP_ProductTypeID = 4, 
    @SP_DepartmentTypeID = 2, 
    @SP_ProductTypeName = 'Raw Chicken Breast', 
    @SP_ProductCost = 10

----------------------------------------------------------------------------------

CREATE TABLE tblRECEIPT (
    ReceiptID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    NumberItems INT,
    FOREIGN KEY (OrderID) REFERENCES tblORDER(OrderID),
    FOREIGN KEY (ProductID) REFERENCES tblPRODUCT(ProductID),
)

CREATE PROCEDURE addProduct
    @ProductID INT,
    @ProductTypeID INT,
    @ProductName VARCHAR(256)
AS
BEGIN
    INSERT INTO tblPRODUCT (ProductID, ProductTypeID, ProductName)
    VALUES (@ProductID, @ProductTypeID, @ProductName)
END
GO

CREATE PROCEDURE addReceipt
    @ReceiptID INT,
    @OrderID INT,
    @ProductID INT,
    @NumberItems INT
AS
BEGIN
    INSERT INTO tblRECEIPT (ReceiptID, OrderID, ProductID, NumberItems)
    VALUES (@ReceiptID, @OrderID, @ProductID, @NumberItems)
END
GO

EXEC addProduct 1, 1, 'Adidas'
EXEC addProduct 2, 2, 'Apple'
EXEC addProduct 3, 3, 'Del Monte'

EXEC addReceipt 1, 1, 1, 1
EXEC addReceipt 2, 2, 2, 2
EXEC addReceipt 3, 3, 3, 3
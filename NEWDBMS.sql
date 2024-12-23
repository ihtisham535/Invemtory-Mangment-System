CREATE DATABASE project;
USE project;

CREATE TABLE IMS_Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,            
    SKU NVARCHAR(50) UNIQUE NOT NULL,       
    Category NVARCHAR(50) NULL,             
    Quantity INT DEFAULT 0,                 
    UnitPrice DECIMAL(10,2),                 
    Barcode NVARCHAR(50) NULL,               
    CreatedAt DATETIME DEFAULT GETDATE(),   
    UpdatedAt DATETIME DEFAULT GETDATE()     
);

CREATE TABLE IMS_Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(100) NOT NULL,      
    ContactName NVARCHAR(100) NULL,           
    Phone NVARCHAR(15) NULL,                  
    Email NVARCHAR(100) NULL,                 
    Address NVARCHAR(255) NULL               
);

CREATE TABLE IMS_PurchaseOrders (
    PurchaseOrderID INT PRIMARY KEY IDENTITY(1,1), 
    SupplierID INT,                               
    OrderDate DATETIME DEFAULT GETDATE(),          
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Cancelled')),
    TotalAmount DECIMAL(10,2) NULL,                

    FOREIGN KEY (SupplierID) REFERENCES IMS_Suppliers(SupplierID)
);

CREATE TABLE IMS_PurchaseOrderDetails (
    PODetailID INT PRIMARY KEY IDENTITY(1,1), 
    PurchaseOrderID INT,                     
    ProductID INT,                          
    Quantity INT NOT NULL,                  
    UnitPrice DECIMAL(10,2) NOT NULL,        

    FOREIGN KEY (PurchaseOrderID) REFERENCES IMS_PurchaseOrders(PurchaseOrderID),
    FOREIGN KEY (ProductID) REFERENCES IMS_Products(ProductID)
);

CREATE TABLE IMS_SalesOrders (
    SalesOrderID INT PRIMARY KEY IDENTITY(1,1), 
    CustomerName NVARCHAR(100) NULL,            
    OrderDate DATETIME DEFAULT GETDATE(),       
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Cancelled')), 
    TotalAmount DECIMAL(10,2) NULL             
);

CREATE TABLE IMS_SalesOrderDetails (
    SODetailID INT PRIMARY KEY IDENTITY(1,1), 
    SalesOrderID INT,                        
    ProductID INT,                            
    Quantity INT NOT NULL,                    
    UnitPrice DECIMAL(10,2) NOT NULL,         

    FOREIGN KEY (SalesOrderID) REFERENCES IMS_SalesOrders(SalesOrderID),
    FOREIGN KEY (ProductID) REFERENCES IMS_Products(ProductID)
);

CREATE TABLE IMS_StockMovements (
    MovementID INT PRIMARY KEY IDENTITY(1,1),                 
    ProductID INT,                                            
    MovementType NVARCHAR(20) CHECK (MovementType IN ('IN', 'OUT', 'ADJUSTMENT')),
    Quantity INT NOT NULL,                                    
    MovementDate DATETIME DEFAULT GETDATE(),                  
    Description NVARCHAR(255) NULL,                            
    
    FOREIGN KEY (ProductID) REFERENCES IMS_Products(ProductID)
);

CREATE TABLE IMS_Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),                     
    Username NVARCHAR(50) UNIQUE NOT NULL,                     
    PasswordHash NVARCHAR(255) NOT NULL,                       
    Role NVARCHAR(20) CHECK (Role IN ('Admin', 'Manager', 'Staff')), 
    CreatedAt DATETIME DEFAULT GETDATE()                    
);

CREATE TABLE IMS_AuditLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),                      
    UserID INT,                                               
    Action NVARCHAR(100) NOT NULL,                          
    TableAffected NVARCHAR(50) NULL,
    ActionTime DATETIME DEFAULT GETDATE(),                    
    Description NVARCHAR(255) NULL,                           

    FOREIGN KEY (UserID) REFERENCES IMS_Users(UserID)
);

CREATE TABLE IMS_Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),                  
    CategoryName NVARCHAR(100) UNIQUE NOT NULL,               
    Description NVARCHAR(255) NULL                           
);

-- Insert Sample Data
INSERT INTO IMS_Products (Name, SKU, Category, Quantity, UnitPrice, Barcode)
VALUES 
('Dawn Bread - Large', 'SKU-PK-DB01', 'Bakery', 500, 150.00, '1234567890'),
('Shan Biryani Masala 50g', 'SKU-PK-SM01', 'Spices', 300, 80.00, '1234567891'),
('Tapal Danedar 400g', 'SKU-PK-TD01', 'Beverages', 200, 420.00, '1234567892'),
('Nestle Milk Pack 1L', 'SKU-PK-NM01', 'Dairy', 150, 210.00, '1234567893'),
('Ferrero Rocher 16pc', 'SKU-IM-FR01', 'Imported Snacks', 50, 1500.00, '1234567894'),
('Nutella 350g', 'SKU-IM-NT01', 'Imported Snacks', 100, 950.00, '1234567895'),
('Olpers Cream 200ml', 'SKU-PK-OC01', 'Dairy', 250, 90.00, '1234567896'),
('Cadbury Dairy Milk 110g', 'SKU-IM-CDM01', 'Imported Chocolates', 75, 400.00, '1234567897');

INSERT INTO IMS_Suppliers (SupplierName, ContactName, Phone, Email, Address)
VALUES 
('Dawn Foods', 'Ali Khan', '0300-1234567', 'ali@dawnfoods.com', 'Lahore, Pakistan'),
('Shan Foods', 'Ahmed Raza', '0312-6543210', 'ahmed@shanfoods.com', 'Karachi, Pakistan'),
('Tapal Tea Pvt Ltd', 'Farhan Iqbal', '0321-9876543', 'farhan@tapal.com', 'Karachi, Pakistan'),
('Nestle Pakistan', 'Saad Iqbal', '0301-1112233', 'saad@nestle.pk', 'Sheikhupura, Pakistan'),
('Metro International Imports', 'John Doe', '0333-4445566', 'john@metro-imports.com', 'Dubai, UAE');

INSERT INTO IMS_PurchaseOrders (SupplierID, OrderDate, Status, TotalAmount)
VALUES 
(1, GETDATE(), 'Completed', 75000.00),
(2, GETDATE(), 'Pending', 24000.00),
(3, GETDATE(), 'Completed', 84000.00),
(4, GETDATE(), 'Pending', 31500.00),
(5, GETDATE(), 'Completed', 130000.00);

INSERT INTO IMS_Categories (CategoryName, Description)
VALUES 
('Bakery', 'Breads, cakes, and pastries'),
('Spices', 'Locally and internationally sourced spices'),
('Beverages', 'Tea, coffee, and juices'),
('Dairy', 'Milk, butter, and cream products'),
('Imported Snacks', 'Imported packaged snacks'),
('Imported Chocolates', 'Imported luxury chocolates');
INSERT INTO IMS_PurchaseOrderDetails (PurchaseOrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 500, 150.00),  
(2, 2, 300, 80.00),   
(3, 3, 200, 420.00),  
(4, 4, 150, 210.00),  
(5, 5, 50, 1500.00);

INSERT INTO IMS_SalesOrders (CustomerName, OrderDate, Status, TotalAmount)
VALUES 
('Hassan Ali', GETDATE(), 'Shipped', 6000.00),
('Zara Khan', GETDATE(), 'Pending', 8500.00),
('Ali Raza', GETDATE(), 'Shipped', 12500.00);

INSERT INTO IMS_SalesOrderDetails (SalesOrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 20, 150.00),   
(2, 3, 10, 420.00),   
(3, 6, 5, 950.00);

INSERT INTO IMS_StockMovements (ProductID, MovementType, Quantity, Description)
VALUES 
(1, 'IN', 500, 'Initial Stock Purchase'),
(2, 'IN', 300, 'Shan Masala Restock'),
(3, 'OUT', 20, 'Sold Tapal Tea to Zara Khan'),
(6, 'OUT', 5, 'Nutella Sold to Ali Raza'),
(4, 'IN', 150, 'Nestle Milk Inventory Update');

INSERT INTO IMS_Users (Username, PasswordHash, Role)
VALUES 
('admin', 'hashedpassword123', 'Admin'),
('manager1', 'hashedpassword456', 'Manager'),
('staff1', 'hashedpassword789', 'Staff');



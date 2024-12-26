-- Little Lemon Database Schema
-- Create the database
CREATE DATABASE IF NOT EXISTS LittleLemonDB;
USE LittleLemonDB;

-- Staff Table
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20),
    HireDate DATE NOT NULL,
    CONSTRAINT chk_salary CHECK (Salary > 0)
);

-- Customer Details Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(200) NOT NULL,
    City VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    Country VARCHAR(50) NOT NULL DEFAULT 'USA',
    JoinDate DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Menu Categories Table
CREATE TABLE MenuCategories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT
);

-- Menu Table
CREATE TABLE Menu (
    MenuItemID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (CategoryID) REFERENCES MenuCategories(CategoryID),
    CONSTRAINT chk_price CHECK (Price > 0)
);

-- Bookings Table
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    TableNumber INT NOT NULL,
    BookingDate DATE NOT NULL,
    BookingTime TIME NOT NULL,
    GuestCount INT NOT NULL,
    StaffID INT,
    SpecialRequests TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    CONSTRAINT chk_guests CHECK (GuestCount > 0 AND GuestCount <= 12)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL,
    BookingID INT,
    StaffID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    CONSTRAINT chk_total CHECK (TotalAmount >= 0)
);

-- Order Items Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (MenuItemID) REFERENCES Menu(MenuItemID),
    CONSTRAINT chk_quantity CHECK (Quantity > 0)
);

-- Order Delivery Status Table
CREATE TABLE OrderDeliveryStatus (
    StatusID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    DeliveryDate DATETIME,
    Status ENUM('Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    DeliveryAddress VARCHAR(200),
    DeliveryNotes TEXT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert sample menu categories
INSERT INTO MenuCategories (CategoryName, Description) VALUES
('Starters', 'Appetizers and small plates'),
('Main Courses', 'Primary dinner entrees'),
('Drinks', 'Beverages including soft drinks and cocktails'),
('Desserts', 'Sweet treats to end your meal');

-- Task 3: Show all databases
SHOW DATABASES;
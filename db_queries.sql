-- First, let's insert some sample data
USE LittleLemonDB;

-- Insert sample staff
INSERT INTO Staff (FirstName, LastName, Role, Salary, Email, PhoneNumber, HireDate) VALUES
('John', 'Doe', 'Manager', 60000, 'john.doe@littlelemon.com', '555-0101', '2023-01-01'),
('Jane', 'Smith', 'Chef', 50000, 'jane.smith@littlelemon.com', '555-0102', '2023-01-02');

-- Insert sample customers
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Address, City, PostalCode) VALUES
('Mike', 'Johnson', 'mike.j@email.com', '555-0201', '123 Main St', 'Chicago', '60601'),
('Sarah', 'Wilson', 'sarah.w@email.com', '555-0202', '456 Park Ave', 'Chicago', '60601');

-- Insert sample menu items
INSERT INTO MenuCategories (CategoryName, Description) VALUES
('Main Course', 'Primary dishes'),
('Starters', 'Appetizers');

INSERT INTO Menu (Name, Description, Price, CategoryID) VALUES
('Grilled Salmon', 'Fresh Atlantic salmon', 25.99, 1),
('Caesar Salad', 'Classic salad with romaine lettuce', 12.99, 2),
('Steak', 'Premium cut beef', 35.99, 1);

-- Insert sample bookings
INSERT INTO Bookings (CustomerID, TableNumber, BookingDate, BookingTime, GuestCount, StaffID) VALUES
(1, 1, '2024-01-01', '18:00', 2, 1),
(2, 2, '2024-01-01', '19:00', 4, 1);

-- Insert sample orders
INSERT INTO Orders (CustomerID, TotalAmount, BookingID, StaffID) VALUES
(1, 180.99, 1, 1),
(2, 120.99, 2, 2);

INSERT INTO OrderItems (OrderID, MenuItemID, Quantity, UnitPrice) VALUES
(1, 1, 3, 25.99),
(1, 2, 1, 12.99),
(2, 3, 2, 35.99);

-- Task 1: Create OrdersView
CREATE OR REPLACE VIEW OrdersView AS
SELECT 
    o.OrderID,
    oi.Quantity,
    o.TotalAmount AS Cost
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE oi.Quantity > 2;

-- Query OrdersView
SELECT * FROM OrdersView;

-- Task 2: JOIN query for orders > $150
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    o.OrderID,
    o.TotalAmount AS Cost,
    m.Name AS MenuName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Menu m ON oi.MenuItemID = m.MenuItemID
WHERE o.TotalAmount > 150
ORDER BY o.TotalAmount ASC;

-- Task 3: Subquery for menu items with more than 2 orders
SELECT DISTINCT m.Name AS MenuName
FROM Menu m
WHERE m.MenuItemID = ANY (
    SELECT MenuItemID 
    FROM OrderItems 
    GROUP BY MenuItemID
    HAVING SUM(Quantity) > 2
);

-- Additional useful queries for verification
-- Check all orders with details
SELECT 
    o.OrderID,
    c.FirstName,
    c.LastName,
    m.Name AS MenuItem,
    oi.Quantity,
    oi.UnitPrice,
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Menu m ON oi.MenuItemID = m.MenuItemID
ORDER BY o.OrderID;
USE LittleLemonDB;

-- Task 1: Create GetMaxQuantity procedure
DELIMITER //

CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS MaxQuantityInOrder
    FROM OrderItems;
END //

DELIMITER ;

-- Test the GetMaxQuantity procedure
CALL GetMaxQuantity();

-- Task 2: Create GetOrderDetail prepared statement
DELIMITER //

CREATE PROCEDURE CreateGetOrderDetail()
BEGIN
    SET @sql = 'PREPARE GetOrderDetail FROM 
        "SELECT o.OrderID, oi.Quantity, o.TotalAmount AS Cost 
         FROM Orders o 
         JOIN OrderItems oi ON o.OrderID = oi.OrderID 
         WHERE o.CustomerID = ?";';
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- Execute the procedure to create the prepared statement
CALL CreateGetOrderDetail();

-- Example usage of GetOrderDetail
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

-- Task 3: Create CancelOrder procedure
DELIMITER //

CREATE PROCEDURE CancelOrder(IN orderIDToCancel INT)
BEGIN
    -- Declare variables for error handling
    DECLARE order_exists INT DEFAULT 0;
    
    -- Check if order exists
    SELECT COUNT(*) INTO order_exists 
    FROM Orders 
    WHERE OrderID = orderIDToCancel;
    
    -- Start transaction
    START TRANSACTION;
    
    IF order_exists > 0 THEN
        -- Delete from OrderDeliveryStatus first (if exists)
        DELETE FROM OrderDeliveryStatus 
        WHERE OrderID = orderIDToCancel;
        
        -- Delete from OrderItems
        DELETE FROM OrderItems 
        WHERE OrderID = orderIDToCancel;
        
        -- Delete from Orders
        DELETE FROM Orders 
        WHERE OrderID = orderIDToCancel;
        
        -- Commit the transaction
        COMMIT;
        
        SELECT CONCAT('Order ', orderIDToCancel, ' is cancelled') AS Confirmation;
    ELSE
        -- Rollback if order doesn't exist
        ROLLBACK;
        SELECT CONCAT('Order ', orderIDToCancel, ' does not exist') AS ErrorMessage;
    END IF;
    
END //

DELIMITER ;

-- Example usage of CancelOrder
CALL CancelOrder(1);

-- Additional helper procedures for testing

-- Procedure to view all orders
DELIMITER //

CREATE PROCEDURE ViewAllOrders()
BEGIN
    SELECT 
        o.OrderID,
        o.CustomerID,
        c.FirstName,
        c.LastName,
        o.TotalAmount,
        GROUP_CONCAT(CONCAT(m.Name, ' (', oi.Quantity, ')')) AS OrderItems
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    JOIN Menu m ON oi.MenuItemID = m.MenuItemID
    GROUP BY o.OrderID;
END //

DELIMITER ;

-- Test Queries
-- View all orders
CALL ViewAllOrders();

-- Get maximum quantity
CALL GetMaxQuantity();

-- Get order details for customer 1
SET @id = 1;
EXECUTE GetOrderDetail USING @id;
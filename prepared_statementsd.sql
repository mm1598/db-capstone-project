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

-- New Booking Management Procedures

-- AddBooking procedure
DELIMITER //

CREATE PROCEDURE AddBooking(
    IN booking_id INT,
    IN customer_id INT,
    IN booking_date DATE,
    IN table_number INT
)
BEGIN
    -- Insert new booking record
    INSERT INTO Bookings (BookingID, CustomerID, BookingDate, TableNumber)
    VALUES (booking_id, customer_id, booking_date, table_number);
END //

DELIMITER ;

-- UpdateBooking procedure
DELIMITER //

CREATE PROCEDURE UpdateBooking(
    IN booking_id INT,
    IN booking_date DATE
)
BEGIN
    -- Declare variables for validation
    DECLARE booking_exists INT DEFAULT 0;
    
    -- Check if booking exists
    SELECT COUNT(*) INTO booking_exists 
    FROM Bookings 
    WHERE BookingID = booking_id;
    
    -- Update booking if it exists
    IF booking_exists > 0 THEN
        UPDATE Bookings 
        SET BookingDate = booking_date 
        WHERE BookingID = booking_id;
        
        SELECT CONCAT('Booking ', booking_id, ' updated to ', booking_date) AS 'Confirmation';
    ELSE
        SELECT CONCAT('Booking ', booking_id, ' does not exist') AS 'Error';
    END IF;
END //

DELIMITER ;

-- CancelBooking procedure
DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN booking_id INT
)
BEGIN
    -- Delete booking
    DELETE FROM Bookings 
    WHERE BookingID = booking_id;
END //

DELIMITER ;

-- Test the new procedures
CALL AddBooking(5, 1, '2024-01-15', 3);
CALL UpdateBooking(5, '2024-01-16');
CALL CancelBooking(5);

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
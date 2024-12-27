USE LittleLemonDB;

-- Task 1: Insert booking records
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID) VALUES
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

-- Verify the insertions
SELECT * FROM Bookings ORDER BY BookingID;

-- Task 2: Create CheckBooking procedure
DELIMITER //

CREATE PROCEDURE CheckBooking(IN bookingDate DATE, IN tableNo INT)
BEGIN
    DECLARE tableStatus VARCHAR(100);
    
    -- Check if table is already booked on given date
    SELECT COUNT(*) INTO @bookingCount 
    FROM Bookings 
    WHERE BookingDate = bookingDate AND TableNumber = tableNo;
    
    -- Set status message based on availability
    IF @bookingCount > 0 THEN
        SET tableStatus = CONCAT('Table ', tableNo, ' is already booked on ', bookingDate);
    ELSE
        SET tableStatus = CONCAT('Table ', tableNo, ' is available on ', bookingDate);
    END IF;
    
    -- Return the status
    SELECT tableStatus AS 'Booking Status';
END //

DELIMITER ;

-- Test CheckBooking procedure
CALL CheckBooking('2022-10-10', 5);  -- Should show as booked
CALL CheckBooking('2022-12-01', 5);  -- Should show as available

-- Task 3: Create AddValidBooking procedure with transaction
DELIMITER //

CREATE PROCEDURE AddValidBooking(IN bookingDate DATE, IN tableNo INT, IN custID INT)
BEGIN
    DECLARE tableBooked INT DEFAULT 0;
    DECLARE nextBookingID INT;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Check if table is already booked
    SELECT COUNT(*) INTO tableBooked 
    FROM Bookings 
    WHERE BookingDate = bookingDate AND TableNumber = tableNo;
    
    -- Get next booking ID
    SELECT COALESCE(MAX(BookingID) + 1, 1) INTO nextBookingID FROM Bookings;
    
    IF tableBooked > 0 THEN
        -- Table is already booked - rollback
        SELECT CONCAT('Table ', tableNo, ' is already booked on ', bookingDate, ' - booking cancelled') AS 'Booking Status';
        ROLLBACK;
    ELSE
        -- Table is available - insert booking
        INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
        VALUES (nextBookingID, bookingDate, tableNo, custID);
        
        SELECT CONCAT('Table ', tableNo, ' has been booked successfully for ', bookingDate) AS 'Booking Status';
        COMMIT;
    END IF;
END //

DELIMITER ;

-- Test AddValidBooking procedure
-- Should fail (table 5 already booked on 2022-10-10)
CALL AddValidBooking('2022-10-10', 5, 1);

-- Should succeed (new date)
CALL AddValidBooking('2022-12-01', 5, 1);

-- Helper procedure to view all bookings
DELIMITER //

CREATE PROCEDURE ViewBookings()
BEGIN
    SELECT 
        b.BookingID,
        b.BookingDate,
        b.TableNumber,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
    FROM Bookings b
    JOIN Customers c ON b.CustomerID = c.CustomerID
    ORDER BY b.BookingDate;
END //

DELIMITER ;

-- View all bookings
CALL ViewBookings();
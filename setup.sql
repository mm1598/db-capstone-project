-- MySQL User Creation and Security Setup Script
-- Make sure to run this as root or a user with administrative privileges

-- 1. Create new user with password
-- Replace 'your_username' and 'your_strong_password' with your desired credentials
CREATE USER 'your_username'@'localhost' IDENTIFIED BY 'your_strong_password';
CREATE USER 'your_username'@'%' IDENTIFIED BY 'your_strong_password';

-- 2. Grant privileges to the user for localhost
GRANT ALL PRIVILEGES ON *.* TO 'your_username'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'your_username'@'%' WITH GRANT OPTION;

-- 3. Apply privileges
FLUSH PRIVILEGES;

-- 4. Verify user creation
SELECT user, host FROM mysql.user WHERE user = 'your_username';

-- 5. Verify user privileges
SHOW GRANTS FOR 'your_username'@'localhost';
SHOW GRANTS FOR 'your_username'@'%';

-- 6. Optional: Create a test database to verify access
CREATE DATABASE IF NOT EXISTS test_db;
GRANT ALL PRIVILEGES ON test_db.* TO 'your_username'@'localhost';
GRANT ALL PRIVILEGES ON test_db.* TO 'your_username'@'%';
FLUSH PRIVILEGES;

-- 7. Switch to test database
USE test_db;

-- 8. Create a test table
CREATE TABLE IF NOT EXISTS test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Insert test data
INSERT INTO test_table (name) VALUES ('Test Record');

-- 10. Verify as new user (run these commands after reconnecting as new user)
-- SELECT current_user();
-- SHOW DATABASES;
-- USE test_db;
-- SELECT * FROM test_table;

-- 11. Security best practices
-- Set password expiration policy (optional)
ALTER USER 'your_username'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
ALTER USER 'your_username'@'%' PASSWORD EXPIRE INTERVAL 90 DAY;

-- Set failed login attempt limits
ALTER USER 'your_username'@'localhost' FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
ALTER USER 'your_username'@'%' FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;

-- Require SSL for connections (if SSL is configured)
-- ALTER USER 'your_username'@'localhost' REQUIRE SSL;
-- ALTER USER 'your_username'@'%' REQUIRE SSL;

-- 12. Cleanup (comment out if you want to keep the test database)
-- DROP DATABASE test_db;

-- Connection Information for MySQL Workbench:
/*
Connection Name: Your_Connection_Name
Hostname: localhost
Port: 3306
Username: your_username
Password: your_strong_password
Default Schema: (leave blank or specify a schema)
*/

-- Additional Security Notes:
/*
1. Keep your password secure and never share it
2. Regular password changes are recommended
3. Monitor failed login attempts
4. Use SSL for remote connections
5. Regularly review user privileges
6. Back up your databases regularly
7. Keep MySQL updated with security patches
*/
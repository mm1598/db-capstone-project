import mysql.connector as connector

def connect_to_database():
    """Establish connection to the Little Lemon database"""
    try:
        # Task 1: Create connection
        connection = connector.connect(
            user="your_username",
            password="your_password",
            db="LittleLemonDB"
        )
        print("Connected to database successfully!")
        
        # Create cursor
        cursor = connection.cursor()
        return connection, cursor
    except connector.Error as e:
        print(f"Error connecting to database: {e}")
        return None, None

def show_tables(cursor):
    """Execute query to show all tables"""
    try:
        # Task 2: Show all tables
        show_tables_query = "SHOW tables"
        cursor.execute(show_tables_query)
        
        # Fetch all results
        results = cursor.fetchall()
        
        print("\nDatabase Tables:")
        for table in results:
            print(table[0])
        
        return results
    except connector.Error as e:
        print(f"Error showing tables: {e}")
        return None

def get_high_value_customers(cursor):
    """Get customers with orders over $60"""
    try:
        # Task 3: Join query for high-value customers
        high_value_query = """
        SELECT 
            CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
            c.Email,
            c.PhoneNumber,
            o.TotalAmount AS BillAmount
        FROM Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        WHERE o.TotalAmount > 60
        ORDER BY o.TotalAmount DESC
        """
        
        cursor.execute(high_value_query)
        results = cursor.fetchall()
        
        print("\nHigh-Value Customers (Orders > $60):")
        print("=====================================")
        for customer in results:
            print(f"""
Name: {customer[0]}
Email: {customer[1]}
Phone: {customer[2]}
Bill Amount: ${customer[3]:.2f}
-----------------------------------""")
        
        return results
    except connector.Error as e:
        print(f"Error retrieving high-value customers: {e}")
        return None

def main():
    # Establish connection
    connection, cursor = connect_to_database()
    
    if connection and cursor:
        try:
            # Show all tables
            show_tables(cursor)
            
            # Get high-value customers
            get_high_value_customers(cursor)
            
        except connector.Error as e:
            print(f"Error executing queries: {e}")
        finally:
            # Close cursor and connection
            cursor.close()
            connection.close()
            print("\nDatabase connection closed.")

if __name__ == "__main__":
    main()
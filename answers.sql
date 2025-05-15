-- answers.sql

-- Question 1: Achieving 1NF
-- To achieve First Normal Form (1NF), it is necessary to ensure that each column contains atomic values and there are no repeating groups.
-- The initial ProductDetail table violates 1NF because the 'Products' column contains multiple values within a single row.
-- The transformation to 1NF involves decomposing the table such that each row represents a single product for a given order.
-- Conceptual Result in 1NF (implementation may vary depending on the database system):
-- OrderID | CustomerName | Product
-- --------|--------------|--------
-- 101     | John Doe     | Laptop
-- 101     | John Doe     | Mouse
-- 102     | Jane Smith   | Tablet
-- 102     | Jane Smith   | Keyboard
-- 102     | Jane Smith   | Mouse
-- 103     | Emily Clark  | Phone

-- Note: The direct SQL query to perform the string splitting and row insertion is database-specific and may require the use of functions or procedures not standard across all SQL implementations.

-- Question 2: Achieving 2NF
-- The provided OrderDetails table is in 1NF but violates Second Normal Form (2NF) due to a partial dependency.
-- Specifically, the 'CustomerName' attribute is dependent only on 'OrderID', which is a part of the composite primary key ('OrderID', 'Product').
-- To achieve 2NF, it is necessary to remove this partial dependency by decomposing the table into two or more tables.

-- Step 1: Create the Customers table to store information about orders and customers.
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Step 2: Populate the Customers table with distinct OrderID and CustomerName values from the original table.
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create the OrderItems table to store details about the products within each order.
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product), -- Define a composite primary key
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID) -- Establish a foreign key relationship
);

-- Step 4: Populate the OrderItems table with the order, product, and quantity information.
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Resulting Tables in 2NF:

-- Customers Table:
-- OrderID | CustomerName
-- --------|--------------
-- 101     | John Doe
-- 102     | Jane Smith
-- 103     | Emily Clark

-- OrderItems Table:
-- OrderID | Product  | Quantity
-- --------|----------|----------
-- 101     | Laptop   | 2
-- 101     | Mouse    | 1
-- 102     | Tablet   | 3
-- 102     | Keyboard | 1
-- 102     | Mouse    | 2
-- 103     | Phone    | 1

-- Explanation for Question 2:
-- The decomposition into the Customers and OrderItems tables eliminates the partial dependency. In the OrderItems table, the non-key attribute 'Quantity' is now fully functionally dependent on the entire primary key ('OrderID', 'Product'). The 'Customers' table establishes the relationship between the order and the customer.

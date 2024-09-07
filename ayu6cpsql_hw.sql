
-- World Database

--1.
SELECT Name FROM `country` WHERE Continent = "South America";
--2
SELECT Population FROM country WHERE name = "Germany";
--3
SELECT name FROM `city` WHERE CountryCode = 'JPN';
--4
SELECT Name FROM country WHERE Region LIKE '%Africa%' ORDER BY Population DESC LIMIT 3;
-- I used this link for the LIKE keyword https://sentry.io/answers/how-to-select-in-sql-where-the-field-contains-words/#:~:text=To%20use%20partial%20matching%20instead,dream%20boat%20down%20the%20stream. 
--5
SELECT name, LifeExpectancy from country WHERE Population BETWEEN 1000000 AND 5000000;
--6
SELECT country.Name FROM country JOIN countrylanguage ON country.Code = countrylanguage.CountryCode WHERE countrylanguage.Language = 'French' AND countrylanguage.IsOfficial = 'T';
--7 
SELECT Title FROM Album WHERE ArtistId=1;
--8
SELECT FirstName, LastName, Email FROM Customer WHERE Country = "Brazil";
--9
SELECT name FROM Playlist;
--10
 SELECT COUNT(Track.TrackId) AS TrackCount FROM Track JOIN Genre ON Track.GenreId = Genre.GenreId WHERE Genre.Name = 'Rock';
--11
SELECT FirstName, LastName FROM Employee WHERE ReportsTo = (SELECT EmployeeId FROM Employee WHERE FirstName = "Nancy" AND LastName = "Edwards");
--12
SELECT Customer.FirstName, Customer.LastName, SUM(Invoice.Total) AS InvoiceAmount FROM Invoice JOIN Customer ON Customer.CustomerId = Invoice.CustomerId GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName ORDER BY InvoiceAmount DESC;



-- Part 2
-- 1
--Customers:
-- CustomerId (Primary Key, Integer)
-- FirstName (Text)
--LastName (Text)
--Email (Text)
--PhoneNumber (Text)
--Flowers:
--FlowerId (Primary Key, Integer)
--FlowerName (Text)
--FlowerColor (Text)
--Price (Decimal)
--StockQuant (Integer)
--Orders:
--OrderId (Primary Key, Integer)
--CustomerId (Foreign Key from Customers)
--FlowerId (Foreign Key from Flowers)
--Timestamp (Date)
--Quantity (Integer)

-- 2
-- I used the built-in SQL table builder to create the three tables.

-- 3
INSERT INTO Customers (CustomerId, FirstName, LastName, Email, PhoneNumber) VALUES (1, 'Carlie', 'Stewart', 'ayu6cp@virginia.edu', '757-915-4697'),  (2, 'John', 'Doe', 'johnd@example.com', '123-456-7890'), (3, 'Walter', 'White', 'walterwhite@walterwhite.com', '222-222-2222'),   (4, 'Travis', 'Scott', 'travis@travis.com', '555-333-4444'), (5, 'Olivia', 'Rodrigo', 'oliviar@olivia.com', '555-555-5555');
INSERT INTO Flowers (FlowerID, FlowerColor, FlowerName, Price, StockQuant) VALUES (1, "Red", "Rose", 5.0, 100), (2, "White", "Orchid", 3.25, 250), (3, "Purple", "Lavender", 6.0, 150), (4, "Yellow", "Sunflower", 2.0, 100), (5, "Pink", "Tulip", 6.0, 50);
INSERT INTO Orders (OrderId, CustomerId, FlowerId, Timestamp, Quantity) VALUES (1, 1, 1, '2024-09-01', 10), (2, 2, 2, '2024-09-02', 20), (3, 3, 3, '2024-09-03', 5), (4, 4, 4, '2024-09-04', 15), (5, 5, 5, '2024-09-05', 2);

--4
-- Find all orders placed by ‘Carlie Stewart’ 
SELECT Orders.OrderID, Flowers.FlowerName, Orders.Quantity FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID JOIN Flowers ON Orders.FlowerID = Flowers.FlowerID WHERE Customers.FirstName = 'Carlie' AND Customers.LastName = 'Stewart';

-- Find customers that placed orders for “Tulips”
SELECT Customers.FirstName, Customers.LastName FROM Orders JOIN Customers ON Orders.CustomerId = Customers.CustomerId JOIN Flowers ON Orders.FlowerId = Flowers.FlowerId WHERE Flowers.FlowerName = 'Tulip';

-- Find all orders placed after 9/3
SELECT Orders.OrderID, Customers.FirstName, Customers.LastName, Orders.Timestamp FROM Orders JOIN Customers ON Orders.CustomerId = Customers.CustomerId JOIN Flowers ON Orders.FlowerId = Flowers.FlowerId WHERE Orders.Timestamp > '2024-09-03';



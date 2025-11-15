use practicedb;

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    unit_price INT
);
CREATE TABLE Sales (
    seller_id INT,
    product_id INT,
    buyer_id INT,
    sale_date DATE,
    quantity INT,
    price INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
INSERT INTO Product (product_id, product_name, unit_price) VALUES
(1, 'S8', 1000),
(2, 'G4', 800),
(3, 'iPhone', 1400);
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) VALUES
(1, 1, 1, '2019-01-21', 2, 2000),
(1, 2, 2, '2019-02-17', 1, 800),
(2, 2, 3, '2019-06-02', 1, 800),
(3, 3, 4, '2019-05-13', 2, 2800);

# 11.  Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is between 2019-01-01 and 2019-03-31 inclusive.
SELECT p.product_id, p.product_name
FROM Product p
JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING MIN(s.sale_date) >= '2019-01-01'
   AND MAX(s.sale_date) <= '2019-03-31';

CREATE TABLE Views (
    article_id INT,
    author_id INT,
    viewer_id INT,
    view_date DATE
);

INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES
(1, 3, 5, '2019-08-01'),
(1, 3, 6, '2019-08-02'),
(2, 7, 7, '2019-08-01'),
(2, 7, 6, '2019-08-02'),
(4, 7, 1, '2019-07-22'),
(3, 4, 4, '2019-07-21'),
(3, 4, 4, '2019-07-21');

# Q 12 Find all authors who viewed at least one of their own articles
select distinct author_id as id  from Views where author_id = viewer_id order by id asc;


CREATE TABLE Delivery (
    delivery_id INT,
    customer_id INT,
    order_date DATE,
    customer_pref_delivery_date DATE
);


INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES
(1, 1, '2019-08-01', '2019-08-02'),
(2, 5, '2019-08-02', '2019-08-02'),
(3, 1, '2019-08-11', '2019-08-11'),
(4, 3, '2019-08-24', '2019-08-26'),
(5, 4, '2019-08-21', '2019-08-22'),
(6, 2, '2019-08-11', '2019-08-13');

# Q 13 Find the percentage of orders that were delivered on the same day they were ordered , rounded to 2 decimal places
SELECT 
    ROUND(
        (SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) * 100, 
        2
    ) AS percentage
FROM Delivery;



CREATE TABLE Ads (
    ad_id INT,
    user_id INT,
    action ENUM('Clicked', 'Viewed', 'Ignored'),
    PRIMARY KEY (ad_id, user_id)
);

INSERT INTO Ads (ad_id, user_id, action) VALUES
(1, 1, 'Clicked'),
(2, 2, 'Clicked'),
(3, 3, 'Viewed'),
(5, 5, 'Ignored'),
(1, 7, 'Ignored'),
(2, 7, 'Viewed'),
(3, 5, 'Clicked'),
(1, 4, 'Viewed'),
(2, 11, 'Viewed'),
(1, 2, 'Clicked');

# Q 14 Write SQL Query to calculate CTR 
SELECT 
    ad_id,
    ROUND(
        CASE 
            WHEN SUM(CASE WHEN action IN ('Clicked', 'Viewed') THEN 1 ELSE 0 END) = 0 
                THEN 0
            ELSE 
                SUM(CASE WHEN action = 'Clicked' THEN 1 ELSE 0 END) * 100.0 /
                SUM(CASE WHEN action IN ('Clicked', 'Viewed') THEN 1 ELSE 0 END)
        END,
        2
    ) AS ctr
FROM Ads
GROUP BY ad_id
ORDER BY ctr DESC, ad_id ASC;

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    team_id INT
);

INSERT INTO Employee (employee_id, team_id) VALUES
(1, 8),
(2, 8),
(3, 8),
(4, 7),
(5, 9),
(6, 9);

# Q 15 Write an SQL Query to find team size of each employee 
select employee_id , count(*) over(partition by team_id) as team_size from Employee order by employee_id;

CREATE TABLE Countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100)
);

CREATE TABLE Weather (
    country_id INT,
    weather_state INT,
    day DATE
);

INSERT INTO Countries (country_id, country_name) VALUES
(2, 'USA'),
(3, 'Australia'),
(7, 'Peru'),
(5, 'China'),
(8, 'Morocco'),
(9, 'Spain');

INSERT INTO Weather (country_id, weather_state, day) VALUES
(2, 15, '2019-11-01'),
(2, 12, '2019-10-28'),
(3, -2, '2019-10-27'),
(3, 0,  '2019-11-10'),
(3, 3,  '2019-11-11'),
(5, 16, '2019-11-12'),
(5, 18, '2019-11-07'),
(5, 21, '2019-11-09'),
(7, 25, '2019-11-23'),
(7, 22, '2019-11-28'),
(7, 20, '2019-12-01'),
(8, 25, '2019-12-02'),
(8, 27, '2019-11-05'),
(8, 31, '2019-11-15'),
(9, 7,  '2019-11-25'),
(9, 3,  '2019-10-23'),
(9, 12, '2019-12-23');

# Q 16 Write an SQL query to find the type of weather in each country for November 2019. The type of weather is: Cold if the average weather_state is less than or equal 15, Hot if the average weather_state is greater than or equal to 25, and Warm otherwise
SELECT 
    c.country_name,
    CASE 
        WHEN AVG(w.weather_state) <= 15 THEN 'Cold'
        WHEN AVG(w.weather_state) >= 25 THEN 'Hot'
        ELSE 'Warm'
    END AS weather_type
FROM Countries c
INNER JOIN Weather w ON c.country_id = w.country_id
WHERE w.day BETWEEN '2019-11-01' AND '2019-11-30'
GROUP BY c.country_name;


CREATE TABLE Prices (
    product_id INT,
    start_date DATE,
    end_date DATE,
    price INT,
    PRIMARY KEY (product_id, start_date, end_date)
);

CREATE TABLE UnitsSold (
    product_id INT,
    purchase_date DATE,
    units INT
);

INSERT INTO Prices (product_id, start_date, end_date, price) VALUES
(1, '2019-02-17', '2019-02-28', 5),
(1, '2019-03-01', '2019-03-22', 20),
(2, '2019-02-01', '2019-02-20', 15),
(2, '2019-02-21', '2019-03-31', 30);

INSERT INTO UnitsSold (product_id, purchase_date, units) VALUES
(1, '2019-02-25', 100),
(1, '2019-03-01', 15),
(2, '2019-02-10', 200),
(2, '2019-03-22', 30);

# Q 17  Write an SQL query to find the average selling price for each product. average_price should be rounded to 2 decimal places. 
SELECT 
    p.product_id,
    ROUND(SUM(u.units * p.price) / SUM(u.units), 2) AS avg_price
FROM
    Prices p
        LEFT JOIN
    UnitsSold u ON p.product_id = u.product_id
        AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;


CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT
);

INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

#Q 18 Write an SQL query to print first login date and login device 
SELECT player_id, device_id AS first_login_device , event_date as first_login_date
FROM (
    SELECT 
        player_id,
        device_id,
        event_date,
        ROW_NUMBER() OVER (
            PARTITION BY player_id 
            ORDER BY event_date ASC
        ) AS rn
    FROM Activity
) t
WHERE rn = 1;


CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_category VARCHAR(255)
);

CREATE TABLE Orders (
    product_id INT,
    order_date DATE,
    unit INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Products (product_id, product_name, product_category) VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'),
(4, 'Lenovo', 'Laptop'),
(5, 'Leetcode Kit', 'T-shirt');

INSERT INTO Orders (product_id, order_date, unit) VALUES
(1, '2020-02-05', 60),
(1, '2020-02-10', 70),
(2, '2020-01-18', 30),
(2, '2020-02-11', 80),
(3, '2020-02-17', 2),
(3, '2020-02-24', 3),
(4, '2020-03-01', 20),
(4, '2020-03-04', 30),
(4, '2020-03-04', 60),
(5, '2020-02-25', 50),
(5, '2020-02-27', 50),
(5, '2020-03-01', 50);


# Q 19 Write an SQL query to get the names of products that have at least 100 units ordered in February 2020 and their amount.
SELECT 
    p.product_name, SUM(o.unit) AS total
FROM
    Products P
        JOIN
    Orders o ON p.product_id = o.product_id
        AND o.order_date BETWEEN '2020-02-01' AND '2020-02-28'
GROUP BY o.product_id
HAVING sum(o.unit) >= 100;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    country VARCHAR(255)
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    description VARCHAR(255),
    price INT
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers (customer_id, name, country) VALUES
(1, 'Winston', 'USA'),
(2, 'Jonathan', 'Peru'),
(3, 'Moustafa', 'Egypt');

INSERT INTO Products (product_id, description, price) VALUES
(10, 'LC Phone', 300),
(20, 'LC T-Shirt', 10),
(30, 'LC Book LC', 45),
(40, 'Keychain', 2);

INSERT INTO Orders (order_id, customer_id, product_id, order_date, quantity) VALUES
(1, 1, 10, '2020-06-10', 1),
(2, 1, 20, '2020-06-10', 1),
(3, 1, 30, '2020-06-10', 2),
(4, 2, 10, '2020-07-01', 10),
(5, 2, 40, '2020-07-01', 2),
(6, 3, 20, '2020-07-01', 2),
(7, 3, 10, '2020-07-08', 2),
(8, 3, 30, '2020-07-08', 3);

# Q 20 Write an SQL query to report the customer_id and customer_name of customers who have spent at least $100 in each month of June and July 2020. Return the result table in any order.
SELECT 
    c.customer_id,
    c.name AS customer_name
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Products p ON o.product_id = p.product_id
WHERE o.order_date BETWEEN '2020-06-01' AND '2020-07-31'
GROUP BY c.customer_id, c.name
HAVING 
    SUM(CASE WHEN MONTH(o.order_date) = 6 AND YEAR(o.order_date) = 2020 
             THEN p.price * o.quantity ELSE 0 END) >= 100
    AND
    SUM(CASE WHEN MONTH(o.order_date) = 7 AND YEAR(o.order_date) = 2020 
             THEN p.price * o.quantity ELSE 0 END) >= 100;
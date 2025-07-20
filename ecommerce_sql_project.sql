-- 📦 Step 1: Create Tables

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    signup_date DATE NOT NULL,
    country TEXT
);

CREATE TABLE campaigns (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name TEXT NOT NULL,
    start_date DATE,
    end_date DATE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT,
    price NUMERIC(10, 2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    campaign_id INT REFERENCES campaigns(campaign_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL
);

-- Step 2: Insert Sample Data

-- Customers
INSERT INTO customers (name, email, signup_date, country) VALUES
('John Smith', 'john@example.com', '2023-01-15', 'USA'),
('Emily Zhang', 'emily@example.com', '2023-01-17', 'Canada'),
('Aisha Khan', 'aisha@example.com', '2023-02-10', 'India'),
('Carlos Gomez', 'carlos@example.com', '2023-02-25', 'Mexico'),
('Rahul Nair', 'rahul@example.com', '2023-03-02', 'India'),
('Anna Ivanova', 'anna@example.com', '2023-03-10', 'Russia'),
('David Lee', 'david@example.com', '2023-03-15', 'South Korea'),
('Nina Patel', 'nina@example.com', '2023-04-01', 'UK'),
('Tom Müller', 'tom@example.com', '2023-04-03', 'Germany'),
('Sara Rossi', 'sara@example.com', '2023-04-05', 'Italy');

-- Campaigns
INSERT INTO campaigns (campaign_name, start_date, end_date) VALUES
('New Year Promo', '2023-01-01', '2023-01-31'),
('Valentine Discount', '2023-02-10', '2023-02-20'),
('Spring Sale', '2023-03-15', '2023-04-15'),
('Back to School', '2023-08-01', '2023-08-31'),
('Black Friday', '2023-11-20', '2023-11-30'),
('Holiday Deals', '2023-12-20', '2023-12-31');

-- Products
INSERT INTO products (product_name, category, price) VALUES
('Wireless Keyboard', 'Electronics', 45.00),
('Bluetooth Mouse', 'Electronics', 25.00),
('Headphones Pro', 'Electronics', 80.00),
('Office Chair', 'Furniture', 150.00),
('Standing Desk', 'Furniture', 300.00);

-- Orders
INSERT INTO orders (customer_id, order_date, campaign_id) VALUES
(1, '2023-03-05', 1),
(2, '2023-03-15', 1),
(3, '2023-04-05', 2),
(4, '2023-04-07', 2),
(5, '2023-06-03', 3),
(6, '2023-06-10', 3),
(7, '2023-06-20', 3),
(8, '2023-08-05', 4),
(9, '2023-08-10', 4),
(10, '2023-08-28', 4),
(1, '2023-11-21', 5),
(3, '2023-11-25', 5),
(6, '2023-11-27', 5),
(2, '2023-12-27', 6),
(5, '2023-12-31', 6);

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 45.00),
(1, 2, 1, 25.00),
(2, 3, 1, 80.00),
(3, 1, 1, 45.00),
(3, 2, 2, 25.00),
(4, 4, 1, 150.00),
(5, 3, 2, 80.00),
(6, 5, 1, 300.00),
(7, 2, 3, 25.00),
(8, 1, 1, 45.00),
(9, 3, 1, 80.00),
(10, 5, 1, 300.00),
(11, 4, 2, 150.00),
(12, 3, 2, 80.00),
(13, 2, 1, 25.00),
(14, 1, 2, 45.00),
(15, 2, 1, 25.00);

-- 🔍 Step 3: Analysis Queries

-- Query 1: Total Revenue by Campaign
SELECT 
    campaigns.campaign_id,
    campaigns.campaign_name,
    SUM(order_items.quantity * order_items.unit_price) AS total_revenue
FROM campaigns
JOIN orders ON campaigns.campaign_id = orders.campaign_id
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY campaigns.campaign_id, campaigns.campaign_name
ORDER BY total_revenue DESC;

-- Query 2: Top Spending Customers
SELECT 
    customers.customer_id,
    customers.name AS customer_name,
    SUM(order_items.quantity * order_items.unit_price) AS total_spent
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY customers.customer_id, customers.name
ORDER BY total_spent DESC;

-- Query 3: Total Orders Per Campaign
SELECT 
    campaigns.campaign_id,
    campaigns.campaign_name,
    COUNT(orders.order_id) AS total_orders
FROM campaigns
LEFT JOIN orders ON campaigns.campaign_id = orders.campaign_id
GROUP BY campaigns.campaign_id, campaigns.campaign_name
ORDER BY total_orders DESC;

-- Query 4: Campaign Performance (Revenue per Order)
SELECT 
    campaigns.campaign_name,
    COUNT(orders.order_id) AS total_orders,
    SUM(order_items.quantity * order_items.unit_price) AS total_revenue,
    ROUND(SUM(order_items.quantity * order_items.unit_price) / COUNT(orders.order_id), 2) AS avg_revenue_per_order
FROM campaigns
JOIN orders ON campaigns.campaign_id = orders.campaign_id
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY campaigns.campaign_name
ORDER BY avg_revenue_per_order DESC;

-- Query 5: Most Popular Products
SELECT 
    products.product_id,
    products.product_name,
    SUM(order_items.quantity) AS total_quantity_sold
FROM products
JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name
ORDER BY total_quantity_sold DESC;

-- Query 6: Revenue by Country
SELECT 
    customers.country,
    ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_revenue
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY customers.country
ORDER BY total_revenue DESC;

-- Query 7: Repeat Customers
SELECT 
    customers.customer_id,
    customers.name AS customer_name,
    COUNT(orders.order_id) AS total_orders
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name
HAVING COUNT(orders.order_id) > 1
ORDER BY total_orders DESC;

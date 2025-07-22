# SQL-analysis
SQL project analyzing an e-commerce dataset using PostgreSQL

# 🛍️ E-commerce SQL Analytics (PostgreSQL)

This project simulates an e-commerce database and showcases SQL queries that analyze customer orders, campaigns, and revenue. It’s designed to demonstrate key SQL skills for data analysis roles.

## 📁 Dataset Overview

The project uses mock data across five tables:

| Table Name     | Description                          |
|----------------|--------------------------------------|
| customers      | Customer information                 |
| campaigns      | Marketing campaigns                  |
| products       | Product catalog                      |
| orders         | Customer orders                      |
| order_items    | Individual items in each order       |

All data is available in the [`data/`](./data) folder as CSV files.

---

## 🛠️ Technologies Used

- **PostgreSQL** (SQL)
- Joins, Aggregations, Aliases, Filtering, Grouping
- Git & GitHub

---

## 📊 Key Business Questions Answered

### 1. Campaign Revenue Ranking

```sql
SELECT 
    campaigns.campaign_id,
    campaigns.campaign_name,
    SUM(order_items.quantity * order_items.unit_price) AS total_revenue
FROM campaigns
JOIN orders ON campaigns.campaign_id = orders.campaign_id
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY campaigns.campaign_id, campaigns.campaign_name
ORDER BY total_revenue DESC;
👉 Shows which campaigns generated the most revenue.

2. Customer Lifetime Value (Top 5)
SELECT 
    customers.customer_id,
    customers.name,
    SUM(order_items.quantity * order_items.unit_price) AS total_spent
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY customers.customer_id, customers.name
ORDER BY total_spent DESC
LIMIT 5;
👉 Identifies the highest-value customers.

📂 Folder Structure
ecommerce-sql-analysis/
├── data/
│   ├── customers.csv
│   ├── campaigns.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
├── README.md
└── queries.sql (optional)

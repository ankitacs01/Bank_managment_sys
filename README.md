# 🏦 Bank Management System – SQL Project

## 📌 Overview

This project simulates a real-world **Bank Management System** using **MySQL**, with a relational database design, realistic dummy data for 5000+ customers, and advanced SQL logic including **joins, subqueries, CASE statements, window functions**, and more.

It serves as a hands-on practice platform for data analysis, reporting, and SQL-based business logic implementation — ideal for students, beginners, and data analyst interview preparation.

---

## 🗃️ Database Schema

The project includes **6 normalized tables**:

| Table Name     | Description                                  |
|----------------|----------------------------------------------|
| `Customers`    | Stores personal details of all customers     |
| `Accounts`     | Customer-linked account info and balance     |
| `Transactions` | Credit/debit transaction history             |
| `Loans`        | Loan info with amount, term, and type        |
| `Branches`     | Branch details and locations                 |
| `Employees`    | Employees working at respective branches     |

---

## 📂 Dataset Summary

- 👤 **Customers**: 5000
- 💳 **Accounts**: 5000
- 🔄 **Transactions**: 25,000+ (5–10 per account)
- 🧑‍💼 **Employees**: 100
- 🏢 **Branches**: 5
- 📄 CSV Files included for each table

---

## 💡 Key Features

- ✅ `CREATE TABLE` DDL scripts
- ✅ Data imported from CSV files
- ✅ Advanced SQL Query Sets:
  - Subqueries
  - CASE Statements
  - Window Functions (`RANK()`, `NTILE()`, `ROW_NUMBER()`)
  - Aggregate Queries
  - Joins (Inner, Left)
- ✅ Covers real-world business scenarios

---

## 🧠 Sample SQL Use Cases

### 📊 Business Insights
```sql
-- Customers with above-average account balance
SELECT c.first_name, c.last_name, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.balance > (SELECT AVG(balance) FROM Accounts);


---

## 🧑‍💻 Author

*Ankita Misal*  
🎓 Data Analyst | MCA Graduate  
📧 ankitamisal1234@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/ankita-misal-536408184)  
💻 [GitHub](https://github.com/ankitacs01)

---

## 📜 License

This project is for educational and portfolio purposes only.

---

## 💬 Suggestions or Questions?

Feel free to raise an issue or contact me directly. Always happy to connect with fellow learners! 😊


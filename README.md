# Pastry Shop (Poslastičarnica)

A web application for an online pastry shop, built for the course *Advanced Java Technologies* (Napredne Java Tehnologije) at FON.

Customers browse pastries by category, add them to a cart and place orders. Administrators manage the whole offer: categories, pastries, users and orders.

## Features

**For customers**
- Registration and login (JWT authentication, BCrypt-hashed passwords)
- Browse pastries by category, with image, price and description
- Shopping cart and placing an order with a delivery address
- "My orders" page with order status and the items in each order
- Confirmation e-mail after placing an order

**For administrators**
- Manage categories (add, edit, delete)
- Manage pastries (add, edit, delete, availability, category, image)
- View users and all orders
- Change the status of an order (pending, accepted, in preparation, completed, cancelled)
- Export orders to Excel

**Other**
- Input validation with clear error messages

## Tech stack

- Java 17, Spring Boot 3.2.4
- Spring Data JPA / Hibernate, MySQL 8
- Spring Security, JWT
- JSP, Bootstrap 5, JavaScript (fetch API)
- Apache POI (Excel export), Spring Mail
- Maven

## Getting started

1. Install JDK 17+, Maven and MySQL 8.
2. Import the database: run `database/poslasticarnica.sql` in MySQL (it creates the database, tables and sample data).
3. Create the file `src/main/resources/application-local.properties` (it is git-ignored) with your own values:
```properties
   spring.datasource.password=YOUR_MYSQL_PASSWORD
   jwt.secret=A_LONG_RANDOM_SECRET_AT_LEAST_32_CHARACTERS
   spring.mail.username=YOUR_MAILTRAP_USERNAME
   spring.mail.password=YOUR_MAILTRAP_PASSWORD
```
4. Run `mvn spring-boot:run` and open http://localhost:8080/pocetna

## Author

Katarina Urošević
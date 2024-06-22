-- Logged-in Customers' First Names:
-- 1. Create 2 tables : Customer and Customer profile. They have a One to One relationship:
CREATE TABLE Customer (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL
);

CREATE TABLE Customer_Profile (
  id SERIAL PRIMARY KEY,
  isLoggedIN BOOLEAN DEFAULT FALSE,
  customer_id INT REFERENCES Customer(id) UNIQUE
);
-- 2.Insert those customers:
INSERT INTO Customer (first_name, last_name)
VALUES ('John', 'Doe'), ('Jerome', 'Lalu'), ('Lea', 'Rive');
-- 3. Insert those customer profiles, use subqueries
INSERT INTO Customer_Profile (customer_id, isLoggedIN)
SELECT id, 
  CASE WHEN first_name = 'John' THEN TRUE ELSE FALSE END AS isLoggedIn
FROM Customer;
-- 4. Use the relevant types of Joins to display:
SELECT c.first_name
FROM Customer c
INNER JOIN Customer_Profile p ON c.id = p.customer_id
WHERE p.isLoggedIN = TRUE;
-- Part 2:
-- 1. Create a table named Book, with the columns : book_id SERIAL PRIMARY KEY, title NOT NULL, author NOT NULL
CREATE TABLE Book (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL
);
-- 2.Insert those books :
INSERT INTO Book (title, author)
VALUES ('Alice In Wonderland', 'Lewis Carroll'),
       ('Harry Potter', 'J.K Rowling'),
       ('To kill a mockingbird', 'Harper Lee');
-- 3. Create a table named Student, with the columns : student_id SERIAL PRIMARY KEY, name NOT NULL UNIQUE, age. Make sure that the age is never bigger than 15 (Find an SQL method);
CREATE TABLE Student (
  student_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  age INT CHECK (age <= 15) -- Enforces age <= 15 constraint
);
-- 4. Insert those students:
INSERT INTO Student (name, age)
VALUES ('John', 12),
       ('Lera', 11),
       ('Patrick', 10),
       ('Bob', 14);
-- 5. Create a table named Library, with the columns :
CREATE TABLE Library (
  library_id SERIAL PRIMARY KEY,
  book_fk_id INT REFERENCES Book(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
  student_fk_id INT REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
  borrowed_date DATE
);
-- 6.Add 4 records in the junction table, use subqueries:
INSERT INTO Library (book_fk_id, student_fk_id, borrowed_date)
SELECT b.book_id, s.student_id, '2022-02-15'
FROM Book b
INNER JOIN Student s ON s.name = 'John'
WHERE b.title = 'Alice In Wonderland';

INSERT INTO Library (book_fk_id, student_fk_id, borrowed_date)
SELECT b.book_id, s.student_id, '2021-03-03'
FROM Book b
INNER JOIN Student s ON s.name = 'Bob'
WHERE b.title = 'To kill a mockingbird';

INSERT INTO Library (book_fk_id, student_fk_id, borrowed_date)
SELECT b.book_id, s.student_id, '2021-05-23'
FROM Book b
INNER JOIN Student s ON s.name = 'Lera'
WHERE b.title = 'Alice In Wonderland';

INSERT INTO Library (book_fk_id, student_id, borrowed_date)
SELECT b.book_id, s.student_id, '2021-08-12'
FROM Book b
INNER JOIN Student s ON s.name = 'Bob'
WHERE b.title = 'Harry Potter';
-- 7. Display the data:
SELECT * FROM Library;

SELECT s.name, b.title
FROM Library l
INNER JOIN Student s ON l.student_fk_id = s.student_id
INNER JOIN Book b ON l.book_fk_id = b.book_id;

SELECT AVG(age) AS avg_age
FROM Student s
INNER JOIN Library l ON l.student_fk_id = s.student_id
INNER JOIN Book b ON l.book_fk_id = b.book_id
WHERE b.title = 'Alice In Wonderland';

DELETE FROM Student WHERE name = 'Bob';

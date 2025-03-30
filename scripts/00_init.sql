DROP DATABASE IF EXISTS "testDB";
CREATE DATABASE "testDB";

\connect testDB;

CREATE TABLE orders (
  id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  product_name TEXT,
  quantity INTEGER,
  order_date DATE
);

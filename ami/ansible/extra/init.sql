-- init.sql

CREATE DATABASE IF NOT EXISTS contact;
USE contact;

CREATE TABLE IF NOT EXISTS contact (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Add any additional SQL commands as needed


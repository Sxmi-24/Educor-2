CREATE DATABASE IF NOT EXISTS educore;
USE educore;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DESCRIBE users;

CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    prix DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_prix_positif CHECK (prix > 0)
);

CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    progress INT DEFAULT 0,
    CONSTRAINT fk_user_enroll FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_course_enroll FOREIGN KEY (course_id) REFERENCES courses(id),
    CONSTRAINT chk_progress_range CHECK (progress BETWEEN 0 AND 100)
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_pay FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (nom, email) VALUES ('Ilias', 'ilias@gmail.com');

SELECT 'Structure créée avec succès' AS status;
CREATE DATABASE IF NOT EXISTS educore;
USE educore;


CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    prix DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_prix CHECK (prix > 0)
);


CREATE TABLE enrollments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    progress INT DEFAULT 0,
    CONSTRAINT fk_user_enroll FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_course_enroll FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT chk_progress CHECK (progress BETWEEN 0 AND 100)
);

CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_pay FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


INSERT INTO courses (titre, prix) VALUES 
('Masterclass IA & Deep Learning', 499.00),
('Data Science avec Python', 299.00),
('Expert Cybersécurité', 550.00),
('Fullstack JS (React/Node)', 350.00),
('Architecture Cloud AWS', 420.00),
('Data Engineering Avancé', 480.00);


INSERT INTO users (nom, email) VALUES 
('Alice Martin', 'alice@email.com'),
('Bob Durand', 'bob@email.com'),
('Charlie Morel', 'charlie@email.com'),
('David Leroy', 'david@email.com'),
('Emma Petit', 'emma@email.com'),
('Franck Simon', 'franck@email.com'),
('Gisèle Roux', 'gisele@email.com'),
('Hugo Blanc', 'hugo@email.com'),
('Iris Garnier', 'iris@email.com'),
('Jean Perrin', 'jean@email.com');


INSERT INTO enrollments (user_id, course_id, progress) VALUES 
(1, 1, 85), (1, 2, 100), (2, 3, 10), (3, 1, 50), (4, 4, 100),
(5, 5, 20), (6, 6, 0), (7, 1, 95), (8, 2, 45), (9, 3, 100),
(10, 4, 15), (2, 1, 30), (5, 2, 60), (7, 6, 100), (3, 5, 5);


INSERT INTO payments (user_id, amount) VALUES 
(1, 499.00), (1, 299.00), (2, 550.00), (3, 499.00), (4, 350.00),
(5, 420.00), (6, 480.00), (7, 499.00), (8, 299.00), (9, 550.00),
(10, 350.00), (7, 480.00);

SELECT 
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(*) FROM courses) AS total_courses,
    (SELECT COUNT(*) FROM enrollments) AS total_enrollments,
    (SELECT COUNT(*) FROM payments) AS total_payments;

SELECT u.nom, e.progress 
FROM enrollments e
JOIN users u ON e.user_id = u.id
WHERE e.progress < 0 OR e.progress > 100;

SELECT e.id 
FROM enrollments e
LEFT JOIN users u ON e.user_id = u.id
LEFT JOIN courses c ON e.course_id = c.id
WHERE u.id IS NULL OR c.id IS NULL;

SELECT p.id, p.amount 
FROM payments p 
WHERE p.amount <= 0;
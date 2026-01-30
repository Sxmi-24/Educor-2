use educore; 
SELECT *
FROM enrollments
WHERE progress < 0 OR progress > 100;

SELECT e.*
FROM enrollments e
LEFT JOIN users u ON e.user_id = u.id
LEFT JOIN courses c ON e.course_id = c.id
WHERE u.id IS NULL OR c.id IS NULL;


SELECT *
FROM payments
WHERE amount <= 0;


SELECT 
    c.titre,
    COUNT(e.id) AS nb_inscrits
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
ORDER BY nb_inscrits DESC;



SELECT
    c.titre,
    SUM(p.amount) AS revenu_total
FROM courses c
JOIN enrollments e ON c.id = e.course_id
JOIN payments p ON e.user_id = p.user_id
GROUP BY c.id, c.titre
ORDER BY revenu_total DESC;


SELECT
    u.id,
    u.nom,
    u.email,
    COUNT(p.id) AS nb_paiements
FROM users u
JOIN payments p ON u.id = p.user_id
GROUP BY u.id, u.nom, u.email
HAVING COUNT(p.id) >= 2;


SELECT
    u.nom
FROM users u
LEFT JOIN payments p ON u.id = p.user_id
WHERE p.id IS NULL;


SELECT
    c.titre,
    AVG(e.progress) AS avg_progress
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre;




SELECT
    u.nom AS user,
    c.titre AS cours,
    e.progress
FROM enrollments e
JOIN users u ON e.user_id = u.id
JOIN courses c ON e.course_id = c.id
WHERE e.progress < 25
ORDER BY e.progress ASC;



SELECT
    c.titre,
    ROUND(AVG(e.progress), 2) AS avg_progress,
    COUNT(e.id) AS nb_inscrits
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
HAVING AVG(e.progress) < 50
   AND COUNT(e.id) >= 3;
   
   
   
   SELECT
    user_id,
    SUM(amount) AS total_spent
FROM payments
GROUP BY user_id;




SELECT
    u.id,
    u.nom,
    SUM(p.amount) AS total_spent
FROM users u
JOIN payments p ON u.id = p.user_id
GROUP BY u.id, u.nom
HAVING SUM(p.amount) > (
    SELECT AVG(total_user_spent)
    FROM (
        SELECT SUM(amount) AS total_user_spent
        FROM payments
        GROUP BY user_id
    ) AS sub
);




SELECT
    id,
    titre,
    prix
FROM courses
WHERE prix > (
    SELECT AVG(prix)
    FROM courses
);



SELECT
    u.id,
    u.nom,
    COUNT(e.course_id) AS nb_cours
FROM users u
JOIN enrollments e ON u.id = e.user_id
GROUP BY u.id, u.nom
HAVING COUNT(e.course_id) >= 2;


SELECT
    c.id,
    c.titre
FROM courses c
JOIN enrollments e ON c.id = e.course_id
LEFT JOIN payments p ON e.user_id = p.user_id
GROUP BY c.id, c.titre
HAVING COUNT(p.id) = 0;


CREATE VIEW v_active_users AS
SELECT DISTINCT
    u.id,
    u.nom,
    u.email,
    u.created_at
FROM users u
JOIN enrollments e ON u.id = e.user_id;



CREATE VIEW v_monthly_revenue AS
SELECT
    DATE_FORMAT(paid_at, '%Y-%m') AS month,
    SUM(amount) AS monthly_revenue
FROM payments
GROUP BY DATE_FORMAT(paid_at, '%Y-%m')
ORDER BY month;





CREATE VIEW v_popular_courses AS
SELECT 
    c.id AS course_id,
    c.titre AS course_title,
    COUNT(e.id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e
    ON c.id = e.course_id
GROUP BY c.id, c.titre
ORDER BY total_enrollments DESC;




EXPLAIN
SELECT *
FROM users
WHERE email = 'test@email.com';



EXPLAIN
SELECT *
FROM payments
ORDER BY paid_at DESC;




EXPLAIN
SELECT *
FROM enrollments
WHERE course_id = 3;




CREATE INDEX idx_users_email
ON users(email);



CREATE INDEX idx_payments_paid_at
ON payments(paid_at);


CREATE INDEX idx_enrollments_course_user
ON enrollments(course_id, user_id);




ALTER TABLE users
ADD COLUMN is_premium TINYINT(1) DEFAULT 0;

START TRANSACTION;

INSERT INTO payments (user_id, amount, paid_at)
VALUES (1, 99.99, NOW());

UPDATE users
SET is_premium = 1
WHERE id = 1;

COMMIT;






START TRANSACTION;

INSERT INTO payments (user_id, amount)
VALUES (1, 50.00);


SAVEPOINT sp1;


INSERT INTO payments (user_id, amount)
VALUES (1, -20.00);


ROLLBACK TO sp1;

COMMIT;
Use educore;
SELECT 
    c.titre AS cours_titre, 
    AVG(e.progress) AS progression_moyenne
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
ORDER BY progression_moyenne DESC;

SELECT 
    u.nom AS nom_eleve, 
    c.titre AS titre_cours, 
    e.progress AS pourcentage_actuel
FROM enrollments e
JOIN users u ON e.user_id = u.id
JOIN courses c ON e.course_id = c.id
WHERE e.progress < 25
ORDER BY e.progress ASC;

SELECT 
    c.titre AS cours_critique, 
    AVG(e.progress) AS moyenne_progression,
    COUNT(e.id) AS nombre_inscrits
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
HAVING AVG(e.progress) < 50 
   AND COUNT(e.id) >= 3
ORDER BY moyenne_progression ASC;
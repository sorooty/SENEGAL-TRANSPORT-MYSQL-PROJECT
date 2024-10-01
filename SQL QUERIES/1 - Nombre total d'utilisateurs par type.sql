/* 1. Nombre total d'utilisateurs par type (élève ou personnel) :
Cette requête permet de savoir combien d'utilisateurs appartiennent à chaque catégorie. */

SELECT type_utilisateur, COUNT(*) AS nombre_utilisateurs
FROM Utilisateur
GROUP BY type_utilisateur;

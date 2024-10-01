/* 2. Nombre total de trajets effectués par chaque utilisateur :
Pour obtenir une liste de tous les utilisateurs et le nombre de trajets qu'ils ont effectués. */
SELECT Utilisateur.nom, Utilisateur.prenom, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Utilisateur
LEFT JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
GROUP BY Utilisateur.id_utilisateur;


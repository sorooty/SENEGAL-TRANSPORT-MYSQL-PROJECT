/*Pour afficher des statistiques globales concernant les utilisateurs et leurs trajets.*/

SELECT 
    COUNT(DISTINCT Utilisateur.id_utilisateur) AS total_utilisateurs,
    COUNT(Trajet.id_trajet) AS total_trajets,
    AVG(Enquete.satisfaction) AS satisfaction_moyenne
FROM Utilisateur
LEFT JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
LEFT JOIN Enquete ON Utilisateur.id_utilisateur = Enquete.id_utilisateur;

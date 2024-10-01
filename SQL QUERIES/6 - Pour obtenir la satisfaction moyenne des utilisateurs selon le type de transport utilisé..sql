/*Pour obtenir la satisfaction moyenne des utilisateurs selon le type de transport utilisé.*/

SELECT Transport.nom_transport, AVG(Enquete.satisfaction) AS satisfaction_moyenne
FROM Enquete
JOIN Utilisateur ON Enquete.id_utilisateur = Utilisateur.id_utilisateur
JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Transport.nom_transport;

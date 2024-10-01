/*Pour obtenir une liste des utilisateurs qui ont répondu à l'enquête et leurs commentaires.*/
SELECT Utilisateur.nom, Utilisateur.prenom, Enquete.date_reponse, Enquete.satisfaction, Enquete.commentaires
FROM Enquete
JOIN Utilisateur ON Enquete.id_utilisateur = Utilisateur.id_utilisateur;

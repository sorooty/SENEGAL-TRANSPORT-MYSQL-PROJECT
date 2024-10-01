/*Détails des trajets récents*/
SELECT Utilisateur.nom, Utilisateur.prenom, Trajet.date_trajet, Station.nom_station AS station_depart, 
       (SELECT nom_station FROM Station WHERE id_station = Trajet.id_station_arrivee) AS station_arrivee
FROM Trajet
JOIN Utilisateur ON Trajet.id_utilisateur = Utilisateur.id_utilisateur
JOIN Station ON Trajet.id_station_depart = Station.id_station
WHERE Trajet.date_trajet >= CURDATE() - INTERVAL 30 DAY
ORDER BY Trajet.date_trajet DESC;

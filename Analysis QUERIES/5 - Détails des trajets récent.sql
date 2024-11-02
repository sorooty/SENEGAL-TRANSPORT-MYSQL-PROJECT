-- Détails des trajets les plus récents :
SELECT Utilisateur.nom, Utilisateur.prenom, Trajet.date_trajet, Station.nom_station AS station_depart, transport.nom_transport AS Moyen_transport,
       (SELECT nom_station FROM Station WHERE id_station = Trajet.id_station_arrivee) AS station_arrivee
FROM Trajet
JOIN Utilisateur ON Trajet.id_utilisateur = Utilisateur.id_utilisateur
JOIN Station ON Trajet.id_station_depart = Station.id_station
JOIN transport ON transport.id_transport = Trajet.id_transport
WHERE Trajet.date_trajet >= CURDATE() - INTERVAL 10 DAY
ORDER BY Trajet.date_trajet DESC;

-- Trajet le plus récent et le plus ancien :
SELECT MAX(date_trajet) as Plus_récent, MIN(date_trajet) AS Plus_ancient
FROM trajet;
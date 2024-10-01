/*Pour identifier les trajets les plus populaires entre les stations.*/

SELECT Station.nom_station AS station_depart, 
       (SELECT nom_station FROM Station WHERE id_station = Trajet.id_station_arrivee) AS station_arrivee, 
       COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Trajet
JOIN Station ON Trajet.id_station_depart = Station.id_station
GROUP BY Trajet.id_station_depart, Trajet.id_station_arrivee
ORDER BY nombre_trajets DESC
LIMIT 10;

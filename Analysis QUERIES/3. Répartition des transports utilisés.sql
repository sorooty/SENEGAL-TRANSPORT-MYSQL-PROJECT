/*3. Répartition des transports utilisés
Pour savoir combien de trajets ont été effectués pour chaque type de transport (TER, BRT, autre).*/
SELECT Transport.nom_transport, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Trajet
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Transport.nom_transport;

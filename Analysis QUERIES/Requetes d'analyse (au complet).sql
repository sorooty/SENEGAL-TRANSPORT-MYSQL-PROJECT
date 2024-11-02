-- 1. Nombre total d'utilisateurs par type de transport
SELECT t.nom_transport AS type_transport, COUNT(DISTINCT u.id_utilisateur) AS nombre_utilisateurs
FROM Transport t
JOIN Trajet tr ON t.id_transport = tr.id_transport
JOIN Utilisateur u ON tr.id_utilisateur = u.id_utilisateur
GROUP BY t.nom_transport;
-- Optimiser dans la partie opti car, cela ne prend pas en compte le cas ou 1 utilisateur prend plusieurs transport (brt et ter)


-- 2. Fréquentation moyenne par jour pour chaque station
SELECT s.nom_station, AVG(trajets_par_jour) AS frequentation_moyenne
FROM Station s
JOIN (
    SELECT id_station_depart, COUNT(*) AS trajets_par_jour, DATE(date_trajet) AS jour
    FROM Trajet
    GROUP BY id_station_depart, DATE(date_trajet)
) t ON s.id_station = t.id_station_depart
GROUP BY s.nom_station;


-- 3. Les 5 trajets les plus populaires
SELECT t.nom_lieu_depart, t.nom_lieu_arrivee, COUNT(*) AS nombre_trajets
FROM Trajet t
GROUP BY t.nom_lieu_depart, t.nom_lieu_arrivee
ORDER BY nombre_trajets DESC
LIMIT 5;

-- 4. Taux d'utilisation par type d'utilisateur (étudiant, personnel, etc.)
SELECT u.type_utilisateur, COUNT(*) AS nombre_trajets,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Trajet) AS pourcentage_utilisation
FROM Utilisateur u
JOIN Trajet t ON u.id_utilisateur = t.id_utilisateur
GROUP BY u.type_utilisateur;

-- 5. Heures de pointe pour chaque type de transport
SELECT tr.nom_transport AS type_transport, 
       HOUR(t.heure_depart) AS heure,
       COUNT(*) AS nombre_trajets
FROM Transport tr
JOIN Trajet t ON tr.id_transport = t.id_transport
GROUP BY tr.nom_transport, HOUR(t.heure_depart)
ORDER BY tr.nom_transport, nombre_trajets DESC;



-- 6. Durée moyenne des trajets par type de transport
SELECT tr.type_transport AS type_transport, 
       AVG(TIMEDIFF(t.heure_arrivee, t.heure_depart)) AS duree_moyenne
FROM Transport tr
JOIN Trajet t ON tr.id_transport = t.id_transport
GROUP BY tr.type_transport;

-- 7. Taux de satisfaction moyen par type de transport (en supposant une table Enquete)
SELECT tr.nom_transport AS nom_transport, AVG(e.satisfaction) AS satisfaction_moyenne
FROM Transport tr
JOIN Trajet t ON tr.id_transport = t.id_transport
JOIN Enquete e ON t.id_utilisateur = e.id_utilisateur
GROUP BY tr.nom_transport;


-- 8. Évolution de l'utilisation des transports au fil du temps
SELECT DATE_FORMAT(date_trajet, '%Y-%m') AS mois, 
       COUNT(*) AS nombre_trajets
FROM Trajet
GROUP BY DATE_FORMAT(date_trajet, '%Y-%m')
ORDER BY mois;

-- 9. Comparaison de l'utilisation BRT vs TER
SELECT 
    CASE 
        WHEN tr.nom_transport LIKE '%BRT%' THEN 'BRT'
        WHEN tr.nom_transport LIKE '%TER%' THEN 'TER'
        ELSE 'Autre'
    END AS type_transport,
    COUNT(*) AS nombre_trajets
FROM Transport tr
JOIN Trajet t ON tr.id_transport = t.id_transport
GROUP BY 
    CASE 
        WHEN tr.nom_transport LIKE '%BRT%' THEN 'BRT'
        WHEN tr.nom_transport LIKE '%TER%' THEN 'TER'
        ELSE 'Autre'
    END;


-- 10. Stations les moins fréquentées (potentiellement à optimiser)
SELECT s.nom_station, COUNT(*) AS nombre_departs
FROM Station s
LEFT JOIN Trajet t ON s.id_station = t.id_station_depart
GROUP BY s.nom_station
ORDER BY nombre_departs ASC
LIMIT 5;

-- 11. Utilisateurs les plus fréquents (pour potentiellement créer un programme de fidélité)
SELECT u.id_utilisateur, u.nom, u.prenom, type_utilisateur, COUNT(*) AS nombre_trajets
FROM Utilisateur u
JOIN Trajet t ON u.id_utilisateur = t.id_utilisateur
GROUP BY u.id_utilisateur, u.nom, u.prenom
ORDER BY nombre_trajets DESC
LIMIT 10;



-- 12. Analyse des commentaires négatifs (en supposant une colonne commentaires dans la table Enquete)
SELECT e.commentaires, e.satisfaction
FROM Enquete e
WHERE e.satisfaction < 5
LIMIT 20;

-- 13. Taux de correspondance(s) (utilisateurs utilisant plus d'un type de transport)
SELECT COUNT(DISTINCT u.id_utilisateur) * 100.0 / (SELECT COUNT(*) FROM Utilisateur) AS taux_correspondance
FROM Utilisateur u
JOIN Trajet t1 ON u.id_utilisateur = t1.id_utilisateur
JOIN Trajet t2 ON u.id_utilisateur = t2.id_utilisateur
JOIN Transport tr1 ON t1.id_transport = tr1.id_transport
JOIN Transport tr2 ON t2.id_transport = tr2.id_transport
WHERE tr1.nom_transport != tr2.nom_transport;

-- 14. Pour afficher des statistiques globales concernant les utilisateurs et leurs trajets.*/
SELECT 
    COUNT(DISTINCT Utilisateur.id_utilisateur) AS total_utilisateurs,
    COUNT(Trajet.id_trajet) AS total_trajets,
    AVG(Enquete.satisfaction) AS satisfaction_moyenne
FROM Utilisateur
LEFT JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
LEFT JOIN Enquete ON Utilisateur.id_utilisateur = Enquete.id_utilisateur;

-- 15. Détails des trajets les plus récents :
SELECT Utilisateur.nom, Utilisateur.prenom, Trajet.date_trajet, Station.nom_station AS station_depart, transport.nom_transport AS Moyen_transport,
       (SELECT nom_station FROM Station WHERE id_station = Trajet.id_station_arrivee) AS station_arrivee
FROM Trajet
JOIN Utilisateur ON Trajet.id_utilisateur = Utilisateur.id_utilisateur
JOIN Station ON Trajet.id_station_depart = Station.id_station
JOIN transport ON transport.id_transport = Trajet.id_transport
WHERE Trajet.date_trajet >= CURDATE() - INTERVAL 10 DAY
ORDER BY Trajet.date_trajet DESC;

-- 16. Trajet le plus récent et le plus ancien :
SELECT MAX(date_trajet) as Plus_récent, MIN(date_trajet) AS Plus_ancient
FROM trajet;

-- Nombre total de trajets
SELECT COUNT(*) AS nombre_tra_total
FROM trajet;

-- Moyenne Trajet par utilisateur sur la période d'étude
SELECT AVG(nombre_trajets) AS moyenne_trajets_par_utilisateur
FROM (
    SELECT COUNT(Trajet.id_trajet) AS nombre_trajets
    FROM Trajet
    GROUP BY Trajet.id_utilisateur
) AS sous_requete;


-- Pourcentage d’utilisation des différents moyens de transport 
SELECT Transport.nom_transport,
       (COUNT(Trajet.id_trajet) / (SELECT COUNT(*) FROM Trajet) * 100) AS pourcentage_utilisation
FROM Trajet
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Transport.nom_transport;

-- Nombre total de trajets effectués par chaque utilisateur
SELECT Utilisateur.nom, Utilisateur.prenom, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Utilisateur
LEFT JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
GROUP BY Utilisateur.id_utilisateur;

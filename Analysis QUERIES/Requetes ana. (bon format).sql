--Groupe 1 : Statistiques générales sur les utilisateurs et trajets
-- Nombre total d’utilisateurs par type (élève, personnel prof)
SELECT type_utilisateur, COUNT(*) AS nombre_utilisateurs
FROM Utilisateur
GROUP BY type_utilisateur;

-- Nombre total de trajets
SELECT COUNT(*) AS nombre_tra_total
FROM trajet;

-- Moyenne de trajets par utilisateur sur la période d'étude
SELECT AVG(nombre_trajets) AS moyenne_trajets_par_utilisateur
FROM (
    SELECT COUNT(Trajet.id_trajet) AS nombre_trajets
    FROM Trajet
    GROUP BY Trajet.id_utilisateur
) AS sous_requete;

-- Nombre moyen de trajets par utilisateur :
SELECT AVG(nombre_trajets) AS moyenne_trajets_par_utilisateur
FROM (
    SELECT COUNT(Trajet.id_trajet) AS nombre_trajets
    FROM Trajet
    GROUP BY Trajet.id_utilisateur
) AS sous_requete;

-- Statistiques globales concernant les utilisateurs et leurs trajets
SELECT
    COUNT(DISTINCT Utilisateur.id_utilisateur) AS total_utilisateurs,
    COUNT(Trajet.id_trajet) AS total_trajets,
    AVG(Enquete.satisfaction) AS satisfaction_moyenne
FROM Utilisateur
LEFT JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
LEFT JOIN Enquete ON Utilisateur.id_utilisateur = Enquete.id_utilisateur;


-- Groupe 2 : Fréquence et distribution des trajets

-- Répartition des transports utilisés
SELECT Transport.nom_transport, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Trajet
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Transport.nom_transport;

-- Répartition des trajets dans le temps (fréquence par mois)
SELECT MONTH(date_trajet) AS mois, COUNT(*) AS nombre_trajets
FROM Trajet
GROUP BY mois
ORDER BY mois;

-- Répartition des trajets par type d’utilisateur et type de transport
SELECT Utilisateur.type_utilisateur, Transport.nom_transport, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Utilisateur
JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Utilisateur.type_utilisateur, Transport.nom_transport;

-- Top 5 des utilisateurs les plus actifs
SELECT Utilisateur.nom, Utilisateur.prenom, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Utilisateur
JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
GROUP BY Utilisateur.id_utilisateur
ORDER BY nombre_trajets DESC
LIMIT 5;

-- Comparaison de l'utilisation BRT vs TER
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

-- Trajets récents (effectués dans les 30 derniers jours)
SELECT Utilisateur.nom, Utilisateur.prenom, Trajet.date_trajet
FROM Utilisateur
JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
WHERE Trajet.date_trajet >= CURDATE() - INTERVAL 30 DAY
ORDER BY Trajet.date_trajet DESC;

-- Pourcentage d’utilisation des différents moyens de transport
SELECT Transport.nom_transport,
       (COUNT(Trajet.id_trajet) / (SELECT COUNT(*) FROM Trajet) * 100) AS pourcentage_utilisation
FROM Trajet
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Transport.nom_transport;

-- Taux de correspondance(s) (utilisateurs utilisant plus d'un type de transport)
SELECT COUNT(DISTINCT u.id_utilisateur) * 100.0 / (SELECT COUNT(*) FROM Utilisateur) AS taux_correspondance
FROM Utilisateur u
JOIN Trajet t1 ON u.id_utilisateur = t1.id_utilisateur
JOIN Trajet t2 ON u.id_utilisateur = t2.id_utilisateur
JOIN Transport tr1 ON t1.id_transport = tr1.id_transport
JOIN Transport tr2 ON t2.id_transport = tr2.id_transport
WHERE tr1.nom_transport != tr2.nom_transport;


--Groupe 3 : Durée et satisfaction des trajets
-- Trajet le plus récent et le plus ancien
SELECT MAX(date_trajet) as Plus_récent, MIN(date_trajet) AS Plus_ancient
FROM trajet;

-- Durée moyenne des trajets par type de transport
SELECT tr.type_transport AS type_transport,
       AVG(TIMEDIFF(t.heure_arrivee, t.heure_depart)) AS duree_moyenne
FROM Transport tr
JOIN Trajet t ON tr.id_transport = t.id_transport
GROUP BY tr.type_transport;

-- Analyse des commentaires négatifs
SELECT e.commentaires, e.satisfaction
FROM Enquete e
WHERE e.satisfaction < 5
LIMIT 20;

-- Satisfaction moyenne par type de transport
SELECT tr.nom_transport AS nom_transport, AVG(e.satisfaction) AS satisfaction_moyenne
FROM Transport tr
JOIN Trajet t ON tr.id_transport = t.id_transport
JOIN Enquete e ON t.id_utilisateur = e.id_utilisateur
GROUP BY tr.nom_transport;

-- Stations les moins fréquentées
SELECT s.nom_station, COUNT(*) AS nombre_departs
FROM Station s
LEFT JOIN Trajet t ON s.id_station = t.id_station_depart
GROUP BY s.nom_station
ORDER BY nombre_departs ASC
LIMIT 5;




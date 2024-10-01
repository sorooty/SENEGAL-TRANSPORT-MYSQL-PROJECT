# Senegal transport
 
 > A university project throughout which we had to manage a public transport society's database to generate useful mass data-analysis inisghts and study users profile for strategic and marketing purposes

# **Projet 11 : "SEN-TRANSPORT", Analyse des Profils des Utilisateurs des Transports Publics à Dakar**

![Texte alternatif](./imgs/ter1.jpeg)

>### **Fiche Technique :** *Présentation de la base de données, de ses composantes puis analyse et interprétation des résultats obtenus*

**Auteurs**: 
- **Seyni Jr. Baldé**,  Data-Analyst chez *CESI-IT*
- **Jean Léandre Tiemtoré**, Data-Administrator chez *CESI-IT*
- **Sonia Hameg**, Data-Analyst chez *CESI-IT*

>Ce notebook présente et explique en détail les requêtes SQL utilisées pour analyser les données des utilisateurs des transports publics à Dakar, Sénégal, plus particulièrement du **TER et du BRT**. Le but est de rendre chaque requête compréhensible, même pour les non-initiés à SQL.

## **1. Création du Modèle Conceptuel de Données (MCD)**

>Le MCD (Modèle Conceptuel de Données) représente la structure logique des données et les relations entre les entités. Voici les principales entités et relations identifiées pour ce projet.

### Entités :
- **Utilisateur** : Informations générales sur les utilisateurs (élèves et personnel de l'ISJA).
- **Transport** : Type de transport utilisé par les usagers (TER, BRT, autre).
- **Station** : Les stations desservies par les transports.
- **Trajet** : Détails des trajets effectués par les utilisateurs.
- **Enquête** : Réponses des utilisateurs concernant leur satisfaction et leurs commentaires.
- **Utilisation** : Fréquence d'utilisation des différents moyens de transport.

### Relations :
- **Utilisateur - Transport** : Un utilisateur peut utiliser plusieurs types de transports.
- **Utilisateur - Trajet** : Un utilisateur peut faire plusieurs trajets.
- **Utilisateur - Enquête** : Un utilisateur peut répondre à une enquête.
- **Utilisateur - Utilisation** : Un utilisateur peut avoir plusieurs enregistrements d'utilisation de transport.

## **2. Conversion en Modèle Logique de Données (MLD)**

>Le MLD (Modèle Logique de Données) représente une forme plus structurée du MCD, prête à être implémentée dans une base de données relationnelle. Voici un aperçu des principales tables et de leurs colonnes :

### **Tables du MLD :**

**Utilisateur :**
- `id_utilisateur` (PRIMARY KEY)
- `nom` (VARCHAR)
- `prenom` (VARCHAR)
- `type_utilisateur` (ENUM('élève', 'personnel'))
- `email` (VARCHAR)

**Transport :**
- `id_transport` (PRIMARY KEY)
- `nom_transport` (ENUM('TER', 'BRT', 'Autre'))
- `type_transport` (VARCHAR)

**Station :**
- `id_station` (PRIMARY KEY)
- `nom_station` (VARCHAR)
- `localisation` (VARCHAR)

**Trajet :**
- `id_trajet` (PRIMARY KEY)
- `id_utilisateur` (FOREIGN KEY)
- `id_transport` (FOREIGN KEY)
- `id_station_depart` (FOREIGN KEY)
- `id_station_arrivee` (FOREIGN KEY)
- `date_trajet` (DATETIME)

**Enquête :**
- `id_enquete` (PRIMARY KEY)
- `id_utilisateur` (FOREIGN KEY)
- `satisfaction` (INT)
- `commentaires` (TEXT)
- `date_reponse` (DATE)

**Utilisation :**
- `id_utilisation` (PRIMARY KEY)
- `id_utilisateur` (FOREIGN KEY)
- `id_transport` (FOREIGN KEY)
- `frequence_utilisation` (ENUM('quotidienne', 'hebdomadaire', 'mensuelle'))

> (Il faudra ajouter les images des modèles graphiques de Sonia)

## **3. Implémentation du fichier CSV dans MySQL**

### **Étape 1 : Création des tables dans MySQL**

Voici les requêtes SQL pour créer les tables correspondant au MLD dans MySQL :

```sql
-- 1 Créer la table utilisateurs
CREATE TABLE IF NOT EXISTS Utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    type_utilisateur ENUM('élève', 'personnel') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 2 Création de la table Transport
CREATE TABLE IF NOT EXISTS Transport (
    id_transport INT AUTO_INCREMENT PRIMARY KEY,
    nom_transport ENUM('TER', 'BRT', 'Autre') NOT NULL,
    type_transport VARCHAR(50) NOT NULL
);

-- 3 Création de la table Station
CREATE TABLE IF NOT EXISTS Station (
    id_station INT AUTO_INCREMENT PRIMARY KEY,
    nom_station VARCHAR(100) NOT NULL,
    localisation VARCHAR(100) NOT NULL
);

-- 4 Création de la table Trajet
CREATE TABLE IF NOT EXISTS Trajet (
    id_trajet INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_transport INT NOT NULL,
    id_station_depart INT NOT NULL,
    id_station_arrivee INT NOT NULL,
    date_trajet DATETIME NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (id_transport) REFERENCES Transport(id_transport),
    FOREIGN KEY (id_station_depart) REFERENCES Station(id_station),
    FOREIGN KEY (id_station_arrivee) REFERENCES Station(id_station)
);

-- 5 Création de la Table Enquete
CREATE TABLE IF NOT EXISTS Enquete (
    id_enquete INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    satisfaction INT NOT NULL,
    commentaires TEXT,
    date_reponse DATE NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
);

-- 6 Création de la table Utilisation
CREATE TABLE IF NOT EXISTS Utilisation (
    id_utilisation INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_transport INT NOT NULL,
    frequence_utilisation ENUM('quotidienne', 'hebdomadaire', 'mensuelle') NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (id_transport) REFERENCES Transport(id_transport)
);
```
### **Étape 2 : (à terminer)
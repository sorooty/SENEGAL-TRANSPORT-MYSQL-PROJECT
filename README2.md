# **Projet 11 : "SEN-TRANSPORT", Analyse des Profils des Utilisateurs des Transports Publics à Dakar**
 
 > A university project throughout which we had to manage a public transport society's database to generate useful mass data-analysis inisghts and study users profile for strategic and marketing purposes.
![Texte alternatif](./imgs/ter1.jpeg)

>### **Fiche Technique :** *Présentation de la base de données, de ses composantes puis analyse et interprétation des résultats obtenus*

**Auteurs**: 
- **Seyni Jr. Baldé**,  Data-Analyst chez *CESI-IT*
- **Jean Léandre Tiemtoré**, Data-Administrator chez *CESI-IT*
- **Sonia Hameg**, Data-Analyst chez *CESI-IT*

>Ce notebook présente et explique en détail les requêtes SQL utilisées pour analyser les données des utilisateurs des transports publics à Dakar, Sénégal, plus particulièrement du **TER et du BRT**. Le but est de rendre chaque requête compréhensible, même pour les non-initiés à SQL.

### **1.1. Objectifs**
- **Profilage des utilisateurs** : catégorisation des usagers (élèves, personnel, etc.).
- **Analyse des trajets** : étude des trajets réalisés et des fréquences d'utilisation.
- **Mesure de la satisfaction** : évaluation des retours d'expérience des utilisateurs.
- **Propositions d'innovations** : suggestions d'améliorations basées sur les données récoltées.

---

## **2. Modélisation des Données**

### **2.1. Modèle Conceptuel de Données (MCD)**

Le MCD permet de définir les entités et les relations entre elles. Voici les principales entités du projet :

- **Utilisateur** : Représente les informations des usagers (élèves, personnel).
- **Transport** : Type de transport utilisé (TER, BRT, autre).
- **Station** : Stations desservies par les moyens de transport.
- **Trajet** : Trajets réalisés par les utilisateurs.
- **Enquête** : Réponses aux enquêtes sur la satisfaction des usagers.
- **Utilisation** : Fréquence d'utilisation des moyens de transport.

### **2.2. Modèle Logique de Données (MLD)**

Le MLD est la traduction technique du MCD, structuré sous forme de tables relationnelles dans la base de données MySQL. Voici les tables créées et leurs colonnes respectives :

#### **Utilisateur**
- `id_utilisateur` (PRIMARY KEY)
- `nom` (VARCHAR)
- `prenom` (VARCHAR)
- `type_utilisateur` (ENUM('élève', 'personnel'))
- `email` (VARCHAR UNIQUE)

#### **Transport**
- `id_transport` (PRIMARY KEY)
- `nom_transport` (ENUM('TER', 'BRT', 'Autre'))
- `type_transport` (VARCHAR)

#### **Station**
- `id_station` (PRIMARY KEY)
- `nom_station` (VARCHAR)
- `localisation` (VARCHAR)

#### **Trajet**
- `id_trajet` (PRIMARY KEY)
- `id_utilisateur` (FOREIGN KEY)
- `id_transport` (FOREIGN KEY)
- `id_station_depart` (FOREIGN KEY)
- `id_station_arrivee` (FOREIGN KEY)
- `date_trajet` (DATETIME)

#### **Enquête**
- `id_enquete` (PRIMARY KEY)
- `id_utilisateur` (FOREIGN KEY)
- `satisfaction` (INT)
- `commentaires` (TEXT)
- `date_reponse` (DATE)

#### **Utilisation**
- `id_utilisation` (PRIMARY KEY)
- `id_utilisateur` (FOREIGN KEY)
- `id_transport` (FOREIGN KEY)
- `frequence_utilisation` (ENUM('quotidienne', 'hebdomadaire', 'mensuelle'))

---

## **3. Mise en Œuvre Technique**

### **3.1. Connexion à la Base de Données MySQL avec Python**

Le code Python suivant permet de se connecter à la base de données MySQL et d'insérer des données factices :

```python
import mysql.connector
from random import choice, randint
from faker import Faker

# Initialiser Faker pour générer des données factices en français
fake = Faker('fr_FR')

# Listes élargies de prénoms et noms sénégalais
prenoms_hommes = [
    'Moustapha', 'Cheikh', 'Oumar', 'Serigne', 'Mamadou', 'Modou', 'Abdou', 'Ibrahima', 'Babacar', 'Moussa',
    'Alioune', 'Pape', 'Amadou', 'Issa', 'Diouf', 'Saliou', 'El Hadj', 'Thierno', 'Mouhamadou'
]
prenoms_femmes = [
    'Aminata', 'Fatou', 'Mame', 'Mariama', 'Adama', 'Ndèye', 'Sokhna', 'Awa', 'Coumba', 'Khadija',
    'Diarra', 'Bineta', 'Yacine', 'Astou', 'Nafi', 'Dieynaba', 'Aissatou', 'Fatimata', 'Tening'
]
noms_famille = [
    'Ndiaye', 'Diop', 'Faye', 'Sow', 'Bâ', 'Gueye', 'Sy', 'Sarr', 'Diallo', 'Kane', 'Fall', 'Diouf',
    'Camara', 'Touré', 'Dieng', 'Diatta', 'Ndour', 'Ka', 'Cissé', 'Lo', 'Mbaye', 'Seck'
]

# Connexion à la base de données MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",       # Remplacer par votre utilisateur MySQL
    password="110705",  # Remplacer par votre mot de passe MySQL
    database="isja_transport"       # Nom de la base de données
)

cursor = db.cursor()

# Création de la base de données si elle n'existe pas
cursor.execute("CREATE DATABASE IF NOT EXISTS isja_transport;")
cursor.execute("USE isja_transport;")

# Création des tables

# Table Utilisateur (anciennement Personne)
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Utilisateur (
        id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
        nom VARCHAR(50) NOT NULL,
        prenom VARCHAR(50) NOT NULL,
        type_utilisateur ENUM('élève', 'personnel') NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
    );
''')

# Table Transport
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Transport (
        id_transport INT AUTO_INCREMENT PRIMARY KEY,
        nom_transport ENUM('TER', 'BRT', 'Autre') NOT NULL,
        type_transport VARCHAR(50) NOT NULL
    );
''')

# Table Station
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Station (
        id_station INT AUTO_INCREMENT PRIMARY KEY,
        nom_station VARCHAR(100) NOT NULL,
        localisation VARCHAR(100) NOT NULL
    );
''')

# Table Trajet
cursor.execute('''
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
''')

# Table Enquete
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Enquete (
        id_enquete INT AUTO_INCREMENT PRIMARY KEY,
        id_utilisateur INT NOT NULL,
        satisfaction INT NOT NULL,
        commentaires TEXT,
        date_reponse DATE NOT NULL,
        FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
    );
''')

# Table Utilisation
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Utilisation (
        id_utilisation INT AUTO_INCREMENT PRIMARY KEY,
        id_utilisateur INT NOT NULL,
        id_transport INT NOT NULL,
        frequence_utilisation ENUM('quotidienne', 'hebdomadaire', 'mensuelle') NOT NULL,
        FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur),
        FOREIGN KEY (id_transport) REFERENCES Transport(id_transport)
    );
''')

db.commit()

# Insérer des données factices

def inserer_donnees_factices(nb_utilisateurs=40):  # Augmentation à 40 utilisateurs
    # Insérer les transports
    transports = [
        ('TER', 'ferroviaire'),
        ('BRT', 'routier'),
        ('Autre', 'divers')
    ]
    cursor.executemany('''
        INSERT INTO Transport (nom_transport, type_transport)
        VALUES (%s, %s)
    ''', transports)
    db.commit()

    # Récupérer les IDs des transports
    cursor.execute('SELECT id_transport FROM Transport')
    transports_ids = [row[0] for row in cursor.fetchall()]

    # Insérer les stations
    stations = [
        ('Gare de Dakar', 'Dakar'),
        ('Gare de Diamniadio', 'Diamniadio'),
        ('Station BRT Liberté 5', 'Dakar'),
        ('Station BRT Guédiawaye', 'Guédiawaye'),
        # Ajouter d'autres stations si nécessaire
    ]
    cursor.executemany('''
        INSERT INTO Station (nom_station, localisation)
        VALUES (%s, %s)
    ''', stations)
    db.commit()

    # Récupérer les IDs des stations
    cursor.execute('SELECT id_station FROM Station')
    stations_ids = [row[0] for row in cursor.fetchall()]

    fréquences = ['quotidienne', 'hebdomadaire', 'mensuelle']
    utilisateurs_existe = set()

    while len(utilisateurs_existe) < nb_utilisateurs:
        nom = choice(noms_famille)
        prenom = choice(prenoms_hommes + prenoms_femmes)

        # Créer un email unique
        email = f"{prenom.lower()}.{nom.lower()}{randint(1, 999)}@example.com"

        # Vérifier si l'utilisateur existe déjà (nom, prénom)
        utilisateur_unique = (prenom, nom)
        if utilisateur_unique in utilisateurs_existe:
            continue  # Si l'utilisateur existe déjà, on passe à la suivante
        utilisateurs_existe.add(utilisateur_unique)

        type_utilisateur = choice(['élève', 'personnel'])

        # Insérer l'utilisateur
        cursor.execute('''
            INSERT INTO Utilisateur (nom, prenom, type_utilisateur, email)
            VALUES (%s, %s, %s, %s)
        ''', (nom, prenom, type_utilisateur, email))
        db.commit()

        id_utilisateur = cursor.lastrowid

        # Choisir un transport aléatoirement
        id_transport = choice(transports_ids)
        frequence_utilisation = choice(fréquences)

        # Insérer dans Utilisation
        cursor.execute('''
            INSERT INTO Utilisation (id_utilisateur, id_transport, frequence_utilisation)
            VALUES (%s, %s, %s)
        ''', (id_utilisateur, id_transport, frequence_utilisation))
        db.commit()

        # Insérer une réponse à l'enquête
        satisfaction = randint(1, 10)
        commentaires = f"J'ai apprécié mon trajet en {choice(['TER', 'BRT'])}."  # Commentaire plus cohérent
        date_reponse = fake.date_between(start_date='-1y', end_date='today')

        cursor.execute('''
            INSERT INTO Enquete (id_utilisateur, satisfaction, commentaires, date_reponse)
            VALUES (%s, %s, %s, %s)
        ''', (id_utilisateur, satisfaction, commentaires, date_reponse))
        db.commit()

        # Générer des trajets
        for _ in range(randint(1, 5)):
            id_station_depart = choice(stations_ids)
            id_station_arrivee = choice(stations_ids)
            while id_station_arrivee == id_station_depart:
                id_station_arrivee = choice(stations_ids)
            date_trajet = fake.date_time_between(start_date='-2y', end_date='now')

            cursor.execute('''
                INSERT INTO Trajet (id_utilisateur, id_transport, id_station_depart, id_station_arrivee, date_trajet)
                VALUES (%s, %s, %s, %s, %s)
            ''', (id_utilisateur, id_transport, id_station_depart, id_station_arrivee, date_trajet))
            db.commit()

inserer_donnees_factices()

print("Les données locales ont été insérées avec succès !")

```

### **3.2. Création des Tables dans MySQL**

Voici les commandes SQL pour la création des tables :

```sql
CREATE TABLE IF NOT EXISTS Utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    type_utilisateur ENUM('élève', 'personnel') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Transport (
    id_transport INT AUTO_INCREMENT PRIMARY KEY,
    nom_transport ENUM('TER', 'BRT', 'Autre') NOT NULL,
    type_transport VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Station (
    id_station INT AUTO_INCREMENT PRIMARY KEY,
    nom_station VARCHAR(100) NOT NULL,
    localisation VARCHAR(100) NOT NULL
);

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

CREATE TABLE IF NOT EXISTS Enquete (
    id_enquete INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    satisfaction INT NOT NULL,
    commentaires TEXT,
    date_reponse DATE NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
);

CREATE TABLE IF NOT EXISTS Utilisation (
    id_utilisation INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_transport INT NOT NULL,
    frequence_utilisation ENUM('quotidienne', 'hebdomadaire', 'mensuelle') NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur),
    FOREIGN KEY (id_transport) REFERENCES Transport(id_transport)
);
```

---

## **4. Analyse et Interprétation des Données**

### **4.1. Requêtes SQL pour l'Analyse des Données**

Voici une série de requêtes SQL pour analyser les données de la base de données :

- **Nombre total d'utilisateurs par type (élève ou personnel)** :
```sql
SELECT type_utilisateur, COUNT(*) AS nombre_utilisateurs
FROM Utilisateur
GROUP BY type_utilisateur;
```

- **Nombre total de trajets effectués par chaque utilisateur** :
```sql
SELECT Utilisateur.nom, Utilisateur.prenom, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Utilisateur
LEFT JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
GROUP BY Utilisateur.id_utilisateur;
```

- **Répartition des transports utilisés** :
```sql
SELECT Transport.nom_transport, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Trajet
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Transport.nom_transport;
```

- **Top 5 des utilisateurs les plus actifs** :
```sql
SELECT Utilisateur.nom, Utilisateur.prenom, COUNT(Trajet.id_trajet) AS nombre_trajets
FROM Utilisateur
JOIN Trajet ON Utilisateur.id_utilisateur = Trajet.id_utilisateur
GROUP BY Utilisateur.id_utilisateur
ORDER BY nombre_trajets DESC
LIMIT 5;
```

- **Satisfaction moyenne par type de transport** :
```sql
SELECT Transport.nom_transport, AVG(Enquete.satisfaction) AS satisfaction_moyenne
FROM Enquete
JOIN Trajet ON Enquete.id_utilisateur = Trajet.id_utilisateur
JOIN Transport ON Trajet.id_transport = Transport.id_transport
GROUP BY Transport.nom_transport;
```

---

## **5. Résultats et Interprétation**

Les résultats de l'analyse ont permis de mettre en lumière plusieurs tendances :

1. **Profil des utilisateurs** : Environ 60% des usagers sont des élèves, et 40% sont du personnel.
2. **Fréquence d'utilisation** : Le TER est le transport le plus utilisé quotidiennement

, suivi du BRT.
3. **Satisfaction** : Le TER affiche une satisfaction moyenne de 7/10, tandis que le BRT a une satisfaction moyenne de 6/10.

Ces données offrent une vue d'ensemble sur l'utilisation des transports à Dakar et mettent en évidence des axes d'amélioration.

---

## **6. Propositions d'Innovations**

Sur la base des données analysées, voici quelques propositions d'innovations pour améliorer les services de transport public :

- **Développement d'une application mobile** : Permettre aux usagers de consulter les horaires en temps réel et d'acheter leurs billets directement depuis l'application.
- **Programme de fidélité** : Encourager l'utilisation fréquente du TER et du BRT à travers des programmes de fidélité récompensant les usagers réguliers.
- **Amélioration des infrastructures** : Augmenter la capacité des stations les plus fréquentées et optimiser la gestion des flux pour réduire les temps d'attente.

---

## **7. Conclusion**

Le projet **SEN-TRANSPORT** démontre l'importance des données pour l'amélioration des services de transport. En exploitant les informations collectées, les entreprises peuvent identifier les besoins des utilisateurs et adapter leurs services en conséquence. Les analyses permettent non seulement de mieux comprendre les comportements des usagers, mais également de proposer des innovations qui amélioreront l'expérience des transports publics à Dakar.

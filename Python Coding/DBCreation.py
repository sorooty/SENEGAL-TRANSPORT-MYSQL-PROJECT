import mysql.connector
from random import choice, randint
from faker import Faker
from PASSWORD import password

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
    password= password,  # Le mot de passe d'accès à ma base de données
    database="sen_trans_test" # Nom de la base de données
)

cursor = db.cursor()

# Création de la base de données si elle n'existe pas
cursor.execute("CREATE DATABASE IF NOT EXISTS sen_trans_test;")
cursor.execute("USE sen_trans_test;")

# Création des tables

# Table Utilisateur 
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Utilisateur (
        id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
        nom VARCHAR(50) NOT NULL,
        prenom VARCHAR(50) NOT NULL,
        type_utilisateur VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
    );
''')

# Table Transport
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Transport (
        id_transport INT AUTO_INCREMENT PRIMARY KEY,
        nom_transport VARCHAR(100) NOT NULL,
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
        ('Taxi', 'routier'),
        ('Bus DemDikk', 'routier'),
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
        ('Gare de Colobane', 'Colobane'),
        ('Gare de Hann', 'Hann'),
        ('Gare de Dalifort', 'Dalifort'),
        ('Gare de Pikine ', 'Pikine'),
        ('Gare de Thiaroye', 'Thiaroye'),
        ('Station BRT Collège Sacré Coeur', 'Sacré Coeur')
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

        type_utilisateur = choice(['élève', 'personnel', 'professeur'])

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

        # Générer des trajets
        for _ in range(randint(1, 5)):
            id_station_depart = choice(stations_ids)
            id_station_arrivee = choice(stations_ids)
            while id_station_arrivee == id_station_depart:
                id_station_arrivee = choice(stations_ids)
            date_trajet = fake.date_time_between(start_date='-1y', end_date='now')

            cursor.execute('''
                INSERT INTO Trajet (id_utilisateur, id_transport, id_station_depart, id_station_arrivee, date_trajet)
                VALUES (%s, %s, %s, %s, %s)
            ''', (id_utilisateur, id_transport, id_station_depart, id_station_arrivee, date_trajet))
            db.commit()

inserer_donnees_factices()

print("Les données locales ont été insérées avec succès !")

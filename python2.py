import csv
import mysql.connector

# Connexion à la base de données MySQL
cnx = mysql.connector.connect(user='root', password='110705', host='localhost', database='senegal_transport')
cursor = cnx.cursor()

# Lecture du fichier CSV
with open('Profils_Utilisateurs_Transports_Publics_Realistes.csv', mode='r') as file:
    csv_reader = csv.reader(file)
    next(csv_reader)  # Ignore l'en-tête
    
    for row in csv_reader:
        email = row[0]
        moyen_transport = row[6]
        frequence_utilisation = row[7]
        distance_parcourue = row[8]
        satisfaction = row[10]
        type_ticket = row[11]
        depenses_mensuelles = row[12]
        app_utilisation = row[9]

        # Fetching user ID
        print(f"Fetching user for email: {email}")
        cursor.execute("SELECT id_utilisateur FROM Utilisateur WHERE email = %s", (email,))
        id_utilisateur = cursor.fetchone()
        
        if id_utilisateur is None:
            print(f"No user found with email: {email}")
            continue  # Skip to the next iteration

        # Fetching transport ID
        cursor.execute("SELECT id_transport FROM Transport WHERE moyen_transport = %s", (moyen_transport,))
        id_transport = cursor.fetchone()

        if id_transport is None:
            print(f"No transport found for: {moyen_transport}")
            continue  # Skip to the next iteration

        # Insert data into Trajet
        cursor.execute("""
            INSERT INTO Trajet (id_utilisateur, id_transport, frequence_utilisation, distance_parcourue, satisfaction)
            VALUES (%s, %s, %s, %s, %s)
        """, (id_utilisateur[0], id_transport[0], frequence_utilisation, distance_parcourue, satisfaction))

        # Insert data into Tickets
        cursor.execute("""
            INSERT INTO Tickets (id_utilisateur, type_ticket, depenses_mensuelles)
            VALUES (%s, %s, %s)
        """, (id_utilisateur[0], type_ticket, depenses_mensuelles))

        # Insert data into Application_Mobile
        cursor.execute("""
            INSERT INTO Application_Mobile (id_utilisateur, app_utilisation)
            VALUES (%s, %s)
        """, (id_utilisateur[0], app_utilisation))


# Valider les changements et fermer la connexion
cnx.commit()
cursor.close()
cnx.close()

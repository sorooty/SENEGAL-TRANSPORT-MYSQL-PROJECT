import csv
import random

# Listes de prénoms et noms sénégalais pour rendre les profils plus réalistes
prenoms = ["Mamadou", "Fatou", "Abdoulaye", "Awa", "Ousmane", "Mariama", "Cheikh", "Astou", "Bamba", "Ndèye", "Pape", "Khady", "Moussa", "Aminata", "Seydou", "Coumba"]
noms = ["Diop", "Ba", "Faye", "Gueye", "Sow", "Ndiaye", "Fall", "Thiam", "Cissé", "Diallo", "Mbaye", "Sarr", "Sakho", "Sy", "Kane", "Dieng"]
quartiers = ["Plateau", "Médina", "Yoff", "Almadies", "Mermoz", "Hann Marinas", "Point E", "Ouakam", "Diamniadio", "Thiaroye", "Autre"]
sexes = ["Masculin", "Féminin"]
professions = ["Élève", "Étudiant", "Professeur", "Personnel"]
transports = ["BRT", "TER", "Bus", "Taxi", "Voiture", "À pied", "Autre"]
frequences = ["Journalière (plusieurs fois par jour)", "Hebdomadaire (plusieurs fois par semaine)", "Mensuelle (plusieurs fois par mois)", "Occasionnelle", "Autre"]
distances = ["Entre 0 et 5 km", "Entre 5 et 10 km", "Entre 10 et 15 km", "Entre 15 et 20 km", "Plus de 20km"]
satisfactions = ["Très satisfait", "Satisfait", "Neutre", "Insatisfait", "Très insatisfait"]
types_tickets = ["Ticket à l'unité", "Carte prépayée", "Abonnement mensuel", "Je ne prends pas ces transports"]
utilisation_app = ["Oui", "Non"]
depenses = [f"{random.randint(500, 20000)} FCFA" for _ in range(30)]

# Génération des profils avec noms et adresses e-mails réalistes
def generate_realistic_profile(id):
    prenom = random.choice(prenoms)
    nom = random.choice(noms)
    email = f"{prenom.lower()}.{nom.lower()}{id}@example.com"
    nom_prenom = f"{prenom} {nom}"
    quartier = random.choice(quartiers)
    sexe = random.choice(sexes)
    age = random.randint(15, 60)
    profession = random.choice(professions)
    transport = random.choice(transports)
    frequence = random.choice(frequences)
    distance = random.choice(distances)
    app = random.choice(utilisation_app)
    satisfaction = random.choice(satisfactions)
    ticket = random.choice(types_tickets)
    depense = random.choice(depenses)

    return [email, nom_prenom, quartier, sexe, age, profession, transport, frequence, distance, app, satisfaction, ticket, depense]


header = ["email", "nom_prenom", "quartier", "sexe", "age", "profession", "transport", "frequence", "distance", "app", "satisfaction", "ticket", "depense"]
# Création du fichier CSV avec 30 profils réalistes
filename_realistic = "./Profils_Utilisateurs_Transports_Publics_Realistes.csv"

with open(filename_realistic, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(header)
    for i in range(30):
        writer.writerow(generate_realistic_profile(i+1))

filename_realistic  # returning the file path to share with the user
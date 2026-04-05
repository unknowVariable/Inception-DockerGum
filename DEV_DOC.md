# Developer Documentation

## Prérequis

- Docker
- Docker Compose
- Make

---

## Installation

### 1. Cloner le projet

git clone <repo_url>
cd Inception

---

### 2. Créer les dossiers de données

mkdir -p /home/<login>/data/mariadb
mkdir -p /home/<login>/data/wordpress

---

### 3. Configurer le fichier `.env`

Créer le fichier `srcs/.env` :

LOGIN=<login>
DOMAIN_NAME=<login>.42.fr
TZ=Europe/Paris

MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser

WP_TITLE=Inception
WP_ADMIN_USER=siteowner
WP_ADMIN_EMAIL=siteowner@example.com

WP_USER=author42
WP_USER_EMAIL=author42@example.com

---

### 4. Configurer les secrets

Créer le dossier `secrets/` à la racine :

mkdir secrets

Puis les fichiers :

secrets/db_root_password.txt
secrets/db_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt

Chaque fichier contient uniquement le mot de passe.

---

## Utilisation du Makefile

### Build uniquement

make build

→ construit les images Docker

---

### Lancer le projet

make up

→ build si nécessaire + lance les conteneurs

---

### Arrêter le projet

make down

→ stop et supprime les conteneurs

---

### Nettoyage complet

make fclean

→ supprime conteneurs, images et volumes Docker

---

### Vérifier les conteneurs

make ps

---

## Commandes Docker Compose utiles

Depuis `srcs/` :

cd srcs

### Voir les conteneurs

docker compose ps

---

### Voir les logs

docker compose logs
docker compose logs wordpress
docker compose logs mariadb
docker compose logs nginx

---

### Accéder à un conteneur

docker compose exec wordpress sh
docker compose exec mariadb sh

---

### Commandes WP-CLI

docker compose exec wordpress wp core is-installed --allow-root
docker compose exec wordpress wp user list --allow-root

---

## Persistance des données

Les données sont stockées sur le host dans :

/home/<login>/data/mariadb
/home/<login>/data/wordpress

Ces dossiers sont montés en volumes dans les conteneurs.

### Important

- Les données persistent après `make down`
- Elles sont supprimées uniquement avec :
  - suppression manuelle des dossiers
  - ou `make fclean` selon la configuration

---

## Architecture

Le projet contient 3 services :

- mariadb → base de données
- wordpress → application PHP-FPM
- nginx → serveur web HTTPS

Flux :

client → nginx → wordpress (php-fpm) → mariadb

---

## Notes

- Les Dockerfiles construisent les images
- docker-compose orchestre les services
- ENTRYPOINT lance les scripts d’initialisation
- CMD lance le service principal dans chaque conteneur
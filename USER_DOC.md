# User Documentation

## Lancer le projet

Depuis la racine du projet :

make up

Cette commande :
- construit les images si nécessaire
- lance les conteneurs
- démarre le site

---

## Arrêter le projet

make down

Cette commande arrête et supprime les conteneurs.

---

## Nettoyer complètement

make fclean

Cette commande supprime :
- conteneurs
- images
- volumes Docker

---

## Accéder au site

https://aconstan.42.fr

Exemple :

https://aconstan.42.fr

---

## Accéder à l’administration WordPress

https://aconstan.42.fr/wp-admin

---

## Identifiants

Les mots de passe sont stockés dans le dossier :

secrets/

Fichiers :

- wp_admin_password.txt → mot de passe admin
- wp_user_password.txt → mot de passe utilisateur

Les identifiants utilisateurs sont définis dans .env :

- Admin : WP_ADMIN_USER
- User : WP_USER

---

## Vérifications de base

### Vérifier que les conteneurs tournent

make ps

Résultat attendu :
- nginx → Up
- wordpress → Up
- mariadb → Up

---

### Vérifier que le site répond

curl -kI https://aconstan.42.fr

Résultat attendu :

HTTP/1.1 200 OK

---

### Vérifier WordPress

cd srcs
docker compose exec wordpress wp core is-installed --allow-root

---

### Lister les utilisateurs WordPress

cd srcs
docker compose exec wordpress wp user list --allow-root
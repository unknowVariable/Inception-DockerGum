*This project has been created as part of the 42 curriculum by aconstan.*

# Inception

## Description
Ce projet consiste à déployer une architecture Docker composée de trois services :
- **NGINX** avec HTTPS (TLS 1.2/1.3)
- **WordPress** avec PHP-FPM
- **MariaDB**

Chaque service tourne dans son propre conteneur et communique via un réseau Docker dédié.

L’objectif est de comprendre le fonctionnement de Docker, la gestion des conteneurs, ainsi que la mise en place d’une infrastructure web sécurisée.

---

## Instructions

### Lancer le projet
```bash
make up
```

### Arrêter le projet
```bash
make down
```

### Nettoyer complètement (images, volumes, conteneurs)
```bash
make fclean
```

### Vérifier les conteneurs
```bash
make ps
```

### Accéder au site
https://aconstan.42.fr

### Accéder à l’admin WordPress
https://aconstan.42.fr/wp-admin

---

## Resources

### Documentation officielle
- https://docs.docker.com/
- https://docs.docker.com/compose/
- https://hub.docker.com/
- https://nginx.org/en/docs/
- https://www.php.net/manual/en/install.fpm.php
- https://mariadb.org/documentation/
- https://wordpress.org/support/article/how-to-install-wordpress/

### Concepts utiles
- Réseaux Docker (bridge, communication inter-conteneurs)
- Volumes Docker (persistance des données)
- Reverse proxy avec NGINX
- Configuration HTTPS (TLS 1.2 / 1.3, certificats SSL)
- Architecture multi-conteneurs avec docker-compose

### Aide utilisée
- Documentation offi
- ChatGPT a été utilisé ponctuellement pour clarifier certains concepts, aider au débogage et améliorer la compréhension globale du projet.
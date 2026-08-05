# Choix techniques

## Pourquoi un prototype en HTML/CSS/JavaScript simple

Le prototype ne dépend d'aucun framework, d'aucune installation, d'aucun serveur. Un fichier `index.html` s'ouvre dans n'importe quel navigateur, sur n'importe quel poste de l'hôpital, sans intervention du service informatique.

Ce choix n'est pas qu'une facilité technique : dans un établissement peu informatisé, la première barrière à un projet numérique est souvent l'installation et la maintenance d'un outil, pas sa conception. Un prototype qu'on peut ouvrir en double-cliquant est un prototype qu'on peut montrer à une équipe soignante, à la direction ou en entretien sans dépendre de personne.

## Ce que cette application fait déjà

Elle est connectée à une vraie base de données en ligne (Supabase, un PostgreSQL managé) : les 9 modules lisent et écrivent des données réelles, partagées entre tous les visiteurs du lien. Déclarer un événement, planifier un audit, proposer une idée et voter modifient réellement la base.

## Ce qu'elle ne fait pas encore

Il n'y a pas de comptes utilisateurs ni de droits d'accès par service : n'importe qui avec le lien peut tout voir et tout modifier. C'est un choix assumé pour tenir un délai court — la [Phase 2 de la roadmap](./ROADMAP.md) prévoit les droits d'accès par service, une fois la Phase 1 validée avec de vraies équipes. Passer à une vraie mise en production supposerait aussi :

- une base de données pour stocker les indicateurs, événements et actions dans la durée,
- une gestion des droits d'accès (chaque service ne doit voir que ses propres données, comme décrit dans le module Les équipes),
- une interface de saisie pour les équipes terrain, pas seulement un tableau de bord de lecture,
- un hébergement conforme aux exigences de sécurité des données de santé.

Ces choix seront à faire une fois la Phase 1 de la [feuille de route](./ROADMAP.md) validée avec de vraies données — pas avant, pour éviter d'investir dans une architecture avant de savoir ce qui sera réellement utilisé.

## Structure du dépôt

```
pulse-qualite/
├── README.md                              → vision et présentation du projet
├── index.html                             → application, connectée à Supabase
├── database/
│   └── schema.sql                          → script de création des tables + données de départ
└── docs/
    ├── ROADMAP.md                          → déploiement progressif envisagé
    ├── MODULES.md                          → détail de chaque module et données nécessaires
    ├── CONFIGURATION-BASE-DE-DONNEES.md    → brancher votre propre base, sans terminal
    └── CHOIX-TECHNIQUES.md                 → ce document
```

# Pulse Qualité

Une plateforme qui centralise toutes les informations liées à la qualité, transforme les données en décisions et facilite l'amélioration continue — au bénéfice des patients et des professionnels.

> Projet conçu pour un contexte hospitalier peu informatisé : la priorité n'est pas la complexité technique, mais la capacité à rendre visible, en un coup d'œil, ce qui aujourd'hui reste dispersé entre tableurs, classeurs papier et boîtes mail.

## Pourquoi ce projet

Dans beaucoup d'établissements, l'information qualité existe — indicateurs ANQ, IQSS, événements indésirables, satisfaction patient — mais elle est éclatée entre plusieurs outils, mise à jour manuellement, et rarement lue par tout le monde en même temps. Résultat : les décisions arrivent en retard, et le travail des équipes qui font bien les choses passe inaperçu.

Pulse Qualité part d'un principe simple : **une seule page doit suffire pour savoir comment va l'hôpital aujourd'hui.**

## Aperçu de l'application

L'application est disponible dans [`index.html`](./index.html) — un site autonome qui se connecte à une vraie base de données en ligne (Supabase/PostgreSQL). Les 9 modules lisent et écrivent des données réelles, partagées entre tous ceux qui ouvrent le lien : déclarer un événement, planifier un audit, proposer une idée et voter sont de vraies actions, enregistrées en base.

Ce que ce n'est **pas** (encore) : un système avec des comptes utilisateurs par service — n'importe qui avec le lien peut tout voir et tout modifier. C'est un choix assumé pour aller vite ; la Phase 2 de la [roadmap](./docs/ROADMAP.md) prévoit les droits d'accès par service.

**Pour connecter votre propre base** : voir [`docs/CONFIGURATION-BASE-DE-DONNEES.md`](./docs/CONFIGURATION-BASE-DE-DONNEES.md) — 3 étapes, aucun terminal requis.

## Les modules

| Module | Ce qu'il fait |
|---|---|
| 🏥 Tableau de bord Direction | Tous les indicateurs qualité (ANQ, IQSS, infections, chutes, escarres, douleur, satisfaction, réclamations, audits, plans d'action, alertes) sur une seule page |
| 👩‍⚕️ Les équipes | Chaque service voit uniquement ses propres indicateurs, actions, audits, formations et événements, avec un code couleur simple |
| 😊 Voix du patient | Satisfaction, compliments, plaintes, idées, témoignages — pas seulement les réclamations |
| ⚠️ Gestion des risques | Événements indésirables, presque accidents, analyses ALARM/REMED, causes profondes, CAPA, suivi automatique |
| 📋 Audits | Planification, checklist numérique, rapports automatiques, suivi des actions |
| 📈 Qualité en temps réel | Une carte de l'hôpital : chaque service en 🟢 stable, 🟠 vigilance ou 🔴 priorité |
| 💡 Boîte à idées | Chaque collaborateur propose une amélioration, les collègues votent, les meilleures sont testées |
| 🤖 IA Qualité | Résumer un audit, rédiger un compte-rendu, proposer une CAPA, rechercher une norme ou une procédure |
| 🎉 Les réussites | Mettre en avant ce qui fonctionne : jours sans chute, service du mois, projets terminés, compliments patients |

**L'idée la plus innovante** : la page *"Le patient aujourd'hui"* — un résumé quotidien qui permet à la direction de connaître l'état de l'hôpital en 30 secondes, sans naviguer dans dix écrans différents.

## Où en est le projet

Ceci est un prototype de vision, pas encore un outil connecté aux vrais systèmes de l'hôpital. Il sert à :
1. valider que l'organisation de l'information a du sens pour les équipes terrain,
2. servir de support de discussion avec la direction pour prioriser les premiers modules,
3. poser une structure de projet claire pour la suite (voir [`docs/ROADMAP.md`](./docs/ROADMAP.md)).

## Documentation du projet

- [`docs/ROADMAP.md`](./docs/ROADMAP.md) — comment ce projet pourrait être déployé étape par étape dans un hôpital réel
- [`docs/MODULES.md`](./docs/MODULES.md) — description détaillée de chaque module et des données qu'il suppose de collecter
- [`docs/CHOIX-TECHNIQUES.md`](./docs/CHOIX-TECHNIQUES.md) — pourquoi ces choix techniques, pensés pour un contexte peu informatisé

## Lancer le prototype

Aucune installation nécessaire :

```
git clone <url-du-repo>
cd pulse-qualite
# ouvrir index.html dans un navigateur
```

Ou, si le dépôt est publié via GitHub Pages, simplement en ouvrant le lien fourni par GitHub.

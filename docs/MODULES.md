# Détail des modules

Pour chaque module : à quoi il sert, et quelles données réelles il suppose de collecter (le point souvent sous-estimé dans ce type de projet).

## 🏥 Tableau de bord Direction

Vue d'ensemble : indicateurs ANQ, IQSS, infections associées aux soins, chutes, escarres, douleur, satisfaction, réclamations, audits en cours, plans d'actions, alertes.

**Données nécessaires** : la plupart existent déjà dans des rapports annuels ou des tableurs de suivi qualité. Le travail principal est de définir une fréquence de mise à jour commune (mensuelle en général) et un responsable par indicateur.

## 👩‍⚕️ Les équipes

Chaque service voit uniquement ses propres indicateurs, actions, audits, formations et événements, avec un code couleur simple.

**Données nécessaires** : les mêmes indicateurs que le tableau de bord Direction, mais filtrés par service — ce qui suppose que la donnée soit saisie avec le bon rattachement dès la collecte.

## 😊 Voix du patient

Regroupe questionnaires de satisfaction, compliments, plaintes, idées et témoignages — pour ne plus considérer uniquement les réclamations.

**Données nécessaires** : la plupart des établissements ont déjà des questionnaires de satisfaction et un circuit de réclamations. Les compliments et témoignages, en revanche, sont rarement collectés systématiquement — c'est souvent à créer.

## ⚠️ Gestion des risques

Événements indésirables, presque accidents, analyses ALARM, analyses REMED, causes profondes, CAPA, suivi automatique.

**Données nécessaires** : suppose un circuit de déclaration clair et connu de toutes les équipes. Le "suivi automatique" ne peut fonctionner que si chaque événement est rattaché à une action et une échéance dès sa création.

## 📋 Audits

Planification, checklist numérique, rapports automatiques, suivi des actions.

**Données nécessaires** : un calendrier d'audits existant généralement déjà. La checklist numérique remplace le papier — un gain d'adoption rapide si elle est plus simple à remplir que l'existant.

## 📈 Qualité en temps réel

Une carte de l'hôpital : chaque service en 🟢 stable, 🟠 vigilance ou 🔴 priorité, cliquable pour voir indicateurs, incidents, actions et satisfaction.

**Données nécessaires** : c'est le module le plus exigeant en fraîcheur de données — il n'a de sens que si les indicateurs sont mis à jour au moins hebdomadairement. À ne déployer qu'une fois les phases 1 et 2 de la feuille de route acquises.

## 💡 Boîte à idées

Chaque collaborateur propose une amélioration, les collègues votent, les meilleures sont testées.

**Données nécessaires** : aucune donnée qualité à proprement parler — surtout un enjeu d'adhésion et de visibilité des décisions prises suite aux votes.

## 🤖 IA Qualité

Résumer un audit, rédiger un compte-rendu, proposer une CAPA, rechercher une procédure, retrouver une norme, identifier les risques récurrents.

**Points de vigilance** : confidentialité des données patient, traçabilité des sources citées, validation humaine systématique avant toute diffusion d'un compte-rendu ou d'une CAPA générée.

## 🎉 Les réussites

Jours sans chute, service du mois, projet terminé, bravo sécurité, compliments patients.

**Données nécessaires** : dérivées des modules Gestion des risques et Voix du patient — pas de collecte supplémentaire, juste une mise en avant différente de données qui existent déjà.

## Le patient aujourd'hui

Résumé quotidien : taux de satisfaction, événements indésirables, plaintes, compliments, audits terminés, actions clôturées, services en vigilance.

**Données nécessaires** : agrège les modules ci-dessus. Ne peut être fiable que si chacun d'eux l'est déjà — c'est la synthèse, pas le point de départ.

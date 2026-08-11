# Rapport préalable : Mesures & Indicateurs — analyse de l'existant

Ce document répond à la demande du cahier des charges "Moteur de collecte, calcul et pilotage des indicateurs qualité" (section 43 : analyser l'existant avant toute modification). Il précède tout code.

## EXISTANT

- Application HTML/CSS/JS autonome (`index.html`), pas de framework, pas d'étape de build
- Base de données Supabase/PostgreSQL, accès public (pas d'authentification, pas de RLS différenciée par rôle)
- 7 tables : `services`, `indicateurs`, `evenements`, `audits`, `voix_patient`, `idees`, `reussites`
- Le tableau de bord Direction lit la table `indicateurs`, qui contient des **valeurs déjà calculées, saisies à la main** (ex : `libelle='Chutes', valeur='3', unite='/1000 j.'`) — pas de données sources, pas de formule, pas de traçabilité
- Une mise à jour d'indicateur (bouton "Mettre à jour un indicateur") écrase directement la valeur affichée — aucun calcul, aucune preuve
- Lecture croisée avec Relia Santé déjà en place (événements et signalements patients)

## À CONSERVER

- L'interface existante (design, navigation, 9 modules) — le cahier des charges le demande explicitement ("conserver l'esprit graphique actuel")
- La lecture croisée avec Relia Santé
- Le principe d'un fichier autonome sans build — changer ça maintenant serait un chantier à part entière, sans rapport avec le moteur de mesures lui-même

## À CRÉER (si on avance sur ce chantier)

Le cœur du modèle générique demandé, adapté à ce qui est réellement faisable en JavaScript + Supabase (sans FastAPI, sans React) :
- `instruments`, `instrument_versions` — référentiel des instruments de mesure
- `form_sections`, `form_items` — structure générique des formulaires
- `measurements`, `measurement_answers` — les mesures et leurs réponses
- `indicators`, `indicator_sources` — indicateurs et ce qui les alimente
- `audit_logs` — traçabilité des modifications

## À MODIFIER

- Le tableau de bord Direction : passer d'une lecture de valeurs saisies à une lecture de valeurs **calculées** à partir de `measurements` — mais seulement une fois qu'il existe de vraies mesures à calculer

## À SUPPRIMER

- Rien dans l'immédiat. Le cahier des charges dit explicitement de ne pas casser l'existant.

## RISQUES

1. **Contenu des instruments ANQ (HoNOS, BSCL, HoNOSCA, EFM, EBI, FIM/MIF, CIRS)** : le cahier des charges est très clair — ne jamais inventer les items, les règles de cotation, les textes officiels. Je n'ai pas accès à ces documents sources, qui sont sous licence ANQ. **Sans eux, je ne peux construire que le moteur générique, avec un instrument d'exemple fictif clairement étiqueté comme placeholder** — jamais un vrai HoNOS.
2. **Authentification et RLS par rôle** : le cahier des charges suppose des droits différenciés (directeur / professionnel / patient). Notre application n'a pas de comptes utilisateurs du tout — c'est un prérequis déjà identifié comme non fait dans la roadmap initiale.
3. **FastAPI / backend séparé** : construire un vrai backend Python dépasse largement ce qui est faisable dans le temps qui reste avant votre entretien, et changerait l'architecture entière du projet.
4. **Ampleur générale** : le document liste 50 sections et un découpage en 8 sprints. Même la version la plus réduite (Sprint 1 seul) représente plusieurs jours de travail bien fait pour être crédible.

## Recommandation

Ne pas tenter de construire l'ensemble du système maintenant. Deux options réalistes, détaillées dans [`PLAN-MESURES-INDICATEURS.md`](./PLAN-MESURES-INDICATEURS.md) :
1. **Documenter l'architecture cible complète** (les livrables A à J demandés en section 50) sans coder — un excellent point à présenter à l'oral : vous montrez que vous savez distinguer un prototype d'un système de production, et que vous avez déjà la cartographie technique en tête.
2. **Construire une preuve de concept limitée** : les tables génériques + un seul instrument d'exemple (fictif, étiqueté comme tel) + un calcul automatique simple relié à une carte du dashboard — pour démontrer le principe "saisie → calcul → dashboard" sans prétendre avoir livré le système complet.

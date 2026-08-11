# Module Risques — ce qui est fait, ce qui ne l'est pas

Le document "Document d'évolution technique global v2.0" décrit un vrai système de gestion des risques hospitaliers (84 sections). Voici honnêtement ce qui a été construit et ce qui reste une vision documentée seulement.

## ✅ Fait — la déclaration universelle (section 5 à 23 du document, simplifiées)

- Bouton **"🚨 Faire un signalement"**, accessible depuis Gestion des risques
- Formulaire en langage courant : *"Que s'est-il passé ?"* plutôt que *"Identifier la nature de l'EIAS"*
- **"Je ne sais pas"** accepté à trois endroits : catégorie, moment exact, conséquence — jamais de valeur arbitraire forcée
- Sélection multiple libre de "qui/quoi était concerné" (Patient, Médicament, Informatique...)
- Séparation entre le fait (*"Que s'est-il passé ?"*) et la mesure immédiate (*"Que s'est-il passé après ?"*)
- **Référence unique**, générée après enregistrement, jamais réutilisée (`EVT-26-000001`)
- Message rassurant après envoi + **proposition de piste non contraignante** (jamais une qualification automatique définitive)
- Liste "Mes signalements" avec statut

## 🟡 Simplifié par rapport au document

- Une seule table (`pq_declarations`), pas de séparation `events` / `risks` / `analyses` / `barriers` / `capa` / `rex` — la structure complète en aval (qualification, analyse ALARM/REMED, barrières, CAPA, REX) n'existe pas
- Pas d'écran de catégorisation en amont ("Que souhaitez-vous signaler ?" avec 7 gros boutons) — remplacé par un simple menu déroulant optionnel dans le même formulaire, pour rester simple
- Pas d'aide contextuelle ⓘ sur les acronymes (le formulaire actuel n'utilise déjà aucun acronyme, donc moins critique)
- Pas de sauvegarde automatique de brouillon
- Pas de formulaire adaptatif selon la catégorie (les mêmes champs s'affichent, quel que soit ce qui est sélectionné)

## ⏳ Pas fait — nécessite une vraie équipe et du temps

- Espace professionnel complet (Vue d'ensemble / Risques / Événements / Analyses / Barrières / Vigilances / CAPA / REX)
- Moteur multi-méthodes d'analyse (ALARM, London Protocol, 5 Pourquoi, Ishikawa, AMDEC...)
- Matrice de criticité configurable
- CAPA avec suivi d'efficacité
- Détection de récurrences et signaux faibles croisés (événements + réclamations + audits)
- Authentification et droits par profil (déclarant / référent risques / direction...)
- Contexte réglementaire France/Suisse configurable
- IA de catégorisation (section 60 du document — explicitement "Phase 2")

## Pourquoi s'arrêter là

Le document lui-même structure le travail en 8 phases, la déclaration universelle étant la toute première brique avant tout le reste ("La déclaration universelle doit être développée avant les fonctionnalités d'analyse complexes" — section 78). C'est exactement ce qui a été fait : la fondation, pas l'édifice complet. Le reste (phases 2 à 8) représente un vrai projet de plusieurs mois, pas une suite de fonctionnalités à ajouter.

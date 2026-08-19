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

## ✅ Fait — espace professionnel simplifié (nouveau module "Analyses & CAPA")

- **Analyses ALARM** : les 7 dimensions du modèle (patient, tâches, professionnel, équipe, environnement, systèmes d'information, organisation), jamais réduites à "erreur humaine", avec référence unique (`ANAL-26-000001`)
- **CAPA** : problème, cause, action, responsable, échéance, avec suivi de statut cliquable (Planifiée → En cours → Terminée → Vérifiée → Clôturée)
- **REX** : les 5 questions du retour d'expérience (ce qui s'est passé / a fonctionné / n'a pas fonctionné / appris / doit changer)
- **Vigilances** : les 6 types réglementaires (pharmaco-, matério-, hémo-, bio-, infectio-, réactovigilance)
- **Signaux faibles** : détection automatique, calculée à partir des données déjà en base (événements + réclamations croisés par service, seuil de 3), sans aucune nouvelle saisie — exactement le principe de la section 48 du document

## ✅ Fait — vrais liens et suivi de bout en bout (au lieu de texte libre)

Correction importante après un premier retour : les analyses, CAPA et REX étaient d'abord reliés à une déclaration par un champ texte libre à retaper (ex : coller "EVT-26-000003" à la main), sans vrai lien ni vue d'ensemble. Désormais :
- Chaque analyse, CAPA et REX se lie à une déclaration via un **vrai menu déroulant** (clé étrangère en base, pas du texte)
- Une CAPA peut se lier soit directement à une déclaration, soit à une analyse précise (les choix se filtrent automatiquement selon la déclaration choisie)
- **Cliquer sur un signalement** dans "Mes signalements" ouvre sa **fiche de suivi complète** : la déclaration, puis chaque analyse liée, puis chaque CAPA liée avec son statut, puis les REX — tout au même endroit
- **Vue globale en entonnoir** : 4 compteurs cliquables (Déclaré / En analyse / Action en cours / Clôturé), calculés automatiquement à partir des liens réels (pas d'un champ statut saisi à la main) — cliquer un compteur filtre la liste des signalements à cette étape

## 🟡 Simplifié par rapport au document

- Une seule table (`pq_declarations`), pas de séparation `events` / `risks` / `analyses` / `barriers` / `capa` / `rex` — la structure complète en aval (qualification, analyse ALARM/REMED, barrières, CAPA, REX) n'existe pas
- Pas d'écran de catégorisation en amont ("Que souhaitez-vous signaler ?" avec 7 gros boutons) — remplacé par un simple menu déroulant optionnel dans le même formulaire, pour rester simple
- Pas d'aide contextuelle ⓘ sur les acronymes (le formulaire actuel n'utilise déjà aucun acronyme, donc moins critique)
- Pas de sauvegarde automatique de brouillon
- Pas de formulaire adaptatif selon la catégorie (les mêmes champs s'affichent, quel que soit ce qui est sélectionné)

## ⏳ Pas fait — nécessite une vraie équipe et du temps

- Moteur multi-méthodes d'analyse complet (London Protocol, 5 Pourquoi, Ishikawa, AMDEC — seule la méthode ALARM est disponible)
- Matrice de criticité configurable (gravité × probabilité)
- Suivi d'efficacité détaillé des CAPA (indicateur avant/après)
- Authentification et droits par profil (déclarant / référent risques / direction...)
- Contexte réglementaire France/Suisse configurable
- IA de catégorisation (section 60 du document — explicitement "Phase 2")
- Lien automatique entre une CAPA et l'indicateur qu'elle est censée améliorer (la donnée existe, le rapprochement reste manuel)

## Pourquoi s'arrêter là

Le document lui-même structure le travail en 8 phases, la déclaration universelle étant la toute première brique avant tout le reste ("La déclaration universelle doit être développée avant les fonctionnalités d'analyse complexes" — section 78). C'est exactement ce qui a été fait : la fondation, pas l'édifice complet. Le reste (phases 2 à 8) représente un vrai projet de plusieurs mois, pas une suite de fonctionnalités à ajouter.

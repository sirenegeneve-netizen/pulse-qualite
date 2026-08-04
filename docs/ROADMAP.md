# Feuille de route

Un projet comme Pulse Qualité ne se déploie pas d'un coup, surtout dans un établissement peu informatisé où les données qualité vivent encore dans des tableurs, des classeurs et des mails. La priorité est de brancher progressivement de vraies données, pas d'ajouter des écrans.

## Phase 1 — Le socle : données réelles sur un périmètre restreint

**Objectif : remplacer les données fictives du Tableau de bord Direction et de la Gestion des risques par de vraies données, même collectées manuellement au départ.**

- Recenser les indicateurs qui existent déjà quelque part (ANQ, IQSS, chutes, escarres, infections, satisfaction) et où ils vivent aujourd'hui (Excel, logiciel métier, papier).
- Définir qui saisit quoi, à quelle fréquence — sans attendre une intégration technique parfaite.
- Brancher le module Gestion des risques sur le circuit de déclaration existant (ou en créer un simple s'il n'existe pas).

C'est la phase la plus importante : sans données fiables, tout le reste — la carte en temps réel, la page "Le patient aujourd'hui" — reste une coquille vide.

## Phase 2 — Un service pilote

**Objectif : tester le module Équipes et le module Audits avec un seul service volontaire, avant de généraliser.**

- Choisir un service moteur (souvent les Urgences ou un service très volontaire).
- Vérifier que le code couleur (🟢/🟠/🔴) correspond à une réalité que l'équipe reconnaît — sinon, ajuster les seuils.
- Recueillir les retours d'usage réels avant d'étendre aux autres services.

## Phase 3 — Écoute patient et reconnaissance

**Objectif : élargir au-delà des seules réclamations.**

- Centraliser questionnaires de satisfaction, compliments et témoignages, pas seulement les plaintes.
- Lancer le module Les réussites — souvent le plus simple à faire adopter, car il valorise plutôt qu'il ne contrôle.
- Ouvrir la Boîte à idées à l'ensemble des équipes.

## Phase 4 — IA Qualité

**Objectif : automatiser une fois que les données des phases précédentes sont fiables.**

Volontairement placée en dernier : une IA qui résume un audit incomplet ou propose une CAPA sur des données incertaines n'aide personne, et peut même nuire à la confiance dans l'outil. Cette phase soulève aussi des questions à trancher en amont : confidentialité des données patient, traçabilité des sources utilisées, validation humaine systématique de toute proposition (CAPA, compte-rendu) avant diffusion.

## Ce que ce séquençage évite

- Vouloir tout informatiser en même temps dans un établissement qui n'a pas cette culture — source d'échec fréquente de ce type de projet.
- Construire une belle carte en temps réel branchée sur des données qui ne sont mises à jour par personne.
- Perdre la confiance des équipes terrain en démarrant par l'outil le plus visible (l'IA) plutôt que par le plus utile (des données fiables, partagées).

# Plan — Moteur de mesures & indicateurs

Réponse aux livrables demandés (section 50 du cahier des charges), adaptés à la stack réelle du projet (HTML/JS + Supabase, pas de FastAPI ni de React).

## A. Architecture cible (simplifiée, sans backend séparé)

```
Établissement → Services → Patients → Séjours → Mesures
                                                    ↓
                                    Instrument → Version → Sections → Items
                                                    ↓
                                              Réponses (measurement_answers)
                                                    ↓
                                          Moteur de calcul (JavaScript, côté client)
                                                    ↓
                                              Score → Indicateur
                                                    ↓
                                              Tableau de bord
                                                    ↓
                                        Alerte → Plan d'action → Vérification
```

Différence assumée avec le cahier des charges : le "moteur de calcul" tourne côté client (JavaScript), pas dans un backend FastAPI séparé. C'est une limite réelle — un calcul déclenché uniquement au chargement de la page est moins robuste qu'un calcul serveur déclenché à chaque écriture. À noter comme dette technique si ce chantier va plus loin.

## B. Tables et relations

| Table | Rôle | Clés étrangères |
|---|---|---|
| `instruments` | Référentiel des instruments (HoNOS, BSCL...) | — |
| `instrument_versions` | Versions d'un instrument, jamais modifiées rétroactivement | `instrument_id` |
| `form_sections` | Sections d'un formulaire | `instrument_version_id` |
| `form_items` | Questions/items d'une section | `section_id` |
| `measurements` | Une mesure réalisée (référence unique, statut, contexte) | `instrument_version_id`, `service_id`, `sejour_id` (via lien Relia Santé si activé) |
| `measurement_answers` | Réponses à une mesure | `measurement_id`, `item_id` |
| `indicators` | Indicateurs calculés (définition, formule, seuils) | — |
| `indicator_sources` | Ce qui alimente un indicateur | `indicator_id` |
| `audit_logs` | Traçabilité de chaque modification | — |

Champs détaillés : voir directement `database/schema-mesures.sql` une fois créé (pas encore fait — dépend de la décision de portée, voir section G).

## C. SQL — non généré tant que la portée n'est pas validée avec vous (voir section G)

## D. RLS — limite assumée

Le cahier des charges demande des droits différenciés par rôle. Sans authentification, impossible à implémenter correctement : une policy RLS a besoin de savoir *qui* fait la requête. Tant que l'authentification n'existe pas (déjà identifiée comme prochaine étape dans `ROADMAP.md`), les tables de mesures resteraient en accès public comme le reste de l'application aujourd'hui — à documenter clairement comme limite de cette version.

## E. API — non applicable

Pas de FastAPI dans cette version : les requêtes passent directement du navigateur à Supabase (comme pour le reste de l'application). Un vrai backend serait nécessaire pour : calculs complexes côté serveur, contrôle d'accès robuste, imports Excel/CSV avec validation transactionnelle. À prévoir si ce chantier devient un vrai projet de production.

## F. Frontend — nouvelles pages/sections envisagées (dans le fichier unique existant)

- Nouveau module "Mesures & indicateurs" dans la navigation (comme demandé section 4)
- Sous-écrans : Nouvelle mesure (formulaire en 4 étapes : contexte, domaine, instrument, moment), Mesures en cours, Historique, Instruments (lecture seule du référentiel)
- Génération dynamique du formulaire à partir de `form_sections` / `form_items` (pas de `if instrument === 'HONOS'` codé en dur, conformément à la consigne)

## G. Portée réaliste avant votre entretien — à valider avec vous

Le cahier des charges découpe le travail en 8 sprints. Voici ce qui est raisonnable dans le temps disponible :

**Faisable (quelques heures, sans risque pour l'existant)**
- Tables génériques (`instruments`, `instrument_versions`, `form_sections`, `form_items`, `measurements`, `measurement_answers`)
- Un instrument d'exemple **fictif**, clairement étiqueté "Exemple — pas un instrument ANQ officiel" (puisque je n'ai pas les contenus HoNOS/BSCL réels sous licence)
- Formulaire dynamique généré depuis ces tables (preuve que le moteur générique fonctionne)
- Un calcul simple (ex: somme des items) affiché comme résultat de la mesure

**Pas faisable maintenant, à documenter comme roadmap**
- Les vrais instruments ANQ (HoNOS, BSCL, HoNOSCA, EFM, EBI, FIM/MIF, CIRS) — nécessitent les documents sources officiels sous licence, que je n'ai pas
- L'authentification et les droits par rôle
- Le moteur de règles conditionnelles complet (logique SI/ALORS stockée en base)
- Import Excel/CSV avec validation transactionnelle
- Un vrai calcul reliant automatiquement TOUS les indicateurs du dashboard existant (chutes, infections, etc.) à des données sources — ça suppose que ces données sources existent déjà quelque part, ce qui n'est pas le cas dans un prototype de démonstration

## H. Migration des données existantes

Les 8 indicateurs actuels de la table `indicateurs` (valeurs saisies à la main) resteraient en place tels quels. Aucune tentative de les migrer automatiquement vers le nouveau moteur — ça n'aurait pas de sens sans les vraies données sources qui les alimenteraient.

## I. Tests — limite assumée

Pas de suite de tests automatisés dans cette version (pas d'outillage de test en place dans le projet). À la place : vérification manuelle documentée (ex: saisir une mesure d'exemple, vérifier que le score calculé correspond au calcul attendu).

## J. Plan de développement, si vous validez la portée réaliste ci-dessus

1. Créer les tables génériques + RLS publique (cohérent avec le reste de l'app aujourd'hui)
2. Créer l'instrument d'exemple fictif (2-3 items, une règle de calcul simple)
3. Construire le formulaire dynamique (génération depuis les métadonnées, pas de code spécifique à l'instrument)
4. Calculer et afficher le score, avec traçabilité minimale (qui, quand)
5. Ajouter le module "Mesures & indicateurs" à la navigation
6. Documenter clairement, dans l'app elle-même, que les vrais instruments ANQ ne sont pas encore intégrés (licence requise)

Chaque étape reste indépendante et n'affecte pas les modules existants.

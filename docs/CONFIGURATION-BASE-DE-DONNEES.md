# Connecter votre base de données (sans terminal)

L'application a besoin de deux informations pour se connecter à votre base Supabase : l'URL du projet et la clé publique ("anon key"). Aucune de ces deux valeurs n'est un mot de passe secret — elles sont faites pour être utilisées dans du code exécuté dans un navigateur.

## Étape 1 — Créer le projet et les tables

1. Sur https://supabase.com, créez un projet (voir le README principal pour le détail pas-à-pas).
2. Dans **SQL Editor**, collez et exécutez le contenu de [`database/schema.sql`](../database/schema.sql). Ça crée les 7 tables et les remplit avec des données de départ.

## Étape 2 — Récupérer vos clés

1. Dans votre projet Supabase : **Project Settings** (icône ⚙️) → **API**
2. Copiez :
   - **Project URL** (ressemble à `https://xxxxxxxx.supabase.co`)
   - **anon public key** (une longue chaîne de caractères)

## Étape 3 — Les coller dans le code, directement sur GitHub

1. Ouvrez votre dépôt sur GitHub, cliquez sur `index.html`
2. Cliquez sur le crayon ✏️ (Edit this file)
3. Tout en haut du bloc `<script>`, repérez ces deux lignes :

```js
const SUPABASE_URL = 'VOTRE_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'VOTRE_SUPABASE_ANON_KEY';
```

4. Remplacez les deux valeurs entre guillemets par les vôtres, par exemple :

```js
const SUPABASE_URL = 'https://xxxxxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

5. En bas de page, **Commit changes**

## Vérifier que ça fonctionne

Ouvrez votre lien GitHub Pages. En bas de la barre latérale, un petit indicateur affiche :
- 🟢 **"Connecté à Supabase"** → tout fonctionne, les données réelles s'affichent
- 🔴 **"Base non connectée"** ou **"Erreur de connexion"** → un bandeau orange en haut de la page "Aujourd'hui" explique ce qui manque

## Lien vers Relia Santé (satisfaction patient)

Un bouton dans **Voix du patient → Satisfaction** renvoie vers Relia Santé (anciennement Synapath), la plateforme dédiée aux résultats détaillés de satisfaction. Pour le mettre à jour :

1. Ouvrez `index.html` sur GitHub → crayon ✏️
2. Cherchez la ligne :
```js
const RELIA_SANTE_URL = 'https://github.com/sirenegeneve-netizen/Relia_sante';
```
3. Remplacez l'adresse par l'URL réelle de la plateforme (idéalement le lien vers l'application en ligne, pas le dépôt de code)
4. **Commit changes**

## En cas d'erreur


- **"Erreur de connexion"** avec un message mentionnant une table introuvable → le script SQL de l'étape 1 n'a pas été exécuté (ou a échoué). Retournez dans SQL Editor et relancez-le.
- **Rien ne s'affiche du tout** → vérifiez que les guillemets autour de vos deux valeurs n'ont pas été supprimés par erreur en collant.

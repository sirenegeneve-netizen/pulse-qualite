-- ============================================================
-- Pulse Qualité — Déclaration universelle (module Risques, v1 simplifiée)
-- Fichier ADDITIF : n'affecte aucune table existante.
-- ============================================================
--
-- Principe : un signalement en langage courant, accessible à tout
-- professionnel sans connaître le vocabulaire qualité. La qualification
-- (EIAS, criticité, etc.) reste un travail humain ultérieur — cette
-- version ne fait qu'accepter la déclaration et proposer une piste,
-- jamais une qualification définitive automatique.
-- ============================================================

drop table if exists pq_declarations cascade;

create table pq_declarations (
  id bigint generated always as identity primary key,
  reference text unique,                 -- généré après insertion : EVT-26-000001
  categorie_initiale text,               -- choix optionnel du déclarant, jamais imposé
  description text not null,             -- "Que s'est-il passé ?" en langage libre
  quand_date date,
  quand_heure time,
  quand_inconnu boolean default false,   -- "Je ne sais pas exactement"
  concerne text,                         -- ex: 'Patient, Médicament' (choix multiples, stockés en texte simple)
  consequence text default 'je_ne_sais_pas' check (consequence in ('aucune','legere','prise_en_charge','grave','je_ne_sais_pas')),
  mesures_immediates text,               -- "Que s'est-il passé immédiatement après ?"
  statut text default 'declare' check (statut in ('brouillon','declare','en_analyse','cloture')),
  created_by text default 'Utilisateur démonstration',
  created_at timestamptz default now()
);

alter table pq_declarations enable row level security;
create policy "public read/write pq_declarations" on pq_declarations for all using (true) with check (true);

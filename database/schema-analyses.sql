-- ============================================================
-- Pulse Qualité — Espace professionnel : Analyses, CAPA, REX, Vigilances
-- Fichier ADDITIF : n'affecte aucune table existante.
-- Version simplifiée — pas de moteur multi-méthodes complet (ALARM
-- uniquement), pas de matrice de criticité configurable.
-- ============================================================

drop table if exists pq_vigilances cascade;
drop table if exists pq_rex cascade;
drop table if exists pq_capa cascade;
drop table if exists pq_analyses cascade;

-- Analyse ALARM simplifiée, rattachée à une déclaration (référence libre,
-- pas de contrainte stricte : une analyse peut aussi naître d'un
-- signalement Relia Santé ou d'un constat sans référence Pulse Qualité).
create table pq_analyses (
  id bigint generated always as identity primary key,
  reference text unique,              -- ANAL-26-000001
  declaration_reference text,         -- ex: 'EVT-26-000003', facultatif
  methode text default 'ALARM',
  patient text,
  taches text,
  professionnel text,
  equipe text,
  environnement text,
  systemes_info text,
  organisation text,
  causes_identifiees text,
  statut text default 'en_cours' check (statut in ('en_cours','terminee')),
  created_by text default 'Utilisateur démonstration',
  created_at timestamptz default now()
);

create table pq_capa (
  id bigint generated always as identity primary key,
  reference text unique,              -- CAPA-26-000001
  analyse_reference text,             -- facultatif, lien vers une analyse
  probleme text not null,
  cause text,
  action text not null,
  responsable text,
  echeance date,
  statut text default 'planned' check (statut in ('planned','in_progress','completed','verified','closed')),
  efficacite text check (efficacite in ('efficace','partiellement_efficace','inefficace','a_reevaluer') or efficacite is null),
  created_at timestamptz default now()
);

create table pq_rex (
  id bigint generated always as identity primary key,
  reference text unique,              -- REX-26-000001
  declaration_reference text,
  ce_qui_sest_passe text,
  ce_qui_a_fonctionne text,
  ce_qui_na_pas_fonctionne text,
  ce_que_nous_avons_appris text,
  ce_qui_doit_changer text,
  created_at timestamptz default now()
);

create table pq_vigilances (
  id bigint generated always as identity primary key,
  type text not null check (type in ('Pharmacovigilance','Matériovigilance','Hémovigilance','Biovigilance','Infectiovigilance','Réactovigilance','Autre')),
  description text not null,
  statut text default 'ouverte' check (statut in ('ouverte','en_cours','cloturee')),
  created_at timestamptz default now()
);

alter table pq_analyses enable row level security;
alter table pq_capa enable row level security;
alter table pq_rex enable row level security;
alter table pq_vigilances enable row level security;

create policy "public read/write pq_analyses" on pq_analyses for all using (true) with check (true);
create policy "public read/write pq_capa" on pq_capa for all using (true) with check (true);
create policy "public read/write pq_rex" on pq_rex for all using (true) with check (true);
create policy "public read/write pq_vigilances" on pq_vigilances for all using (true) with check (true);

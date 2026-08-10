-- ============================================================
-- PULSE QUALITÉ — schéma complet de base de données
-- (Supabase / PostgreSQL) — fichier unique : schema.sql
--
-- PARTIE 1 : socle applicatif (services, indicateurs, événements,
--            audits, voix du patient, idées, réussites)
-- PARTIE 2 : socle « Mesures & indicateurs » (référentiel
--            d'instruments versionnés, mesures, audit, indicateurs)
--
-- À exécuter dans Supabase → SQL Editor. Ré-exécutable sans erreur.
-- ============================================================

create extension if not exists "pgcrypto";

-- ============================================================
-- PARTIE 1 — SOCLE APPLICATIF
-- ============================================================

-- Services / équipes de l'hôpital, avec statut couleur
create table if not exists services (
  id text primary key,
  nom text not null,
  statut text not null check (statut in ('green','orange','red')),
  satisfaction text,
  indicateurs text,
  actions text,
  audits text,
  formations text,
  evenements text,
  updated_at timestamptz default now()
);

-- Indicateurs qualité du tableau de bord Direction
create table if not exists indicateurs (
  id bigint generated always as identity primary key,
  categorie text not null,
  libelle text not null,
  valeur text not null,
  unite text,
  tendance text,
  tendance_type text check (tendance_type in ('bonne','mauvaise','stable')),
  updated_at timestamptz default now()
);

-- Gestion des risques : événements indésirables, presque accidents, CAPA
create table if not exists evenements (
  id bigint generated always as identity primary key,
  description text not null,
  service text not null,
  type text not null default 'indesirable',
  gravite text not null check (gravite in ('green','orange','red')),
  statut text default 'Suivi standard',
  created_at timestamptz default now()
);

-- Audits : planification, checklist, statut
create table if not exists audits (
  id bigint generated always as identity primary key,
  titre text not null,
  service text,
  date_prevue date,
  statut text default 'Planifié' check (statut in ('Planifié','En cours','Terminé')),
  progression int default 0,
  created_at timestamptz default now()
);

-- Voix du patient : satisfaction, compliments, plaintes, idées, témoignages
create table if not exists voix_patient (
  id bigint generated always as identity primary key,
  type text not null check (type in ('satisfaction','compliment','plainte','idee','temoignage')),
  contenu text not null,
  service text,
  statut text,
  created_at timestamptz default now()
);

-- Boîte à idées
create table if not exists idees (
  id bigint generated always as identity primary key,
  titre text not null,
  auteur text default 'Anonyme',
  votes int default 1,
  created_at timestamptz default now()
);

-- Les réussites
create table if not exists reussites (
  id bigint generated always as identity primary key,
  icone text default '🎉',
  titre text not null,
  description text,
  created_at timestamptz default now()
);

-- ------------------------------------------------------------
-- GRANTS (obligatoire : l'API Data de Supabase n'accorde plus
-- de privilèges par défaut sur le schéma public)
-- ------------------------------------------------------------
grant select, insert, update, delete on
  services, indicateurs, evenements, audits, voix_patient, idees, reussites
  to anon, authenticated;
grant all on
  services, indicateurs, evenements, audits, voix_patient, idees, reussites
  to service_role;
grant usage, select on all sequences in schema public to anon, authenticated;

-- ------------------------------------------------------------
-- Sécurité : pas de comptes utilisateurs pour l'instant
-- (voir ROADMAP.md, Phase 2). Lecture/écriture publique via la
-- clé "anon" pour que la démo fonctionne sans backend.
-- À DURCIR AVANT PRODUCTION.
-- ------------------------------------------------------------
alter table services     enable row level security;
alter table indicateurs  enable row level security;
alter table evenements   enable row level security;
alter table audits       enable row level security;
alter table voix_patient enable row level security;
alter table idees        enable row level security;
alter table reussites    enable row level security;

do $pol$
begin
  if not exists (select 1 from pg_policies where tablename='services' and policyname='public read/write services') then
    create policy "public read/write services" on services for all using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='indicateurs' and policyname='public read/write indicateurs') then
    create policy "public read/write indicateurs" on indicateurs for all using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='evenements' and policyname='public read/write evenements') then
    create policy "public read/write evenements" on evenements for all using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='audits' and policyname='public read/write audits') then
    create policy "public read/write audits" on audits for all using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='voix_patient' and policyname='public read/write voix_patient') then
    create policy "public read/write voix_patient" on voix_patient for all using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='idees' and policyname='public read/write idees') then
    create policy "public read/write idees" on idees for all using (true) with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='reussites' and policyname='public read/write reussites') then
    create policy "public read/write reussites" on reussites for all using (true) with check (true); end if;
end $pol$;

-- ------------------------------------------------------------
-- Données de départ (PARTIE 1)
-- ------------------------------------------------------------
insert into services (id, nom, statut, satisfaction, indicateurs, actions, audits, formations, evenements) values
('urgences','Urgences','orange','88%','Délai d''attente moyen : 42 min (+18)','3 en cours','1 audit en cours','Formation triage — 80%','1 événement cette semaine'),
('chirurgie','Chirurgie','red','90%','Taux d''infection post-op : 1.4%','5 en cours','Audit hygiène bloc en cours','Formation identitovigilance — 60%','1 ALARM en cours'),
('maternite','Maternité','green','98%','Chutes : 0','1 en cours','Aucun audit en cours','À jour','120 jours sans chute'),
('geriatrie','Gériatrie','green','95%','Chutes : 0.5 / 1000 j','2 en cours','Audit dossier patient prévu','Formation douleur — 100%','Aucun événement'),
('pediatrie','Pédiatrie','green','97%','Satisfaction : 97%','0 en cours','Aucun audit en cours','À jour','Aucun événement'),
('medecine-interne','Médecine interne','orange','91%','Escarres : 2.1%','4 en cours','Audit prévention escarres prévu','Formation prévention — 45%','2 presque accidents'),
('bloc','Bloc opératoire','green','—','Checklist : 100%','0 en cours','—','—','Aucun'),
('pharmacie','Pharmacie','green','—','Ruptures : 1 en cours','1 en cours','—','—','0 ce mois')
on conflict (id) do nothing;

insert into indicateurs (categorie, libelle, valeur, unite, tendance, tendance_type)
select * from (values
('ANQ','Indicateurs ANQ','87','/100','▲ 3 pts vs T-1','bonne'),
('IQSS','IQSS','A','classe','= stable','stable'),
('Infections','Infections associées aux soins','0.8','%','▼ 0.2 pt','bonne'),
('Chutes','Chutes','3','/1000 j.','▲ 1 vs mois dernier','mauvaise'),
('Escarres','Escarres','1.2','%','▼ 0.4 pt','bonne'),
('Douleur','Douleur maîtrisée','91','%','= stable','stable'),
('Satisfaction','Satisfaction globale','96','%','▲ 2 pts','bonne'),
('Réclamations','Réclamations','14','ce mois','▼ 5','bonne')
) as v where not exists (select 1 from indicateurs);

insert into evenements (description, service, type, gravite, statut)
select * from (values
('Erreur d''identitovigilance','Chirurgie','indesirable','red','ALARM en cours'),
('Chute avec conséquence mineure','Gériatrie','indesirable','orange','REMED planifiée'),
('Presque accident médicamenteux','Pharmacie','presque_accident','green','CAPA clôturée')
) as v where not exists (select 1 from evenements);

insert into audits (titre, service, date_prevue, statut, progression)
select * from (values
('Circuit du médicament','Pharmacie','2026-08-12'::date,'Planifié',0),
('Hygiène des mains — Urgences','Urgences','2026-08-19'::date,'Planifié',0),
('Dossier patient informatisé','Direction','2026-08-26'::date,'Planifié',0),
('Hygiène — Bloc opératoire','Bloc opératoire',null,'En cours',78)
) as v where not exists (select 1 from audits);

insert into voix_patient (type, contenu, service, statut)
select * from (values
('compliment','Personnel très à l''écoute en Pédiatrie','Pédiatrie',null),
('compliment','Prise en charge rapide aux Urgences','Urgences',null),
('compliment','Merci à l''équipe de nuit en Chirurgie','Chirurgie',null),
('plainte','Temps d''attente jugé trop long','Urgences','En traitement'),
('plainte','Erreur de facturation','Administration','Résolue'),
('temoignage','Trois semaines d''hospitalisation, et jamais je ne me suis sentie seule. L''équipe de Gériatrie a un vrai sens de l''humain.','Gériatrie',null)
) as v where not exists (select 1 from voix_patient);

insert into idees (titre, auteur, votes)
select * from (values
('Écrans d''attente avec temps estimé aux Urgences','Équipe Urgences',34),
('Chariot de soins avec check-list intégrée','Équipe Chirurgie',27),
('Application mobile pour signaler un événement en 1 clic','Direction qualité',21),
('Salle de repos dédiée pour les familles en Gériatrie','Équipe Gériatrie',15)
) as v where not exists (select 1 from idees);

insert into reussites (icone, titre, description)
select * from (values
('🛡️','120','jours sans chute — Maternité'),
('🏆','Gériatrie','Service du mois'),
('✅','Circuit du médicament','Projet terminé'),
('👏','Bloc opératoire','Bravo sécurité'),
('💌','17','compliments patients aujourd''hui'),
('🎯','96 %','objectif satisfaction atteint')
) as v where not exists (select 1 from reussites);

-- ============================================================
-- PARTIE 2 — SOCLE « MESURES & INDICATEURS »
-- (ex-pulse_mesures.sql, intégré ici)
-- ============================================================



-- ---------- Référentiel : instruments ----------
create table if not exists public.pq_instruments (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  name text not null,
  short_name text,
  description text,
  domain text not null,
  population text,
  source text,
  owner text,
  license_required boolean not null default false,
  license_status text,
  license_reference text,
  authorized_use text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ---------- Référentiel : versions (jamais modifiées rétroactivement) ----------
create table if not exists public.pq_instrument_versions (
  id uuid primary key default gen_random_uuid(),
  instrument_code text not null references public.pq_instruments(code) on delete restrict,
  version text not null,
  effective_from date,
  effective_to date,
  status text not null default 'active',
  source_document text,
  source_url text,
  license_information text,
  calculation_version text not null default '1',
  validation_version text not null default '1',
  items jsonb not null default '[]'::jsonb,   -- sections/items/options/règles de visibilité
  rule  jsonb not null default '{"type":"SUM"}'::jsonb, -- règle de calcul du score
  created_at timestamptz not null default now(),
  unique (instrument_code, version)
);

-- ---------- Mesures ----------
create table if not exists public.pq_measurements (
  id uuid primary key default gen_random_uuid(),
  reference text unique not null,
  instrument_code text not null,
  instrument_version text not null,
  calculation_version text,
  domain text,
  patient_ref text,
  stay_ref text,
  service text,
  unit text,
  professional text,
  measurement_date date,
  measurement_time text,
  measurement_context text not null,           -- ADMISSION / IN_STAY / DISCHARGE / EVENT / FOLLOW_UP / REASSESSMENT
  status text not null default 'draft',        -- draft/in_progress/completed/validated/rejected/archived
  answers jsonb not null default '{}'::jsonb,
  score jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by text,
  updated_by text,
  validated_at timestamptz,
  validated_by text,
  constraint pq_measurement_status_chk
    check (status in ('draft','in_progress','completed','validated','rejected','archived')),
  constraint pq_measurement_version_fk
    foreign key (instrument_code, instrument_version)
    references public.pq_instrument_versions (instrument_code, version) on delete restrict
);
create index if not exists pq_measurements_instr_idx on public.pq_measurements (instrument_code, measurement_context, status);
create index if not exists pq_measurements_date_idx  on public.pq_measurements (measurement_date);

-- Une mesure validée ne peut pas être supprimée silencieusement
create or replace function public.pq_block_delete_validated()
returns trigger language plpgsql as $$
begin
  if old.status = 'validated' then
    raise exception 'Une mesure validée ne peut pas être supprimée : utilisez le statut archived.';
  end if;
  return old;
end $$;
drop trigger if exists pq_no_delete_validated on public.pq_measurements;
create trigger pq_no_delete_validated before delete on public.pq_measurements
for each row execute function public.pq_block_delete_validated();

-- ---------- Journal d'audit ----------
create table if not exists public.pq_audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id text,
  entity_type text not null,
  entity_id text not null,
  action text not null,        -- CREATE/UPDATE/DELETE/VALIDATE/REJECT/ARCHIVE/EXPORT
  old_value jsonb,
  new_value jsonb,
  timestamp timestamptz not null default now(),
  ip text
);
create index if not exists pq_audit_entity_idx on public.pq_audit_logs (entity_type, entity_id);

-- ---------- Indicateurs (définitions + sources) ----------
create table if not exists public.pq_indicators (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  name text not null,
  description text,
  domain text,
  unit text,
  frequency text,
  numerator_definition text,
  denominator_definition text,
  calculation_formula text,
  target numeric,
  warning_threshold numeric,
  critical_threshold numeric,
  source text,
  active boolean not null default true
);

create table if not exists public.pq_indicator_sources (
  id uuid primary key default gen_random_uuid(),
  indicator_code text not null references public.pq_indicators(code) on delete cascade,
  source_type text not null,   -- measurement / event / voix_patient / audit
  source_filter jsonb not null default '{}'::jsonb
);

-- ---------- GRANTS (obligatoire pour l'API Data de Supabase) ----------
grant select on public.pq_instruments, public.pq_instrument_versions,
                public.pq_indicators, public.pq_indicator_sources to anon, authenticated;
grant select, insert, update on public.pq_measurements to anon, authenticated;
grant select, insert on public.pq_audit_logs to anon, authenticated;
grant all on public.pq_instruments, public.pq_instrument_versions, public.pq_measurements,
             public.pq_audit_logs, public.pq_indicators, public.pq_indicator_sources to service_role;

-- ---------- RLS (démo ouverte : à durcir avant production) ----------
alter table public.pq_instruments          enable row level security;
alter table public.pq_instrument_versions  enable row level security;
alter table public.pq_measurements         enable row level security;
alter table public.pq_audit_logs           enable row level security;
alter table public.pq_indicators           enable row level security;
alter table public.pq_indicator_sources    enable row level security;

do $$
begin
  -- Lecture du référentiel : ouverte (aucune donnée patient)
  if not exists (select 1 from pg_policies where tablename='pq_instruments' and policyname='ref_read') then
    create policy ref_read on public.pq_instruments for select using (true); end if;
  if not exists (select 1 from pg_policies where tablename='pq_instrument_versions' and policyname='ref_read_v') then
    create policy ref_read_v on public.pq_instrument_versions for select using (true); end if;
  if not exists (select 1 from pg_policies where tablename='pq_indicators' and policyname='ind_read') then
    create policy ind_read on public.pq_indicators for select using (true); end if;
  if not exists (select 1 from pg_policies where tablename='pq_indicator_sources' and policyname='ind_src_read') then
    create policy ind_src_read on public.pq_indicator_sources for select using (true); end if;

  -- Mesures : mode démo. EN PRODUCTION, remplacer par des policies
  -- restreintes à auth.uid() / au service du professionnel.
  if not exists (select 1 from pg_policies where tablename='pq_measurements' and policyname='m_demo_read') then
    create policy m_demo_read   on public.pq_measurements for select using (true); end if;
  if not exists (select 1 from pg_policies where tablename='pq_measurements' and policyname='m_demo_write') then
    create policy m_demo_write  on public.pq_measurements for insert with check (true); end if;
  if not exists (select 1 from pg_policies where tablename='pq_measurements' and policyname='m_demo_update') then
    create policy m_demo_update on public.pq_measurements for update using (status <> 'validated') with check (true); end if;

  if not exists (select 1 from pg_policies where tablename='pq_audit_logs' and policyname='log_read') then
    create policy log_read  on public.pq_audit_logs for select using (true); end if;
  if not exists (select 1 from pg_policies where tablename='pq_audit_logs' and policyname='log_write') then
    create policy log_write on public.pq_audit_logs for insert with check (true); end if;
end $$;

-- ---------- Amorçage du référentiel (placeholders, contenu officiel NON reproduit) ----------
insert into public.pq_instruments (code,name,domain,population,source,owner,license_required,license_status)
values
 ('HONOS','HoNOS','PSY','Adulte','ANQ','Détenteur des droits',true,'à vérifier'),
 ('BSCL','BSCL','PSY','Adulte','ANQ','Détenteur des droits',true,'à vérifier'),
 ('HONOSCA','HoNOSCA','PSY','Enfant/ado','ANQ','Détenteur des droits',true,'à vérifier'),
 ('HONOSCA_SR','HoNOSCA-SR','PSY','Enfant/ado','ANQ','Détenteur des droits',true,'à vérifier'),
 ('EFM','EFM (mesures limitatives de liberté)','PSY','Adulte/PEA','ANQ','ANQ',false,'à vérifier'),
 ('EBI','EBI','REA','Selon périmètre','ANQ','ANQ',false,'à vérifier'),
 ('FIM_MIF','FIM/MIF','REA','Selon périmètre','ANQ','Détenteur des droits',true,'à vérifier'),
 ('CIRS','CIRS','REA','Selon périmètre','ANQ','ANQ',false,'à vérifier'),
 ('PQ_DOULEUR','Échelle douleur (interne)','DOU','Tous','Interne','Établissement',false,'libre'),
 ('PQ_PREM','PREMs (interne)','EXP','Tous','Interne','Établissement',false,'libre')
on conflict (code) do nothing;

-- Les versions/items officiels doivent être insérés à partir des documents
-- autorisés. Exemple de structure attendue pour la colonne items :
--   [{"code":"HONOS_01","label":"...","type":"scale","required":true,
--     "min_value":0,"max_value":4,"order":1}]
-- et pour rule : {"type":"SUM","unit":"points","max":48}

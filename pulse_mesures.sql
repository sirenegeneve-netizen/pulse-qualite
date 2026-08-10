-- =====================================================================
-- PULSE QUALITÉ — Socle « Mesures & indicateurs » (Sprint 1 à 4)
-- À exécuter dans Supabase → SQL Editor.
-- Le fichier index.html bascule automatiquement en base dès que ces
-- tables existent (sinon il fonctionne en mode démo local).
-- =====================================================================

create extension if not exists "pgcrypto";

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

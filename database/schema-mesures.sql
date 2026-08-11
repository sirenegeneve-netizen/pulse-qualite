-- ============================================================
-- Pulse Qualité — Moteur de mesures & indicateurs (preuve de concept)
-- Fichier ADDITIF : n'affecte aucune table existante.
-- À exécuter dans le même projet Supabase que schema.sql.
-- ============================================================
--
-- IMPORTANT — à lire avant d'utiliser ce module :
-- Ceci est un moteur GÉNÉRIQUE de démonstration, pas une intégration
-- ANQ officielle. L'instrument fourni en exemple est fictif. Les vrais
-- instruments (HoNOS, BSCL, HoNOSCA, EFM, EBI, FIM/MIF, CIRS) sont sous
-- licence ANQ et ne peuvent pas être recréés sans les documents sources
-- officiels autorisés. Voir docs/PLAN-MESURES-INDICATEURS.md.
-- ============================================================

drop table if exists pq_measurement_answers cascade;
drop table if exists pq_measurements cascade;
drop table if exists pq_instrument_items cascade;
drop table if exists pq_instruments cascade;

-- Référentiel des instruments de mesure
create table pq_instruments (
  id bigint generated always as identity primary key,
  code text not null unique,          -- ex: 'EXEMPLE'
  name text not null,
  domain text,                        -- ex: 'Démonstration'
  is_example boolean default true,    -- true = fictif, pas un instrument ANQ officiel
  active boolean default true,
  created_at timestamptz default now()
);

-- Items (questions) d'un instrument — structure générique, pas de code
-- spécifique par instrument dans l'application.
create table pq_instrument_items (
  id bigint generated always as identity primary key,
  instrument_id bigint references pq_instruments(id) on delete cascade,
  code text not null,                 -- ex: 'item_01'
  label text not null,
  min_value int default 0,
  max_value int default 4,
  order_index int default 0
);

-- Une mesure réalisée
create table pq_measurements (
  id bigint generated always as identity primary key,
  reference text unique,              -- généré après insertion : PQ-26-EXEMPLE-000001
  instrument_id bigint references pq_instruments(id),
  service_nom text,
  moment text default 'suivi' check (moment in ('admission','sortie','suivi','evenement')),
  statut text default 'validated' check (statut in ('draft','completed','validated')),
  score_brut numeric,
  score_max numeric,
  created_by text default 'Utilisateur démonstration',
  created_at timestamptz default now(),
  validated_at timestamptz
);

-- Réponses à une mesure — traçabilité : chaque score remonte à ses réponses sources
create table pq_measurement_answers (
  id bigint generated always as identity primary key,
  measurement_id bigint references pq_measurements(id) on delete cascade,
  item_id bigint references pq_instrument_items(id),
  value_numeric numeric,
  created_at timestamptz default now()
);

alter table pq_instruments enable row level security;
alter table pq_instrument_items enable row level security;
alter table pq_measurements enable row level security;
alter table pq_measurement_answers enable row level security;

create policy "public read/write pq_instruments" on pq_instruments for all using (true) with check (true);
create policy "public read/write pq_instrument_items" on pq_instrument_items for all using (true) with check (true);
create policy "public read/write pq_measurements" on pq_measurements for all using (true) with check (true);
create policy "public read/write pq_measurement_answers" on pq_measurement_answers for all using (true) with check (true);

-- ============================================================
-- Instrument d'exemple — FICTIF, à but de démonstration du moteur uniquement
-- ============================================================
insert into pq_instruments (code, name, domain, is_example) values
('EXEMPLE', 'Évaluation simplifiée (démonstration)', 'Démonstration', true);

insert into pq_instrument_items (instrument_id, code, label, min_value, max_value, order_index) values
(1, 'item_01', 'Autonomie dans les gestes du quotidien', 0, 4, 1),
(1, 'item_02', 'Douleur ressentie', 0, 4, 2),
(1, 'item_03', 'Compréhension des consignes données', 0, 4, 3);

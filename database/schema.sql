-- ============================================================
-- Pulse Qualité — schéma de base de données (Supabase / PostgreSQL)
-- À exécuter une seule fois dans l'éditeur SQL de Supabase
-- ============================================================

-- Services / équipes de l'hôpital, avec statut couleur
create table services (
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
create table indicateurs (
  id bigint generated always as identity primary key,
  categorie text not null,          -- ex: 'ANQ', 'IQSS', 'Infections', 'Chutes', 'Escarres', 'Douleur', 'Satisfaction', 'Réclamations'
  libelle text not null,
  valeur text not null,
  unite text,
  tendance text,                     -- ex: '▲ 3 pts vs T-1'
  tendance_type text check (tendance_type in ('bonne','mauvaise','stable')),
  updated_at timestamptz default now()
);

-- Gestion des risques : événements indésirables, presque accidents, CAPA
create table evenements (
  id bigint generated always as identity primary key,
  description text not null,
  service text not null,
  type text not null default 'indesirable', -- 'indesirable' | 'presque_accident'
  gravite text not null check (gravite in ('green','orange','red')),
  statut text default 'Suivi standard',      -- ex: 'ALARM en cours', 'REMED planifiée', 'CAPA clôturée'
  created_at timestamptz default now()
);

-- Audits : planification, checklist, statut
create table audits (
  id bigint generated always as identity primary key,
  titre text not null,
  service text,
  date_prevue date,
  statut text default 'Planifié' check (statut in ('Planifié','En cours','Terminé')),
  progression int default 0,          -- % de la checklist validé
  created_at timestamptz default now()
);

-- Voix du patient : satisfaction, compliments, plaintes, idées, témoignages
create table voix_patient (
  id bigint generated always as identity primary key,
  type text not null check (type in ('satisfaction','compliment','plainte','idee','temoignage')),
  contenu text not null,
  service text,
  statut text,                        -- pour les plaintes : 'En traitement' / 'Résolue'
  created_at timestamptz default now()
);

-- Boîte à idées
create table idees (
  id bigint generated always as identity primary key,
  titre text not null,
  auteur text default 'Anonyme',
  votes int default 1,
  created_at timestamptz default now()
);

-- Les réussites
create table reussites (
  id bigint generated always as identity primary key,
  icone text default '🎉',
  titre text not null,
  description text,
  created_at timestamptz default now()
);

-- ============================================================
-- Sécurité : pas de comptes utilisateurs pour l'instant (voir ROADMAP.md,
-- Phase 2). On autorise la lecture/écriture publique via la clé "anon"
-- pour que la démo fonctionne sans backend supplémentaire.
-- ============================================================
alter table services enable row level security;
alter table indicateurs enable row level security;
alter table evenements enable row level security;
alter table audits enable row level security;
alter table voix_patient enable row level security;
alter table idees enable row level security;
alter table reussites enable row level security;

create policy "public read/write services" on services for all using (true) with check (true);
create policy "public read/write indicateurs" on indicateurs for all using (true) with check (true);
create policy "public read/write evenements" on evenements for all using (true) with check (true);
create policy "public read/write audits" on audits for all using (true) with check (true);
create policy "public read/write voix_patient" on voix_patient for all using (true) with check (true);
create policy "public read/write idees" on idees for all using (true) with check (true);
create policy "public read/write reussites" on reussites for all using (true) with check (true);

-- ============================================================
-- Données de départ
-- ============================================================

insert into services (id, nom, statut, satisfaction, indicateurs, actions, audits, formations, evenements) values
('urgences','Urgences','orange','88%','Délai d''attente moyen : 42 min (+18)','3 en cours','1 audit en cours','Formation triage — 80%','1 événement cette semaine'),
('chirurgie','Chirurgie','red','90%','Taux d''infection post-op : 1.4%','5 en cours','Audit hygiène bloc en cours','Formation identitovigilance — 60%','1 ALARM en cours'),
('maternite','Maternité','green','98%','Chutes : 0','1 en cours','Aucun audit en cours','À jour','120 jours sans chute'),
('geriatrie','Gériatrie','green','95%','Chutes : 0.5 / 1000 j','2 en cours','Audit dossier patient prévu','Formation douleur — 100%','Aucun événement'),
('pediatrie','Pédiatrie','green','97%','Satisfaction : 97%','0 en cours','Aucun audit en cours','À jour','Aucun événement'),
('medecine-interne','Médecine interne','orange','91%','Escarres : 2.1%','4 en cours','Audit prévention escarres prévu','Formation prévention — 45%','2 presque accidents'),
('bloc','Bloc opératoire','green','—','Checklist : 100%','0 en cours','—','—','Aucun'),
('pharmacie','Pharmacie','green','—','Ruptures : 1 en cours','1 en cours','—','—','0 ce mois');

insert into indicateurs (categorie, libelle, valeur, unite, tendance, tendance_type) values
('ANQ','Indicateurs ANQ','87','/100','▲ 3 pts vs T-1','bonne'),
('IQSS','IQSS','A','classe','= stable','stable'),
('Infections','Infections associées aux soins','0.8','%','▼ 0.2 pt','bonne'),
('Chutes','Chutes','3','/1000 j.','▲ 1 vs mois dernier','mauvaise'),
('Escarres','Escarres','1.2','%','▼ 0.4 pt','bonne'),
('Douleur','Douleur maîtrisée','91','%','= stable','stable'),
('Satisfaction','Satisfaction globale','96','%','▲ 2 pts','bonne'),
('Réclamations','Réclamations','14','ce mois','▼ 5','bonne');

insert into evenements (description, service, type, gravite, statut) values
('Erreur d''identitovigilance','Chirurgie','indesirable','red','ALARM en cours'),
('Chute avec conséquence mineure','Gériatrie','indesirable','orange','REMED planifiée'),
('Presque accident médicamenteux','Pharmacie','presque_accident','green','CAPA clôturée');

insert into audits (titre, service, date_prevue, statut, progression) values
('Circuit du médicament','Pharmacie','2026-08-12','Planifié',0),
('Hygiène des mains — Urgences','Urgences','2026-08-19','Planifié',0),
('Dossier patient informatisé','Direction','2026-08-26','Planifié',0),
('Hygiène — Bloc opératoire','Bloc opératoire',null,'En cours',78);

insert into voix_patient (type, contenu, service, statut) values
('compliment','Personnel très à l''écoute en Pédiatrie','Pédiatrie',null),
('compliment','Prise en charge rapide aux Urgences','Urgences',null),
('compliment','Merci à l''équipe de nuit en Chirurgie','Chirurgie',null),
('plainte','Temps d''attente jugé trop long','Urgences','En traitement'),
('plainte','Erreur de facturation','Administration','Résolue'),
('temoignage','Trois semaines d''hospitalisation, et jamais je ne me suis sentie seule. L''équipe de Gériatrie a un vrai sens de l''humain.','Gériatrie',null);

insert into idees (titre, auteur, votes) values
('Écrans d''attente avec temps estimé aux Urgences','Équipe Urgences',34),
('Chariot de soins avec check-list intégrée','Équipe Chirurgie',27),
('Application mobile pour signaler un événement en 1 clic','Direction qualité',21),
('Salle de repos dédiée pour les familles en Gériatrie','Équipe Gériatrie',15);

insert into reussites (icone, titre, description) values
('🛡️','120','jours sans chute — Maternité'),
('🏆','Gériatrie','Service du mois'),
('✅','Circuit du médicament','Projet terminé'),
('👏','Bloc opératoire','Bravo sécurité'),
('💌','17','compliments patients aujourd''hui'),
('🎯','96 %','objectif satisfaction atteint');

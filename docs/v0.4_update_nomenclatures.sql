BEGIN;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.003'),
	definition_default = 'Établir un bilan stationnel après visite des stations et déduire du résultat de ce bilan des actions de conservations si nécessaire.',
	definition_fr = 'Établir un bilan stationnel après visite des stations et déduire du résultat de ce bilan des actions de conservations si nécessaire.'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','rbs');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	label_default = 'Diffuser la fiche bilan stationnel',
	label_fr = 'Diffuser la fiche bilan stationnel',
	definition_default = 'Diffuser le bilan stationnel auprès des collectivités (mairies, communautés de communes...), partenaires/gestionnaires, usagers...',
	mnemonique = 'diffuserFicheBilanStationnel',
	definition_fr = 'Diffuser le bilan stationnel auprès des collectivités (mairies, communautés de communes...), partenaires/gestionnaires, usagers...',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.005'),
	cd_nomenclature = 'dfbs'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','dbs');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Mettre en place un suivi dans le but de connaître la dynamique de l''espèce et de l''habitat sur un site donné et en réponse à une problématique (ex : la population est-elle en bon état ? Le nombre d''individus est-il croissant ? Quelle est l''influence du pâturage ? ...).',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.008'),
	definition_default = 'Mettre en place un suivi dans le but de connaître la dynamique de l''espèce et de l''habitat sur un site donné et en réponse à une problématique (ex : la population est-elle en bon état ? Le nombre d''individus est-il croissant ? Quelle est l''influence du pâturage ? ...).',
	label_default = 'Réaliser un suivi station',
	label_fr = 'Réaliser un suivi station'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','rss');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	label_default = 'Réaliser un suivi territoire',
	definition_default = 'Mettre en place un suivi à grande échelle dont le protocole est identique sur toutes les stations dans le but de connaître la dynamique de l''espèce sur l''ensemble du territoire sur lequel elle est prioritaire.',
	label_fr = 'Réaliser un suivi territoire',
	definition_fr = 'Mettre en place un suivi à grande échelle dont le protocole est identique sur toutes les stations dans le but de connaître la dynamique de l''espèce sur l''ensemble du territoire sur lequel elle est prioritaire.',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.007')
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','rst');

DELETE
FROM
	ref_nomenclatures.t_nomenclatures
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','rsa');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Mettre en place une stratégie de maîtrise foncière (animer ou acquérir) en collaboration avec les CEN dans le but de limiter les menaces ou d''établir une gestion favorable à l''espèce.',
	label_default = 'Maîtriser foncièrement',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.010'),
	label_fr = 'Maîtriser foncièrement',
	definition_default = 'Mettre en place une stratégie de maîtrise foncière (animer ou acquérir) en collaboration avec les CEN dans le but de limiter les menaces ou d''établir une gestion favorable à l''espèce.'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','mf');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	cd_nomenclature = 'ilr',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.011'),
	definition_default = 'Intégrer l''espèce dans les listes de protections départementales, régionales ou nationales.',
	label_default = 'Inscrire l''espèce sur une liste réglementaire',
	mnemonique = 'inscrireListeReglementaire',
	label_fr = 'Inscrire l''espèce sur une liste réglementaire',
	definition_fr = 'Intégrer l''espèce dans les listes de protections départementales, régionales ou nationales.'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','pr');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Informer les acteurs locaux et/ou les services de l''état de la présence de l''espèce.',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.021'),
	definition_default = 'Informer les acteurs locaux et/ou les services de l''état de la présence de l''espèce.'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','pac');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Échanger avec les acteurs locaux (associations, communes...).',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.020'),
	mnemonique = 'animer',
	label_default = 'Animer/sensibiliser/concerter',
	cd_nomenclature = 'a',
	label_fr = 'Animer/sensibiliser/concerter',
	definition_default = 'Échanger avec les acteurs locaux (associations, communes...).'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','s');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Définir et mettre en place une gestion adaptée à l''espèce et au milieu (Préciser : fauche, fauche tardive, gestion pastorale, remise en eau, mise en défens, ouverture du milieu...), en concertation avec gestionnaire et propriétaire.',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.013'),
	label_default = 'Établir des mesures de gestion',
	label_fr = 'Établir des mesures de gestion',
	definition_default = 'Définir et mettre en place une gestion adaptée à l''espèce et au milieu (Préciser : fauche, fauche tardive, gestion pastorale, remise en eau, mise en défens, ouverture du milieu...), en concertation avec gestionnaire et propriétaire.'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','emg');

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Rédiger une fiche bilan stationnel pour renseigner les actions à mener.',
	"hierarchy" = CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.004'),
	label_default = 'Réaliser une fiche bilan stationnel',
	label_fr = 'Réaliser une fiche bilan stationnel',
	definition_default = 'Rédiger une fiche bilan stationnel pour renseigner les actions à mener.'
WHERE
	id_nomenclature = ref_nomenclatures.get_id_nomenclature('CS_ACTION','rfbs');

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'con',
    'controler',
    'Contrôler à 10-15 ans',
    'Vérifier l''état de conservation des stations 10 à 15 ans après l''édition de la fiche bilan stationnel.',
    'Contrôler à 10-15 ans',
    'Vérifier l''état de conservation des stations 10 à 15 ans après l''édition de la fiche bilan stationnel.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.001'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'sm',
    'surveillerMenace',
    'Surveiller les menaces',
    'Vérifier régulièrement l''évolution des menaces, par exemple si des menaces qualifiées de potentielles se sont transformées en menaces imminentes.',
    'Surveiller les menaces',
    'Vérifier régulièrement l''évolution des menaces, par exemple si des menaces qualifiées de potentielles se sont transformées en menaces imminentes.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.002'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'rprc',
    'realiserProspectionCible',
    'Réaliser des prospections ciblées',
    'Prospecter des zones choisies en capitalisant les informations disponibles sur le taxon (stations historiques, écologie...) dans le but de retrouver d''anciennes stations voire d''en découvrir de nouvelles.',
    'Réaliser des prospections ciblées',
    'Prospecter des zones choisies en capitalisant les informations disponibles sur le taxon (stations historiques, écologie...) dans le but de retrouver d''anciennes stations voire d''en découvrir de nouvelles.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.006'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'rsic',
    'realiserSuiviIndividuCentre',
    'Réaliser un suivi individu-centré',
    'Mettre en place un suivi visant à étudier uniquement la dynamique de l''espèce cible à fine échelle (lorsque la station compte peu d''individus ou lorsque l''on s''intéresse aux paramètres phénologiques du taxon).',
    'Réaliser un suivi individu-centré',
    'Mettre en place un suivi visant à étudier uniquement la dynamique de l''espèce cible à fine échelle (lorsque la station compte peu d''individus ou lorsque l''on s''intéresse aux paramètres phénologiques du taxon).',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.009'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'rrs',
    'realiserReglementationSite',
    'Réaliser une réglementation du(des) site(s)',
    'Intégrer le site dans les démarches de classement d''espaces protégés (APPB, APHN, ENS...).',
    'Réaliser une réglementation du(des) site(s)',
    'Intégrer le site dans les démarches de classement d''espaces protégés (APPB, APHN, ENS...).',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.012'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'rpc',
    'redigerPlanConservation',
    'Rédiger et mettre en place un plan de conservation',
    'Rédiger et mettre en place un plan de conservation, dirigé par un comité de pilotage, en déterminant et organisant dans le temps plusieurs actions (connaissance/conservation/communication) en faveur de l''espèce.',
    'Rédiger et mettre en place un plan de conservation',
    'Rédiger et mettre en place un plan de conservation, dirigé par un comité de pilotage, en déterminant et organisant dans le temps plusieurs actions (connaissance/conservation/communication) en faveur de l''espèce.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.014'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'rg',
    'recolterGraines',
    'Récolter des graines',
    'Récolter des graines pour stockage ex situ en banque de semences à moyen ou long terme, ou pour mise en culture.',
    'Récolter des graines',
    'Récolter des graines pour stockage ex situ en banque de semences à moyen ou long terme, ou pour mise en culture.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.015'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'cjc',
    'cultiverJardinConservatoire',
    'Mettre en culture en jardin conservatoire',
    'Mettre en culture l''espèce à partir d''organes de dissémination nouvellement récoltés ou issus de banque de semences dans un but de multiplication ou d''étude.',
    'Mettre en culture en jardin conservatoire',
    'Mettre en culture l''espèce à partir d''organes de dissémination nouvellement récoltés ou issus de banque de semences dans un but de multiplication ou d''étude.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.016'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'rp',
    'renforcerPopulation',
    'Renforcer la population/réintroduire',
    'Renforcer la population existante ou réintroduire l''espèce (sous réserve d''un site toujours favorable) avec des plants ou des organes de dissémination.',
    'Renforcer la population/réintroduire',
    'Renforcer la population existante ou réintroduire l''espèce (sous réserve d''un site toujours favorable) avec des plants ou des organes de dissémination.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.017'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'i',
    'introduire',
    'Introduire',
    'Introduire l''espèce sur une site favorable où elle n''a jamais été observée, avec des plants ou des organes de dissémination.',
    'Introduire',
    'Introduire l''espèce sur une site favorable où elle n''a jamais été observée, avec des plants ou des organes de dissémination.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.018'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    't',
    'transloquer',
    'Transloquer',
    'Déplacer l''espèce depuis un site sur un autre site où elle était présente.',
    'Transloquer',
    'Déplacer l''espèce depuis un site sur un autre site où elle était présente.',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.019'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'med',
    'mettreEnDefens',
    'Mettre en défens',
    'Procéder à la mise en défens de certaines populations particulièrement menacées',
    'Mettre en défens',
    'Procéder à la mise en défens de certaines populations particulièrement menacées',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.022'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'mpr',
    'realiserProtocolesRecherche',
    'Réaliser des protocoles de recherche',
    'Mettre en place des protocoles et expérimentations en biologie de la conservation, en partenariat avec les laboratoires de recherche',
    'Réaliser des protocoles de recherche',
    'Mettre en place des protocoles et expérimentations en biologie de la conservation, en partenariat avec les laboratoires de recherche',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.023'),
    TRUE
    );

INSERT INTO ref_nomenclatures.t_nomenclatures (
    id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	active
    )
VALUES (
    ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'),
    'pag',
    'procederAnalyseGenetique',
    'Procéder à des analyses génétiques',
    'Procéder à des analyses génétiques',
    'Procéder à des analyses génétiques',
    'Procéder à des analyses génétiques',
    0,
    CONCAT(ref_nomenclatures.get_id_nomenclature_type('CS_ACTION'), '.024'),
    TRUE
    );

COMMIT;

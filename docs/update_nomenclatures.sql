UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	"hierarchy" = '137.003',
	definition_default = 'Établir un bilan stationnel après visite des stations et déduire du résultat de ce bilan des actions de conservations si nécessaire.',
	definition_fr = 'Établir un bilan stationnel après visite des stations et déduire du résultat de ce bilan des actions de conservations si nécessaire.'
WHERE
	id_nomenclature = 677;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	label_default = 'Diffuser la fiche bilan stationnel'
	label_fr = 'Diffuser la fiche bilan stationnel',
	definition_default = 'Diffuser le bilan stationnel auprès des collectivités (mairies, communautés de communes...), partenaires/gestionnaires, usagers...',
	mnemonique = 'diffuserFicheBilanStationnel',
	definition_fr = 'Diffuser le bilan stationnel auprès des collectivités (mairies, communautés de communes...), partenaires/gestionnaires, usagers...',
	"hierarchy" = '137.005',
	cd_nomenclature = 'dfbs'
WHERE
	id_nomenclature = 678;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Mettre en place un suivi dans le but de connaître la dynamique de l''espèce et de l''habitat sur un site donné et en réponse à une problématique (ex : la population est-elle en bon état ? Le nombre d''individus est-il croissant ? Quelle est l''influence du pâturage ? ...).',
	"hierarchy" = '137.008',
	definition_default = 'Mettre en place un suivi dans le but de connaître la dynamique de l''espèce et de l''habitat sur un site donné et en réponse à une problématique (ex : la population est-elle en bon état ? Le nombre d''individus est-il croissant ? Quelle est l''influence du pâturage ? ...).',
	label_default = 'Réaliser un suivi station',
	label_fr = 'Réaliser un suivi station'
WHERE
	id_nomenclature = 679;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	label_default = 'Réaliser un suivi territoire',
	definition_default = 'Mettre en place un suivi à grande échelle dont le protocole est identique sur toutes les stations dans le but de connaître la dynamique de l''espèce sur l''ensemble du territoire sur lequel elle est prioritaire.',
	label_fr = 'Réaliser un suivi territoire',
	definition_fr = 'Mettre en place un suivi à grande échelle dont le protocole est identique sur toutes les stations dans le but de connaître la dynamique de l''espèce sur l''ensemble du territoire sur lequel elle est prioritaire.',
	"hierarchy" = '137.007'
WHERE
	id_nomenclature = 680;

DELETE
FROM
	ref_nomenclatures.t_nomenclatures
WHERE
	id_nomenclature = 681;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Mettre en place une stratégie de maîtrise foncière (animer ou acquérir) en collaboration avec les CEN dans le but de limiter les menaces ou d''établir une gestion favorable à l''espèce.',
	label_default = 'Maîtriser foncièrement',
	"hierarchy" = '137.010',
	label_fr = 'Maîtriser foncièrement',
	definition_default = 'Mettre en place une stratégie de maîtrise foncière (animer ou acquérir) en collaboration avec les CEN dans le but de limiter les menaces ou d''établir une gestion favorable à l''espèce.'
WHERE
	id_nomenclature = 682;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	cd_nomenclature = 'ilr',
	"hierarchy" = '137.011',
	definition_default = 'Intégrer l''espèce dans les listes de protections départementales, régionales ou nationales.',
	label_default = 'Inscrire l''espèce sur une liste réglementaire',
	mnemonique = 'inscrireListeReglementaire',
	label_fr = 'Inscrire l''espèce sur une liste réglementaire',
	definition_fr = 'Intégrer l''espèce dans les listes de protections départementales, régionales ou nationales.'
WHERE
	id_nomenclature = 683;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Informer les acteurs locaux et/ou les services de l''état de la présence de l''espèce.',
	"hierarchy" = '137.021',
	definition_default = 'Informer les acteurs locaux et/ou les services de l''état de la présence de l''espèce.'
WHERE
	id_nomenclature = 684;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Échanger avec les acteurs locaux (associations, communes...).',
	"hierarchy" = '137.020',
	mnemonique = 'animer',
	label_default = 'Animer/sensibiliser/concerter',
	cd_nomenclature = 'a',
	label_fr = 'Animer/sensibiliser/concerter',
	definition_default = 'Échanger avec les acteurs locaux (associations, communes...).'
WHERE
	id_nomenclature = 685;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Définir et mettre en place une gestion adaptée à l''espèce et au milieu (Préciser : fauche, fauche tardive, gestion pastorale, remise en eau, mise en défens, ouverture du milieu...), en concertation avec gestionnaire et propriétaire.',
	"hierarchy" = '137.013',
	label_default = 'Établir des mesures de gestion',
	label_fr = 'Établir des mesures de gestion',
	definition_default = 'Définir et mettre en place une gestion adaptée à l''espèce et au milieu (Préciser : fauche, fauche tardive, gestion pastorale, remise en eau, mise en défens, ouverture du milieu...), en concertation avec gestionnaire et propriétaire.'
WHERE
	id_nomenclature = 686;

UPDATE
	ref_nomenclatures.t_nomenclatures
SET
	definition_fr = 'Rédiger une fiche bilan stationnel pour renseigner les actions à mener.',
	"hierarchy" = '137.004',
	label_default = 'Réaliser une fiche bilan stationnel',
	label_fr = 'Réaliser une fiche bilan stationnel',
	definition_default = 'Rédiger une fiche bilan stationnel pour renseigner les actions à mener.'
WHERE
	id_nomenclature = 799;

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'con',
'controler',
'Contrôler à 10-15 ans',
'Vérifier l''état de conservation des stations 10 à 15 ans après l''édition de la fiche bilan stationnel.',
'Contrôler à 10-15 ans',
'Vérifier l''état de conservation des stations 10 à 15 ans après l''édition de la fiche bilan stationnel.',
0,
'137.001',
'2021-12-15 20:36:21.347',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'sm',
'surveillerMenace',
'Surveiller les menaces',
'Vérifier régulièrement l''évolution des menaces, par exemple si des menaces qualifiées de potentielles se sont transformées en menaces imminentes.',
'Surveiller les menaces',
'Vérifier régulièrement l''évolution des menaces, par exemple si des menaces qualifiées de potentielles se sont transformées en menaces imminentes.',
0,
'137.002',
'2023-01-06 17:07:15.985',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'rprc',
'realiserProspectionCible',
'Réaliser des prospections ciblées',
'Prospecter des zones choisies en capitalisant les informations disponibles sur le taxon (stations historiques, écologie...) dans le but de retrouver d''anciennes stations voire d''en découvrir de nouvelles.',
'Réaliser des prospections ciblées',
'Prospecter des zones choisies en capitalisant les informations disponibles sur le taxon (stations historiques, écologie...) dans le but de retrouver d''anciennes stations voire d''en découvrir de nouvelles.',
0,
'137.006',
'2023-01-06 17:25:35.808',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'rsic',
'realiserSuiviIndividuCentre',
'Réaliser un suivi individu-centré',
'Mettre en place un suivi visant à étudier uniquement la dynamique de l''espèce cible à fine échelle (lorsque la station compte peu d''individus ou lorsque l''on s''intéresse aux paramètres phénologiques du taxon).',
'Réaliser un suivi individu-centré',
'Mettre en place un suivi visant à étudier uniquement la dynamique de l''espèce cible à fine échelle (lorsque la station compte peu d''individus ou lorsque l''on s''intéresse aux paramètres phénologiques du taxon).',
0,
'137.009',
'2023-01-06 17:30:55.503',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'rrs',
'realiserReglementationSite',
'Réaliser une réglementation du(des) site(s)',
'Intégrer le site dans les démarches de classement d''espaces protégés (APPB, APHN, ENS...).',
'Réaliser une réglementation du(des) site(s)',
'Intégrer le site dans les démarches de classement d''espaces protégés (APPB, APHN, ENS...).',
0,
'137.012',
'2023-01-06 17:31:53.399',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'rpc',
'redigerPlanConservation',
'Rédiger et mettre en place un plan de conservation',
'Rédiger et mettre en place un plan de conservation, dirigé par un comité de pilotage, en déterminant et organisant dans le temps plusieurs actions (connaissance/conservation/communication) en faveur de l''espèce.',
'Rédiger et mettre en place un plan de conservation',
'Rédiger et mettre en place un plan de conservation, dirigé par un comité de pilotage, en déterminant et organisant dans le temps plusieurs actions (connaissance/conservation/communication) en faveur de l''espèce.',
0,
'137.014',
'2023-01-06 17:32:35.674',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'rg',
'recolterGraines',
'Récolter des graines',
'Récolter des graines pour stockage ex situ en banque de semences à moyen ou long terme, ou pour mise en culture.',
'Récolter des graines',
'Récolter des graines pour stockage ex situ en banque de semences à moyen ou long terme, ou pour mise en culture.',
0,
'137.015',
'2023-01-06 17:33:31.724',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'cjc',
'cultiverJardinConservatoire',
'Mettre en culture en jardin conservatoire',
'Mettre en culture l''espèce à partir d''organes de dissémination nouvellement récoltés ou issus de banque de semences dans un but de multiplication ou d''étude.',
'Mettre en culture en jardin conservatoire',
'Mettre en culture l''espèce à partir d''organes de dissémination nouvellement récoltés ou issus de banque de semences dans un but de multiplication ou d''étude.',
0,
'137.016',
'2023-01-06 17:34:27.981',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'rp',
'renforcerPopulation',
'Renforcer la population/réintroduire',
'Renforcer la population existante ou réintroduire l''espèce (sous réserve d''un site toujours favorable) avec des plants ou des organes de dissémination.',
'Renforcer la population/réintroduire',
'Renforcer la population existante ou réintroduire l''espèce (sous réserve d''un site toujours favorable) avec des plants ou des organes de dissémination.',
0,
'137.017',
'2023-01-06 17:35:07.929',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'i',
'introduire',
'Introduire',
'Introduire l''espèce sur une site favorable où elle n''a jamais été observée, avec des plants ou des organes de dissémination.',
'Introduire',
'Introduire l''espèce sur une site favorable où elle n''a jamais été observée, avec des plants ou des organes de dissémination.',
0,
'137.018',
'2023-01-06 17:39:55.057',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
't',
'transloquer',
'Transloquer',
'Déplacer l''espèce depuis un site sur un autre site où elle était présente.',
'Transloquer',
'Déplacer l''espèce depuis un site sur un autre site où elle était présente.',
0,
'137.019',
'2023-01-06 17:45:12.924',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'med',
'mettreEnDefens',
'Mettre en défens',
'Procéder à la mise en défens de certaines populations particulièrement menacées',
'Mettre en défens',
'Procéder à la mise en défens de certaines populations particulièrement menacées',
0,
'137.022',
'2023-01-06 17:49:16.053',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'mpr',
'realiserProtocolesRecherche',
'Réaliser des protocoles de recherche',
'Mettre en place des protocoles et expérimentations en biologie de la conservation, en partenariat avec les laboratoires de recherche',
'Réaliser des protocoles de recherche',
'Mettre en place des protocoles et expérimentations en biologie de la conservation, en partenariat avec les laboratoires de recherche',
0,
'137.023',
'2023-01-06 17:53:01.437',
'2023-01-06 14:44:40.738',
TRUE);

INSERT
	INTO
	ref_nomenclatures.t_nomenclatures (id_type,
	cd_nomenclature,
	mnemonique,
	label_default,
	definition_default,
	label_fr,
	definition_fr,
	id_broader,
	"hierarchy",
	meta_create_date,
	meta_update_date,
	active)
VALUES (137,
'pag',
'procederAnalyseGenetique',
'Procéder à des analyses génétiques',
'Procéder à des analyses génétiques',
'Procéder à des analyses génétiques',
'Procéder à des analyses génétiques',
0,
'137.024',
'2023-01-06 17:53:43.572',
'2023-01-06 14:44:40.738',
TRUE);

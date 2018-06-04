CREATE OR REPLACE VIEW informea_treaty_machine_name AS
  SELECT 
    nid,
    uuid,
    CASE 
      WHEN nid = 1 THEN 'cms'
      WHEN nid = 2 THEN 'aewa'
      WHEN nid = 3 THEN 'eurobats'
      WHEN nid = 4 THEN 'ascobans'
      WHEN nid = 5 THEN 'accobams'
      WHEN nid = 6 THEN 'wadden-sea-seals'
      WHEN nid = 7 THEN 'acap'
      WHEN nid = 8 THEN 'gorilla'
      WHEN nid = 9 THEN 'siberian-crane'
      WHEN nid = 10 THEN 'slender-billed-curlew'
      WHEN nid = 11 THEN 'middle-european-great-bustard'
      WHEN nid = 12 THEN 'atlantic-turtles'
      WHEN nid = 13 THEN 'iosea-marine-turtles'
      WHEN nid = 14 THEN 'bukhara-deer'
      WHEN nid = 15 THEN 'aquatic-warbler'
      WHEN nid = 16 THEN 'west-african-elephants'
      WHEN nid = 17 THEN 'saiga-antelope'
      WHEN nid = 18 THEN 'pacific-inslands-cetaceans'
      WHEN nid = 19 THEN 'ruddy-headed-goose'
      WHEN nid = 20 THEN 'southern-south-american-grassland-birds'  
      WHEN nid = 21 THEN 'monk-seal-atlantic'  
      WHEN nid = 22 THEN 'dugong'  
      WHEN nid = 23 THEN 'western-african-aquatic-mammals'  
      WHEN nid = 24 THEN 'birds-of-prey'
      WHEN nid = 25 THEN 'high-andean-flamingos'
      WHEN nid = 26 THEN 'sharks'
      WHEN nid = 27 THEN 'south-andean-huemul'
      WHEN nid = 28 THEN 'central-asian-mammals'  
      WHEN nid = 29 THEN 'sahelo-saharan-megafauna'  
      WHEN nid = 30 THEN 'central-asian-flyway'
    ELSE
      NULL 
    END treaty,
    title
  FROM node
  WHERE `type` = 'legal_instrument';

--
-- Document entity view
--
CREATE OR REPLACE VIEW informea_documents AS
  SELECT 
    1 schemaVersion,
    node.uuid id,
    CONVERT(field_publication_published_date_timestamp, DATE) AS published,
    FROM_UNIXTIME(node.changed) updated,
    treaty.treaty,
    REPLACE(thumbnails.uri, 'public://', 'http://www.cms.int/sites/default/files') thumbnailUrl,
    0 displayOrder,
    UPPER(ciso.field_country_iso3_value) country,
    node.nid
  FROM node node
    LEFT JOIN field_data_field_publication_published_date pdate ON node.nid = pdate.entity_id
    INNER JOIN field_data_field_instrument instr ON node.nid = instr.entity_id
    INNER JOIN informea_treaty_machine_name treaty ON treaty.nid = instr.field_instrument_target_id
    LEFT JOIN field_data_field_publication_image img ON node.nid = img.entity_id
    LEFT JOIN file_managed thumbnails ON field_publication_image_fid = thumbnails.fid
    LEFT JOIN field_data_field_country country ON country.entity_id = node.nid
    LEFT JOIN field_data_field_country_iso3 ciso ON country.field_country_target_id = ciso.entity_id
  WHERE
    treaty IS NOT NULL
   AND node.type = 'publication'
   GROUP BY node.nid;



--
-- Documents `type` navigation property
--
CREATE OR REPLACE VIEW informea_documents_types AS
  SELECT
    CONCAT(a.id, '-', 'publication') AS id,
    a.id document_id,
    'Publication' `value`
  FROM informea_documents a
  UNION
    SELECT
    CONCAT(a.id, '-', tb.tid) AS id,
    a.id document_id,
    CASE
      WHEN tb.tid = 1942 THEN 'Factsheet'
      WHEN tb.tid = 229 THEN 'Guidance'
    ELSE
      tb.name
    END `value`
  FROM informea_documents a
  INNER JOIN field_data_field_publication_type b ON a.nid = b.entity_id
  INNER JOIN taxonomy_term_data tb ON b.field_publication_type_tid = tb.tid
  WHERE tb.tid IN (1684, 1662, 1942, 229, 226, 224, 230, 223) ORDER BY document_id;

--
-- Documents `authors` navigation property
--
CREATE OR REPLACE VIEW informea_documents_authors AS
  SELECT
    CONCAT(a.nid, '-', tb.tid) id,
    a.id document_id,
    NULL `type`,
    tb.name
  FROM informea_documents a
  INNER JOIN field_data_field_publication_author b ON a.nid = b.entity_id
  INNER JOIN taxonomy_term_data tb ON tb.tid = b.field_publication_author_tid;

--
-- Documents `keywords` navigation property
--
CREATE OR REPLACE VIEW informea_documents_keywords AS
  SELECT
    NULL id,
    NULL document_id,
    NULL termURI,
    NULL scope,
    NULL literalForm,
    NULL sourceURL
  FROM DUAL;

--
-- Documents goals navigation property
--
CREATE OR REPLACE VIEW informea_documents_goals AS
  SELECT
    NULL id,
    NULL document_id,
    NULL source,
    NULL type,
    NULL identifier,
    NULL sourceURL
  FROM DUAL;

--
-- Documents `titles` navigation property
--
CREATE OR REPLACE VIEW informea_documents_titles AS
  SELECT
    CONCAT(a.nid, '-', CASE WHEN b.language = 'und' THEN 'en' ELSE b.language END) id,
    a.id document_id,
    CASE WHEN b.language = 'und' THEN 'en' ELSE b.language END `language`,
    b.title_field_value `value`
  FROM informea_documents a
    INNER JOIN field_data_title_field b ON a.nid = b.entity_id
  GROUP BY CONCAT(a.nid, '-', CASE WHEN b.language = 'und' THEN 'en' ELSE b.language END);

--
-- Documents `descriptions` navigation property
--
CREATE OR REPLACE VIEW informea_documents_descriptions AS
  SELECT
    CONCAT(a.id, '-', CASE WHEN b.language = 'und' THEN 'en' ELSE b.language END) AS id,
    a.id document_id,
    CASE WHEN b.language = 'und' THEN 'en' ELSE b.language END `language`,
    b.body_value `value`
  FROM informea_documents a
    INNER JOIN field_data_body b ON a.nid = b.entity_id
  GROUP BY CONCAT(a.id, '-', CASE WHEN b.language = 'und' THEN 'en' ELSE b.language END);

--
-- Documents `identifiers` navigation property
-- @todo
--
CREATE OR REPLACE VIEW informea_documents_identifiers AS
  SELECT
    NULL id,
    NULL document_id,
    NULL name,
    NULL value
  FROM DUAL;

--
-- Documents `files` navigation property
--
CREATE OR REPLACE VIEW informea_documents_files AS
  SELECT
    files.fid id,
    a.id document_id,
    REPLACE(files.uri, 'public://', 'http://www.cms.int/sites/default/files/') url,
    NULL content,
    files.filemime AS mimeType,
    CASE WHEN f.language = 'und' THEN 'en' ELSE f.language END `language`,
    files.filename
  FROM informea_documents a
    INNER JOIN field_data_field_publication_attachment f ON a.nid = f.entity_id
    INNER JOIN file_managed files ON f.field_publication_attachment_fid = files.fid
  GROUP BY files.fid;

--
-- Documents `tags` navigation property
-- @todo:
--
CREATE OR REPLACE VIEW informea_documents_tags AS
  SELECT
    NULL id,
    NULL document_id,
    NULL language,
    NULL scope,
    NULL value,
    NULL comment
  FROM DUAL;

--
-- Documents `referenceToEntities` navigation property
-- @todo:
--
CREATE or replace VIEW `informea_documents_references`
AS
  select   concat('meeting-', `a`.`nid`, '-', `bn`.`nid`) AS `id`, 'meeting' AS `type`, `a`.`id` AS `document_id`,
           NULL AS `refURI`
  from     (  (  `cms`.`informea_documents` `a`
    join
    `cms`.`field_data_field_publication_meeting` `b`
      on ((`a`.`nid` = `b`.`entity_id`)))
    join
    `cms`.`node` `bn`
      on (((`b`.`field_publication_meeting_target_id` = `bn`.`nid`) and (`bn`.`type` = 'meeting'))))
  group by `bn`.`nid`
  union
  select   concat('NationalPlans-', `a`.`nid`, '-', `bn`.`nid`) AS `id`, 'NationalPlans' AS `type`, `a`.`id` AS `document_id`,
           NULL AS `refURI`
  from     (  (  `cms`.`informea_documents` `a`
    join
    `cms`.`field_data_field_publication_plans` `b`
      on ((`a`.`nid` = `b`.`entity_id`)))
    join
    `cms`.`node` `bn`
      on (((`b`.`field_publication_plans_target_id` = `bn`.`nid`) and (`bn`.`type` = 'document'))))
  group by `bn`.`nid`
  union
  select   concat('CountryReports-', `a`.`nid`, '-', `bn`.`nid`) AS `id`, 'CountryReports' AS `type`, `a`.`id` AS `document_id`,
           NULL AS `refURI`
  from     (  (  `cms`.`informea_documents` `a`
    join
    `cms`.`field_data_field_publication_nat_report` `b`
      on ((`a`.`nid` = `b`.`entity_id`)))
    join
    `cms`.`node` `bn`
      on (((`b`.`field_publication_nat_report_target_id` = `bn`.`nid`) and (`bn`.`type` = 'document'))))
  group by `bn`.`nid`;
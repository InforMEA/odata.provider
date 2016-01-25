-- informea_treaties
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_treaties` AS
  SELECT
    c.field_odata_identifier_value AS id,
    a.uuid AS uuid,
    CONCAT('http://www.informea.org/treaties/', c.field_odata_identifier_value) AS url,
    url.field_treaty_website_url_url AS treatyWebsiteURL,
    a.title AS titleEnglish,
    d.field_official_name_value AS officialNameEnglish,
    FROM_UNIXTIME(a.changed) AS updated
  FROM
    `informea_drupal`.node a
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier c ON a.nid = c.entity_id
    LEFT JOIN `informea_drupal`.field_data_field_treaty_website_url url ON url.entity_id = a.nid
    -- INNER JOIN `informea_drupal`.field_data_field_data_source src ON src.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_official_name d  ON d.entity_id = a.nid
  WHERE
	-- src.field_data_source_tid = 815
	-- Do not publish 'special' treaties
	a.nid NOT IN (316, 302, 282, 301, 267)
    AND a.`TYPE` = 'treaty'
    AND a.`status` = 1
    GROUP BY a.nid;

-- informea_treaties_description
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_treaties_description` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS treaty_id,
    c.language AS `language`,
    c.body_value AS description
  FROM `informea_treaties` a
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier b ON a.id = b.field_odata_identifier_value
    INNER JOIN `informea_drupal`.field_data_body c ON c.entity_id = b.entity_id;

-- informea_treaties_title
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_treaties_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS treaty_id,
    c.language AS `language`,
    c.title_field_value AS title
  FROM `informea_treaties` a
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier b ON a.id = b.field_odata_identifier_value
    INNER JOIN `informea_drupal`.field_data_title_field c ON c.entity_id = b.entity_id;

-- informea_meetings
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_meetings` AS
  SELECT
    CAST(a.uuid AS CHAR) AS id,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid as treatyUUID,
    url.field_url_url AS url,
    d.event_calendar_date_value AS `start`,
    d.event_calendar_date_value2 AS `end`,
    t1.name AS `repetition`,
    t2.name AS `kind`,
    t3.name AS `type`,
    t4.name AS `access`,
    t5.name AS `status`,
    NULL AS imageUrl,
    NULL AS imageCopyright,
    loc.field_location_value AS location,
    city.field_city_value AS city,
    iso2.field_country_iso2_value AS country,
    lat.field_latitude_value AS latitude,
    lon.field_longitude_value AS longitude,
    FROM_UNIXTIME(a.changed) AS updated,
    a.nid AS nid
  FROM
    `informea_drupal`.node a
    INNER JOIN `informea_drupal`.field_data_field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    INNER JOIN `informea_drupal`.field_data_field_url url ON url.entity_id = a.nid
    INNER JOIN `informea_drupal`.field_data_event_calendar_date d ON d.entity_id = a.nid
    
    LEFT JOIN `informea_drupal`.field_data_field_event_repetition rep ON rep.entity_id = a.nid
    LEFT JOIN `informea_drupal`.taxonomy_term_data t1 ON rep.field_event_repetition_tid = t1.tid
    
    LEFT JOIN `informea_drupal`.field_data_field_event_kind k ON k.entity_id = a.nid
    LEFT JOIN `informea_drupal`.taxonomy_term_data t2 ON k.field_event_kind_tid = t2.tid
    
    LEFT JOIN `informea_drupal`.field_data_field_event_type et ON et.entity_id = a.nid
    LEFT JOIN `informea_drupal`.taxonomy_term_data t3 ON et.field_event_type_tid = t3.tid
    
    LEFT JOIN `informea_drupal`.field_data_field_event_access ac ON ac.entity_id = a.nid
    LEFT JOIN `informea_drupal`.taxonomy_term_data t4 ON ac.field_event_access_tid = t4.tid

    LEFT JOIN `informea_drupal`.field_data_field_event_calendar_status st ON st.entity_id = a.nid
    LEFT JOIN `informea_drupal`.taxonomy_term_data t5 ON st.field_event_calendar_status_tid = t5.tid

    LEFT JOIN `informea_drupal`.field_data_field_location loc ON loc.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_city city ON city.entity_id = a.nid

    INNER JOIN `informea_drupal`.field_data_field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_drupal`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_drupal`.field_data_field_country_iso2 iso2 ON nc.nid = iso2.entity_id

    LEFT JOIN `informea_drupal`.field_data_field_latitude lat ON lat.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_longitude lon ON lon.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_drupal`.node treaty ON b.entity_id = treaty.nid

  WHERE
    a.`type` = 'event_calendar'
    AND d.event_calendar_date_value IS NOT NULL
    -- Do not publish 'special' treaties
    AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
    AND a.status = 1
    AND treaty.status = 1
    GROUP BY a.nid;


-- informea_meetings_description
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_meetings_description` AS
  SELECT 
    CONCAT(CAST(a.id AS CHAR), '-', c.language) AS id, 
    CAST(a.id AS CHAR) AS meeting_id,
    c.language AS `language`,
    c.body_value AS description
  FROM `informea_meetings` a
    INNER JOIN `informea_drupal`.field_data_body c ON a.nid = c.entity_id;


-- informea_meetings_title
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_meetings_title` AS
  SELECT 
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id, 
    CAST(a.id AS CHAR) AS meeting_id,
    c.language AS `language`,
    c.title_field_value AS title
  FROM `informea_meetings` a 
    INNER JOIN `informea_drupal`.field_data_title_field c ON a.nid = c.entity_id;

-- DECISIONS 
-- informea_decisions
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_decisions` AS
  SELECT
    a.uuid AS id,
    IF (url.field_url_url IS NULL, concat('http://www.informea.org/node/' , a.nid), url.field_url_url) AS link,
    t1.name AS `type`,
    t2.name AS `status`,
    field_decision_number_value AS number,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    dp.field_decision_published_value AS published,
    n2.uuid AS meetingId,
    n2.title AS meetingTitle,
    urlm.field_url_url AS meetingUrl,
    FROM_UNIXTIME(a.changed) AS updated,
    a.nid AS nid
  FROM
    `informea_drupal`.node a
    INNER JOIN `informea_drupal`.field_data_field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier c ON b.field_treaty_target_id = c.entity_id

    LEFT JOIN `informea_drupal`.field_data_field_url url ON url.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_decision_type dt ON dt.entity_id = a.nid
    INNER JOIN `informea_drupal`.taxonomy_term_data t1 ON dt.field_decision_type_tid = t1.tid

    LEFT JOIN `informea_drupal`.field_data_field_decision_status ds ON ds.entity_id = a.nid
    INNER JOIN `informea_drupal`.taxonomy_term_data t2 ON ds.field_decision_status_tid = t2.tid

    INNER JOIN `informea_drupal`.field_data_field_decision_number dn ON dn.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_sorting_date dp ON dp.entity_id = a.nid

    INNER JOIN `informea_drupal`.field_data_field_meeting m ON m.entity_id = a.nid
    INNER JOIN `informea_drupal`.node n2 ON m.field_meeting_target_id = n2.nid

    LEFT JOIN `informea_drupal`.field_data_field_url urlm ON urlm.entity_id = m.field_meeting_target_id

    LEFT JOIN `informea_drupal`.field_data_field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_drupal`.node treaty ON b.entity_id = treaty.nid
  WHERE 
      a.`type` = 'decision'
      AND a.status = 1
      AND treaty.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
      GROUP BY a.nid;

-- informea_decisions_title
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_decisions_title` AS
  SELECT 
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id, 
    CAST(a.id AS CHAR) AS decision_id,
    c.language AS `language`,
    c.title_field_value AS title
  FROM `informea_decisions` a
    INNER JOIN `informea_drupal`.field_data_title_field c ON a.nid = c.entity_id;

-- informea_decisions_content
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_decisions_content` AS
  SELECT 
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id, 
    CAST(a.id AS CHAR) AS decision_id,
    c.language AS `language`,
    c.body_value AS content
  FROM `informea_decisions` a
    INNER JOIN `informea_drupal`.field_data_body c ON a.nid = c.entity_id
  WHERE c.body_value IS NOT NULL AND TRIM(c.body_value) <> '';

-- informea_decisions_documents
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_decisions_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid) AS id,
    a.id AS decision_id,
    fm.uri AS diskPath,
    IF (f.field_files_description IS NULL, CONCAT('http://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.`language` AS `language`,
    fm.filename AS filename
  FROM `informea_decisions` a
    INNER JOIN `informea_drupal`.field_data_field_files f ON f.entity_id = a.nid
    INNER JOIN `informea_drupal`.file_managed fm ON fm.fid = field_files_fid;

-- informea_decisions_keywords
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_decisions_keywords` AS
  SELECT 
    CAST(CONCAT(a.id, '-en') AS CHAR) AS id, 
    CAST(a.id AS CHAR) AS decision_id,
    'http://www.informea.org/terms/' AS namespace,
    t1.name AS term
  FROM `informea_decisions` a
    INNER JOIN `informea_drupal`.field_data_field_informea_tags c ON a.nid = c.entity_id
    INNER JOIN `informea_drupal`.taxonomy_term_data t1 ON c.field_informea_tags_tid = t1.tid;

-- informea_decisions_longtitle
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_decisions_longtitle` AS
  SELECT
    NULL AS id,
    NULL AS decision_id,
    NULL AS `language`,
    NULL AS long_title
  LIMIT 0;

-- informea_decisions_summary
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_decisions_summary` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    c.language AS `language`,
    c.body_summary AS summary
  FROM `informea_decisions` a
    INNER JOIN `informea_drupal`.field_data_body c ON a.nid = c.entity_id
  WHERE c.body_summary IS NOT NULL AND TRIM(c.body_summary) <> '';
  
-- COUNTRY REPORTS (National Reports)

-- informea_country_reports
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_country_reports` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    iso2.field_country_iso2_value AS country,
    sd.field_sorting_date_value AS submission,
    durl.field_document_url_url AS url,
    FROM_UNIXTIME(a.changed) AS updated,
    a.nid AS nid
  FROM
    `informea_drupal`.node a
    INNER JOIN `informea_drupal`.field_data_field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    LEFT JOIN `informea_drupal`.field_data_field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_drupal`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_drupal`.field_data_field_country_iso2 iso2 ON nc.nid = iso2.entity_id
    LEFT JOIN `informea_drupal`.field_data_field_sorting_date sd ON sd.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_document_url durl ON durl.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_drupal`.node treaty ON b.entity_id = treaty.nid
  WHERE 
      a.`type` = 'national_report'
      AND a.status = 1
      AND treaty.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
      GROUP BY a.nid;

-- informea_country_reports_title
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_country_reports_title` AS
  SELECT 
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id, 
    CAST(a.id AS CHAR) AS country_report_id,
    c.language AS `language`,
    c.title_field_value AS title
  FROM `informea_country_reports` a 
    INNER JOIN `informea_drupal`.field_data_title_field c ON a.nid = c.entity_id;

-- informea_country_reports_documents
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_country_reports_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid) AS id,
    a.id AS country_report_id,
    fm.uri AS diskPath,
    IF (f.field_files_description = '', CONCAT('http://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.`language` AS `language`,
    fm.filename AS filename
  FROM `informea_country_reports` a
    INNER JOIN `informea_drupal`.field_data_field_files f ON f.entity_id = a.nid
    INNER JOIN `informea_drupal`.file_managed fm ON fm.fid = field_files_fid;

-- NATIONAL PLANS (Action Plans)
-- informea_national_plans
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_national_plans` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    iso2.field_country_iso2_value AS country,
    sd.field_sorting_date_value AS submission,
    durl.field_document_url_url AS url,
    t1.name AS `type`,
    FROM_UNIXTIME(a.changed) AS updated,
    a.nid AS nid
  FROM
    `informea_drupal`.node a
    INNER JOIN `informea_drupal`.field_data_field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier c ON b.field_treaty_target_id = c.entity_id

    LEFT JOIN `informea_drupal`.field_data_field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_drupal`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_drupal`.field_data_field_country_iso2 iso2 ON nc.nid = iso2.entity_id

    LEFT JOIN `informea_drupal`.field_data_field_action_plan_type apt ON apt.entity_id = a.nid
    INNER JOIN `informea_drupal`.taxonomy_term_data t1 ON apt.field_action_plan_type_tid = t1.tid

    LEFT JOIN `informea_drupal`.field_data_field_sorting_date sd ON sd.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_document_url durl ON durl.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_drupal`.node treaty ON b.entity_id = treaty.nid
  WHERE 
    a.type = 'action_plan'
    AND a.status = 1
    AND treaty.status = 1
    -- Do not publish 'special' treaties
    AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
    GROUP BY a.nid;

-- informea_national_plans_title
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_national_plans_title` AS
  SELECT 
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id, 
    CAST(a.id AS CHAR) AS national_plan_id,
    c.language AS `language`,
    c.title_field_value AS title
  FROM `informea_national_plans` a
  INNER JOIN `informea_drupal`.field_data_title_field c ON a.nid = c.entity_id;

-- informea_national_plans_documents
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_national_plans_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid)  AS id,
    a.id AS national_plan_id,
    fm.uri AS diskPath,
    IF (f.field_files_description = '', CONCAT('http://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.`language` AS `language`,
    fm.filename AS filename
  FROM `informea_national_plans` a
    INNER JOIN `informea_drupal`.field_data_field_files f ON f.entity_id = a.nid
    INNER JOIN `informea_drupal`.file_managed fm ON fm.fid = field_files_fid;

-- CONTACTS (Focal Points)
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_contacts` AS
  SELECT
    a.uuid AS id,
    iso2.field_country_iso2_value AS country,
    prf.field_person_prefix_value AS prefix,
    fst.field_person_first_name_value AS firstName,
    lst.field_person_last_name_value AS lastName,
    pos.field_person_position_value AS `position`,
    inst.field_person_institution_value AS institution,
    dept.field_person_department_value AS department,
    t1.name AS `type`,
    addr.field_address_value AS address,
    mail.field_person_email_email AS email,
    tel.field_contact_telephone_value AS phoneNumber,
    fax.field_contact_fax_value AS fax,
    pri.field_contact_primary_nfp_value AS `primary`,
    FROM_UNIXTIME(a.changed) AS updated,
    a.nid
  FROM `informea_drupal`.node a
    LEFT JOIN `informea_drupal`.field_data_field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_drupal`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_drupal`.field_data_field_country_iso2 iso2 ON nc.nid = iso2.entity_id

    LEFT JOIN `informea_drupal`.field_data_field_person_prefix prf ON prf.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_person_first_name fst ON fst.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_person_last_name lst ON lst.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_person_position  pos ON pos.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_person_institution inst ON inst.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_person_department dept ON dept.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_person_type ptype ON ptype.entity_id = a.nid
    LEFT JOIN `informea_drupal`.taxonomy_term_data t1 ON ptype.field_person_type_tid = t1.tid

    LEFT JOIN `informea_drupal`.field_data_field_address addr ON addr.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_person_email mail ON mail.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_contact_telephone tel ON tel.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_contact_fax fax ON fax.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_contact_primary_nfp pri ON pri.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_drupal`.field_data_field_treaty t ON a.nid = t.entity_id
    INNER JOIN `informea_drupal`.node treaty ON t.entity_id = treaty.nid
  WHERE 
    a.`type` = 'contact_person'
    AND a.status = 1
    AND treaty.status = 1
    -- Do not publish 'special' treaties
    AND t.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
  GROUP BY a.nid;

-- informea_contacts_treaties
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_contacts_treaties` AS
  SELECT
    CAST(CONCAT(a.id, '-', d.field_odata_identifier_value) AS CHAR) AS id,
    a.id AS contact_id,
    d.field_odata_identifier_value AS treaty
    treaty.uuid AS treatyUUID
  FROM `informea_contacts` a
  INNER JOIN `informea_drupal`.field_data_field_treaty c ON a.nid = c.entity_id
  INNER JOIN `informea_drupal`.field_data_field_odata_identifier d ON c.field_treaty_target_id = d.entity_id;
  INNER JOIN `informea_drupal`.node treaty ON c.field_treaty_target_id = treaty.nid;

-- SITES
-- informea_sites
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_sites` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS `type`,
    iso2.field_country_iso2_value AS country,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    url.field_url_url AS url,
    lat.field_latitude_value AS latitude,
    lon.field_longitude_value AS longitude,
    FROM_UNIXTIME(a.changed) AS updated,
    a.nid AS nid
  FROM `informea_drupal`.node a
    INNER JOIN `informea_drupal`.field_data_field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_drupal`.field_data_field_odata_identifier c ON b.field_treaty_target_id = c.entity_id

    LEFT JOIN `informea_drupal`.field_data_field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_drupal`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_drupal`.field_data_field_country_iso2 iso2 ON nc.nid = iso2.entity_id

    LEFT JOIN `informea_drupal`.field_data_field_url url ON url.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_latitude lat ON lat.entity_id = a.nid
    LEFT JOIN `informea_drupal`.field_data_field_longitude lon ON lon.entity_id = a.nid

    LEFT JOIN `informea_drupal`.field_data_field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_drupal`.node treaty ON b.entity_id = treaty.nid

    WHERE 
      a.`type` = 'geographical_site'
      AND a.status = 1
      AND treaty.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
    GROUP BY a.nid;

-- informea_sites_name
CREATE OR REPLACE DEFINER =`informea`@`localhost` SQL SECURITY DEFINER VIEW `informea_sites_name` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.language) AS CHAR) AS id, 
    CAST(a.id AS CHAR) AS site_id,
    c.language AS `language`,
    c.title_field_value AS `name`
  FROM `informea_sites` a 
    INNER JOIN `informea_drupal`.field_data_title_field c ON a.nid = c.entity_id;

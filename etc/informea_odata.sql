-- informea_treaties
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_treaties` AS
  SELECT
    c.field_odata_identifier_value AS id,
    a.uuid AS uuid,
    CONCAT('https://www.informea.org/treaties/', c.field_odata_identifier_value) AS url,
    url.field_treaty_website_url_uri AS treatyWebsiteURL,
    b.title AS titleEnglish,
    d.field_official_name_value AS officialNameEnglish,
    FROM_UNIXTIME(b.changed) AS updated,
    a.nid
  FROM
    `informea`.node a
    INNER JOIN `informea`.node_field_data b ON b.nid = a.nid
    INNER JOIN `informea`.node__field_odata_identifier c ON c.entity_id = a.nid
    LEFT JOIN `informea`.node__field_treaty_website_url url ON url.entity_id = a.nid
    LEFT JOIN `informea`.node__field_official_name d ON d.entity_id = a.nid
  WHERE
  -- Do not publish 'special' treaties
  a.nid NOT IN (316, 302, 282, 301, 267)
    AND a.`TYPE` = 'treaty'
    AND b.langcode = 'en'
    AND b.`status` = 1
    GROUP BY a.nid;

-- informea_treaties_description
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_treaties_description` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS treaty_id,
    c.langcode AS `language`,
    c.body_value AS description
  FROM `informea_treaties` a
    INNER JOIN `informea`.node__body c ON c.entity_id = a.nid;


-- informea_treaties_title
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_treaties_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS treaty_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_treaties` a
    INNER JOIN `informea`.node__field_odata_identifier b ON b.field_odata_identifier_value = a.id
    INNER JOIN `informea`.node_field_data c ON c.nid = b.entity_id;

-- informea_meetings
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_meetings` AS
  SELECT
    CAST(a.uuid AS CHAR) AS id,
    c.field_odata_identifier_value AS treaty,
    n.uuid as treatyUUID,
    url.field_external_url_uri AS url,
    d.field_date_range_value AS `start`,
    d.field_date_range_end_value AS `end`,
    rep.field_repetition_value AS `repetition`,
    k.field_event_kind_value AS `kind`,
    t3.name AS `type`,
    ac.field_event_access_value AS `access`,
    st.field_event_status_value AS `status`,
    NULL AS imageUrl,
    NULL AS imageCopyright,
    loc.field_location_value AS location,
    city.field_city_value AS city,
    iso2.field_country_iso2_value AS country,
    lat.field_latitude_value AS latitude,
    lon.field_longitude_value AS longitude,
    FROM_UNIXTIME(nfd.changed) AS updated,
    a.nid AS nid
  FROM
    `informea`.node a
    INNER JOIN `informea`.node_field_data nfd ON a.nid = nfd.nid
    INNER JOIN `informea`.node__field_treaty b ON b.entity_id = a.nid
    INNER JOIN `informea`.node__field_odata_identifier c ON c.entity_id = b.field_treaty_target_id
    INNER JOIN `informea`.node__field_external_url url ON url.entity_id = a.nid
    INNER JOIN `informea`.node__field_date_range d ON d.entity_id = a.nid
    LEFT JOIN `informea`.node__field_repetition rep ON rep.entity_id = a.nid
    LEFT JOIN `informea`.node__field_event_kind k ON k.entity_id = a.nid
    LEFT JOIN `informea`.node__field_event_type et ON et.entity_id = a.nid
    LEFT JOIN `informea`.taxonomy_term_field_data t3 ON t3.tid = et.field_event_type_target_id
    LEFT JOIN `informea`.node__field_event_access ac ON ac.entity_id = a.nid
    LEFT JOIN `informea`.node__field_event_status st ON st.entity_id = a.nid
    LEFT JOIN `informea`.node__field_location loc ON loc.entity_id = a.nid
    LEFT JOIN `informea`.node__field_city city ON city.entity_id = a.nid
    INNER JOIN `informea`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea`.node nc ON (nc.nid = cou.field_country_target_id AND nc.type = 'country')
    INNER JOIN `informea`.node__field_country_iso2 iso2 ON iso2.entity_id = nc.nid
    LEFT JOIN `informea`.node__field_latitude lat ON lat.entity_id = a.nid
    LEFT JOIN `informea`.node__field_longitude lon ON lon.entity_id = a.nid
    LEFT JOIN `informea`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea`.node_field_data treaty ON treaty.nid = b.field_treaty_target_id
    INNER JOIN `informea`.node n ON treaty.nid = n.nid
  WHERE
    a.langcode = 'en'
    AND n.langcode = 'en'
    AND a.`type` = 'event'
    AND d.field_date_range_value IS NOT NULL
    -- Do not publish 'special' treaties
    AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
    AND nfd.status = 1
    AND treaty.status = 1
    GROUP BY a.nid;

-- informea_meetings_description
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_meetings_description` AS
  SELECT
    CONCAT(CAST(a.id AS CHAR), '-', c.langcode) AS id,
    CAST(a.id AS CHAR) AS meeting_id,
    c.langcode AS `language`,
    c.body_value AS description
  FROM `informea_meetings` a
    INNER JOIN `informea`.node__body c ON c.entity_id = a.nid;

-- informea_meetings_title
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_meetings_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS meeting_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_meetings` a
    INNER JOIN `informea`.node_field_data c ON a.nid = c.nid;

-- DECISIONS
-- informea_decisions
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_decisions` AS
  SELECT
    a.uuid AS id,
    IF (url.field_external_url_uri IS NULL, concat('https://www.informea.org/node/' , a.nid), url.field_external_url_uri) AS link,
    dt.field_decision_type_value AS `type`,
    ds.field_decision_status_value AS `status`,
    field_decision_number_value AS number,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    dp.field_date_value AS published,
    n3.uuid AS meetingId,
    n2.title AS meetingTitle,
    urlm.field_external_url_uri AS meetingUrl,
    FROM_UNIXTIME(a2.changed) AS updated,
    weight.field_weight_value AS displayOrder,
    a.nid AS nid
  FROM
    `informea`.node a
    INNER JOIN `informea`.node_field_data a2 ON a2.nid = a.nid
    INNER JOIN `informea`.node__field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea`.node__field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    LEFT JOIN `informea`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea`.node__field_decision_type dt ON dt.entity_id = a.nid
    LEFT JOIN `informea`.node__field_decision_status ds ON ds.entity_id = a.nid
    INNER JOIN `informea`.node__field_decision_number dn ON dn.entity_id = a.nid
    LEFT JOIN `informea`.node__field_date dp ON dp.entity_id = a.nid
    INNER JOIN `informea`.node__field_meeting m ON m.entity_id = a.nid
    INNER JOIN `informea`.node_field_data n2 ON m.field_meeting_target_id = n2.nid
    INNER JOIN `informea`.node n3 ON m.field_meeting_target_id = n3.nid
    LEFT JOIN `informea`.node__field_external_url urlm ON urlm.entity_id = m.field_meeting_target_id
    LEFT JOIN `informea`.node__field_weight weight ON weight.entity_id = a.nid
    INNER JOIN `informea`.node treaty ON b.field_treaty_target_id = treaty.nid
    INNER JOIN `informea`.node_field_data treaty2 ON treaty2.nid = treaty.nid
  WHERE
	  a.`type` = 'decision'
      AND a2.status = 1
      AND treaty2.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
      GROUP BY a.nid

-- informea_decisions_title
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_decisions_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_decisions` a
    INNER JOIN `informea`.node_field_data c ON a.nid = c.nid;

-- informea_decisions_content
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_decisions_content` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    c.langcode AS `language`,
    c.body_value AS content
  FROM `informea_decisions` a
    INNER JOIN `informea`.node__body c ON a.nid = c.entity_id
  WHERE c.body_value IS NOT NULL AND TRIM(c.body_value) <> '';

-- informea_decisions_documents
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_decisions_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid) AS id,
    a.id AS decision_id,
    fm.uri AS diskPath,
    IF (f.field_files_description IS NULL, CONCAT('https://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.`langcode` AS `language`,
    fm.filename AS filename
  FROM `informea_decisions` a
    INNER JOIN `informea`.node__field_files f ON f.entity_id = a.nid
    INNER JOIN `informea`.file_managed fm ON fm.fid = f.field_files_target_id;

-- informea_decisions_keywords
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_decisions_keywords` AS
  SELECT
    CAST(CONCAT(a.id, '-', t1.tid) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    'https://www.informea.org/terms/' AS namespace,
    t1.name AS term
  FROM `informea_decisions` a
    INNER JOIN `informea`.node__field_informea_tags c ON a.nid = c.entity_id
    INNER JOIN `informea`.taxonomy_term_field_data t1 ON c.field_informea_tags_target_id = t1.tid;

-- informea_decisions_longtitle
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_decisions_longtitle` AS
  SELECT
    NULL AS id,
    NULL AS decision_id,
    NULL AS `language`,
    NULL AS long_title
  LIMIT 0;

-- informea_decisions_summary
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_decisions_summary` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    c.langcode AS `language`,
    c.body_summary AS summary
  FROM `informea_decisions` a
    INNER JOIN `informea`.node__body c ON a.nid = c.entity_id
  WHERE c.body_summary IS NOT NULL AND TRIM(c.body_summary) <> '';

-- COUNTRY REPORTS (National Reports)

-- informea_country_reports
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_country_reports` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    iso2.field_country_iso2_value AS country,
    sd.field_date_value AS submission,
    url.field_external_url_uri AS url,
    FROM_UNIXTIME(nfd.changed) AS updated,
    a.nid AS nid
  FROM
    `informea`.node a
    INNER JOIN `informea`.node_field_data nfd ON nfd.nid = a.nid
    INNER JOIN `informea`.node__field_treaty b ON b.entity_id = a.nid
    INNER JOIN `informea`.node__field_odata_identifier c ON c.entity_id = b.field_treaty_target_id
    LEFT JOIN `informea`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea`.node nc ON (nc.nid = cou.field_country_target_id AND nc.type = 'country')
    INNER JOIN `informea`.node__field_country_iso2 iso2 ON iso2.entity_id = nc.nid
    LEFT JOIN `informea`.node__field_date sd ON sd.entity_id = a.nid
    LEFT JOIN `informea`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea`.node treaty ON treaty.nid = b.field_treaty_target_id
    INNER JOIN `informea`.node_field_data treaty2 ON treaty2.nid = b.field_treaty_target_id
  WHERE
      a.`type` = 'national_report'
      AND nfd.status = 1
      AND treaty2.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
      GROUP BY a.nid;

-- informea_country_reports_title
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_country_reports_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS country_report_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_country_reports` a
    INNER JOIN `informea`.node_field_data c ON a.nid = c.nid;

-- informea_country_reports_documents
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_country_reports_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid) AS id,
    a.id AS country_report_id,
    fm.uri AS diskPath,
    IF (f.field_files_description = '', CONCAT('https://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.langcode AS `language`,
    fm.filename AS filename
  FROM `informea_country_reports` a
    INNER JOIN `informea`.node__field_files f ON f.entity_id = a.nid
    INNER JOIN `informea`.file_managed fm ON fm.fid = f.field_files_target_id;

-- NATIONAL PLANS (Action Plans)
-- informea_national_plans
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_national_plans` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    iso2.field_country_iso2_value AS country,
    sd.field_date_value AS submission,
    url.field_external_url_uri AS url,
    apt.field_action_plan_type_value AS `type`,
    FROM_UNIXTIME(a2.changed) AS updated,
    a.nid AS nid
  FROM
    `informea`.node a
    INNER JOIN `informea`.node_field_data a2 ON a.nid = a2.nid
    INNER JOIN `informea`.node__field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea`.node__field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    LEFT JOIN `informea`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea`.node__field_country_iso2 iso2 ON nc.nid = iso2.entity_id
    LEFT JOIN `informea`.node__field_action_plan_type apt ON apt.entity_id = a.nid
    LEFT JOIN `informea`.node__field_date sd ON sd.entity_id = a.nid
    LEFT JOIN `informea`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea`.node treaty ON b.field_treaty_target_id = treaty.nid
    INNER JOIN `informea`.node_field_data treaty2 ON treaty2.nid = b.field_treaty_target_id
  WHERE
    a2.type = 'action_plan'
    AND a2.status = 1
    AND treaty2.status = 1
    -- Do not publish 'special' treaties
    AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
    AND url.field_external_url_uri IS NOT NULL
    -- avoid migration issue 10 Feb 2022
    AND apt.field_action_plan_type_value IS NOT NULL
    GROUP BY a.nid;

-- informea_national_plans_title
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_national_plans_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS national_plan_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_national_plans` a
  INNER JOIN `informea`.node_field_data c ON a.nid = c.nid;

-- informea_national_plans_documents
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_national_plans_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid)  AS id,
    a.id AS national_plan_id,
    fm.uri AS diskPath,
    IF (f.field_files_description = '', CONCAT('https://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.langcode AS `language`,
    fm.filename AS filename
  FROM `informea_national_plans` a
    INNER JOIN `informea`.node__field_files f ON f.entity_id = a.nid
    INNER JOIN `informea`.file_managed fm ON fm.fid = f.field_files_target_id;

-- CONTACTS (Focal Points)
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_contacts` AS
  SELECT
    a.uuid AS id,
    iso2.field_country_iso2_value AS country,
    prf.field_person_prefix_value AS prefix,
    fst.field_first_name_value AS firstName,
    lst.field_last_name_value AS lastName,
    pos.field_position_value AS `position`,
    inst.field_institution_value AS institution,
    dept.field_department_value AS department,
    t1.name AS `type`,
    addr.field_address_value AS address,
    mail.field_email_value AS email,
    tel.field_telephone_value AS phoneNumber,
    fax.field_fax_value AS fax,
    pri.field_primary_nfp_value AS `primary`,
    FROM_UNIXTIME(a2.changed) AS updated,
    a.nid
  FROM `informea`.node a
    LEFT JOIN `informea`.node_field_data a2 ON a.nid = a2.nid
    LEFT JOIN `informea`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea`.node__field_country_iso2 iso2 ON nc.nid = iso2.entity_id
    LEFT JOIN `informea`.node__field_person_prefix prf ON prf.entity_id = a.nid
    LEFT JOIN `informea`.node__field_first_name fst ON fst.entity_id = a.nid
    LEFT JOIN `informea`.node__field_last_name lst ON lst.entity_id = a.nid
    LEFT JOIN `informea`.node__field_position  pos ON pos.entity_id = a.nid
    LEFT JOIN `informea`.node__field_institution inst ON inst.entity_id = a.nid
    LEFT JOIN `informea`.node__field_department dept ON dept.entity_id = a.nid
    LEFT JOIN `informea`.node__field_person_type ptype ON ptype.entity_id = a.nid
    LEFT JOIN `informea`.taxonomy_term_field_data t1 ON ptype.field_person_type_target_id = t1.tid
    LEFT JOIN `informea`.node__field_address addr ON addr.entity_id = a.nid
    LEFT JOIN `informea`.node__field_email mail ON mail.entity_id = a.nid
    LEFT JOIN `informea`.node__field_telephone tel ON tel.entity_id = a.nid
    LEFT JOIN `informea`.node__field_fax fax ON fax.entity_id = a.nid
    LEFT JOIN `informea`.node__field_primary_nfp pri ON pri.entity_id = a.nid
    LEFT JOIN `informea`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea`.node__field_treaty t ON a.nid = t.entity_id
    INNER JOIN `informea`.node treaty ON t.entity_id = treaty.nid
    INNER JOIN `informea`.node_field_data treaty2 ON treaty2.nid = treaty.nid
  WHERE
    a.`type` = 'contact_person'
    AND a2.status = 1
    AND treaty2.status = 1
    -- Do not publish 'special' treaties
    AND t.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
  GROUP BY a.nid;

-- informea_contacts_treaties
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_contacts_treaties` AS
  SELECT
    CAST(CONCAT(a.id, '-', d.field_odata_identifier_value) AS CHAR) AS id,
    a.id AS contact_id,
    d.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID
  FROM `informea_contacts` a
  INNER JOIN `informea`.node__field_treaty c ON a.nid = c.entity_id
  INNER JOIN `informea`.node__field_odata_identifier d ON c.field_treaty_target_id = d.entity_id
  INNER JOIN `informea`.node treaty ON c.field_treaty_target_id = treaty.nid;

-- SITES
-- informea_sites
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_sites` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS `type`,
    iso2.field_country_iso2_value AS country,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    url.field_external_url_uri AS url,
    lat.field_latitude_value AS latitude,
    lon.field_longitude_value AS longitude,
    FROM_UNIXTIME(a2.changed) AS updated,
    a.nid AS nid
  FROM `informea`.node a
  INNER JOIN `informea`.node_field_data a2 ON a.nid = a2.nid
    INNER JOIN `informea`.node__field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea`.node__field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    LEFT JOIN `informea`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea`.node__field_country_iso2 iso2 ON nc.nid = iso2.entity_id
    LEFT JOIN `informea`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea`.node__field_latitude lat ON lat.entity_id = a.nid
    LEFT JOIN `informea`.node__field_longitude lon ON lon.entity_id = a.nid
    LEFT JOIN `informea`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea`.node treaty ON b.field_treaty_target_id = treaty.nid
    INNER JOIN `informea`.node_field_data treaty2 ON treaty.nid = treaty2.nid
  WHERE
      a.`type` = 'geographical_site'
      AND a2.status = 1
      AND treaty2.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
    GROUP BY a.nid;

-- informea_sites_name
CREATE OR REPLACE SQL SECURITY DEFINER VIEW `informea_sites_name` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS site_id,
    c.langcode AS `language`,
    c.title AS `name`
  FROM `informea_sites` a
    INNER JOIN `informea`.node_field_data c ON a.nid = c.nid;

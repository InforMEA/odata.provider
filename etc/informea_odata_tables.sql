-- informea_treaties
  CREATE OR REPLACE TABLE `informea_treaties` AS
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
      `informea_prod`.node a
      INNER JOIN `informea_prod`.node_field_data b ON b.nid = a.nid
      INNER JOIN `informea_prod`.node__field_odata_identifier c ON c.entity_id = a.nid
      LEFT JOIN `informea_prod`.node__field_treaty_website_url url ON url.entity_id = a.nid
      LEFT JOIN `informea_prod`.node__field_official_name d ON d.entity_id = a.nid
    WHERE
    -- Do not publish 'special' treaties
    a.nid NOT IN (316, 302, 282, 301, 267)
      AND a.`TYPE` = 'treaty'
      AND b.langcode = 'en'
      AND b.`status` = 1
      GROUP BY a.nid;

-- informea_treaties_description
CREATE OR REPLACE TABLE `informea_treaties_description` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS treaty_id,
    c.langcode AS `language`,
    c.body_value AS description
  FROM `informea_treaties` a
    INNER JOIN `informea_prod`.node__body c ON c.entity_id = a.nid;

-- informea_treaties_title
CREATE OR REPLACE TABLE `informea_treaties_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS treaty_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_treaties` a
    INNER JOIN `informea_prod`.node__field_odata_identifier b ON b.field_odata_identifier_value = a.id
    INNER JOIN `informea_prod`.node_field_data c ON c.nid = b.entity_id;

-- informea_meetings
CREATE OR REPLACE TABLE `informea_meetings` AS
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
    fva.field_virtual_attendance_value AS virtual,
    iso2.field_country_iso2_value AS country,
    lat.field_latitude_value AS latitude,
    lon.field_longitude_value AS longitude,
    FROM_UNIXTIME(nfd.changed) AS updated,
    a.nid AS nid
  FROM
    `informea_prod`.node a
    INNER JOIN `informea_prod`.node_field_data nfd ON a.nid = nfd.nid
    INNER JOIN `informea_prod`.node__field_treaty b ON b.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_odata_identifier c ON c.entity_id = b.field_treaty_target_id
    INNER JOIN `informea_prod`.node__field_external_url url ON url.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_date_range d ON d.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_repetition rep ON rep.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_event_kind k ON k.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_event_type et ON et.entity_id = a.nid
    LEFT JOIN `informea_prod`.taxonomy_term_field_data t3 ON t3.tid = et.field_event_type_target_id
    LEFT JOIN `informea_prod`.node__field_event_access ac ON ac.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_event_status st ON st.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_location loc ON loc.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_city city ON city.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_prod`.node nc ON (nc.nid = cou.field_country_target_id AND nc.type = 'country')
    INNER JOIN `informea_prod`.node__field_country_iso2 iso2 ON iso2.entity_id = nc.nid
    LEFT JOIN `informea_prod`.node__field_latitude lat ON lat.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_longitude lon ON lon.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_last_update upd ON upd.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_virtual_attendance fva ON fva.entity_id = a.nid
    INNER JOIN `informea_prod`.node_field_data treaty ON treaty.nid = b.field_treaty_target_id
    INNER JOIN `informea_prod`.node n ON treaty.nid = n.nid
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
CREATE OR REPLACE TABLE `informea_meetings_description` AS
  SELECT
    CONCAT(CAST(a.id AS CHAR), '-', c.langcode) AS id,
    CAST(a.id AS CHAR) AS meeting_id,
    c.langcode AS `language`,
    c.body_value AS description
  FROM `informea_meetings` a
    INNER JOIN `informea_prod`.node__body c ON c.entity_id = a.nid;

-- informea_meetings_title
CREATE OR REPLACE TABLE `informea_meetings_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS meeting_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_meetings` a
    INNER JOIN `informea_prod`.node_field_data c ON a.nid = c.nid;


-- DECISIONS
-- informea_decisions
CREATE OR REPLACE TABLE `informea_decisions` AS
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
    `informea_prod`.node a
    INNER JOIN `informea_prod`.node_field_data a2 ON a2.nid = a.nid
    INNER JOIN `informea_prod`.node__field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_prod`.node__field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    LEFT JOIN `informea_prod`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_decision_type dt ON dt.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_decision_status ds ON ds.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_decision_number dn ON dn.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_date dp ON dp.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_meeting m ON m.entity_id = a.nid
    INNER JOIN `informea_prod`.node_field_data n2 ON m.field_meeting_target_id = n2.nid
    INNER JOIN `informea_prod`.node n3 ON m.field_meeting_target_id = n3.nid
    LEFT JOIN `informea_prod`.node__field_external_url urlm ON urlm.entity_id = m.field_meeting_target_id
    LEFT JOIN `informea_prod`.node__field_weight weight ON weight.entity_id = a.nid
    INNER JOIN `informea_prod`.node treaty ON b.field_treaty_target_id = treaty.nid
    INNER JOIN `informea_prod`.node_field_data treaty2 ON treaty2.nid = treaty.nid
  WHERE
    a.`type` = 'decision'
      AND a2.status = 1
      AND treaty2.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
      GROUP BY a.nid;

-- informea_decisions_title
CREATE OR REPLACE TABLE `informea_decisions_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_decisions` a
    INNER JOIN `informea_prod`.node_field_data c ON a.nid = c.nid;

-- informea_decisions_content
CREATE OR REPLACE TABLE `informea_decisions_content` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    c.langcode AS `language`,
    c.body_value AS content
  FROM `informea_decisions` a
    INNER JOIN `informea_prod`.node__body c ON a.nid = c.entity_id
  WHERE c.body_value IS NOT NULL AND TRIM(c.body_value) <> '';

-- informea_decisions_documents
CREATE OR REPLACE TABLE `informea_decisions_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid) AS id,
    a.id AS decision_id,
    fm.uri AS diskPath,
    IF (f.field_files_description IS NULL, CONCAT('https://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.`langcode` AS `language`,
    fm.filename AS filename
  FROM `informea_decisions` a
    INNER JOIN `informea_prod`.node__field_files f ON f.entity_id = a.nid
    INNER JOIN `informea_prod`.file_managed fm ON fm.fid = f.field_files_target_id;

-- informea_decisions_keywords
CREATE OR REPLACE TABLE `informea_decisions_keywords` AS
  SELECT
    CAST(CONCAT(a.id, '-', t1.tid) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    'https://www.informea.org/terms/' AS namespace,
    t1.name AS term
  FROM `informea_decisions` a
    INNER JOIN `informea_prod`.node__field_informea_tags c ON a.nid = c.entity_id
    INNER JOIN `informea_prod`.taxonomy_term_field_data t1 ON c.field_informea_tags_target_id = t1.tid
    WHERE t1.langcode = 'en';

-- informea_decisions_longtitle
CREATE OR REPLACE TABLE `informea_decisions_longtitle` AS
  SELECT
    NULL AS id,
    NULL AS decision_id,
    NULL AS `language`,
    NULL AS long_title
  LIMIT 0;

-- informea_decisions_summary
CREATE OR REPLACE TABLE `informea_decisions_summary` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS decision_id,
    c.langcode AS `language`,
    c.body_summary AS summary
  FROM `informea_decisions` a
    INNER JOIN `informea_prod`.node__body c ON a.nid = c.entity_id
  WHERE c.body_summary IS NOT NULL AND TRIM(c.body_summary) <> '';


-- COUNTRY REPORTS (National Reports)

-- informea_country_reports
CREATE OR REPLACE TABLE `informea_country_reports` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    iso2.field_country_iso2_value AS country,
    SUBSTR(sd.field_date_value, 1, 10) AS submission,
    url.field_external_url_uri AS url,
    FROM_UNIXTIME(nfd.changed) AS updated,
    a.nid AS nid
  FROM
    `informea_prod`.node a
    INNER JOIN `informea_prod`.node_field_data nfd ON nfd.nid = a.nid
    INNER JOIN `informea_prod`.node__field_treaty b ON b.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_odata_identifier c ON c.entity_id = b.field_treaty_target_id
    LEFT JOIN `informea_prod`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_prod`.node nc ON (nc.nid = cou.field_country_target_id AND nc.type = 'country')
    INNER JOIN `informea_prod`.node__field_country_iso2 iso2 ON iso2.entity_id = nc.nid
    LEFT JOIN `informea_prod`.node__field_date sd ON sd.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_prod`.node treaty ON treaty.nid = b.field_treaty_target_id
    INNER JOIN `informea_prod`.node_field_data treaty2 ON treaty2.nid = b.field_treaty_target_id
  WHERE
      a.`type` = 'national_report'
      AND nfd.status = 1
      AND treaty2.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
      GROUP BY a.nid;

-- informea_country_reports_title
CREATE OR REPLACE TABLE `informea_country_reports_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS country_report_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_country_reports` a
    INNER JOIN `informea_prod`.node_field_data c ON a.nid = c.nid;

-- informea_country_reports_documents
CREATE OR REPLACE TABLE `informea_country_reports_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid) AS id,
    a.id AS country_report_id,
    fm.uri AS diskPath,
    IF (f.field_files_description = '', CONCAT('https://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.langcode AS `language`,
    fm.filename AS filename
  FROM `informea_country_reports` a
    INNER JOIN `informea_prod`.node__field_files f ON f.entity_id = a.nid
    INNER JOIN `informea_prod`.file_managed fm ON fm.fid = f.field_files_target_id;


-- NATIONAL PLANS (Action Plans)

-- informea_national_plans
CREATE OR REPLACE TABLE `informea_national_plans` AS
  SELECT
    a.uuid AS id,
    c.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID,
    iso2.field_country_iso2_value AS country,
    SUBSTR(sd.field_date_value, 1, 10) AS submission,
    url.field_external_url_uri AS url,
    apt.field_action_plan_type_value AS `type`,
    FROM_UNIXTIME(a2.changed) AS updated,
    a.nid AS nid
  FROM
    `informea_prod`.node a
    INNER JOIN `informea_prod`.node_field_data a2 ON a.nid = a2.nid
    INNER JOIN `informea_prod`.node__field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_prod`.node__field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    LEFT JOIN `informea_prod`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_prod`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_prod`.node__field_country_iso2 iso2 ON nc.nid = iso2.entity_id
    LEFT JOIN `informea_prod`.node__field_action_plan_type apt ON apt.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_date sd ON sd.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_prod`.node treaty ON b.field_treaty_target_id = treaty.nid
    INNER JOIN `informea_prod`.node_field_data treaty2 ON treaty2.nid = b.field_treaty_target_id
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
CREATE OR REPLACE TABLE `informea_national_plans_title` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS national_plan_id,
    c.langcode AS `language`,
    c.title AS title
  FROM `informea_national_plans` a
  INNER JOIN `informea_prod`.node_field_data c ON a.nid = c.nid;

-- informea_national_plans_documents
CREATE OR REPLACE TABLE `informea_national_plans_documents` AS
  SELECT
    CONCAT(a.id, '-', fm.uuid, '-', f.delta)  AS id,
    a.id AS national_plan_id,
    fm.uri AS diskPath,
    IF (f.field_files_description = '', CONCAT('https://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')), f.field_files_description) AS url,
    fm.filemime AS mimeType,
    f.langcode AS `language`,
    fm.filename AS filename
  FROM `informea_national_plans` a
    INNER JOIN `informea_prod`.node__field_files f ON f.entity_id = a.nid
    INNER JOIN `informea_prod`.file_managed fm ON fm.fid = f.field_files_target_id;


-- CONTACTS (Focal Points)

-- informea_contacts
CREATE OR REPLACE TABLE `informea_contacts` AS
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
  FROM `informea_prod`.node a
    LEFT JOIN `informea_prod`.node_field_data a2 ON a.nid = a2.nid
    LEFT JOIN `informea_prod`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_prod`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_prod`.node__field_country_iso2 iso2 ON nc.nid = iso2.entity_id
    LEFT JOIN `informea_prod`.node__field_person_prefix prf ON prf.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_first_name fst ON fst.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_last_name lst ON lst.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_position  pos ON pos.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_institution inst ON inst.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_department dept ON dept.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_person_type ptype ON ptype.entity_id = a.nid
    LEFT JOIN `informea_prod`.taxonomy_term_field_data t1 ON ptype.field_person_type_target_id = t1.tid
    LEFT JOIN `informea_prod`.node__field_address addr ON addr.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_email mail ON mail.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_telephone tel ON tel.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_fax fax ON fax.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_primary_nfp pri ON pri.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_treaty t ON a.nid = t.entity_id
    INNER JOIN `informea_prod`.node treaty ON t.entity_id = treaty.nid
    INNER JOIN `informea_prod`.node_field_data treaty2 ON treaty2.nid = treaty.nid
  WHERE
    a.`type` = 'contact_person'
    AND a2.status = 1
    AND treaty2.status = 1
    -- Do not publish 'special' treaties
    AND t.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
  GROUP BY a.nid;

-- informea_contacts_treaties
CREATE OR REPLACE TABLE `informea_contacts_treaties` AS
  SELECT
    CAST(CONCAT(a.id, '-', d.field_odata_identifier_value) AS CHAR) AS id,
    a.id AS contact_id,
    d.field_odata_identifier_value AS treaty,
    treaty.uuid AS treatyUUID
  FROM `informea_contacts` a
  INNER JOIN `informea_prod`.node__field_treaty c ON a.nid = c.entity_id
  INNER JOIN `informea_prod`.node__field_odata_identifier d ON c.field_treaty_target_id = d.entity_id
  INNER JOIN `informea_prod`.node treaty ON c.field_treaty_target_id = treaty.nid;


-- SITES

-- informea_sites
CREATE OR REPLACE TABLE `informea_sites` AS
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
  FROM `informea_prod`.node a
  INNER JOIN `informea_prod`.node_field_data a2 ON a.nid = a2.nid
    INNER JOIN `informea_prod`.node__field_treaty b ON a.nid = b.entity_id
    INNER JOIN `informea_prod`.node__field_odata_identifier c ON b.field_treaty_target_id = c.entity_id
    LEFT JOIN `informea_prod`.node__field_country cou ON cou.entity_id = a.nid
    INNER JOIN `informea_prod`.node nc ON (cou.field_country_target_id = nc.nid AND nc.type = 'country')
    INNER JOIN `informea_prod`.node__field_country_iso2 iso2 ON nc.nid = iso2.entity_id
    LEFT JOIN `informea_prod`.node__field_external_url url ON url.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_latitude lat ON lat.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_longitude lon ON lon.entity_id = a.nid
    LEFT JOIN `informea_prod`.node__field_last_update upd ON upd.entity_id = a.nid
    INNER JOIN `informea_prod`.node treaty ON b.field_treaty_target_id = treaty.nid
    INNER JOIN `informea_prod`.node_field_data treaty2 ON treaty.nid = treaty2.nid
  WHERE
      a.`type` = 'geographical_site'
      AND a2.status = 1
      AND treaty2.status = 1
      -- Do not publish 'special' treaties
      AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
    GROUP BY a.nid;

-- informea_sites_name
CREATE OR REPLACE TABLE `informea_sites_name` AS
  SELECT
    CAST(CONCAT(a.id, '-', c.langcode) AS CHAR) AS id,
    CAST(a.id AS CHAR) AS site_id,
    c.langcode AS `language`,
    c.title AS `name`
  FROM `informea_sites` a
    INNER JOIN `informea_prod`.node_field_data c ON a.nid = c.nid;


-- DOCUMENTS ENTITY

-- informea_documents
CREATE OR REPLACE TABLE `informea_documents` AS
  SELECT
    1 schemaversion,
    a.uuid AS `id`,
    dp.field_date_value AS published,
    FROM_UNIXTIME(nfd.changed) `updated`,
    c.field_odata_identifier_value AS treaty,
    NULL AS thumbnailUrl,
    1 AS displayOrder,
    iso2.field_country_iso2_value AS country,
    a.nid
  FROM
    `informea_prod`.node a
    INNER JOIN `informea_prod`.node_field_data nfd ON nfd.nid = a.nid
    INNER JOIN `informea_prod`.node__field_treaty b ON b.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_odata_identifier c ON c.entity_id = b.field_treaty_target_id

    LEFT JOIN `informea_prod`.node__field_date dp ON dp.entity_id = a.nid

    LEFT JOIN `informea_prod`.node__field_country cou ON cou.entity_id = a.nid
    LEFT JOIN `informea_prod`.node_field_data nc ON (nc.nid = cou.field_country_target_id AND nc.`type` = 'country')
    LEFT JOIN `informea_prod`.node__field_country_iso2 iso2 ON nc.nid = iso2.entity_id

    INNER JOIN `informea_prod`.node treaty ON treaty.nid = b.field_treaty_target_id
    INNER JOIN `informea_prod`.node_field_data treaty2 ON treaty2.nid = treaty.nid
  WHERE
    a.`type` = 'document'
    AND nfd.status = 1
    AND treaty2.status = 1
    -- Do not publish 'special' treaties
    AND b.field_treaty_target_id NOT IN (316, 302, 282, 301, 267)
  GROUP BY a.nid;


-- Documents `type` navigation property
CREATE OR REPLACE TABLE `informea_documents_types` AS
  SELECT
    CONCAT(a.id, '-', t.tid) AS id,
    a.id document_id,
    t.name AS `value`
  FROM informea_documents a
    INNER JOIN `informea_prod`.node__field_document_types dt ON (a.nid = dt.entity_id AND dt.bundle = 'document')
    INNER JOIN `informea_prod`.taxonomy_term_field_data t on dt.field_document_types_target_id = t.tid
  GROUP BY a.id, t.tid;


-- Documents `authors` navigation property
CREATE OR REPLACE TABLE `informea_documents_authors` AS
  SELECT
    CONCAT(a.nid, '-', bt.tid) id,
    a.id AS document_id,
    NULL `type`,
    bt.name AS name
  FROM informea_documents a
    INNER JOIN `informea_prod`.node__field_authors b ON b.entity_id = a.nid
    INNER JOIN `informea_prod`.taxonomy_term_field_data bt ON bt.tid = b.field_authors_target_id
  GROUP BY a.nid, bt.tid;


-- Documents `keywords` navigation property
CREATE OR REPLACE TABLE `informea_documents_keywords` AS
  SELECT
    CONCAT(a.nid, '-', kwt.tid) AS id,
    a.id AS document_id,
    uri.field_term_reference_url_uri AS `termuri`,
    'leo' AS `scope`,
    kwt.name AS literalForm,
    CONCAT('https://www.informea.org/taxonomy/term/', kwt.tid) AS sourceURL
  FROM informea_documents a
    INNER JOIN `informea_prod`.node__field_informea_tags kw ON kw.entity_id = a.nid
    INNER JOIN `informea_prod`.taxonomy_term_field_data kwt ON kwt.tid = kw.field_informea_tags_target_id
    INNER JOIN `informea_prod`.taxonomy_term__field_term_reference_url uri ON uri.entity_id = kwt.tid
  WHERE kwt.langcode = 'en'
  GROUP BY a.nid, kwt.tid;


-- Documents `title` navigation property
CREATE OR REPLACE TABLE `informea_documents_title` AS
  SELECT
    CAST(concat(a.ID, '-', b.`langcode`) AS CHAR) AS `id`,
    CAST(a.ID AS CHAR) AS document_id,
    b.langcode AS `language`,
    b.title AS value
  FROM `informea_documents` a
    INNER JOIN `informea_prod`.node_field_data b ON b.nid = a.nid;

-- Documents `description` navigation property
CREATE OR REPLACE TABLE `informea_documents_description` AS
  SELECT
    CONCAT(a.id, '-', c.`langcode`) AS `id`,
    CAST(a.id AS CHAR) AS document_id,
    c.langcode AS `language`,
    c.body_value AS value
  FROM `informea_documents` a
    INNER JOIN `informea_prod`.node__body c ON a.nid = c.entity_id
  WHERE c.body_value IS NOT NULL AND c.body_value <> '';

-- Documents `identifiers` navigation property
-- @todo
CREATE OR REPLACE TABLE `informea_documents_identifiers` AS
  SELECT
    NULL `id`,
    NULL document_id,
    NULL `name`,
    NULL `value`
  LIMIT 0;

-- Documents `files` navigation property
CREATE OR REPLACE TABLE `informea_documents_files` AS
  SELECT
    CONCAT(a.nid, '-', d.langcode, '-', d.delta) AS id,
    a.id AS document_id,
    CONCAT('http://www.informea.org/sites/default/files/', REPLACE(fm.uri, 'public://', '')) AS url,
    NULL AS content,
    fm.filemime AS mimeType,
    d.langcode AS `language`,
    fm.filename AS filename
  FROM `informea_documents` a
    INNER JOIN `informea_prod`.node__field_files d ON d.entity_id = a.nid
    INNER JOIN `informea_prod`.file_managed fm ON fm.fid = d.field_files_target_id;

-- Documents `tags` navigation property
-- @todo:
CREATE OR REPLACE TABLE `informea_documents_tags` AS
  SELECT
    NULL `id`,
    NULL `document_id`,
    NULL `language`,
    NULL `scope`,
    NULL `value`,
    NULL `comment`
  FROM DUAL;

-- Documents `referenceToEntities` navigation property
-- @todo:
DROP TABLE IF EXISTS informea_documents_references;
CREATE OR REPLACE TABLE `informea_documents_references` AS
  SELECT
      NULL AS `id`,
      NULL AS document_id,
      NULL AS type,
      NULL AS refId
    FROM DUAL;

-- Documents `treaties` navigation property
-- @todo:
CREATE OR REPLACE TABLE `informea_documents_treaties` AS
  SELECT
    CONCAT(a.nid, '-', t.field_treaty_target_id) id,
    a.id AS document_id,
    o.field_odata_identifier_value AS treaty
  FROM informea_documents a
    INNER JOIN `informea_prod`.node__field_treaty t ON t.entity_id = a.nid
    INNER JOIN `informea_prod`.node__field_odata_identifier o ON o.entity_id = t.field_treaty_target_id
  GROUP BY a.nid, t.field_treaty_target_id;

ALTER TABLE informea_meetings_title
    ADD INDEX idx_imt_mid (meeting_id);
ALTER TABLE informea_meetings_description
    ADD INDEX idx_imd_mid (meeting_id);

ALTER TABLE informea_contacts_treaties
    ADD INDEX idx_ict_cid (contact_id);

ALTER TABLE informea_national_plans_title
    ADD INDEX idx_inpt_npid (national_plan_id);
ALTER TABLE informea_national_plans_documents
    ADD INDEX idx_inpd_npid (national_plan_id);

ALTER TABLE informea_documents_authors
    ADD INDEX idx_ida_did (document_id);
ALTER TABLE informea_documents_description
    ADD INDEX idx_idd_did (document_id);
ALTER TABLE informea_documents_files
    ADD INDEX idx_idf_did (document_id);
ALTER TABLE informea_documents_identifiers
    ADD INDEX idx_idi_did (document_id);
ALTER TABLE informea_documents_keywords
    ADD INDEX idx_idk_did (document_id);
ALTER TABLE informea_documents_references
    ADD INDEX idx_idr_did (document_id);
ALTER TABLE informea_documents_tags
    ADD INDEX idx_idta_did (document_id);
ALTER TABLE informea_documents_title
    ADD INDEX idx_idti_did (document_id);
ALTER TABLE informea_documents_treaties
    ADD INDEX idx_idtr_did (document_id);
ALTER TABLE informea_documents_types
    ADD INDEX idx_idty_did (document_id);


ALTER TABLE informea_decisions_content
    ADD INDEX idx_idc_did (decision_id);
ALTER TABLE informea_decisions_documents
    ADD INDEX idx_idd_did (decision_id);
ALTER TABLE informea_decisions_keywords
    ADD INDEX idx_idk_did (decision_id);
ALTER TABLE informea_decisions_longtitle
    ADD INDEX idx_idl_did (decision_id);
ALTER TABLE informea_decisions_summary
    ADD INDEX idx_ids_did (decision_id);
ALTER TABLE informea_decisions_title
    ADD INDEX idx_idt_did (decision_id);


ALTER TABLE informea_country_reports_title
    ADD INDEX idx_icrt_crid (country_report_id);
ALTER TABLE informea_country_reports_documents
    ADD INDEX idx_icrd_crid (country_report_id);

ALTER TABLE informea_treaties_description
    ADD INDEX idx_itd_tid (treaty_id);
ALTER TABLE informea_treaties_title
    ADD INDEX idx_itd_tid (treaty_id);

ALTER TABLE informea_sites_name
    ADD INDEX idx_isn_sid (site_id);


ALTER TABLE informea_contacts
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_contacts_treaties
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_country_reports
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_country_reports_documents
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_country_reports_title
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_decisions
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_decisions_content
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_decisions_documents
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_decisions_keywords
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_decisions_longtitle
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_decisions_summary
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_decisions_title
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_authors
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_description
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_files
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_identifiers
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_keywords
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_references
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_tags
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_title
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_treaties
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_documents_types
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_meetings
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_meetings_description
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_meetings_title
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_national_plans
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_national_plans_documents
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_national_plans_title
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_sites
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_sites_name
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_treaties
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_treaties_description
    ADD UNIQUE INDEX pk_id (id);
ALTER TABLE informea_treaties_title
    ADD UNIQUE INDEX pk_id (id);


-- fixes for bad data
update informea_documents_title set value=REGEXP_REPLACE(value, '\\x1E', '-') where REGEXP_REPLACE(value, '\\x1E', '-')<>value;
update informea_documents_title set value=REGEXP_REPLACE(value, '[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]', '') where REGEXP_REPLACE(value, '[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]', '')<>value;

update informea_documents_description set value=REGEXP_REPLACE(value, '\\x1E', '-') where REGEXP_REPLACE(value, '\\x1E', '-')<>value;
update informea_documents_description set value=REGEXP_REPLACE(value, '[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]', '') where REGEXP_REPLACE(value, '[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]', '')<>value;

update informea_contacts set address=REGEXP_REPLACE(address, '\\x1E', '-') where REGEXP_REPLACE(address, '\\x1E', '-')<>address;
update informea_contacts set address=REGEXP_REPLACE(address, '[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]', '') where REGEXP_REPLACE(address, '[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F]', '')<>address;

commit;

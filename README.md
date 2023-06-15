# OData provider

[![Build Status](http://ci.edw.ro/buildStatus/icon?job=informea.odata.provider)](http://ci.edw.ro/job/informea.odata.provider/)

InforMEA OData provider

This project contains the OData provider web application to be deployed on third parties environments such as MEAs (Multilateral Environment Agreements) where it can be configured to expose the InforMEA compatible entities present inside their relational database back-end.

The 2.0 version features:

* New implementation based on the Apache Olingo library
* Amendments added to the API specification for data structures (ie File entity)

## Prerequisites

* Java 1.7 (not tested with 1.8)
* Apache Tomcat 7.x
* Hardware requirements: The minimum hardware requirements are specific to [Java & Apache Tomcat hosting the toolkit](https://java.com/en/download/help/sysreq.xml), in terms of RAM allocated to the Java VM we recommend **512 MB** but that depends on the dataset size and might need tweaking.
* Sofware requirements: No specific requirements, we recommend CentOS Linux. Please consult the Java requirements above.

## Create new release

* Refer to `docker-build` folder

## Binary installation


### Step 1. Create the database views

Once setup the toolkit is looking for each entity it needs to list (i.e. Decisions, Meetings) and it is querying the target database, looking for some database views/tables with a pre-defined naming. Those views are queries and the information is extracted for each rown then serialized into XML or JSON. 

Considering that each MEA is storing the data into its own system with a custom database structure, in order to make the toolkit reusable for any MEA, instead of selecting the data from the underlying custom database tables - it actually selects the data from standard database views, which themselves are created as site-specific queries at this stage. This way, the database views have uderlying site-specific custom queries - while their structure is well-known to the persistence layer.

Conceptual diagram showing a request:

```
Internet request => Request processor => JPA/JDBC Query => DB views => DB tables => Response serializer (XML/JSON) => Client
```

> * see doc/ directory for deployment guidelines
> * src/test/sql/clean.sql has sample data.

Here are some examples on how to create the database views for a Drupal 7 deployment

```SQL
CREATE OR REPLACE VIEW `informea_decisions` AS
  SELECT
    a.uuid                                                     AS id,
    CONCAT('http://www.mea.org/node/', a.nid)                  AS link,
    CASE b1.name WHEN 'resolutions' THEN 'resolution'
      WHEN 'recommendations' THEN 'recommendation'
      ELSE 'decision'
    END                                                        AS `type`,
    'Adopted'                                                  AS `status`,
    d.field_document_number_value                              AS number,
    lower(e1.title)                                            AS treaty,
    f.field_document_publish_date_value                        AS published,
    date_format(from_unixtime(a.created), '%Y-%m-%d %H:%i:%s') AS updated,
    g.id_meeting                                               AS meetingId,
    NULL                                                       AS meetingTitle,
    NULL                                                       AS meetingUrl,
    dg.weight                                                  AS displayOrder,
    a.nid
  FROM node a
    INNER JOIN field_data_field_document_type b ON b.entity_id = a.nid
    INNER JOIN taxonomy_term_data b1 ON b.field_document_type_tid = b1.tid
    INNER JOIN field_data_field_document_number d ON d.entity_id = a.nid
    INNER JOIN field_data_field_instrument e ON e.entity_id = a.nid
    INNER JOIN node e1 ON e.field_instrument_target_id = e1.nid
    INNER JOIN field_data_field_document_publish_date f ON f.entity_id = a.nid
    INNER JOIN informea_decisions_cop_documents g ON g.id_document = a.nid
    LEFT JOIN draggableviews_structure dg ON (dg.view_name = 'meeting_documents_list_reorder' AND dg.entity_id = a.nid)
  WHERE
    a.`type` = 'document'
    AND LOWER(b1.name) IN ('resolution', 'resolutions', 'recommendation', 'recommendations')
  GROUP BY a.uuid;

-- informea_decisions_content
CREATE OR REPLACE VIEW `informea_decisions_content` AS
  SELECT
    NULL AS id,
    NULL AS decision_id,
    NULL AS `language`,
    NULL AS content
  LIMIT 0;


-- informea_decisions_documents
CREATE OR REPLACE VIEW `informea_decisions_documents` AS
  SELECT
    CONCAT(a.uuid, '-', f2.fid)                                                         AS id,
    a.uuid                                                                              AS decision_id,
    CONCAT('http://www.mea.org/sites/default/files/', REPLACE(f2.uri, 'public://', '')) AS url,
    f2.filemime                                                                         AS mimeType,
    f1.`language`                                                                       AS language,
    f2.filename                                                                         AS filename
  FROM node a
    INNER JOIN field_data_field_document_type b ON b.entity_id = a.nid
    INNER JOIN taxonomy_term_data b1 ON b.field_document_type_tid = b1.tid
    INNER JOIN field_data_field_document_number d ON d.entity_id = a.nid
    INNER JOIN field_data_field_instrument e ON e.entity_id = a.nid
    INNER JOIN node e1 ON e.field_instrument_target_id = e1.nid
    INNER JOIN field_data_field_document_files f ON f.entity_id = a.nid
    INNER JOIN field_data_field_document_file f1 ON f1.entity_id = f.field_document_files_value
    INNER JOIN file_managed f2 ON f2.fid = f1.field_document_file_fid
  WHERE
    a.`type` = 'document'
    AND LOWER(b1.name) IN ('resolution', 'resolutions', 'recommendation', 'recommendations')
    AND LOWER(e1.title) IN ('cms');


-- informea_decisions_keywords
CREATE OR REPLACE VIEW `informea_decisions_keywords` AS
  SELECT
    CONCAT(a.id, '-', td.tid) AS id,
    a.id decision_id,
    'http://www.informea.org/terms' AS `namespace`,
    td.name AS term
  FROM informea_decisions a
    INNER JOIN field_data_field_cms_tags tags ON tags.entity_id = a.nid
    INNER JOIN field_data_field_related_informea_terms itags ON tags.field_cms_tags_tid = itags.entity_id
    INNER JOIN taxonomy_term_data td ON itags.field_related_informea_terms_target_id = td.tid;

-- informea_decisions_title
CREATE OR REPLACE VIEW `informea_decisions_title` AS
  SELECT
    CONCAT(a.uuid, '-', 'en') AS id,
    a.uuid                    AS decision_id,
    'en'                      AS `language`,
    a.title                   AS title
  FROM node a
    INNER JOIN field_data_field_document_type b ON b.entity_id = a.nid
    INNER JOIN taxonomy_term_data b1 ON b.field_document_type_tid = b1.tid
    INNER JOIN field_data_field_document_number d ON d.entity_id = a.nid
    INNER JOIN field_data_field_instrument e ON e.entity_id = a.nid
    INNER JOIN node e1 ON e.field_instrument_target_id = e1.nid
  WHERE
    a.`type` = 'document'
    AND LOWER(b1.name) IN ('resolution', 'resolutions', 'recommendation', 'recommendations')
    AND LOWER(e1.title) IN ('cms');
```


### Step 2. Configure the data source

* Deploy the WAR package into Tomcat.
* Copy WEB-INF/classes/META-INF/persistence.template.xml to WEB-INF/classes/META-INF/persistence.xml and set the appropriate DB connection parameters, see below:

```
<property name="javax.persistence.jdbc.url" value="jdbc:mysql://mysql.host:3306/database?zeroDateTimeBehavior=convertToNull" />
<property name="javax.persistence.jdbc.user" value="root" />
<property name="javax.persistence.jdbc.password" value="root" />

<property name="eclipselink.connection-pool.default.url" value="jdbc:mysql://mysql.host:3306/database?zeroDateTimeBehavior=convertToNull" />
```

SQLServer specific configuration:

```
<property name="javax.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
<property name="javax.persistence.jdbc.url" value="jdbc:sqlserver://192.168.0.1;database=your_db_name;" />
```


* Restart Tomcat to take effect

### Limit the results (optional)
If (for performance reasons) you need to limit the number of entities returned when no limits are set ($top / $skip limits), se the environment variable `ODATA_PAGESIZE` to the number of entities to return:

`export ODATA_PAGESIZE=250`

Build from source
=================

* Install the SQL database from src/test/sql/clean.sql
* `mvn package` or `mvn -DskipTests=true package` without running the tests
* Use the war for binary installation

Testing
=================

To run tests:

1. Create a database called `informea_odata_test`
2. Edit _persistence.xml_ and configure the connection details for _persistence_unit_test_ at the bottom of the page (username, password, host, etc.)
3. Edit the pom.xml and configure database connection in the _test database configuration_ section
4. Execute the tests with ```mvn sql:execute test```

### In case of 'An exception occurred' errors

Some types of special characters (basically anything with ascii code <32 except for CR/LF/TAB) in the document names/addresses and other text fields are not supported by Olingo. In such cases, a generic 'An exception occurred' error is shown. To identify exactly the issue, you can use the `etc/functional_test.py` script to extract all entities and to check which one is faulty.

To use it, set the persistence logging to log SQL in `persistence.xml`
```
<property name="eclipselink.logging.level.sql" value="FINE" />
<property name="eclipselink.logging.level" value="FINE" />
<property name="eclipselink.logging.file" value="eclipselink.log"/>
```
Configure the `baseurl` value in `functional_test.py` then run the script. It will connect to the application and list all entities. When it finds an error, it will check every entity to find the faulty one. Then you can look in the `eclipselink.log` for the last DB calls and identify the source record.

Configuration
=============

The current list of SQL views part of the toolkit:

* informea_contacts
* informea_contacts_treaties
* informea_country_reports
* informea_country_reports_documents
* informea_country_reports_title
* informea_decisions
* informea_decisions_content
* informea_decisions_documents
* informea_decisions_keywords
* informea_decisions_longtitle
* informea_decisions_summary
* informea_decisions_title
* informea_documents
* informea_documents_authors
* informea_documents_description
* informea_documents_files
* informea_documents_identifiers
* informea_documents_keywords
* informea_documents_references
* informea_documents_tags
* informea_documents_title
* informea_documents_treaties
* informea_documents_types
* informea_meetings
* informea_meetings_description
* informea_meetings_title
* informea_national_plans
* informea_national_plans_documents
* informea_national_plans_title
* informea_sites
* informea_sites_name
* informea_treaties
* informea_treaties_description
* informea_treaties_title


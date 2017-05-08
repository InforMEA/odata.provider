odata.provider
==============

[![Build Status](http://ci.edw.ro/buildStatus/icon?job=informea.odata.provider)](http://ci.edw.ro/job/informea.odata.provider/)

InforMEA OData provider

This project contains the OData provider web application to be deployed on third parties environments such as MEAs (Multilateral Environment Agreements) where it can be configured to expose the InforMEA compatible entities present inside their relational database back-end.

The 2.0 version features:

* New implementation based on the Apache Olingo library
* Amendments added to the API specification for data structures (ie File entity)

Prerequisites
=============

* Java 1.7 (not tested with 1.8)
* Apache Tomcat 7.x

Binary installation
===================

* Configure the database views

> * see doc/ directory for deployment guidelines
> * src/test/sql/clean.sql has sample data.

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

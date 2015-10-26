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

> * visit http://www.informea.org/api on how to do that 
> * src/test/sql/clean.sql has sample data.

* Deploy the WAR package into Tomcat.
* Edit WEB-INF/classes/META-INF/persistence.xml and set the proper DB parameters, see below:

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
* mvn package
* Use the war for binary installation


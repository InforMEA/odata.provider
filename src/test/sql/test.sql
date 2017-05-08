--
-- informea_documents
--
DROP TABLE IF EXISTS informea_documents;
CREATE TABLE informea_documents (
  `id` VARCHAR(36) PRIMARY KEY,
  schemaversion INT,
  published DATETIME,
  `updated` DATETIME,
  treaty VARCHAR(255),
  thumbnailUrl VARCHAR(255),
  displayOrder INT,
  country VARCHAR(2)
);

DELETE FROM informea_documents;
INSERT INTO informea_documents VALUES (
  '00000000-0000-0000-0000-000000000000',
  1,
  '2008-10-02 12:34:56',
  '2014-06-16 13:05:13',
  'cms',
  'http://www.cms.int/sites/default/filespublication/gorilla_0_3_0_0.jpg',
  '2',
  'RO'
);

--
-- informea_documents_title
--
DROP TABLE IF EXISTS informea_documents_title;
CREATE TABLE informea_documents_title (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  language VARCHAR(2),
  value VARCHAR(255)
);
DELETE FROM informea_documents_title;
INSERT INTO informea_documents_title VALUES (
  '00000000-0000-0000-0000-000000000000-en',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'Title english'
);

INSERT INTO informea_documents_title VALUES (
  '00000000-0000-0000-0000-000000000000-fr',
  '00000000-0000-0000-0000-000000000000',
  'fr',
  'Title french'
);

--
-- informea_documents_authors
--
DROP TABLE IF EXISTS informea_documents_authors;
CREATE TABLE informea_documents_authors (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  type VARCHAR(32),
  name VARCHAR(255)
);
DELETE FROM informea_documents_authors;
INSERT INTO informea_documents_authors VALUES (
  '00000000-0000-0000-0000-000000000000-1',
  '00000000-0000-0000-0000-000000000000',
  'Person',
  'Cristian Romanescu'
);
INSERT INTO informea_documents_authors VALUES (
  '00000000-0000-0000-0000-000000000000-2',
  '00000000-0000-0000-0000-000000000000',
  'Company',
  'John Doe'
);

--
-- informea_documents_description
--
DROP TABLE IF EXISTS informea_documents_description;
CREATE TABLE informea_documents_description (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  language VARCHAR(2),
  value TEXT
);
DELETE FROM informea_documents_description;
INSERT INTO informea_documents_description VALUES (
  '00000000-0000-0000-0000-000000000000-en',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'Description english'
);
INSERT INTO informea_documents_description VALUES (
  '00000000-0000-0000-0000-000000000000-fr',
  '00000000-0000-0000-0000-000000000000',
  'fr',
  'Description french'
);

--
-- informea_documents_identifiers
--
DROP TABLE IF EXISTS informea_documents_identifiers;
CREATE TABLE informea_documents_identifiers (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  name VARCHAR(255),
  value VARCHAR(255)
);
DELETE FROM informea_documents_identifiers;
INSERT INTO informea_documents_identifiers VALUES (
  '00000000-0000-0000-0000-000000000000-1',
  '00000000-0000-0000-0000-000000000000',
  'Identifier 1',
  'Value 1'
);
INSERT INTO informea_documents_identifiers VALUES (
  '00000000-0000-0000-0000-000000000000-2',
  '00000000-0000-0000-0000-000000000000',
  'Identifier 2',
  'Value 2'
);

--
-- informea_documents_files
--
DROP TABLE IF EXISTS informea_documents_files;
CREATE TABLE informea_documents_files (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  url VARCHAR(255),
  content TEXT,
  mimeType VARCHAR(64),
  language VARCHAR(2),
  filename VARCHAR(255)
);
DELETE FROM informea_documents_files;
INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-en-pdf',
  '00000000-0000-0000-0000-000000000000',
  'Url 1',
  'Content 1',
  'Mime 1',
  'en',
  'filename1.pdf'
);
INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-en-doc',
  '00000000-0000-0000-0000-000000000000',
  'Url 2',
  'Content 2',
  'Mime 2',
  'en',
  'filename2.doc'
);

INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-fr-pdf',
  '00000000-0000-0000-0000-000000000000',
  'Url 3',
  'Content 3',
  'Mime 3',
  'fr',
  'filename3.pdf'
);
--
-- informea_documents
--
DROP TABLE IF EXISTS informea_documents;
CREATE TABLE informea_documents (
  `id` VARCHAR(36) PRIMARY KEY,
  schemaversion INT,
  published DATETIME,
  `updated` DATETIME,
  treaty VARCHAR(255),
  thumbnailUrl VARCHAR(255),
  displayOrder INT,
  country VARCHAR(2)
);

DELETE FROM informea_documents;
INSERT INTO informea_documents VALUES (
  '00000000-0000-0000-0000-000000000000',
  1,
  '2008-10-02 12:34:56',
  '2014-06-16 13:05:13',
  'cms',
  'http://www.cms.int/sites/default/filespublication/gorilla_0_3_0_0.jpg',
  '2',
  'RO'
);

--
-- informea_documents_authors
--
DROP TABLE IF EXISTS informea_documents_authors;
CREATE TABLE informea_documents_authors (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  type VARCHAR(32),
  name VARCHAR(255)
);
DELETE FROM informea_documents_authors;
INSERT INTO informea_documents_authors VALUES (
  '00000000-0000-0000-0000-000000000000-1',
  '00000000-0000-0000-0000-000000000000',
  'Person',
  'Cristian Romanescu'
);
INSERT INTO informea_documents_authors VALUES (
  '00000000-0000-0000-0000-000000000000-2',
  '00000000-0000-0000-0000-000000000000',
  'Company',
  'John Doe'
);

--
-- informea_documents_description
--
DROP TABLE IF EXISTS informea_documents_description;
CREATE TABLE informea_documents_description (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  language VARCHAR(2),
  value TEXT
);
DELETE FROM informea_documents_description;
INSERT INTO informea_documents_description VALUES (
  '00000000-0000-0000-0000-000000000000-en',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'Description english'
);
INSERT INTO informea_documents_description VALUES (
  '00000000-0000-0000-0000-000000000000-fr',
  '00000000-0000-0000-0000-000000000000',
  'fr',
  'Description french'
);

--
-- informea_documents_identifiers
--
DROP TABLE IF EXISTS informea_documents_identifiers;
CREATE TABLE informea_documents_identifiers (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  name VARCHAR(255),
  value VARCHAR(255)
);
DELETE FROM informea_documents_identifiers;
INSERT INTO informea_documents_identifiers VALUES (
  '00000000-0000-0000-0000-000000000000-1',
  '00000000-0000-0000-0000-000000000000',
  'Identifier 1',
  'Value 1'
);
INSERT INTO informea_documents_identifiers VALUES (
  '00000000-0000-0000-0000-000000000000-2',
  '00000000-0000-0000-0000-000000000000',
  'Identifier 2',
  'Value 2'
);

--
-- informea_documents_files
--
DROP TABLE IF EXISTS informea_documents_files;
CREATE TABLE informea_documents_files (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  url VARCHAR(255),
  content TEXT,
  mimeType VARCHAR(64),
  language VARCHAR(2),
  filename VARCHAR(255)
);
DELETE FROM informea_documents_files;
INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-en-pdf',
  '00000000-0000-0000-0000-000000000000',
  'Url 1',
  'Content 1',
  'Mime 1',
  'en',
  'filename1.pdf'
);
INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-en-doc',
  '00000000-0000-0000-0000-000000000000',
  'Url 2',
  'Content 2',
  'Mime 2',
  'en',
  'filename2.doc'
);

INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-fr-pdf',
  '00000000-0000-0000-0000-000000000000',
  'Url 3',
  'Content 3',
  'Mime 3',
  'fr',
  'filename3.pdf'
);

--
-- informea_documents_keywords
--
DROP TABLE IF EXISTS informea_documents_keywords;
CREATE TABLE informea_documents_keywords (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  termURI VARCHAR(255),
  scope VARCHAR(255),
  literalForm VARCHAR(64),
  sourceURL VARCHAR(255)
);
DELETE FROM informea_documents_keywords;
INSERT INTO informea_documents_keywords VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'http://www.informea.org/term/acceptance',
  'InforMEA',
  'Acceptance',
  'http://www.informea.org/taxonomy/term/1135'
);

INSERT INTO informea_documents_keywords VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'Uri 2',
  'Scope 2',
  'Term 2',
  'Source URL 2'
);

--
-- informea_documents_references
--
DROP TABLE IF EXISTS informea_documents_references;
CREATE TABLE informea_documents_references (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  type VARCHAR(255),
  refId VARCHAR(255)
);
DELETE FROM informea_documents_references;
INSERT INTO informea_documents_references VALUES (
  '00000000-0000-0000-0000-000000000000-r1',
  '00000000-0000-0000-0000-000000000000',
  'meeting',
  '00000000-0000-0000-0000-000000000001'
);

INSERT INTO informea_documents_references VALUES (
  '00000000-0000-0000-0000-000000000000-r2',
  '00000000-0000-0000-0000-000000000000',
  'decision',
  '00000000-0000-0000-0000-000000000002'
);


--
-- informea_documents_types
--
DROP TABLE IF EXISTS informea_documents_types;
CREATE TABLE informea_documents_types (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  value VARCHAR(255)
);
DELETE FROM informea_documents_types;
INSERT INTO informea_documents_types VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'Technical Series'
);

INSERT INTO informea_documents_types VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'Publication'
);

--
-- informea_documents_tags
--
DROP TABLE IF EXISTS informea_documents_tags;
CREATE TABLE informea_documents_tags (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  language VARCHAR(2),
  scope VARCHAR(255),
  value VARCHAR(255),
  comment VARCHAR(255)
);
DELETE FROM informea_documents_tags;
INSERT INTO informea_documents_tags VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'BRS',
  'Chemical',
  'Custom term'
);

INSERT INTO informea_documents_tags VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'BRS',
  'DDT',
  'Test term'
);

--
-- informea_documents_treaties
--
DROP TABLE IF EXISTS informea_documents_treaties;
CREATE TABLE informea_documents_treaties (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  treaty VARCHAR(255)
);
DELETE FROM informea_documents_treaties;
INSERT INTO informea_documents_treaties VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'cms'
);

INSERT INTO informea_documents_treaties VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'aewa'
);

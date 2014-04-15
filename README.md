This is a test repository for legacy NoteTab-generated EAD files being prepared for migration into Archivists' Toolkit (and ultimately ArchivesSpace). This space is only to test out the process. The official repository will reside elsewhere.

Directories:

1_rbmscl_master_EADs
--------------------
* A copy of the master xml files for notetab-generated finding aids

2_schema_valid_EADs
-------------------
* XML files after running through dtd2schema.xsl to convert from 2002 EAD DTD to W3C schema

3_processed_EADs
----------------
* XML files after AT-import-fixer.xsl transform, which readies them for AT migration

xsl
---
* dtd2schema.xsl -- transforms EADs from 2002 EAD DTD to Schema
* AT-import-fixer.xsl -- transforms the schema-ready EADs into AT-ready form

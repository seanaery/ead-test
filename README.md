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

other_files
-----------
* controlaccess_extracted.txt -- a tabbed file of controlaccess terms extracted from schema-valid-EADs folder, used to import to GoogleRefine for cleaning
* controlaccess_cleaned.xls -- a spreadsheet generated from GoogleRefine contains old and cleaned up controlaccess terms, used to export controlaccess-cleaner-dataset.xml in xsl folder.
* controlaccess-mapping-schema.xml -- a dummy xml record that Excel uses to associate a schema with spreadsheet, and output records in proper xml format
* eadid2rlid_extracted.xml -- an xml file with eadid values extracted from schema-valid-EADs folder using eadid-extractor.xsl in xsl folder
* eadid2rlid_mapping.xlsx -- a spreadsheet view of eadid2rlid-extracted.xml with mappings from eadid values to rlid values.  This file can be exported as xml (xsl/eadid2rlid-dataset.xml) for use by AT-import-fixer.xsl

xsl
---
* dtd2schema.xsl -- transforms EADs from 2002 EAD DTD to Schema
* AT-import-fixer.xsl -- transforms the schema-ready EADs into AT-ready form
* eadid_extractor.xsl -- extracts eadid values from schema-valid-EADs into eadid2rlid.txt
* eadid2rlid_dataset.xml -- XML file containing eadid to rlid mappings, file is accessed by AT-import-fixer.xsl to insert rlids in <unitid> tag.  File is exported from otherfiles/eadid2rlid-mapping.xslx spreadsheet
* controlaccess_extractor.xsl -- extracts controlaccess terms, term type, and eadid, from EADs in 2-schema-valid-EADs. Used to produce old term | cleaned term mappings
* controlaccess-cleaner-dataset.xml -- XML file containing mappings from old extracted controlaccess terms to terms cleaned up using GoogleRefine.  This file is accessed by AT-import-fixer.xsl to replace old terms with new terms during processing.
* container-type-list.xsl -- extracts list of container types and labels used in rbmscl EADs.  This file is only used to identify issues.  It is not involved in processing any files.

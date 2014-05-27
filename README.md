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
* controlaccess_cleaned-txt.xls -- a spreadsheet generated from GoogleRefine contains old and cleaned up controlaccess terms, used to export controlaccess-cleaner-dataset.xml in xsl folder.
* controlaccess-mapping-schema.xml -- a fake xml record that Excel uses to associate schema with spreadsheet, and output records in proper xml format
* eadid2rlid_tsv.txt -- a tabbed text file of eadid values and rlid values extracted from schema-valid-EADs folder using eadid-extractor.xsl in xsl folder
* eadid2rlid_mapping.xlsx -- a spreadsheet with mappings from eadid values to rlid values, used to generate 
eadid2rl_dataset.xml in xsl folder
* eadid2rl_schema.xml -- a fake xml record that Excel uses to associate schema with spreadsheet, and ouput records in proper xml format

xsl
---
* dtd2schema.xsl -- transforms EADs from 2002 EAD DTD to Schema
* AT-import-fixer.xsl -- transforms the schema-ready EADs into AT-ready form
* eadid_extractor.xsl -- extracts eadid values from schema-valid-EADs into eadid2rlid.txt
* eadid2rl_dataset.xml -- XML file containing eadid to rlid mappings, file is accessed by AT-import-fixer.xsl to insert rlids in <unitid> tag
* controlaccess_extractor.xsl -- extracts controlaccess terms, term type, and eadid, from EADs in 2-schema-valid-EADs. Used to produce old term | cleaned term mappings
* controlaccess-cleaner-dataset.xml -- XML file containing mappings from old extracted controlaccess terms to terms cleaned up using GoogleRefine.  This file is accessed by AT-import-fixer.xsl to replace old terms with new terms during processing.
* container-type-list.xsl -- extracts list of contain types and labels used in rbmscl EADs.  This file is only used to identify issues.  It is not involved in processing files.

Test Stuff Added from Windows
------------------------
* just added from Windows client to see how this works

Test Stuff Added in develop branch
----------------------------------
* created a develop branch and added this stuff there, then changed it.

aerytwo account added this

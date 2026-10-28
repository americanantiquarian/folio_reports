Reports intended for use by Cataloging staff.

## Contents

+ *AuthVocabCounts*<br/>
Lists counts of Authority records in the catalog for each vocabulary in use with the total number of records.
+ *AuthoritiesDeletedInDateRange*<br/>
Lists headings and vocabulary id number for authority records deleted in the specified range of dates (inclusive).
+ *CallNumberGenerators*<br/>
Lists all call number generators currently enabled for use in the Inventory app.
+ *Individual583Summary*<br/>
Lists counts of bibliographic records for each value of 583 $a (Action) for the specified cataloger in the specified date range.<br/>
Inputs: Cataloger's code used in 583 subfield $k (Action agent) and starting and ending dates to compare to 583 subfield $c (Time/date of action)
+ *MetadbRefreshTimes*<br/>
Lists the tables in Metadb which are refreshed less frequently, along with the start and end times for their last update. This includes the marc__t table, which refreshes approximately once an hour, and all tables in the folio_derived schema, which are refreshed overnight.
   - Folio Reporting does not correctly interpret the *timestamptz* data type, so the UTC offset is hard-coded into this query and will require manual editing when switching between Standard and Daylight Savings time.

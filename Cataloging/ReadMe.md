Reports intended for use by Cataloging staff.

## Contents

+ *MetadbRefreshTimes*<br/>
Lists the tables in Metadb which are refreshed less frequently, along with the start and end times for their last update. This includes the marc__t table, which refreshes approximately once an hour, and all tables in the folio_derived schema, which are refreshed overnight.
   - Folio Reporting does not correctly interpret the *timestamptz* data type, so the UTC offset is hard-coded into this query and will require manual editing when switching between Standard and Daylight Savings time

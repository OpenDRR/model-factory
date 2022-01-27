-- create table of row count of each table/view to help spot possible missing issues. 
-- code copied with modifications from https://stackoverflow.com/questions/2596670/how-do-you-find-the-row-count-for-all-your-tables-in-postgres


-- check row counts for each table/view
CREATE SCHEMA IF NOT EXISTS db_check;
DROP TABLE IF EXISTS db_check.table_view_checkrow;
CREATE TABLE db_check.table_view_checkrow AS
(
SELECT table_schema, 
       table_name, 
	   table_type,
       (xpath('/row/cnt/text()', xml_count))[1]::text::int AS row_count
FROM (
  SELECT table_name, table_schema,table_type, 
         query_to_xml(format('select count(*) as cnt from %I.%I', table_schema, table_name), false, true, '') as xml_count
  FROM information_schema.tables
	WHERE table_schema NOT IN ('public','pg_catalog','information_schema','tiger','tiger_data','topology')
) t
);
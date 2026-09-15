--metadb:function table_refresh_times

drop function if exists table_refresh_times;
create function table_refresh_times()
returns table(
	"schema" text,
	"table" text,
	start_day text,
	start_time text,
	end_time text
)
as $$
select tu.schema_name as "schema",
	tu.table_name as "table",
	to_char(tu.last_update - (tu.elapsed_real_time::text || ' minutes')::interval, 'YYYY-MM-DD') as start_day,
	to_char(tu.last_update - (tu.elapsed_real_time::text || ' minutes')::interval, 'HH12:MI:SS AM') as start_time,
	to_char(tu.last_update, 'HH12:MI:SS AM') as end_time
from metadb.table_update tu
order by tu.schema_name desc, tu.table_name;
$$
language sql
stable
parallel safe;

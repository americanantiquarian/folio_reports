--metadb:function individual_583_summary

drop function if exists individual_583_summary;
create function individual_583_summary(
	op_code text,
	start_date text,
	end_date text
)
returns table(
	activity,
	bib_count
)
as $$
with cat_act as (
	select rl.external_hrid as hrid,
		trim(both '"' from jsonb_path_query(mrl."content", '$.fields[*]."583".subfields[*]."a"')::text) as activity,
		trim(both '"' from jsonb_path_query(mrl."content", '$.fields[*]."583".subfields[*]."c"')::text) as act_date,
		trim(both '"' from jsonb_path_query(mrl."content", '$.fields[*]."583".subfields[*]."k"')::text) as cataloger
	from folio_source_record.marc_records_lb mrl 
	inner join folio_source_record.records_lb rl
		on mrl.id = rl.id
	where rl.state = 'ACTUAL'
		and rl.__current = true
		and rl.record_type = 'MARC_BIB'
)
select cat_act.activity,
	count(cat_act.hrid) as bib_count
from cat_act
where cat_act.cataloger = op_code
	and cat_act.act_date >= start_date
	and cat_act.act_date <= end_date
group by grouping sets(
	(activity),
	()
)
order by activity;
$$
language sql
stable
parallel safe;

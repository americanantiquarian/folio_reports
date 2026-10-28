--metadb:function crash_test_dummy

drop function if exists crash_test_dummy;
create function crash_test_dummy()
returns table(
	bib_id,
	activity
)
as $$
	select rl.external_hrid as bib_id,
		trim(both '"' from jsonb_path_query(mrl."content", '$.fields[*]."583".subfields[*]."a"')::text) as activity,
	from folio_source_record.marc_records_lb mrl 
	inner join folio_source_record.records_lb rl
		on mrl.id = rl.id
	where rl.state = 'ACTUAL'
		and rl.__current = true
		and rl.record_type = 'MARC_BIB'
		and rl.external_hrid = '344291';
$$
language sql
stable
parallel safe;

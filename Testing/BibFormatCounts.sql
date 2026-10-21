--metadb:function bib_format_counts

drop function if exists bib_format_counts;
create function bib_format_counts()
returns table(
	bib_format,
	bib_count
)
as $$
	select substring(mt."content", 7, 2) as bib_format,
		count(mt.srs_id) as bib_count
	from folio_source_record.marc__t mt 
		inner join folio_source_record.records_lb rl 
			on mt.instance_id = rl.external_id 
	where mt.field = '000'
		and substring(mt."content", 7, 1) <> 'z'
		and rl.state ='ACTUAL'
	group by (bib_format)
	order by bib_format;
$$
language sql
stable
parallel safe;

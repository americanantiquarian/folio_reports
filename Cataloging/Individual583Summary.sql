--metadb:function activity_583_summary

drop function if exists activity_583_summary;
create function activity_583_summary(
	op_code text,
	start_date text,
	end_date text
)
returns table(
	activity,
	bib_count
)
as $$
select mta."content" as activity,
	count(mtk.instance_hrid) as bib_count
from folio_source_record.marc__t mtk
inner join folio_source_record.marc__t mta
	on mtk.instance_id = mta.instance_id 
		and mtk.field = mta.field 
		and mtk.ord = mta.ord
inner join folio_source_record.marc__t mtc
	on mtk.instance_id = mtc.instance_id 
		and mtk.field = mtc.field 
		and mtk.ord = mtc.ord
where mtk.field = '583' 
	and mtk.sf = 'k'
	and mta.sf = 'a'
	and mtc.sf = 'c'
	and mtk."content" = op_code
	and mtc."content" >= start_date
	and mtc."content" <= end_date
group by grouping sets (
	(activity),
	()
)
order by activity;
$$
language sql
stable
parallel safe;

--metadb:function auth_deletes_by_dates

drop function if exists auth_deletes_by_dates;
create function auth_deletes_by_dates(
	start_date text
	end_date text
)
returns table(
	tag text,
	heading text,
	voc_id text
)
as $$
	select ads.heading_type_old as tag,
		ads.heading_old as heading,
		ads.authority_natural_id_old as voc_id
	from folio_entities_links.authority_data_stat ads 
	where ads.updated_at::date >= start_date::date
		and ads.updated_at::date <= end_date::date
		and ads."action" = 'DELETE'
	order by heading;
$$
language sql
stable
parallel safe;

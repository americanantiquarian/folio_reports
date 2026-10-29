--metadb:function auth_deletes_by_dates

drop function if exists auth_deletes_by_dates;
create function auth_deletes_by_dates(
	start_date text,
	end_date text
)
returns table(
	tag text,
	heading text,
	voc_id text,
	subj_use text,
	username text
)
as $$
	select distinct ads.heading_type_old as tag,
		ads.heading_old as heading,
		ads.authority_natural_id_old as voc_id,
		substring(jsonb_path_query(mrl."content", '$.fields[*]."008"')::text from 17 for 1) as subj_use,
		ut.username
	from folio_entities_links.authority_data_stat ads 
		inner join folio_source_record.records_lb__ rl 
			on ads.authority_id  = rl.external_id 
		inner join folio_source_record.marc_records_lb__ mrl 
			on rl.id = mrl.id 
		left join folio_users.users__t ut
			on rl.updated_by_user_id = ut.id
	where ads.updated_at::date >= start_date::date
		and ads.updated_at::date <= end_date::date
		and ads."action" = 'DELETE'
		and rl.__current = true
		and rl.state = 'DELETED'
	order by heading;
$$
language sql
stable
parallel safe;

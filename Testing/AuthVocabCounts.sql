--metadb:function auth_vocab_counts

drop function if exists auth_vocab_counts;
create function auth_vocab_counts()
returns table(
	vocab text,
	auth_count text
)
as $$
	select asf.name as vocab,
		to_char(count(a.id), S999,999) as auth_count
	from folio_entities_links.authority a
		inner join folio_entities_links.authority_source_file asf
			on a.source_file_id = asf.id	
	where a.deleted = false
	group by grouping sets (
		(vocab),
		()
	)
	order by vocab;
$$
language sql
stable
parallel safe;

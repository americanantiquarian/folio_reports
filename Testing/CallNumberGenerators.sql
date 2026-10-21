--metadb:function call_number_generators

drop function if exists call_number_generators;
create function call_number_generators()
returns table(
	generator text,
	template text,
	next_value integer
)
as $$
	select ngs.ngs_name as generator,
		--can't include leading dollar sign and surrounding brackets when look for position of generated_number
		overlay(ngs.ngs_output_template placing ngs.ngs_format from position('generated_number' in ngs.ngs_output_template) - 2 for 19) as template,
		ngs.ngs_next_value as next_value
	from folio_service_interaction.number_generator_sequence ngs 
		inner join folio_service_interaction.number_generator ng
			on ngs.ngs_owner = ng.ng_id 
	where ng.ng_code = 'inventory_callNumber'
		and ngs.ngs_enabled = true
	order by generator;
$$
language sql
stable
parallel safe;
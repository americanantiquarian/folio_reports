--metadb:function budget_snapshot

drop function if exists budget_snapshot
create function budget_snapshot(
	FY_code text default 'FY2027'
)
returns table(
	FundGroup text,
	FundCode text,
	FundName text,
	initial_allocation money,
	allocation_to money,
	allocation_from money,
	CalcTotalAllocated money,
	net_transfers money,
	CalcTotalFunding money,
	allocated money,
	encumbered money,
	expenditures money,
	awaiting_payment money,
	credits money,
	CalcUnavailable money,
	CalcCashBalance money,
	CalcAvailBalance money
)
as $$
	select gps."name" as FundGroup,
		fun.code as FundCode,
		fun."name" as FundName,
		bud.initial_allocation::money,
		bud.allocation_to::money,
		bud.allocation_from::money,
		(bud.initial_allocation + bud.allocation_to - bud.allocation_from)::money as CalcTotalAllocated,
		bud.net_transfers::money,
		(bud.initial_allocation + bud.allocation_to - bud.allocation_from - bud.net_transfers)::money as CalcTotalFunding,
		bud.allocated::money,
		bud.encumbered::money,
		bud.expenditures::money,
		bud.awaiting_payment::money,
		bud.credits::money,
		(bud.encumbered + bud.awaiting_payment + bud.expenditures - bud.credits)::money as CalcUnavailable,
		((bud.initial_allocation + bud.allocation_to - bud.allocation_from - bud.net_transfers) - (bud.expenditures - bud.credits))::money as CalcCashBalance,	
		((bud.initial_allocation + bud.allocation_to - bud.allocation_from - bud.net_transfers) - (bud.encumbered + bud.awaiting_payment + bud.expenditures - bud.credits))::money as CalcAvailBalance
	from folio_finance.budget__t bud
	inner join folio_finance.fund__t fun
		on bud.fund_id::uuid = fun.id
	inner join folio_finance.group_fund_fiscal_year__t gffy
		on bud.id = gffy.budget_id::uuid
	inner join folio_finance.groups__t gps
		on gffy.group_id::uuid = gps.id
	where lower(bud.name) like '%-'||lower(FY_code)
	order by FundGroup, FundName;
$$
language sql
stable
parallel safe;

use crm_new;

-- Opportunity
select * from crm_new.oppertunity_table;
select Opportunity_ID, Expected_Amount from crm_new.oppertunity_table
where won = "TRUE";

select sum(expected_amount) from crm_new.oppertunity_table;

-- Active Opportunities
select opportunity_id, forecast_category1 from crm_new.oppertunity_table
where forecast_category1 = "pipeline";

select count(opportunity_id) from crm_new.oppertunity_table
where forecast_category1 = "pipeline";

-- Conversion rate
select opportunity_id, probability from crm_new.oppertunity_table
where Probability = 100;

select count(opportunity_id) from crm_new.oppertunity_table
where Probability=100;
select count(opportunity_id) from crm_new.oppertunity_table;
select count(opportunity_id) from crm_new.opportunity_product;

# conversion rate
# total opportunities 
select count(opportunity_id) from crm_new.oppertunity_table 
left join
crm_new.opportunity_product 
Using (Opportunity_ID);         # 11424

# opportunities having conversion rate 100%
select count(opportunity_id) from crm_new.oppertunity_table
left join
crm_new.opportunity_product
Using (opportunity_id)
where probability = 100;  #3139

# conversion rate is
select (11424/3139) as conversion_rate;    # 3.6% 

-- win rate
# win rate = (total opportunities/ opportunities having satge closed won)

# total opportunities 
select count(opportunity_id) from crm_new.oppertunity_table 
left join
crm_new.opportunity_product 
Using (Opportunity_ID);         # 11424

# opportunities count having stage is closed won
select count(opportunity_id) from crm_new.oppertunity_table
left join
crm_new.opportunity_product
Using (opportunity_id)
where stage = "Closed Won";  #3134

# win rate is
select (11424/3134) as win_rate;    # 3.64% 

-- Loss

# loss rate = (total opportunities/ opportunities having stage closed lost)

# total opportunities 
select count(opportunity_id) from crm_new.oppertunity_table 
left join
crm_new.opportunity_product 
Using (Opportunity_ID);         # 11424

# opportunities count having stage closed lost
select count(opportunity_id) from crm_new.oppertunity_table
left join
crm_new.opportunity_product
Using (opportunity_id)
where stage = "Closed lost";  # 4304

# loss rate is
select (11424/4304) as loss_rate;    # 2.65% 

-- Expected_amount by oppertunity_type
select opportunity_type, sum(Expected_Amount) as Expected_amount from oppertunity_table
group by opportunity_type
order by Expected_amount desc;

-- opportunities by industry
select industry, count(opportunity_id) from oppertunity_table
group by industry
order by count(opportunity_id) desc;

-- Trend Analysis
# Running Total Expected Vs commit forecast amount over time.

select * from crm_new.oppertunity_table;

drop view trend_analysis1;
create view trend_analysis1
 as select forecast_category1, Created_date, amount,(CASE WHEN forecast_category1 = "Commit" then amount end ) as commit_forecast_amount ,
sum(expected_amount) OVER (partition by YEAR(created_date) order by created_date) as Y_running_expected_amount,
sum(expected_amount) OVER (partition by MONTH(created_date) order by created_date) as Y_running_expected_amount2 from crm_new.oppertunity_table ;

select * from trend_analysis1;
select created_date, commit_forecast_amount, Y_running_expected_amount from trend_analysis1
where forecast_category1 = "Commit";



# Running total active vs total opportunities over time

select * from crm_new.opportunity_product;

rollback;

Update crm_new.opportunity_product
set total_price = replace(total_price,'$',''), Subtotal = replace(Subtotal,'$',''), sales_price = replace(sales_price,'$',''), list_price = replace(list_price,'$','');

drop view Trend_analysis2;

create view Trend_analysis2
as select OP.opportunity_id, OP.created_date,OP.total_price, U.active
from opportunity_product OP
left join
User_table U
ON OP.created_by_id = U.created_by_id
order by active desc;

select * from Trend_analysis2;

select opportunity_id,Created_date,total_price,active,sum(total_price) over(partition by YEAR(created_date) order by created_date) as running_total_active,
count(opportunity_id) OVER (PARTITION BY YEAR(created_date) ORDER by created_date) as Y_total_opportunities
from Trend_analysis2;

# closed won vs total opportunities over time
drop view trend_analysis3;
create view trend_analysis3
as select  opportunity_id ,created_date,STAGE, (CASE WHEN WON = "TRUE" then "CLOSED WON" END ) as STAGE_NEW  from oppertunity_table
order by stage_new desc;

select * from trend_analysis3;

select created_date, opportunity_id, count(opportunity_id) over(partition by created_date order by opportunity_id) as total_opportunity_id,stage_new,
count(stage_new) over(partition by created_date order by opportunity_id) as closed_won from trend_analysis3;

# closed won vs total closed over time
drop view trend_analysis4;

create view trend_analysis4
as select O.created_date, O.opportunity_id, O.forecast_category1,O.stage, O.Won, (case when won = "TRUE" then "Closed Won" end) as closed_won , OP.Total_price from oppertunity_table O 
join
opportunity_product OP 
on (O.opportunity_id = OP.opportunity_id)
order by closed_won desc;

select created_date, opportunity_id, forecast_category1,closed_won, sum(total_price) over(partition by created_date) as total_closed from trend_analysis4
where forecast_category1 = "closed";
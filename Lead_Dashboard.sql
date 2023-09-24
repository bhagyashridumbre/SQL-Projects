use crm_new;
-----------------------------------------------------------------------------------------
use crm_new;
-----------------------------------------------------------
-- Formatting
drop table crm_new.lead;
rollback;
select * from crm_new.lead;

update crm_new.lead
set conversion_rate = replace(conversion_rate,'%','');

-- Total leads
select sum(Total_Leads) from crm_new.lead; # by agregating total leads
select count(lead_id) from crm_new.lead;  # by counting lead id

-- expected amount from converted leads
# for this we need to join lead and oppertunity_table.
drop table crm_new.lead;
drop table crm_new.oppertunity_table;

select * from crm_new.lead;
select * from crm_new.oppertunity_table;

## Expected Amount from Converted lead
select Lead_ID, Status, Converted_Account_ID, Converted_Opportunity_ID, Account_ID,Opportunity_ID,Expected_Amount from crm_new.Lead L
left join
crm_new.oppertunity_table O
on (L.Converted_Account_ID = O.Account_ID)
where Status = "Converted";

##  total sum of expected amount where lead is converted.
select sum(Expected_Amount) from crm_new.Lead L
left join
crm_new.oppertunity_table O
on (L.Converted_Account_ID = O.Account_ID)
where Status = "Converted";

-- Conversion Rate
## lead having conversion rate 100%
select Lead_ID, Conversion_Rate from crm_new.lead
where Conversion_Rate = 100;

select sum(total_leads) from crm_new.lead  # method1
where conversion_rate = 100;

select count(Lead_ID) from crm_new.lead  # method2
where Conversion_Rate = 100;

# here total leads are 10000 &
# total leads having conversion rate 100 are 1033
#conversion rate is
select (10000/1033) as conversion_rate;  # conversion rate is 9.6%

-- Converted Accounts
select * from crm_new.lead;

## Total Converted Accounts
select sum(Converted_Accounts) from crm_new.lead;

## converted Accounts
select Lead_ID, Converted_Account_ID,Converted_Accounts from crm_new.lead
where Converted_Accounts = 1;

-- Converted Opportunities
select sum(Converted_Opportunities) from crm_new.lead;

## converted opportunities
select Lead_ID, Converted_Opportunity_ID, Converted_Opportunities from crm_new.lead
where Converted_Opportunities = 1;

-- Lead by source
select * from crm_new.lead;

select Lead_Source, Sum(Total_Leads) from crm_new.lead
group by Lead_Source;

## converted leads by source
select Lead_Source,sum(Total_Leads) from crm_new.lead
where status = "Converted"
group by Lead_Source; 

-- Lead by Industry
select * from crm_new.lead;
select Industry, Sum(Total_Leads) from crm_new.lead
group by Industry;

## converted leads by Industry
select Industry,sum(Total_Leads) from crm_new.lead
where status = "Converted"
group by Industry; 
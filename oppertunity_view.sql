use crm_new;
--------------------------------------------------------------------------------------------------
# joining the table oppertunity_table and opportunity_product
drop view oppertunity_view;

create view oppertunity_view as 
select  O.Opportunity_id, O.expected_amount,O.Amount, O.closed,
O.stage,O.won,O.Opportunity_type, O.industry as industry_O, O.account_id,O.owner_id, O.forecast_category1,O.close_date,
OP.name_product,
OP.total_price,
OP.list_price,
OP.quantity,
OP.sales_price,
OP.subtotal,
OP.created_date as createddate_OP,
OP.opportunity_id as opportunityid_OP
FROM crm_new.opportunity_product AS OP
LEFT JOIN crm_new.oppertunity_table O on (O.opportunity_id = OP.opportunity_id)

UNION
select  O.Opportunity_id, O.expected_amount,O.Amount, O.closed,
O.stage,O.won,O.Opportunity_type, O.industry as industry_O, O.account_id,O.owner_id, O.forecast_category1,O.close_date,
OP.name_product,
OP.total_price,
OP.list_price,
OP.quantity,
OP.sales_price,
OP.subtotal,
OP.created_date as createddate_OP,
OP.opportunity_id as opportunityid_OP
FROM crm_new.opportunity_product AS OP
RIGHT JOIN crm_new.oppertunity_table O on (O.opportunity_id = OP.opportunity_id) or OP.opportunity_id is null
order by opportunity_id;
-----------------------------------------------------------------------------------------------------------
## joining oppertunity_view1 and account_table
drop view oppertunity_view2;
create view oppertunity_view2 as 
select  OV.Opportunity_id, OV.expected_amount,OV.Amount, OV.closed,
OV.stage,OV.won,OV.Opportunity_type, OV.industry_O, OV.account_id,OV.owner_id, OV.forecast_category1,OV.close_date,
OV.name_product,
OV.total_price,
OV.list_price,
OV.quantity,
OV.sales_price,
OV.subtotal,
OV.createddate_OP,
OV.opportunityid_OP,
A.account_id as accountid_A,
A.created_date as createddate_A,
A.Account_Name 
FROM crm_new.oppertunity_view AS OV
LEFT JOIN crm_new.Account A on (OV.Account_id = A.account_id)

UNION
select  OV.Opportunity_id, OV.expected_amount,OV.Amount, OV.closed,
OV.stage,OV.won,OV.Opportunity_type, OV.industry_O, OV.account_id,OV.owner_id, OV.forecast_category1,OV.close_date,
OV.name_product,
OV.total_price,
OV.list_price,
OV.quantity,
OV.sales_price,
OV.subtotal,
OV.createddate_OP,
OV.opportunityid_OP,
A.account_id as accountid_A,
A.created_date as createddate_A,
A.Account_Name 
FROM crm_new.oppertunity_view AS OV
RIGHT JOIN crm_new.Account A on (OV.Account_id = A.account_id) or OV.account_id is null
order by opportunity_id;
----------------------------------------------------------------------------------------------------------------
drop view oppertunity_view3;
create view oppertunity_view3 as 
select  OU.Opportunity_id, OU.expected_amount,OU.Amount, OU.closed,
OU.stage,OU.won,OU.Opportunity_type, OU.industry_O, OU.account_id,OU.owner_id, OU.forecast_category1,OU.close_date,
OU.name_product,
OU.total_price,
OU.list_price,
OU.quantity,
OU.sales_price,
OU.subtotal,
OU.createddate_OP,
OU.opportunityid_OP,
OU.accountid_A,
OU.createddate_A,
OU.Account_Name,
U.active,
U.user_id,
U.created_date as createddte_U
FROM crm_new.oppertunity_view2 AS OU
LEFT JOIN crm_new.user_table U on (OU.owner_id = U.user_id)

UNION
select  OU.Opportunity_id, OU.expected_amount,OU.Amount, OU.closed,
OU.stage,OU.won,OU.Opportunity_type, OU.industry_O, OU.account_id,OU.owner_id, OU.forecast_category1,OU.close_date,
OU.name_product,
OU.total_price,
OU.list_price,
OU.quantity,
OU.sales_price,
OU.subtotal,
OU.createddate_OP,
OU.opportunityid_OP,
OU.accountid_A,
OU.createddate_A,
OU.Account_Name,
U.active,
U.user_id,
U.created_date as createddte_U
FROM crm_new.oppertunity_view2 AS OU
RIGHT JOIN crm_new.user_table U on (OU.owner_id = U.user_id) or OU.owner_id is null
order by opportunity_id;
-------------------------------------------------------------------------------------------
select count(opportunity_id) from oppertunity_view3;
select count(opportunityid_OP) from oppertunity_view3;
select count(account_id) from oppertunity_view3;
select count(user_id) from oppertunity_view3;
select * from oppertunity_view3;

------------------------------------------------------------------------------------------------------------------

drop view crm_viewnew;

create view crm_viewnew as
select LV.expected_amount,LV.Amount, LV.closed,
LV.stage,LV.won,LV.Opportunity_type, LV.industry_O, LV.account_id,LV.owner_id, LV.forecast_category1,LV.close_date,
LV.Lead_id, LV.status,LV.Converted_Opportunity_ID,LV.CONVERSION_RATE,LV.Converted_Accounts,LV.Converted_Account_ID,LV.Converted_Opportunities,
LV.lead_source,LV.industry_L,LV.lead_type,LV.createddate_L,LV.last_status_change,LV.total_leads,
OV1.Opportunity_id,OV1.name_product,OV1.total_price,OV1.list_price,OV1.quantity,OV1.sales_price,OV1.subtotal,OV1.createddate_OP,
OV1.opportunityid_OP,
OV1.accountid_A,
OV1.createddate_A,
OV1.active,
OV1.user_id,
OV1.createddte_U
FROM crm_new.LEAD_VIEW AS LV
LEFT JOIN crm_new.Oppertunity_view3 OV1 on (LV.opportunity_id = OV1.opportunity_id)

UNION

select  LV.expected_amount,LV.Amount, LV.closed,
LV.stage,LV.won,LV.Opportunity_type, LV.industry_O, LV.account_id,LV.owner_id, LV.forecast_category1,LV.close_date,
LV.Lead_id, LV.status,LV.Converted_Opportunity_ID,LV.CONVERSION_RATE,LV.Converted_Accounts,LV.Converted_Account_ID,LV.Converted_Opportunities,
LV.lead_source,LV.industry_L,LV.lead_type,LV.createddate_L,LV.last_status_change,LV.total_leads,
OV1.Opportunity_id,OV1.name_product,OV1.total_price,OV1.list_price,OV1.quantity,OV1.sales_price,OV1.subtotal,OV1.createddate_OP,
OV1.opportunityid_OP,
OV1.accountid_A,
OV1.createddate_A,
OV1.active,
OV1.user_id,
OV1.createddte_U
FROM crm_new.LEAD_VIEW AS LV
RIGHT JOIN crm_new.Oppertunity_view3 OV1 on (LV.account_id = OV1.accountid_A) or LV.account_id is null
order by opportunity_id;

select count(opportunity_id) from crm_viewnew;
select count(lead_id) from crm_viewnew;
select count(account_id) from oppertunity_view3;
select count(user_id) from oppertunity_view3;





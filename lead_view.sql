use crm_new;
 DROP view lead_view;
create view lead_view as
select  O.Opportunity_id, O.expected_amount,O.Amount, O.closed,
O.stage,O.won,O.Opportunity_type, O.industry as industry_O, O.account_id,O.owner_id, O.forecast_category1,O.close_date,
L.Lead_id, L.status,
L.Converted_Opportunity_ID, 
L.CONVERSION_RATE,
L.Converted_Accounts,
L.Converted_Account_ID,
L.Converted_Opportunities,
L.lead_source,
L.industry as industry_L,
L.lead_type,
L.created_date as createddate_L,
L.last_status_change,
L.total_leads
FROM crm_new.lead AS L
LEFT JOIN crm_new.Oppertunity_table as O on (O.opportunity_id = L.converted_opportunity_id)

UNION

select  O.Opportunity_id, O.expected_amount,O.Amount, O.closed,
O.stage,O.won,O.Opportunity_type, O.industry as industry_O, O.account_id,O.owner_id, O.forecast_category1,O.close_date,
L.Lead_id, L.status,
L.Converted_Opportunity_ID, 
L.CONVERSION_RATE,
L.Converted_Accounts,
L.Converted_Account_ID,
L.Converted_Opportunities,
L.lead_source,
L.industry as industry_L,
L.lead_type,
L.created_date as createddate_L,
L.last_status_change,
L.total_leads
FROM crm_new.lead AS L
RIGHT JOIN crm_new.Oppertunity_table as O on (O.opportunity_id = L.converted_opportunity_id);

select count(total_leads) from lead_view;
select count(opportunity_id) from lead_view;
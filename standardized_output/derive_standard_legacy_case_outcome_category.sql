------------------------------
--
-- This SQL script derives the SNOMED-CT concept codes for the FAERS outcome (categories) legacy data in a new table called standard_legacy_case_outcome_category, limited to just the unique legacy cases
--
-- Map the outcome categories to the following SNOMED codes:
--
-- CA "Congenital Anomaly" = SNOMED concept code: 107656002, SNOMED concept: "Congenital anomaly", OHDSI concept_id = 4029540
-- DE "Death" = SNOMED concept code: 419620001, SNOMED concept: "Death" , OHDSI concept_id = 4306655
-- DS "Disability" = SNOMED concept code: 21134002, SNOMED concept: "Disability", OHDSI concept_id = 4052648
-- HO "Hospitalization - Initial or Prolonged" = SNOMED concept code: 32485007, SNOMED concept: "Hospital admission", OHDSI concept_id = 8715
-- LT "Life-Threatening" = SNOMED concept code: 442452003, SNOMED concept: "Life threatening severity" OHDSI, concept_id = 40483553
-- OT "Other" = SNOMED concept code: 10003008, SNOMED concept: "Non-specific", OHDSI concept_id = 4001594
-- RI "Required Intervention to Prevent Permanent Impairment/Damage" = SNOMED concept code: 3890004, SNOMED concept: "Treatment required for", OHDSI concept_id = 4191370
--
-- NOTE. Around a quarter of the cases in the FAERS demo table do not have an outcome in the outc table so in this sql we use a left outer join and some of the outc_codes will be null.
--
-- LTS COMPUTING LLC
------------------------------

set search_path = faers;

drop table if exists standard_legacy_case_outcome_category;
create table standard_legacy_case_outcome_category as
(
	with cte1 as (
	select distinct a.isr, b.outc_cod
	from unique_case_legacy a
	left outer join outc_legacy b
	on a.isr = b.isr
	),
	cte2 as (
	select isr, outc_cod, 
	case 
	when (outc_cod = 'CA') then 4029540 	-- SNOMED concept: "Congenital anomaly", OHDSI concept_id = 4029540
	when (outc_cod = 'DE') then 4306655 	-- SNOMED concept: "Death" , OHDSI concept_id = 4306655
	when (outc_cod = 'DS') then 4052648  	-- SNOMED concept: "Disability", OHDSI concept_id = 4052648
	when (outc_cod = 'HO') then 8715		-- SNOMED concept: "Hospital admission", OHDSI concept_id = 8715
	when (outc_cod = 'LT') then 40483553	-- SNOMED concept: "Life threatening severity" OHDSI, concept_id = 40483553
	when (outc_cod = 'OT') then 4001594	-- SNOMED concept: "Non-specific", OHDSI concept_id = 4001594
	when (outc_cod = 'RI') then 4191370	-- SNOMED concept: "Treatment required for", OHDSI concept_id = 4191370
	end as snomed_concept_id
	from cte1
	)
select * from cte2
);
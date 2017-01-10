--º®–ß≤‚ ‘
SELECT DIM_STAGE.L_STAGEID, DIM_STAGE.L_PROJECTID, DIM_STAGE.C_STAGE_CODE, DIM_QUARTER.QUARTER_ID 
FROM
 DIM_STAGE, DIM_QUARTER 
WHERE
 (1 = 0 and DIM_QUARTER.QUARTER_DATE <= to_date(20150624,'YYYYMMDD'))
or
(1 = 1 and DIM_QUARTER.QUARTER_DATE <= to_date(20150624,'YYYYMMDD')
and
DIM_QUARTER.QUARTER_DATE > to_date(20141231,'YYYYMMDD'))
and
DIM_STAGE.C_STAGE_CODE = 'E913-001';

select * from tt_kpi_income_quarter t where t.l_projectid = 163 and t.l_stageid = 59 order by t.l_quarterid desc;

select * from dim_stage t where t.l_stageid = 59;

select * from dim_projectinfo t where t.c_projectcode = 'E913';

select * from dim_stage t where t.c_stage_code = 'E913-001' for update;

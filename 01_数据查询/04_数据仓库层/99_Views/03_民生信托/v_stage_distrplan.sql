create or replace view v_stage_distrplan as
select td.c_projectcode,
         td.c_stagescode,
         td.l_period,
         td.d_plandate,
         td.f_calcbase,                  --本金金额
         td.f_rate,                      --收益率
         td.c_rpclass,
         td.f_money,
         td.l_writeoff
from dataods.tta_distrplan td;

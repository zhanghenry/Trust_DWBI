create or replace view v_stage_rep as
select
t.c_stagescode,
t.d_plandate,
t.c_rpclass,
t.f_money
from dataods.tam_repayplan t;

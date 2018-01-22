create or replace view v_stage_status as
select d1.l_stage_id,
       d2.l_dayid,
       MAX(case
             when substr(d1.l_setup_date, 0, 4) >= substr(d2.l_dayid, 0, 4) then
              'ĞÂÔö'
             else
              '´æĞø'
           end) c_stage_status
  from dim_sr_stage d1, dim_day d2
 group by d1.l_stage_id, d2.l_dayid;

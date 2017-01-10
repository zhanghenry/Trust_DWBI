--CRM份额汇总
select sum(case
             when t.c_busi_type in ('50', '02') then
              t.f_share
             else
              t.f_share * -1
           end)
  from tcr_share_change t;
  
--经纪人对应经纪团队
select b.c_broker_name,b.c_broker_code, b.c_team_code, a.c_team_name
  from tcr_broker_team a, tcr_broker b
 where a.c_team_code(+) = b.c_team_code
   and exists (select 1
          from tcr_broker_cust c
         where b.c_broker_code = c.c_broker_code);
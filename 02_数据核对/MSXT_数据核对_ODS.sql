--收入--项目-日
select a1.c_projectcode as c_grain, sum(a1.f_money) as f_value
  from tam_fareplan a1, tprojectinfo a2
 where a1.c_projectcode = a2.c_projectcode
   and to_char(a2.d_setup, 'yyyymmdd') <= 20170731
   and to_char(a1.d_plandate, 'yyyy') = '2017'
   and a1.l_fareflag in (1, 2, 3)
 group by a1.c_projectcode
union all
select b1.c_projectcode as c_grain, sum(b1.f_money) as f_value
  from tam_repayplan b1, tpm_project_innate b2
 where b1.c_projectcode = b2.c_projectcode
   and b1.l_busiscope = 0
   and to_char(b1.d_plandate, 'yyyy') = 2017
   and b1.c_rpclass in ('0201', '0202', '0203', '0204', '0299')
   and nvl(to_char(b2.d_setup, 'yyyymmdd'), '20170731') <= '20170731'
 group by b1.c_projectcode;

--收入--项目-月
select a2.c_projectcode as c_grain, sum(a1.f_money) as f_value
  from tam_fareplan a1,tpm_stagesinfo a2
 where a1.c_stagescode = a2.c_stagescode
   and to_char(a2.d_setup, 'yyyymm') <= 201706
   and to_char(a1.d_plandate, 'yyyy') = '2017'
   and a1.l_fareflag in (1,2,3)
 group by a2.c_projectcode
union all
select b1.c_projectcode as c_grain, sum(b1.f_money) as f_value
  from tam_repayplan b1, tpm_project_innate b2
 where b1.c_projectcode = b2.c_projectcode
   and b1.l_busiscope = 0
   and to_char(b1.d_plandate, 'yyyy') = 2017
   and b1.c_rpclass in ('0201', '0202', '0203', '0204', '0299')
   and (to_char(b2.d_setup, 'yyyymm') <= '201707' or b2.d_setup is null)
 group by b1.c_projectcode;
 
--收入--信托--日
select a.c_stagescode as c_grain,
sum(case when a.l_fareflag in(1,2)  then a.f_money when a.l_fareflag = 3 and a.l_payway in (1,2) then a.f_money*-1 when a.c_rpclass = '0299' then a.f_money* -1 else 0 end)/10000 as f_value
from (
select a1.d_plandate,
       a1.c_projectcode,
       a1.c_stagescode,
       a1.l_busiscope,
       a1.l_fareflag,
       a1.c_rpclass,
       a1.l_payway,
       a1.f_money,
       null as l_busitype
  from dataods.tam_fareplan a1
union all
select a2.d_plandate,
       a6.c_projectcode,
       a4.c_stagescode  as c_stagescode,
       a6.l_busiscope   as l_busiscope,
       null             as l_fareflag,
       a2.c_rpclass,
       null             as l_payway,
       a2.f_money,
       a7.l_busitype
  from dataods.tam_repayplan      a2,
       dataods.tpm_project_innate a3,
       dataods.tpm_stagesfund     a4,
       dataods.tpm_stagesinfo     a5,
       dataods.tprojectinfo       a6,
       dataods.tpm_project_innate a7
 where a2.c_projectcode = a3.c_projectcode
   and a3.c_investprod_code = a4.c_fundcode
   and a2.c_projectcode = a7.c_projectcode
   and a4.c_stagescode = a5.c_stagescode(+)
   and a5.c_projectcode = a6.c_projectcode(+)
   and a2.l_busiscope = 0) a,tpm_stagesinfo b
where  a.c_stagescode = b.c_stagescode 
and to_char(a.d_plandate, 'yyyy') = '2017'
and to_char(b.d_setup,'yyyymmdd') <= '20170731'
group by a.c_stagescode;

--收入--信托--月
select a.c_stagescode as c_grain,
sum(case when a.l_fareflag in(1,2)  then a.f_money when a.l_fareflag = 3 and a.l_payway in (1,2) then a.f_money*-1 when a.c_rpclass = '0299' then a.f_money* -1 else 0 end)/10000 as f_value
from (
select a1.d_plandate,
       a1.c_projectcode,
       a1.c_stagescode,
       a1.l_busiscope,
       a1.l_fareflag,
       a1.c_rpclass,
       a1.l_payway,
       a1.f_money,
       null as l_busitype
  from dataods.tam_fareplan a1
union all
select a2.d_plandate,
       a6.c_projectcode,
       a4.c_stagescode  as c_stagescode,
       a6.l_busiscope   as l_busiscope,
       null             as l_fareflag,
       a2.c_rpclass,
       null             as l_payway,
       a2.f_money,
       a7.l_busitype
  from dataods.tam_repayplan      a2,
       dataods.tpm_project_innate a3,
       dataods.tpm_stagesfund     a4,
       dataods.tpm_stagesinfo     a5,
       dataods.tprojectinfo       a6,
       dataods.tpm_project_innate a7
 where a2.c_projectcode = a3.c_projectcode
   and a3.c_investprod_code = a4.c_fundcode
   and a2.c_projectcode = a7.c_projectcode
   and a4.c_stagescode = a5.c_stagescode(+)
   and a5.c_projectcode = a6.c_projectcode(+)
   and a2.l_busiscope = 0) a,tpm_stagesinfo b
where  a.c_stagescode = b.c_stagescode 
and to_char(a.d_plandate, 'yyyy') = '2017'
and to_char(b.d_setup,'yyyymm') <= '201707'
group by a.c_stagescode;

--收入-自营收入-日
select a.c_projectcode as c_grain, sum(a.f_money) as f_value
  from tam_repayplan a,tpm_project_innate b
 where a.c_projectcode = b.c_projectcode
   and a.l_busiscope = 0
   and to_char(a.d_plandate, 'yyyy') = 2017
   and a.c_rpclass in ('0201', '0202', '0203', '0204', '0299')
   and nvl(to_char(b.d_setup,'yyyymmdd'),'20170731') <= '20170731'
 group by a.c_projectcode;
 
--收入-自营收入-月
select a.c_projectcode as c_grain, sum(a.f_money) as f_value
  from tam_repayplan a,tpm_project_innate b
 where a.c_projectcode = b.c_projectcode
   and a.l_busiscope = 0
   and to_char(a.d_plandate, 'yyyy') = 2017
   and a.c_rpclass in ('0201', '0202', '0203', '0204', '0299')
   and nvl(to_char(b.d_setup,'yyyymm'),'201707') <= '201707'
 group by a.c_projectcode;

--收入--信托新增-日
select a.c_stagescode as c_grain,
sum(case when a.l_fareflag in(1,2)  then a.f_money when a.l_fareflag = 3 and a.l_payway in (1,2) then a.f_money*-1 when a.c_rpclass = '0299' then a.f_money* -1 else 0 end) as f_value
from (
select a1.d_plandate,
       a1.c_projectcode,
       a1.c_stagescode,
       a1.l_busiscope,
       a1.l_fareflag,
       a1.c_rpclass,
       a1.l_payway,
       a1.f_money,
       null as l_busitype
  from dataods.tam_fareplan a1
union all
select a2.d_plandate,
       a6.c_projectcode,
       a4.c_stagescode  as c_stagescode,
       a6.l_busiscope   as l_busiscope,
       null             as l_fareflag,
       a2.c_rpclass,
       null             as l_payway,
       a2.f_money,
       a7.l_busitype
  from dataods.tam_repayplan      a2,
       dataods.tpm_project_innate a3,
       dataods.tpm_stagesfund     a4,
       dataods.tpm_stagesinfo     a5,
       dataods.tprojectinfo       a6,
       dataods.tpm_project_innate a7
 where a2.c_projectcode = a3.c_projectcode
   and a3.c_investprod_code = a4.c_fundcode
   and a2.c_projectcode = a7.c_projectcode
   and a4.c_stagescode = a5.c_stagescode(+)
   and a5.c_projectcode = a6.c_projectcode(+)
   and a2.l_busiscope = 0) a,tpm_stagesinfo b
where to_char(a.d_plandate, 'yyyy') = '2017' and a.c_stagescode = b.c_stagescode
and to_char(b.d_setup,'YYYYMMDD') <= '20170731' and to_char(b.d_setup,'YYYY') = '2017'
group by a.c_stagescode;

--收入--信托新增-月
select a.c_stagescode as c_grain,
sum(case when a.l_fareflag in(1,2)  then a.f_money when a.l_fareflag = 3 and a.l_payway in (1,2) then a.f_money*-1 when a.c_rpclass = '0299' then a.f_money* -1 else 0 end) as f_value
from (
select a1.d_plandate,
       a1.c_projectcode,
       a1.c_stagescode,
       a1.l_busiscope,
       a1.l_fareflag,
       a1.c_rpclass,
       a1.l_payway,
       a1.f_money,
       null as l_busitype
  from dataods.tam_fareplan a1
union all
select a2.d_plandate,
       a6.c_projectcode,
       a4.c_stagescode  as c_stagescode,
       a6.l_busiscope   as l_busiscope,
       null             as l_fareflag,
       a2.c_rpclass,
       null             as l_payway,
       a2.f_money,
       a7.l_busitype
  from dataods.tam_repayplan      a2,
       dataods.tpm_project_innate a3,
       dataods.tpm_stagesfund     a4,
       dataods.tpm_stagesinfo     a5,
       dataods.tprojectinfo       a6,
       dataods.tpm_project_innate a7
 where a2.c_projectcode = a3.c_projectcode
   and a3.c_investprod_code = a4.c_fundcode
   and a2.c_projectcode = a7.c_projectcode
   and a4.c_stagescode = a5.c_stagescode(+)
   and a5.c_projectcode = a6.c_projectcode(+)
   and a2.l_busiscope = 0) a,tpm_stagesinfo b
where to_char(a.d_plandate, 'yyyy') = '2017' and a.c_stagescode = b.c_stagescode
and to_char(b.d_setup,'YYYYMM') <= '201707' and to_char(b.d_setup,'YYYY') = '2017'
group by a.c_stagescode;

--分成后收入-日-部门-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) /
           (tt.d_expiration_max - tt.d_effective_min + 1) *
           tt.f_divide_rate * tt.f_sr)
  from (select greatest(b.d_bdate, d_effective_min) as d_effective,
               least(nvl(b.d_edate, to_date(:C_YEAR || '1231', 'yyyymmdd')),d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_ratio as f_divide_rate,
               a.c_stagescode as c_stage_code,
               a.f_sr
          from (select a.c_stagescode,
                       sum(case when a.l_fareflag in (1, 2) then a.f_money when a.l_fareflag = 3 and a.l_payway in (1, 2) then a.f_money * -1 when a.c_rpclass = '0299' then a.f_money * -1 else 0 end) as f_sr
                  from (select a1.d_plandate,
                               a1.c_projectcode,
                               a1.c_stagescode,
                               a1.l_busiscope,
                               a1.l_fareflag,
                               a1.c_rpclass,
                               a1.l_payway,
                               a1.f_money,
                               null as l_busitype
                          from dataods.tam_fareplan a1
                        union all
                        select a2.d_plandate,
                               a6.c_projectcode,
                               a4.c_stagescode  as c_stagescode,
                               a6.l_busiscope   as l_busiscope,
                               null             as l_fareflag,
                               a2.c_rpclass,
                               null             as l_payway,
                               a2.f_money,
                               a7.l_busitype
                          from dataods.tam_repayplan      a2,
                               dataods.tpm_project_innate a3,
                               dataods.tpm_stagesfund     a4,
                               dataods.tpm_stagesinfo     a5,
                               dataods.tprojectinfo       a6,
                               dataods.tpm_project_innate a7
                         where a2.c_projectcode = a3.c_projectcode
                           and a3.c_investprod_code = a4.c_fundcode
                           and a2.c_projectcode = a7.c_projectcode
                           and a4.c_stagescode = a5.c_stagescode(+)
                           and a5.c_projectcode = a6.c_projectcode(+)
                           and a2.l_busiscope = 0) a,
                       tpm_stagesinfo b
                 where a.c_stagescode = b.c_stagescode
                   and to_char(a.d_plandate, 'yyyy') = :C_YEAR
                   and to_char(b.d_setup, 'yyyymmdd') <= :C_DAY
                 group by a.c_stagescode) a,
               thr_dividescheme b,
               (select t.c_stagescode as c_stage_code,
                       min(t.d_bdate) as d_effective_min,
                       nvl(max(t.d_edate), to_date(:C_YEAR || '1231', 'yyyymmdd')) as d_expiration_max
                  from thr_dividescheme t
                 where t.l_divideway = 0
                   and t.c_level = 'BM'
                   and (to_char(t.d_edate, 'yyyy') >= :C_YEAR or t.d_edate is null)
                   and to_char(t.d_bdate, 'yyyy') <= :C_YEAR
                 group by t.c_stagescode) c,
               tpm_stagesinfo d,
               tprojectinfo e
         where a.c_stagescode = b.c_stagescode
           and a.c_stagescode = c.c_stage_code
           and a.c_stagescode = d.c_stagescode
           and d.c_projectcode = e.c_projectcode
           and b.l_divideway = 0
           and b.c_level = 'BM') tt
 group by tt.c_stage_code;
 
--分成后收入-日-员工-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) /
           (tt.d_expiration_max - tt.d_effective_min + 1) *
           tt.f_divide_rate * tt.f_sr)
  from (select greatest(b.d_bdate, d_effective_min) as d_effective,
               least(nvl(b.d_edate, to_date(:C_YEAR || '1231', 'yyyymmdd')),d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_ratio as f_divide_rate,
               a.c_stagescode as c_stage_code,
               a.f_sr
          from (select a.c_stagescode,
                       sum(case when a.l_fareflag in (1, 2) then a.f_money when a.l_fareflag = 3 and a.l_payway in (1, 2) then a.f_money * -1 when a.c_rpclass = '0299' then a.f_money * -1 else 0 end) as f_sr
                  from (select a1.d_plandate,
                               a1.c_projectcode,
                               a1.c_stagescode,
                               a1.l_busiscope,
                               a1.l_fareflag,
                               a1.c_rpclass,
                               a1.l_payway,
                               a1.f_money,
                               null as l_busitype
                          from dataods.tam_fareplan a1
                        union all
                        select a2.d_plandate,
                               a6.c_projectcode,
                               a4.c_stagescode  as c_stagescode,
                               a6.l_busiscope   as l_busiscope,
                               null             as l_fareflag,
                               a2.c_rpclass,
                               null             as l_payway,
                               a2.f_money,
                               a7.l_busitype
                          from dataods.tam_repayplan      a2,
                               dataods.tpm_project_innate a3,
                               dataods.tpm_stagesfund     a4,
                               dataods.tpm_stagesinfo     a5,
                               dataods.tprojectinfo       a6,
                               dataods.tpm_project_innate a7
                         where a2.c_projectcode = a3.c_projectcode
                           and a3.c_investprod_code = a4.c_fundcode
                           and a2.c_projectcode = a7.c_projectcode
                           and a4.c_stagescode = a5.c_stagescode(+)
                           and a5.c_projectcode = a6.c_projectcode(+)
                           and a2.l_busiscope = 0) a,
                       tpm_stagesinfo b
                 where a.c_stagescode = b.c_stagescode
                   and to_char(a.d_plandate, 'yyyy') = :C_YEAR
                   and to_char(b.d_setup, 'yyyymmdd') <= :C_DAY
                 group by a.c_stagescode) a,
               thr_dividescheme b,
               (select t.c_stagescode as c_stage_code,
                       min(t.d_bdate) as d_effective_min,
                       nvl(max(t.d_edate), to_date(:C_YEAR || '1231', 'yyyymmdd')) as d_expiration_max
                  from thr_dividescheme t
                 where t.l_divideway = 0
                   and t.c_level = 'YG'
                   and (to_char(t.d_edate, 'yyyy') >= :C_YEAR or t.d_edate is null)
                   and to_char(t.d_bdate, 'yyyy') <= :C_YEAR
                 group by t.c_stagescode) c,
               tpm_stagesinfo d,
               tprojectinfo e
         where a.c_stagescode = b.c_stagescode
           and a.c_stagescode = c.c_stage_code
           and a.c_stagescode = d.c_stagescode
           and d.c_projectcode = e.c_projectcode
           and b.l_divideway = 0
           and b.c_level = 'YG') tt
 group by tt.c_stage_code; 

--收入--信托存续-日月--不用
select a.c_stagescode as c_grain,
sum(case when a.l_fareflag in(1,2)  then a.f_money when a.l_fareflag = 3 and a.l_payway in (1,2) then a.f_money*-1 when a.c_rpclass = '0299' then a.f_money* -1 else 0 end)/10000 as f_value
from (
select a1.d_plandate,
       a1.c_projectcode,
       a1.c_stagescode,
       a1.l_busiscope,
       a1.l_fareflag,
       a1.c_rpclass,
       a1.l_payway,
       a1.f_money,
       null as l_busitype
  from dataods.tam_fareplan a1
union all
select a2.d_plandate,
       a6.c_projectcode,
       a4.c_stagescode  as c_stagescode,
       a6.l_busiscope   as l_busiscope,
       null             as l_fareflag,
       a2.c_rpclass,
       null             as l_payway,
       a2.f_money,
       a7.l_busitype
  from dataods.tam_repayplan      a2,
       dataods.tpm_project_innate a3,
       dataods.tpm_stagesfund     a4,
       dataods.tpm_stagesinfo     a5,
       dataods.tprojectinfo       a6,
       dataods.tpm_project_innate a7
 where a2.c_projectcode = a3.c_projectcode
   and a3.c_investprod_code = a4.c_fundcode
   and a2.c_projectcode = a7.c_projectcode
   and a4.c_stagescode = a5.c_stagescode(+)
   and a5.c_projectcode = a6.c_projectcode(+)
   and a2.l_busiscope = 0) a,tpm_stagesinfo b
where  to_char(a.d_plandate, 'yyyy') = '2017' and a.c_stagescode = b.c_stagescode
and to_char(b.d_setup,'YYYY') < '2017'
group by a.c_stagescode;

--规模-时点-日
 select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0 else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and to_char(a.d_varydate,'yyyymmdd') <= '20170731' group by a.c_stagescode;
    
--规模-时点-月
select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0 else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and to_char(a.d_varydate,'yyyymm') <= '201707' group by a.c_stagescode;

--规模-信托-日
select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0  else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.l_busiscope = 1
    and to_char(a.d_varydate,'yyyymmdd') <= '20170731' group by a.c_stagescode;

--规模-信托-月
select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0  else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.l_busiscope = 1
    and to_char(a.d_varydate,'yyyymm') <= '201707' group by a.c_stagescode;

--规模-基金-日
 select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0  else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.l_busiscope = 2
    and to_char(a.d_varydate,'yyyymmdd') <= '20170814' group by a.c_stagescode;

--规模-基金-月
 select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0  else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.l_busiscope = 2
    and to_char(a.d_varydate,'yyyymm') <= '201708' group by a.c_stagescode;
    
--规模-主动-日
 select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0 else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.c_managetype = '1'
    and to_char(a.d_varydate,'yyyymmdd') <= '20170814' group by a.c_stagescode;
    
--规模-主动-月
 select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0 else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.c_managetype = '1'
    and to_char(a.d_varydate,'yyyymm') <= '201708' group by a.c_stagescode;

--规模-被动-日
 select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0  else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.c_managetype <> '1'
    and to_char(a.d_varydate,'yyyymmdd') <= '20170814' group by a.c_stagescode;

--规模-被动-月
 select a.c_stagescode as c_grain,sum(case when c.c_propertytype_indiv = '1' and b.l_period <> 0 then 0  else a.f_scale end) as f_value
   from dataods.tta_saclevary  a,
        dataods.tpm_stagesinfo b,
        dataods.tprojectinfo   c
  where a.c_stagescode = b.c_stagescode
    and b.c_projectcode = c.c_projectcode
    and c.c_managetype <> '1'
    and to_char(a.d_varydate,'yyyymm') <= '201708' group by a.c_stagescode;

--分成后规模-日-部门-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) / (tt.d_expiration_max - tt.d_effective_min + 1) * tt.f_divide_rate * tt.f_scale)
  from (select greatest(b.d_bdate, d_effective_min) as d_effective,
               least(nvl(b.d_edate, to_date('2017' || '1231', 'yyyymmdd')),
                     d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_ratio as f_divide_rate,
               a.c_stagescode as c_stage_code,
               case when e.c_propertytype_indiv = 1 and d.l_period <> 0 then 0 else a.f_scale end as f_scale
          from tta_saclevary a,
               thr_dividescheme b,
               (select t.c_stagescode as c_stage_code,
                       min(t.d_bdate) as d_effective_min,
                       nvl(max(t.d_edate), to_date('2017' || '1231', 'yyyymmdd')) as d_expiration_max
                  from thr_dividescheme t
                 where t.l_divideway = 0
                   and t.c_level = 'BM'
                   and (to_char(t.d_edate, 'yyyy') >= '2017' or t.d_edate is null)
                   and to_char(t.d_bdate, 'yyyy') <= '2017'
                 group by t.c_stagescode) c,
               tpm_stagesinfo d,
               tprojectinfo e
         where a.c_stagescode = b.c_stagescode
           and a.c_stagescode = c.c_stage_code
           and a.c_stagescode = d.c_stagescode
           and d.c_projectcode = e.c_projectcode
           and b.l_divideway = 0
           and b.c_level = 'BM'
           and to_char(a.d_varydate, 'yyyymmdd') <= '20170731') tt
 group by tt.c_stage_code;

--分成后规模-日-员工-期次
select tt.c_stage_code,
       sum((tt.d_expiration - tt.d_effective + 1) / (tt.d_expiration_max - tt.d_effective_min + 1) * tt.f_divide_rate * tt.f_scale)
  from (select greatest(b.d_bdate, d_effective_min) as d_effective,
               least(nvl(b.d_edate, to_date('2017' || '1231', 'yyyymmdd')), d_expiration_max) as d_expiration,
               c.d_effective_min,
               c.d_expiration_max,
               b.f_ratio as f_divide_rate,
               a.c_stagescode as c_stage_code,
               case when e.c_propertytype_indiv = 1 and d.l_period <> 0 then 0 else a.f_scale end as f_scale
          from tta_saclevary a,
               thr_dividescheme b,
               (select t.c_stagescode as c_stage_code,
                       min(t.d_bdate) as d_effective_min,
                       nvl(max(t.d_edate), to_date('2017' || '1231', 'yyyymmdd')) as d_expiration_max
                  from thr_dividescheme t
                 where t.l_divideway = 0
                   and t.c_level = 'YG'
                   and (to_char(t.d_edate, 'yyyy') >= '2017' or t.d_edate is null)
                   and to_char(t.d_bdate, 'yyyy') <= '2017'
                 group by t.c_stagescode) c,
               tpm_stagesinfo d,
               tprojectinfo e
         where a.c_stagescode = b.c_stagescode
           and a.c_stagescode = c.c_stage_code
           and a.c_stagescode = d.c_stagescode
           and d.c_projectcode = e.c_projectcode
           and b.l_divideway = 0
           and b.c_level = 'YG'
           and to_char(a.d_varydate, 'yyyymmdd') <= '20170731') tt
 group by tt.c_stage_code;

--弹性费用-部门-日
select s.c_orgid as c_grain, sum(t.f_debit) as f_value
  from dataods.tfa_vouchers_innate t, dataods.tbd_org s
 where t.c_deptno is not null
   and t.l_state <> 32
   and (t.c_subcode like '660102%' or t.c_subcode like '66010301%' or t.c_subcode like '66010302%')
   and t.l_year = 2017
   and nvl(to_char(t.d_busi,'yyyymmdd'),t.l_year||lpad(t.l_month,2,0)||'01') <= 20170731
   and t.c_deptno = s.c_orgid(+)
 group by s.c_orgid;

--弹性费用-部门-月
select s.c_orgid as c_grain, sum(t.f_debit) as f_value
  from dataods.tfa_vouchers_innate t, dataods.tbd_org s
 where t.c_deptno is not null
   and t.l_state <> 32
   and (t.c_subcode like '660102%' or t.c_subcode like '66010301%' or t.c_subcode like '66010302%')
   and t.l_year = 2017
   and t.l_year||lpad(t.l_month,2,0) <= 201705
   and t.c_deptno = s.c_orgid(+)
 group by s.c_orgid;

 --公共费用-部门-日
select s.c_orgid as c_grain, sum(t.f_debit) as f_value
  from dataods.tfa_vouchers_innate t, dataods.tbd_org s
 where t.c_deptno is not null
   and t.l_state <> 32
   and (t.c_subcode like '660102%' or t.c_subcode like '660103%' or t.c_subcode like '660104%')
   and t.l_year = 2017
   and nvl(to_char(t.d_busi,'yyyymmdd'),t.l_year||lpad(t.l_month,2,0)||'01') <= 20170731
   and t.c_deptno = s.c_orgid(+)
   and s.c_orgcalss = '5'
 group by s.c_orgid;

 --公共费用-部门-月
select s.c_orgid as c_grain, sum(t.f_debit) as f_value
  from dataods.tfa_vouchers_innate t, dataods.tbd_org s
 where t.c_deptno is not null
   and t.l_state <> 32
   and (t.c_subcode like '660102%' or t.c_subcode like '660103%' or t.c_subcode like '660104%')
   and t.l_year = 2017
   and t.l_year||lpad(t.l_month,2,0) <= 201707
   and t.c_deptno = s.c_orgid(+)
   and s.c_orgcalss = '5'
 group by s.c_orgid;
 
--项目个数-项目-日
select a.c_projectcode as c_grain, count(*) as f_value
  from dataods.tprojectinfo a
 where a.d_setup is not null
 and to_char(a.d_setup,'yyyymmdd') <= '20170731'
 group by a.c_projectcode;
 
--项目个数-项目-月
select a.c_projectcode as c_grain, count(*) as f_value
  from dataods.tprojectinfo a
 where a.d_setup is not null
 and to_char(a.d_setup,'yyyymm') <= '201707'
 group by a.c_projectcode;

--期次个数-期次-日
select a.c_stagescode as c_grain, count(*) as f_value
  from dataods.tpm_stagesinfo a, dataods.tprojectinfo b
 where a.c_projectcode = b.c_projectcode
   and b.d_setup is not null
   and to_char(a.d_setup,'yyyymmdd') <= '20170731'
 group by a.c_stagescode;
 
--期次个数-期次-月
select a.c_stagescode as c_grain, count(*) as f_value
  from dataods.tpm_stagesinfo a, dataods.tprojectinfo b
 where a.c_projectcode = b.c_projectcode
   and b.d_setup is not null
   and to_char(a.d_setup,'yyyymm') <= '201707'
 group by a.c_stagescode;

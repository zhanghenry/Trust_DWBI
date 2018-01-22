create or replace view v_property_scale as
select a.c_stagescode,d.d_date,
       sum(case when to_char(a.d_varydate,'yyyy') < to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_balance_ly,--年初存续规模
       sum(a.f_scale) as f_balance,--当前规模余额
       sum(case when a.c_busiflag = '62' and to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_bridge, --本年过桥规模
       sum(case when to_char(b.d_setup,'yyyy') = to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_net_increase,--净增规模
       sum(case when to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') and a.f_scale > 0 then a.f_scale else 0end) as f_increase,--新增规模
       sum(case when to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') and a.f_scale < 0 then a.f_scale*-1 else 0end) as f_decrease --清算规模
  from dataods.tta_saclevary  a,
       dataods.tpm_stagesinfo b,
       dataods.tprojectinfo   c,
       dataods.topenday       d
 where a.c_stagescode = b.c_stagescode
   and b.c_projectcode = c.c_projectcode
   and a.d_varydate <= d.d_date
   and c.c_propertytype_indiv = '1'
   and b.l_period <> 0
   group by a.c_stagescode,d.d_date;

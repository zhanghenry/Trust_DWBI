--产品信息
select a.c_prod_code     as 产品编码,
       a.c_prod_name     as 产品名称,
       a.c_proj_code     as 项目编码,
       b.c_proj_name     as 项目名称,
       a.c_prod_status   as 产品状态,
       a.c_prod_status_n as 产品状态,
       a.d_setup         as 成立日期,
       a.d_expiry        as 终止日期,
       a.l_struct_flag   as 是否结构化,
       a.c_struct_type   as 受益结构类型,
       a.c_struct_type_n as 受益结构类型
  from tde_product a, tde_project b
 where a.c_proj_code = b.c_proj_code(+)
 order by a.d_setup;

--项目和产品成立日期
select s.c_projcode  as 项目编码,
       s.c_fullname  as 项目名称,
       s.d_begdate   as 项目开始日期,
       s.d_enddate   as 项目结束日期,
       t.c_fundcode  as 产品编码,
       t.c_fundname  as 产品名称,
       t.d_issuedate as 产品发行日期,
       t.d_setupdate as 产品成立日期,
       t.d_enddate   as 产品终止日期,
       t.d_liqudate  as 产品清算日期
  from ta_fundinfo t, pm_projectinfo s
 where t.c_projcode = s.c_projcode
   --and t.d_setupdate is null
   and exists (select 1
          from bulu_amfareplan r1
         where t.c_fundcode = r1.vc_product_id);
		 
--项目已终止，产品未结束，但已维护结束日期,且无存续规模
with temp_scale as
 (select t.c_fundcode,
         sum(case
               when t.c_busiflag = '03' then
                t.f_tshares * -1
               else
                t.f_tshares
             end) as f_scale
    from ta_order t
   where t.c_busiflag in ('50', '02', '03')
   group by t.c_fundcode
  having sum(case
    when t.c_busiflag = '03' then
     t.f_tshares * -1
    else
     t.f_tshares
  end) = 0)
select *
  from ta_fundinfo t, temp_scale
 where t.c_status <> '6'
   and t.c_fundcode = temp_scale.c_fundcode
   and nvl(t.d_enddate, to_date('20991231', 'yyyymmdd')) <=
       to_date('20160930', 'yyyymmdd')
   and exists (select 1
          from pm_projectinfo s
         where t.c_projcode = s.c_projcode
           and s.c_projphase = '99');
		   
--产品已终止但还有存续规模
with temp_scale as
 (select t.c_fundcode,
         sum(case
               when t.c_busiflag = '03' then
                t.f_tshares * -1
               else
                t.f_tshares
             end) as f_scale
    from ta_order t
   where t.c_busiflag in ('50', '02', '03')
   group by t.c_fundcode
  having sum(case
    when t.c_busiflag = '03' then
     t.f_tshares * -1
    else
     t.f_tshares
  end) <> 0)
select c.c_projcode   as 项目编码,
       c.c_fullname   as 项目名称,
       c.c_projstatus as 项目状态,
       c.c_projphase  as 项目阶段,
       a.c_fundcode   as 产品编码,
       a.c_fundname   as 产品名称,
       a.d_issuedate  as 产品发行日期,
       a.d_enddate    as 产品终止日期,
       b.f_scale      as 规模余额
  from ta_fundinfo a, pm_projectinfo c, temp_scale b
 where a.c_projcode = c.c_projcode
      and nvl(a.d_enddate, to_date('20991231', 'yyyymmdd')) <=
      to_date('20151231', 'yyyymmdd')
   and a.c_status = '6'
   and a.c_fundcode = b.c_fundcode
 order by c.d_begdate;

